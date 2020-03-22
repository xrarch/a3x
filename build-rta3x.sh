path=$(dirname $0)

make --directory=${path}/rta3x

../sdk/install.sh ${path}/rta3x
