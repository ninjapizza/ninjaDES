# ninjaDES

An open source Data Encryption Standard (DES) core in VHDL.

# Data Encryption Standard

The Data Encryption Standard (aka DES) is a symetric-key algorithm for the encryption of digital data. It was made by IBM during the 1970s. It is not used much anymore nowdays due to the key size. The data block size is 64b and the key size is 56b. It consists of 16 rounds. Each round has its own subkey. A total of 16 subkeys are made. [The DES wikipedia page has cool diagrams, check them!](https://en.wikipedia.org/wiki/Data_Encryption_Standard)

The goal of this VHDL implementation is to learn about this algorithm and to implement a high throughput encoder / decoder. It has an inital latency of 17 cycles. After this initial latency, it can output one block of data on each cycle. The following timing diagram is an example.

![alt text](https://i.imgur.com/MqELTJp.png "Implementation timing diagram")

This high throughput has a ressource cost. Indeed, we have to instanciate 16 rounds instead of only one. A high throughput implementation will be usefull if you intend to use this module with ECB / CTR mode. However, it will be useless with modes such as CBC / OFB. This implementation can also be use as Triple DES.

# Files

This repository contains the following files :
- run.do             → Modelsim script, compile the sources and launch the simulation
- bench_des_top.vhd  → Bench module, instantiate des_operator.vhd	
- des_operator.vhd   → DES Operator (encode/decode), instantiate des_round and do the key scheduling
- des_package.vhd    → DES Package, contains useful DES functions
- des_round.vhd	   → DES Round, one DES round

# Performance

Those results come from Vivado Synthesis 2015.4. The target was a Xilinx Kintex 7 (xc7k70tfbv676-1). It can be easily routed at 400 MHz in both encode and decode mode. Thus, the throughput is > 3000 Mo/s. 

| Mode     |      LUT      |  FF   |
|----------|:-------------:|------:|
| Encrypt  |  1647         | 1993  |
| Decrypt  |  1635         |  1993 |
   

# Useful links
- https://en.wikipedia.org/wiki/Data_Encryption_Standard
- http://page.math.tu-berlin.de/~kant/teaching/hess/krypto-ws2006/des.htm
- https://www.tutorialspoint.com/cryptography/data_encryption_standard.htm
