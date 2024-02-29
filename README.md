# XR/STATION Firmware

Abbreviated frequently as a3x. Retired in favor of [a4x](https://github.com/xrarch/a4x) in February 2024 after 5 years of faithful service to the project.

Old boot firmware for the XR/station architecture, written in xr17032 assembly and dragonfruit.

Makes heavy internal use of NVRAM variables and a device tree model.

![Running](https://raw.githubusercontent.com/xrarch/a3x/master/screenshot.png)

## Building

Download the XR/station sdk, and place it in a folder titled `sdk` in your current directory.

Then run the `build.sh` script using the path you'd like to place the ROM file as the argument.

Example:

`./a3x/build.sh ./rom.bin`
