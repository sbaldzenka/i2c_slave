-- project     : i2c_slave
-- date        : 30.07.2022
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/i2c_slave/i2c_slave_vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package i2c_slave_pkg is

    constant ADDRESS_I2C : std_logic_vector(6 downto 0) := b"1000_100";

    type i2c_states is
    (
        S_IDLE,
        S_START,
        S_REPEATED_START,
        S_GET_ADDR,
        S_RW,
        S_R_ACK,
        S_R_NACK,
        S_GET_BYTE,
        S_READ,
        S_WRITE,
        S_W_ACK,
        S_STOP
    );

end i2c_slave_pkg;

package body i2c_slave_pkg is
end i2c_slave_pkg;