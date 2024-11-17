# make.sh
echo "making executable file from name [s]"
as $1.s -g -o $1.o
ld $1.o -o $1

