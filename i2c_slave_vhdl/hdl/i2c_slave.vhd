-- project     : i2c_slave
-- date        : 26.07.2022
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/i2c_slave/i2c_slave_vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity i2c_slave is
generic
(
    SYNC_STAGES : integer := 4
);
port
(
    -- system signals
    i_clk               : in  std_logic;
    i_reset_n           : in  std_logic;
    -- device address
    i_address           : in  std_logic_vector(6 downto 0);
    -- slave data bus
    i_s_valid           : in  std_logic;
    i_s_data            : in  std_logic_vector(7 downto 0);
    o_s_ready           : out std_logic;
    -- master data bus
    o_m_valid           : out std_logic;
    o_m_data            : out std_logic_vector(7 downto 0);
    -- status signals
    o_start_transaction : out std_logic;
    o_end_transaction   : out std_logic;
    -- i2c signals
    o_scl_en            : out std_logic;
    i_scl               : in  std_logic;
    o_scl               : out std_logic;
    o_sda_en            : out std_logic;
    i_sda               : in  std_logic;
    o_sda               : out std_logic
);
end i2c_slave;

architecture behavioral of i2c_slave is

    -- types
    type i2c_states is
    (
        S_IDLE,
        S_START,
        S_REPEATED_START,
        S_GET_ADDR,
        S_RW,
        S_R_ACK,
        S_R_NACK_CHECK,
        S_GET_BYTE,
        S_READ,
        S_WRITE,
        S_W_ACK,
        S_STOP_WRITE,
        S_STOP_READ
    );

    -- constants
    constant HIGH_VALUE      : std_logic_vector(SYNC_STAGES-1 downto 0) := (others => '1');
    constant LOW_VALUE       : std_logic_vector(SYNC_STAGES-1 downto 0) := (others => '0');

    -- signals
    signal ready             : std_logic;
    signal sync_scl_i        : std_logic_vector(SYNC_STAGES-1 downto 0);
    signal sync_sda_i        : std_logic_vector(SYNC_STAGES-1 downto 0);
    signal sync_scl_i_reg    : std_logic;
    signal sync_sda_i_reg    : std_logic;
    signal sync_scl_i_reg_ff : std_logic;
    signal sync_sda_i_reg_ff : std_logic;
    signal r_edge_detect     : std_logic;
    signal f_edge_detect     : std_logic;
    signal bit_counter       : std_logic_vector(4 downto 0);
    signal bit_capture       : std_logic;
    signal srl_register_in   : std_logic_vector(7 downto 0);
    signal srl_register_out  : std_logic_vector(7 downto 0);
    signal rw_flag           : std_logic;
    signal address_flag      : std_logic;
    signal i2c_state         : i2c_states;

begin

    o_scl_en  <= '0';
    o_scl     <= '0';
    o_s_ready <= ready;

    SYNCHRONIZER: process(i_clk)
    begin
        if rising_edge(i_clk) then
            sync_scl_i <= sync_scl_i(SYNC_STAGES-2 downto 0) & i_scl;
            sync_sda_i <= sync_sda_i(SYNC_STAGES-2 downto 0) & i_sda;

            if (sync_scl_i = HIGH_VALUE) then
                sync_scl_i_reg <= '1';
            elsif (sync_scl_i = LOW_VALUE) then
                sync_scl_i_reg <= '0';
            end if;

            if (sync_sda_i = HIGH_VALUE) then
                sync_sda_i_reg <= '1';
            elsif (sync_sda_i = LOW_VALUE) then
                sync_sda_i_reg <= '0';
            end if;
        end if;
    end process;

    EDGE_DETECT: process(i_clk)
    begin
        if rising_edge(i_clk) then
            sync_scl_i_reg_ff <= sync_scl_i_reg;
            sync_sda_i_reg_ff <= sync_sda_i_reg;

            if (sync_scl_i_reg = '1' and sync_scl_i_reg_ff = '0') then
                r_edge_detect <= '1';
            else
                r_edge_detect <= '0';
            end if;

            if (sync_scl_i_reg = '0' and sync_scl_i_reg_ff = '1') then
                f_edge_detect <= '1';
            else
                f_edge_detect <= '0';
            end if;
        end if;
    end process;

    BIT_COUNTER_GEN: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i2c_state = S_IDLE or i2c_state = S_REPEATED_START) then
                bit_counter <= (others => '0');
            elsif (f_edge_detect = '1') then
                bit_counter <= bit_counter + '1';

                if (bit_counter = x"8") then
                    bit_counter <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    RW_FLAG_GEN: process(i_clk)
    begin
        if rising_edge(i_clk) then
            bit_capture <= r_edge_detect;

            if (i2c_state = S_IDLE) then
                rw_flag <= '0';
            elsif (i2c_state = S_RW and bit_capture = '1') then
                if (srl_register_in(0) = '1') then
                    rw_flag <= '1';
                else
                    rw_flag <= '0';
                end if;
            end if;
        end if;
    end process;

    ADDRESS_FLAG_GEN: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i2c_state = S_IDLE) then
                address_flag <= '0';
            elsif (i2c_state = S_GET_ADDR) then
                address_flag <= '1';
            elsif (i2c_state = S_W_ACK or i2c_state = S_R_ACK) then
                address_flag <= '0';
            end if;
        end if;
    end process;

    START_TRANSACTION_PULSE: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i2c_state = S_IDLE) then
                o_start_transaction <= '0';
            elsif (i2c_state = S_RW and f_edge_detect = '1') then
                o_start_transaction <= '1';
            else
                o_start_transaction <= '0';
            end if;
        end if;
    end process;

    END_TRANSACTION_PULSE: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i2c_state = S_STOP_WRITE or (i2c_state = S_STOP_READ and r_edge_detect = '1')) then
                o_end_transaction <= '1';
            else
                o_end_transaction <= '0';
            end if;
        end if;
    end process;

    SRL_REG_IN: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i2c_state = S_IDLE or i2c_state = S_REPEATED_START) then
                srl_register_in <= (others => '0');
            elsif (r_edge_detect = '1') then
                srl_register_in <= srl_register_in(6 downto 0) & sync_sda_i_reg_ff;
            end if;
        end if;
    end process;

    SRL_REG_OUT: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i2c_state = S_IDLE) then
                srl_register_out <= (others => '0');
            elsif (i_s_valid = '1' and ready = '1') then
                srl_register_out <= i_s_data;
            end if;

            if (i2c_state = S_READ and f_edge_detect = '1') then
                srl_register_out <= srl_register_out(6 downto 0) & '0';
            end if;
        end if;
    end process;

    DATA_BUS_OUT: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i2c_state = S_WRITE and bit_counter = x"8" and 
                bit_capture = '1' and address_flag = '0') then
                o_m_valid <= '1';
                o_m_data  <= srl_register_in;
            else
                o_m_valid <= '0';
                o_m_data  <= (others => '0');
            end if;
        end if;
    end process;

    DATA_BUS_IN: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i2c_state = S_GET_BYTE) then
                ready <= '1';

                if (i_s_valid = '1') then
                    ready <= '0';
                end if;
            else
                ready <= '0';
            end if;
        end if;
    end process;

    SDA_OUT_CONTROL: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i2c_state = S_READ) then
                o_sda <= srl_register_out(7);
            elsif (i2c_state = S_W_ACK) then
                o_sda <= '1';
            else
                o_sda <= '0';
            end if;
        end if;
    end process;

    SDA_EN_CONTROL: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i2c_state = S_W_ACK or i2c_state = S_READ) then
                o_sda_en <= '1';
            else
                o_sda_en <= '0';
            end if;
        end if;
    end process;

    FSM: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_reset_n = '0') then
                i2c_state <= S_IDLE;
            else
                case(i2c_state) is
                    when S_IDLE =>
                        if (sync_scl_i_reg = '1' and sync_sda_i_reg = '0') then
                            i2c_state <= S_START;
                        end if;

                    when S_START =>
                        if (f_edge_detect = '1') then
                            i2c_state <= S_GET_ADDR;
                        end if;

                    when S_GET_ADDR =>
                        if (f_edge_detect = '1' and bit_counter = x"7") then
                            if (i_address = srl_register_in) then
                                i2c_state <= S_RW;
                            else
                                i2c_state <= S_IDLE;
                            end if;
                        end if;

                    when S_RW =>
                        if (f_edge_detect = '1' and bit_counter = x"8") then
                            if (rw_flag = '0') then
                                i2c_state <= S_W_ACK;
                            else
                                i2c_state <= S_R_ACK;
                            end if;
                        end if;

                    when S_W_ACK =>
                        if (f_edge_detect = '1') then
                            i2c_state <= S_WRITE;
                        end if;

                    when S_WRITE =>
                        if (f_edge_detect = '1' and bit_counter = x"8") then
                            i2c_state <= S_W_ACK;
                        end if;

                        if (sync_scl_i_reg = '1' and sync_sda_i_reg = '0' and sync_sda_i_reg_ff = '1') then
                            i2c_state <= S_REPEATED_START;
                        end if;

                        if (sync_scl_i_reg = '1' and sync_scl_i_reg_ff = '1' and 
                            sync_sda_i_reg = '1' and sync_sda_i_reg_ff = '0') then
                            i2c_state <= S_STOP_WRITE;
                        end if;

                    when S_GET_BYTE =>
                        if (i_s_valid = '1') then
                            i2c_state <= S_READ;
                        end if;

                    when S_READ =>
                        if (f_edge_detect = '1' and bit_counter = x"8") then
                            i2c_state <= S_R_NACK_CHECK;
                        end if;

                    when S_R_ACK =>
                        if (f_edge_detect = '1') then
                            i2c_state <= S_GET_BYTE;
                        end if;

                    when S_R_NACK_CHECK =>
                        if (f_edge_detect = '1') then
                            if (sync_sda_i_reg_ff = '0') then
                                i2c_state <= S_STOP_READ;
                            else
                                i2c_state <= S_GET_BYTE;
                            end if;
                        end if;

                    when S_STOP_WRITE =>
                        i2c_state <= S_IDLE;

                    when S_STOP_READ =>
                        if (sync_scl_i_reg = '1' and sync_scl_i_reg_ff = '1' and 
                            sync_sda_i_reg = '1' and sync_sda_i_reg_ff = '0') then
                            i2c_state <= S_IDLE;
                        end if;

                    when S_REPEATED_START =>
                        i2c_state <= S_START;

                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

end behavioral;