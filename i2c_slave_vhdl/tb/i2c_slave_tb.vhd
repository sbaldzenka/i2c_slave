-- project     : i2c_slave
-- date        : 23.05.2023
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/i2c_slave/i2c_slave_vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity i2c_slave_tb is
end i2c_slave_tb;

architecture behavioral of i2c_slave_tb is

    constant clk_period : time := 20 ns; --50 MHz

    signal clk               : std_logic;
    signal resetn            : std_logic;

    signal scl               : std_logic;
    signal sda_en            : std_logic;
    signal sda_i             : std_logic;
    signal sda_o             : std_logic;

    signal s_valid           : std_logic;
    signal s_data            : std_logic_vector(7 downto 0);
    signal s_valid_ff        : std_logic;
    signal s_data_ff         : std_logic_vector(7 downto 0);

    signal m_valid           : std_logic;
    signal m_data            : std_logic_vector(7 downto 0);

    signal start_transaction : std_logic;
    signal end_transaction   : std_logic;
    signal get_byte_ready    : std_logic;

    component i2c_slave is
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
    end component;

begin

    CLK_GENERATE: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    RESET_GENERATE: process
    begin
        resetn <= '1';
        wait for 2 us;
        resetn <= '0';
        report "!---------------- START SIMULATION!";
        wait for 0.1 us;
        resetn <= '1';
        wait;
    end process;

    process
    begin
        scl   <= '1';   -- idle
        sda_i <= '1';
        wait for 100 us;
        sda_i <= '0';   -- start
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 1 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 2 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 3 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 4 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- 5 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 6 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- 7 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 8 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- ack
        report "SEND ADDRESS DEVICE!";
        report "WRITE!";
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 1 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- 2 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 3 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 4 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- 5 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 6 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 7 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 8 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- ack
        report "SEND ADDRESS REGISTER!";
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- 1 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 2 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 3 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 4 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 5 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 6 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 7 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 8 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- nack
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- stop
        wait for 10 us;
        sda_i <= '0';
        report "SEND DATA!";
        wait for 10 us;
        sda_i <= '1';
        wait for 100 us;
        sda_i <= '0';   -- start
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 1 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 2 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 3 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 4 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- 5 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 6 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- 7 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 8 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- ack
        report "SEND ADDRESS DEVICE!";
        report "WRITE!";
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 1 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- 2 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 3 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 4 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- 5 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 6 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 7 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 8 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- ack
        wait for 10 us;
        scl   <= '0';
        report "SEND ADDRESS REGISTER!";
        wait for 10 us;
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';
        wait for 5 us;
        sda_i <= '0';
        wait for 5 us;
        scl   <= '0';
        report "REPEATED START!";
        wait for 10 us;
        scl   <= '1';   -- 1 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 2 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 3 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 4 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- 5 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 6 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- 7 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- 8 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '0';
        wait for 10 us;
        scl   <= '1';   -- ack
        report "SEND ADDRESS DEVICE!";
        report "READ!";
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 1 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 2 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 3 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 4 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 5 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 6 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 7 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 8 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- ack
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 1 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 2 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 3 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 4 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 5 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 6 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 7 bit
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';   -- 8 bit
        wait for 10 us;
        scl   <= '0';
        sda_i <= '1';
        wait for 10 us;
        scl   <= '1';   -- nack
        wait for 10 us;
        scl   <= '0';
        wait for 10 us;
        scl   <= '1';
        wait for 10 us;
        sda_i <= '1';   -- stop
        report"!---------------- STOP SIMULATION!";
        wait;
    end process;

    process
    begin
        s_valid <= '0';
        s_data  <= (others => '0');
        wait for 1355 us;
        s_valid <= '1';
        s_data  <= x"84";
        wait for clk_period;
        s_valid <= '0';
        s_data  <= (others => '0');
        wait for 180 us;
        s_valid <= '1';
        s_data  <= x"85";
        wait for clk_period;
        s_valid <= '0';
        s_data  <= (others => '0');
        wait;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            s_valid_ff <= s_valid;
            s_data_ff  <= s_data;
        end if;
    end process;

    DUT_inst: i2c_slave
    port map
    (
        -- system signals
        clk_i               => clk,
        reset_n_i           => resetn,
        -- slave data bus
        s_valid_i           => s_valid_ff,
        s_data_i            => s_data_ff,
        -- master data bus
        m_valid_o           => m_valid,
        m_data_o            => m_data,
        -- status signals
        start_transaction_o => start_transaction,
        end_transaction_o   => end_transaction,
        get_byte_ready_o    => get_byte_ready,
        -- i2c signals
        scl_i               => scl,
        sda_en_o            => sda_en,
        sda_i               => sda_i,
        sda_o               => sda_o
    );

end behavioral;
