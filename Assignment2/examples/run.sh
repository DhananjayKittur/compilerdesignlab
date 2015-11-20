ARG_LENGTH=1
if [ $# -ne $ARG_LENGTH ];
then
    echo "Invalid comamnd!!!Use --> ./run.sh file_name"
    exit
fi
FILE_NAME=$1
bison -d $FILE_NAME.y -o $FILE_NAME.yy.c 
flex -o $FILE_NAME.lex.c $FILE_NAME.lex 
gcc -o $FILE_NAME.out $FILE_NAME.yy.c $FILE_NAME.lex.c