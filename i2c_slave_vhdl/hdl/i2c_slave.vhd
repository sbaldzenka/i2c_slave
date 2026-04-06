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
use work.i2c_slave_pkg.all;

entity i2c_slave is
port
(
    -- system signals
    clk_i               : in  std_logic;
    reset_n_i           : in  std_logic;
    -- slave data bus
    s_valid_i           : in  std_logic;
    s_data_i            : in  std_logic_vector(7 downto 0);
    -- master data bus
    m_valid_o           : out std_logic;
    m_data_o            : out std_logic_vector(7 downto 0);
    -- status signals
    start_transaction_o : out std_logic;
    end_transaction_o   : out std_logic;
    get_byte_ready_o    : out std_logic;
    -- i2c signals
    scl_i               : in  std_logic;
    sda_en_o            : out std_logic;
    sda_i               : in  std_logic;
    sda_o               : out std_logic
);
end i2c_slave;

architecture behavioral of i2c_slave is

    signal sync_scl      : std_logic_vector( 2 downto 0);
    signal sync_sda_i    : std_logic_vector( 1 downto 0);
    signal r_edge_detect : std_logic;
    signal f_edge_detect : std_logic;
    signal bit_counter   : std_logic_vector( 3 downto 0);
    signal read_buffer   : std_logic_vector( 7 downto 0);
    signal write_buffer  : std_logic_vector( 7 downto 0);
    signal rw_flag       : std_logic;                       -- read = 1, write = 0
    signal byte_ready    : std_logic_vector( 1 downto 0);

    signal watchdog_cnt  : std_logic_vector(11 downto 0);
    signal watchdog_flag : std_logic;
    signal watchdog_rstn : std_logic;

    signal i2c_state     : i2c_states;

begin

    WATCHDOG: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (watchdog_flag = '0') then
                watchdog_cnt <= (others => '0');
            else
                watchdog_cnt <= watchdog_cnt + '1';
            end if;

            if (watchdog_cnt = x"FFF") then
                watchdog_rstn <= '0';
            else
                watchdog_rstn <= '1';
            end if;
        end if;
    end process;

    SYNCHRONIZER: process(clk_i)
    begin
        if rising_edge(clk_i) then
            sync_scl   <= sync_scl(1 downto 0) & scl_i;
            sync_sda_i <= sync_sda_i(0) & sda_i;
        end if;
    end process;

    EDGE_DETECT: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (sync_scl = b"001") then
                r_edge_detect <= '1';
            else
                r_edge_detect <= '0';
            end if;

            if (sync_scl = b"100") then
                f_edge_detect <= '1';
            else
                f_edge_detect <= '0';
            end if;
        end if;
    end process;

    BIT_COUNT: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (i2c_state = S_IDLE or i2c_state = S_REPEATED_START) then
                bit_counter <= (others => '0');
            elsif (r_edge_detect = '1') then
                bit_counter <= bit_counter + '1';
            elsif (f_edge_detect = '1' and bit_counter = x"9") then
                if (i2c_state = S_GET_BYTE or i2c_state = S_W_ACK) then
                    bit_counter <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    GET_BYTE_READY_GENERATE: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (i2c_state = S_GET_BYTE) then
                byte_ready <= byte_ready(0) & '1';
            else
                byte_ready <= (others => '0');
            end if;

            if (byte_ready = b"01") then
                get_byte_ready_o <= '1';
            else
                get_byte_ready_o <= '0';
            end if;
        end if;
    end process;

    SRL_WRITE: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (i2c_state = S_IDLE) then
                write_buffer <= (others => '0');
            elsif (i2c_state = S_GET_BYTE and s_valid_i = '1') then
                write_buffer <= s_data_i;
            elsif (i2c_state = S_READ and f_edge_detect = '1') then
                write_buffer <= write_buffer(6 downto 0) & '0';
            end if;
        end if;
    end process;

    FSM: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (reset_n_i = '0' or watchdog_rstn = '0') then
                i2c_state <= S_IDLE;
            else
                case(i2c_state) is
                    when S_IDLE =>
                        rw_flag             <= '0';
                        sda_en_o            <= '0';
                        end_transaction_o   <= '0';
                        start_transaction_o <= '0';
                        watchdog_flag       <= '0';

                        if (sync_scl = b"111" and sync_sda_i = b"00") then
                            i2c_state     <= S_START;
                            watchdog_flag <= '0';
                        end if;
                    when S_START =>
                        watchdog_flag <= '1';

                        if (r_edge_detect = '1') then
                            i2c_state           <= S_GET_ADDR;
                            start_transaction_o <= '1';
                            watchdog_flag       <= '0';
                        end if;
                    when S_GET_ADDR =>
                        start_transaction_o <= '0';
                        watchdog_flag       <= '1';

                        if (bit_counter = x"7") then
                            if (read_buffer(6 downto 0) = ADDRESS_I2C) then
                                i2c_state     <= S_RW;
                                watchdog_flag <= '0';
                            else
                                i2c_state <= S_IDLE;
                            end if;
                        else
                            if (sync_scl(2) = '1' and sync_sda_i = b"01") then
                                i2c_state <= S_IDLE;
                            end if;
                        end if;
                    when S_RW =>
                        watchdog_flag <= '1';

                        if (bit_counter = x"8") then
                            if (read_buffer(0) = '1') then
                                rw_flag <= '1';
                            else
                                rw_flag <= '0';
                            end if;

                            i2c_state     <= S_W_ACK;
                            watchdog_flag <= '0';
                        end if;
                    when S_W_ACK =>
                        watchdog_flag <= '1';

                        if (f_edge_detect = '1') then
                            sda_en_o <= '1';
                        end if;

                        if (rw_flag = '1') then
                            if (r_edge_detect = '1' and bit_counter = x"8") then
                                i2c_state     <= S_GET_BYTE;
                                watchdog_flag <= '0';
                            end if;
                        else
                            if (f_edge_detect = '1' and bit_counter = x"9") then
                                i2c_state     <= S_WRITE;
                                watchdog_flag <= '0';
                            end if;
                        end if;
                    when S_WRITE =>
                        watchdog_flag <= '1';
                        sda_en_o      <= '0';

                        if (bit_counter = x"8") then
                            i2c_state     <= S_W_ACK;
                            watchdog_flag <= '0';
                        end if;

                        if (sync_scl = b"111" and sync_sda_i = b"10") then
                            i2c_state     <= S_REPEATED_START;
                            watchdog_flag <= '0';
                        end if;

                        if (sync_scl = b"111" and sync_sda_i = b"01") then
                            i2c_state     <= S_STOP;
                            watchdog_flag <= '0';
                        end if;
                    when S_GET_BYTE =>
                        watchdog_flag <= '1';

                        if (f_edge_detect = '1') then
                            sda_en_o      <= '1';
                            i2c_state     <= S_READ;
                            watchdog_flag <= '0';
                        end if;
                    when S_READ =>
                        watchdog_flag <= '1';

                        if (bit_counter = x"8") then
                            i2c_state     <= S_R_ACK;
                            watchdog_flag <= '0';
                        end if;
                    when S_R_ACK =>
                        watchdog_flag <= '1';

                        if (f_edge_detect = '1') then
                            sda_en_o <= '0';
                        elsif (r_edge_detect = '1' and bit_counter = x"8") then
                            if (sda_i = '1') then
                                i2c_state     <= S_R_NACK;
                                watchdog_flag <= '0';
                            else
                                i2c_state     <= S_GET_BYTE;
                                watchdog_flag <= '0';
                            end if;
                        end if;
                    when S_R_NACK =>
                        watchdog_flag <= '1';

                        if (r_edge_detect = '1') then
                            i2c_state     <= S_STOP;
                            watchdog_flag <= '0';
                        end if;
                    when S_STOP =>
                        watchdog_flag     <= '1';
                        end_transaction_o <= '1';

                        if (sync_scl(2) = '1' and sync_sda_i(1) = '1') then
                            i2c_state <= S_IDLE;
                        end if;
                    when S_REPEATED_START =>
                        watchdog_flag <= '1';

                        if (f_edge_detect = '1') then
                            start_transaction_o <= '1';
                            i2c_state           <= S_GET_ADDR;
                            watchdog_flag       <= '0';
                        end if;
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    READ_SDA: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (reset_n_i = '0' or i2c_state = S_REPEATED_START) then
                read_buffer <= (others => '0');
            elsif (r_edge_detect = '1') then
                read_buffer <= read_buffer(6 downto 0) & sync_sda_i(1);
            elsif (i2c_state = S_STOP) then
                read_buffer <= (others => '0');
            end if;
        end if;
    end process;

    WRITE_SDA: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (reset_n_i = '0') then
                sda_o <= '0';
            elsif (i2c_state = S_W_ACK) then
                sda_o <= '0';
            elsif (i2c_state = S_READ) then
                sda_o <= write_buffer(7);
            end if;
        end if;
    end process;

    M_BUS_GENERATE: process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (i2c_state = S_W_ACK and f_edge_detect = '1' and bit_counter = x"8") then
                m_valid_o <= '1';
                m_data_o  <= read_buffer;
            else
                m_valid_o <= '0';
            end if;
        end if;
    end process;

end behavioral;
