-- project     : i2c_slave
-- date        : 23.05.2023
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/i2c_slave/i2c_slave_vhdl

vlib work
vmap work work

vcom -93 ../tb/i2c_slave_tb.vhd
vcom -93 ../hdl/i2c_slave_pkg.vhd
vcom -93 ../hdl/i2c_slave.vhd

vsim -t 1ps -voptargs=+acc=lprn -lib work i2c_slave_tb

do wave_test.do
view wave
run 2 ms