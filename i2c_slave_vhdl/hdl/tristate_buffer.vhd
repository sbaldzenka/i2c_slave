-- project     : i2c_slave
-- date        : 06.04.2026
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/i2c_slave/i2c_slave_vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tristate_buffer is
port
(
    io : inout std_logic;
    en : in    std_logic;
    i  : in    std_logic;
    o  : out   std_logic
);
end tristate_buffer;

architecture behavioral of tristate_buffer is

begin

    io <= i when en = '1' else 'Z';
    o  <= io;

end behavioral;