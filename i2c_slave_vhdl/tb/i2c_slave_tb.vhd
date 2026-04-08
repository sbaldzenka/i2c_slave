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
        i_clk               : in  std_logic;
        i_reset_n           : in  std_logic;
        -- slave data bus
        i_s_valid           : in  std_logic;
        i_s_data            : in  std_logic_vector(7 downto 0);
        -- master data bus
        o_m_valid           : out std_logic;
        o_m_data            : out std_logic_vector(7 downto 0);
        -- status signals
        o_start_transaction : out std_logic;
        o_end_transaction   : out std_logic;
        o_get_byte_ready    : out std_logic;
        -- i2c signals
        i_scl               : in  std_logic;
        o_sda_en            : out std_logic;
        i_sda               : in  std_logic;
        o_sda               : out std_logic
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
        sda_i <= '0';
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
        i_clk               => clk,
        i_reset_n           => resetn,
        -- slave data bus
        i_s_valid           => s_valid_ff,
        i_s_data            => s_data_ff,
        -- master data bus
        o_m_valid           => m_valid,
        o_m_data            => m_data,
        -- status signals
        o_start_transaction => start_transaction,
        o_end_transaction   => end_transaction,
        o_get_byte_ready    => get_byte_ready,
        -- i2c signals
        i_scl               => scl,
        o_sda_en            => sda_en,
        i_sda               => sda_i,
        o_sda               => sda_o
    );

end behavioral;
