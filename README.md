# ANTECEDENT 3.x firmware

Abbreviated frequently as a3x.

Boot firmware for the LIMN architecture, written in assembly and dragonfruit.

Makes heavy internal use of NVRAM variables and a device tree model.

![Running](https://i.imgur.com/Jt3Tvoe.png)

## Building

Download the LIMN sdk, and place it in a folder titled `sdk` in your current directory.

Then run the `build.sh` script using the path you'd like to place the ROM file as the argument.

Example:

`./a3x/build.sh ./rom.bin`
