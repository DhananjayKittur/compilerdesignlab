ARG_LENGTH=0
if [ $# -gt $ARG_LENGTH ];
then
	if [ "$1" = "help" ];
	then
    	echo "Available Commands --> 
    			1. ./build.sh (It will run make)
    			2. ./build.sh clean (To clean the build)
    			3. ./build.sh clang testx ( where x = 0,1,...,8) 
    			4. ./build.sh opt testx ( where x = 0,1,...,8) "
    	exit
	elif [ "$1" = "clean" ];
	then
		rm *.out *.bc *.opt *.so
		echo "Directory cleaned"
		exit
	elif [ "$1" = "clang" ];
	then
		if [ $# -ne 2 ];
		then
			echo "Invalid command!!! Use--> ./build.sh clang testx ( where x = 0,1,...,8) "
			exit
		fi
		clang-3.5 -c -emit-llvm $2.c -o $2.bc
		exit
	elif [ "$1" = "opt" ];
	then
		if [ $# -ne 2 ];
		then
			echo "Invalid command!!! Use--> ./build.sh opt testx ( where x = 0,1,...,8) "
			exit
		fi
		opt -load ./p34.so -def-pass $2.bc -o $2_def.bc
	else
		echo "Wrong Options selected. Available options 1. help 2. clean 3. clang 4.opt"
		exit
	fi
fi
make