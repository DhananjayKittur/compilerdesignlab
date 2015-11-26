ARG_LENGTH=0
if [ $# -gt $ARG_LENGTH ];
then
	if [ "$1" = "help" ];
	then
    	echo "Available Commands --> 
    			1. ./build.sh (To build file) 
    			2. ./build.sh clean (To clean the build)
    			3. ./build.sh generate file_name(To generate output and compare with the test data)"
    	exit
	elif [ "$1" = "clean" ];
	then
		rm *.c *.out *.h *.err
		echo "Directory cleaned"
		exit
	elif [ "$1" = "generate" ];
	then
		if [ $# -ne 2 ];
		then
			echo "Invalid command!!! Use--> ./build.sh compare file_name"
			exit
		fi
		TEST_FILE=$2
		echo "Comparing with the test data"
		./parser.out <../Assignment2_data/$TEST_FILE.rtsl 1>$TEST_FILE.out 2>$TEST_FILE.err
		exit
	else
		echo "Wrong Options selected. Available options 1. help 2. clean 3. compare"
		exit
	fi
fi

bison -vd student.y -o student.yy.c 
flex -o student.lex.c student.lex 
gcc -o parser.out student.yy.c student.lex.c
