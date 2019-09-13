#!/bin/bash

path=$(dirname $0)

./sdk/dragonc-flat.sh ${path}/src/Antecedent.d $1

printf '%s' `expr \`cat ${path}/src/build\` + 1` > ${path}/src/build
