# XR/STATION Firmware

Abbreviated frequently as a3x.

Boot firmware for the XR/station architecture, written in xr17032 assembly and dragonfruit.

Makes heavy internal use of NVRAM variables and a device tree model.

![Running](https://i.imgur.com/TTYU8WT.png)

## Building

Download the XR/station sdk, and place it in a folder titled `sdk` in your current directory.

Then run the `build.sh` script using the path you'd like to place the ROM file as the argument.

Example:

`./a3x/build.sh ./rom.bin`
