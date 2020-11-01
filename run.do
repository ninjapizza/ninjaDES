vlib work

# Compilation sources
vcom -2008 ./des_package.vhd
vcom -2008 ./des_round.vhd
vcom -2008 ./des_operator.vhd

# Compilation bench
vcom -2008 ./bench_des_top.vhd

# Run the simulation
vsim work.bench_des_top

# Waves
add wave -group "DES_OPERATOR_ENCODER" -position insertpoint sim:/bench_des_top/des_operator_enc_inst/*
add wave -group "DES_OPERATOR_DECODER" -position insertpoint sim:/bench_des_top/des_operator_dec_inst/*

# Run the simulation!
run 5 us;
