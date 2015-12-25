clang++-3.5 -g tut1.cpp -std=c++0x `llvm-config --libs core --ldflags --cxxflags` -o tut1

opt -load=./func_pass.so -test_pass < test_func_pass.bc