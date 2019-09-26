#!/bin/bash

path=$(dirname $0)

make --directory=${path}/src

cp ${path}/src/boot.bin $1