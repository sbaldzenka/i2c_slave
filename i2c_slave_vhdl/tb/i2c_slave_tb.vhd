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

    -- constants
    constant clk_period      : time                         := 20 ns; --50 MHz
    constant i2c_address     : std_logic_vector(6 downto 0) := b"1000_100";

    -- signals
    signal clk               : std_logic;
    signal resetn            : std_logic;
    signal s_valid           : std_logic;
    signal s_data            : std_logic_vector(7 downto 0);
    signal s_ready           : std_logic;
    signal m_valid           : std_logic;
    signal m_data            : std_logic_vector(7 downto 0);
    signal start_transaction : std_logic;
    signal end_transaction   : std_logic;
    signal scl_en            : std_logic;
    signal scl_i             : std_logic;
    signal scl_o             : std_logic;
    signal sda_en            : std_logic;
    signal sda_i             : std_logic;
    signal sda_o             : std_logic;
    signal scl               : std_logic;
    signal sda               : std_logic;

    component i2c_slave is
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
    end component;

    component tristate_buffer is
    port
    (
        io : inout std_logic;
        en : in    std_logic;
        i  : in    std_logic;
        o  : out   std_logic
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
        wait for 0.1 us;
        resetn <= '1';
        wait;
    end process;

    scl <= 'H';
    sda <= 'H';

    process
    begin
        report "!------------------------------------- START SIMULATION!";
        scl <= 'H';   -- idle
        sda <= 'H';
        wait for 100 us;
        scl <= '1';
        sda <= '1';
        wait for 10 us;
        report "!------------------------------------- FIRST TRANSACTION!";
        scl <= '1';
        sda <= '0';   -- start
        wait for 10 us;
        scl <= '0';   -- 1 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 2 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 3 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 4 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 5 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 6 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 7 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 8 bit (write)
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- ack
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        report "!------------------------------------- SEND ADDRESS DEVICE!";
        report "!------------------------------------- WRITE!";
        scl <= '0';   -- 1 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 2 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 3 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 4 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 5 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 6 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 7 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 8 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- ack
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        report "!------------------------------------- SEND ADDRESS REGISTER!";
        scl <= '0';   -- 1 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 2 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 3 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 4 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 5 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 6 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 7 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 8 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- ack
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        report "!------------------------------------- SEND DATA!";
        scl <= '0';   -- stop
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        sda <= '0';
        wait for 10 us;
        scl <= '1';   -- idle
        sda <= '1';
        wait for 10 us;
        scl <= 'H';
        sda <= 'H';
        wait for 100 us;
        report "!------------------------------------- SECOND TRANSACTION!";
        scl <= '1';
        sda <= '0';   -- start
        wait for 10 us;
        scl <= '0';   -- 1 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 2 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 3 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 4 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 5 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 6 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 7 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 8 bit (read)
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- ack
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        report "!------------------------------------- SEND ADDRESS DEVICE!";
        report "!------------------------------------- READ BYTE1!";
        scl <= '0';   -- 1 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        sda <= 'H';
        wait for 10 us;
        scl <= '0';   -- 2 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 3 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 4 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 5 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 6 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 7 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 8 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- ack
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        report "!------------------------------------- READ BYTE2!";
        scl <= '0';   -- 1 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 2 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 3 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 4 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 5 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 6 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 7 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 8 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- ack
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- stop
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        sda <= '0';
        wait for 10 us;
        scl <= '1';   -- idle
        sda <= '1';
        wait for 10 us;
        scl <= 'H';
        sda <= 'H';
        wait for 100 us;
        report "!------------------------------------- THIRD TRANSACTION!";
        scl <= '1';
        sda <= '0';   -- start
        wait for 10 us;
        scl <= '0';   -- 1 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 2 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 3 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 4 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 5 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 6 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 7 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 8 bit (write)
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- ack
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        report "!------------------------------------- SEND ADDRESS DEVICE!";
        report "!------------------------------------- WRITE!";
        scl <= '0';   -- 1 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 2 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 3 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 4 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 5 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 6 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 7 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 8 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- ack
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        report "!------------------------------------- SEND ADDRESS REGISTER!";
        scl <= '0';   -- repeated start
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 5 us;
        sda <= '0';
        wait for 5 us;
        sda <= '0';
        wait for 10 us;
        scl <= '0';   -- 1 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 2 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 3 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 4 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 5 bit
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 6 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 7 bit
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 8 bit (read)
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- ack
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        report "!------------------------------------- SEND ADDRESS REGISTER!";
        report "!------------------------------------- READ BYTE1!";
        scl <= '0';   -- 1 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 2 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 3 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 4 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 5 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 6 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 7 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- 8 bit
        sda <= 'H';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- ack
        sda <= '1';
        wait for 10 us;
        scl <= '1';
        wait for 10 us;
        scl <= '0';   -- stop
        sda <= '0';
        wait for 10 us;
        scl <= '1';
        sda <= '0';
        wait for 10 us;
        scl <= '1';   -- idle
        sda <= '1';
        wait for 10 us;
        scl <= 'H';
        sda <= 'H';
        wait for 100 us;
        report"!------------------------------------- STOP SIMULATION!";
        wait;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if (resetn = '0') then
                s_valid <= '0';
                s_data  <= x"80";
            elsif (s_ready = '1') then
                s_valid <= '1';
                s_data  <= s_data + '1';
            else
                s_valid <= '0';
            end if;
        end if;
    end process;

    DUT_inst: i2c_slave
    port map
    (
        i_clk               => clk,
        i_reset_n           => resetn,
        i_address           => i2c_address,
        i_s_valid           => s_valid,
        i_s_data            => s_data,
        o_s_ready           => s_ready,
        o_m_valid           => m_valid,
        o_m_data            => m_data,
        o_start_transaction => start_transaction,
        o_end_transaction   => end_transaction,
        o_scl_en            => scl_en,
        i_scl               => scl_i,
        o_scl               => scl_o,
        o_sda_en            => sda_en,
        i_sda               => sda_i,
        o_sda               => sda_o
    );

    tristate_buffer_scl_inst: tristate_buffer
    port map
    (
        io => scl,
        en => scl_en,
        i  => scl_o,
        o  => scl_i
    );

    tristate_buffer_sda_inst: tristate_buffer
    port map
    (
        io => sda,
        en => sda_en,
        i  => sda_o,
        o  => sda_i
    );

end behavioral;
