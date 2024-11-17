# make.sh
echo "making executable file from name [$1.s]"
as $1.s -g -o $1.o
ld $1.o -o $1

