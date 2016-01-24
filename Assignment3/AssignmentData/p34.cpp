/* Name Surname */

// STL 
#include <map>
#include <vector>
#include <utility>

// LLVM 
#include <llvm/Pass.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include "llvm/Support/CFG.h"
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/InstIterator.h>
#include <llvm/IR/Constants.h>
#define WORKING_SOLUTION 1

using namespace llvm;

namespace {

class BlockData 
{
public:
	StringRef mInitializedVar[100];
	int mNumInitializedVar;

	BlockData() {
		mNumInitializedVar = 0;
	}

	void addInitializedVar(StringRef val) {
		if( !existInEntry(val) ) {
			mInitializedVar[mNumInitializedVar++] = val;
		}
	}

private:
	int existInEntry(StringRef val) {
		for( int i=0; i<mNumInitializedVar; i++ ) {
			if( !mInitializedVar[i].compare(val)) {
				return 1;
			}
		}

		return 0;
	}
};

class DefinitionPass  : public FunctionPass {
#if 0
	int mSize; 
	StringRef mLoadVariable[100];
#endif
	BlockData mBlockData[26];
	StringRef mUninitVar[100];
	int mNumOfUninitVar;
public:
	static char ID;
	DefinitionPass() : FunctionPass(ID), mNumOfUninitVar(0) {}

	virtual void getAnalysisUsage(AnalysisUsage &au) const {
		au.setPreservesAll();
	}

	virtual bool runOnFunction(Function &F) {
		StringRef ArgInstrName[10] = {"One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};
#if 0  //Testing for inter function reference passing 
            // TODO
		errs()<<"Function "<<F.getName()<<"\n";
		//For the time being just work for the function call from the main and doesnot support function call from function
		if(F.getName().compare("main")) {
			return false;
		}
      	for (Function::iterator b = F.begin(), be = F.end(); b != be; ++b) {
      			//errs()<<"Block "<<"\n";
        	for (BasicBlock::iterator i = b->begin(), ie = b->end(); i != ie; ++i) {
        		errs() << *i << "\n";
        		if( isa<LoadInst>(*i) ) {
        			//errs()<<*I<<"\n";
        			//errs()<<"Load: Name: "<<i->getOperand(0)->getName()<<" Type: "<<i->getOperand(0)->getType()->isPointerTy()<<"\n";

        			//LoadInst *loadInst = (LoadInst) &*i;
        		}
        		if( isa<StoreInst>(*i) ) {
        			//errs()<<"Store: Name: "<<i->getOperand(0)->getName()<<" Type: "<<i->getOperand(0)->getType()->isPointerTy()<<"\n";
        			//errs()<<"Store: Name: "<<i->getOperand(1)->getName()<<" Type: "<<i->getOperand(1)->getType()->isPointerTy()<<"\n";
        		}
        		if( isa<CallInst>(i)) {

        			CallInst *calledFuncInst = (CallInst*) &*i;
        			Function *calledFunc = calledFuncInst->getCalledFunction();
        			int argPos = 0;
        			errs()<<" Num of Operand = "<<calledFuncInst->getNumArgOperands ()<<"\n";
        			for( int opIter=0; opIter<calledFuncInst->getNumArgOperands (); opIter++ ) {
        				errs()<<" Para: "<<calledFuncInst->getOperand(opIter)->getName();
        			}
        			for(Function::arg_iterator argIterator = calledFunc->arg_begin(), argE 
        				= calledFunc->arg_end(); argIterator != argE; argIterator++ ) {
        				errs()<<" Args: name = "<<argIterator->getName()<<"Type = " <<argIterator->getType()->isPointerTy();
        				if(argIterator->getType()->isPointerTy()) {
        					int retVal = trackPointerArgument(calledFunc, argPos, ArgInstrName[argPos]);
        					if( retVal < 0 ) {
        						errs()<<"Uninitialized Variable is being used for "<<calledFuncInst->getOperand(argPos)->getName();
        					} else if( retVal > 0 ) {
        						errs()<<"Variable initialized for "<<calledFuncInst->getOperand(argPos)->getName();
        					} 
        				}
        				argPos++;
        			}
        			//errs()<<" Calling Function "<<"\n";
        			//ParseCalledFunction(calledFuncInst->getCalledFunction());
        		}
        	}
        }
#endif
#if 0
            for (inst_iterator I = inst_begin(F), E = inst_end(F); I != E; ++I) {
 				 //errs() << *I << "\n";
 				 //errs() <<"Name of Instructions:"<<I->getName()<<"\n";
 				 if( isa<AllocaInst>(*I)) {
 				 	//errs() << "Alloca Instruction"<<"\n";
 				 }
 				 if( isa<LoadInst>(*I)) {
 				 	//errs() << "Load Instruction " <<I->getOperand(0)->getName()<<"\n";
 				 	if( checkLoadVariable(I->getOperand(0)->getName())) {
 				 		errs()<<"Not Initialized Value "<<I->getOperand(0)->getName()<<"\n";
 				 	}
 				 }
 				 if( isa<StoreInst>(*I)) {
 				 	addLoadVariable(I->getOperand(1)->getName());
 				 	//errs() << "Store Instruction " << I->getOperand(1)->getName()<<"\n";
 				 }
 				 //errs() <<I->getOperand(0)->getName()<<"\n";
 #endif
 #if 0
 		//StringRef val = "Block";
 		char a[2]; //Given the fact the number of blocks are less than 26
 		a[0] = 'A';
 		a[1] = '\0';
 		int i=0;
      	for (Function::iterator b = F.begin(), be = F.end(); b != be; ++b) {
      			b->setName(a);
      			a[0]++;
      			errs()<<"Block "<<b->getName()<<"\n";
        	for (BasicBlock::iterator i = b->begin(), ie = b->end(); i != ie; ++i) {
        		errs() << *i << "\n";
        	}
        }
        errs()<<"Predecssor List"<<"\n\n";
        for (Function::iterator b = F.begin(), be = F.end(); b != be; ++b) {
        	errs()<<b->getName()<<": ";
        	for (pred_iterator PI = pred_begin(b), E = pred_end(b); PI != E; ++PI) {
  				BasicBlock *Pred = *PI;
  				errs()<<Pred->getName()<<" ,";
  				// ...
			}
			errs()<<"\n";
        }
#endif
#if WORKING_SOLUTION
		//Start with Naming the block
        //Given the fact the number of blocks are less than 26
 		char a[2]; 
 		a[0] = 'A';
 		a[1] = '\0';
      	for (Function::iterator b = F.begin(), be = F.end(); b != be; ++b) {
      			b->setName(a);
      			a[0]++;
        }

        int currentPos = 0;
        int posOfPred = 0;

		if(F.getName().compare("main")) {
			return false;
		}

        for (Function::iterator b = F.begin(), be = F.end(); b != be; ++b) {
       	    int firstTime = 1;
  			StringRef currName = b->getName();
  			const char *ptrCurrName = currName.data();
  			currentPos = ptrCurrName[0] - 'A';
        	//errs()<<b->getName()<<currentPos<<": ";

        	//Initialize the current block
        	//No need to initialize the first block since it will be empty
        	if( currentPos ) {
        		for (pred_iterator PI = pred_begin(b), E = pred_end(b); PI != E; ++PI) {
  					BasicBlock *Pred = *PI;
  					StringRef predName = Pred->getName();
  					const char *ptrPredName = predName.data();

  					posOfPred = ptrPredName[0] - 'A';
  					if( currentPos > posOfPred ) {
						copyEntryValue(currentPos, posOfPred, firstTime);
						firstTime = 0;
  					}
				}
        	}

        	for (BasicBlock::iterator i = b->begin(), ie = b->end(); i != ie; ++i) {
        		if( isa<LoadInst>(*i)) {
 				 	if( !isVariableInitialized( currentPos, i->getOperand(0)->getName())) {
 				 		if( i->getOperand(0)->hasName() )
 				 			addUninitVar(i->getOperand(0)->getName());
 				 	}
 				 }
 				 if( isa<StoreInst>(*i)) {
 				 	if( i->getOperand(1)->hasName() )
 				 		addInitializedVar( currentPos, i->getOperand(1)->getName());
 				 }
        		if( isa<CallInst>(i)) {

        			CallInst *calledFuncInst = (CallInst*) &*i;
        			Function *calledFunc = calledFuncInst->getCalledFunction();
        			int argPos = 0;
        			for(Function::arg_iterator argIterator = calledFunc->arg_begin(), argE 
        				= calledFunc->arg_end(); argIterator != argE; argIterator++ ) {
        				if(argIterator->getType()->isPointerTy()) {
        					int retVal = trackPointerArgument(calledFunc, argPos, ArgInstrName[argPos]);
        					if( retVal < 0 ) {

 				 				addUninitVar(calledFuncInst->getOperand(argPos)->getName());
        					} else if( retVal > 0 ) {
 				 				addInitializedVar( currentPos, calledFuncInst->getOperand(argPos)->getName());
        					} 
        				}
        				argPos++;
        			}
        		}
        	}
        }
        displayUninitVar();
#endif
#if 0
        int j=0;
        for(Function::iterator b = F.begin(), be = F.end(); b != be; ++b) {
        	errs()<<"Initialized For Block " << j<<"\n";
        	for(int k=0; k<mBlockData[j].mNumInitializedVar; k++ ) {
        		errs()<<" "<<mBlockData[j].mInitializedVar[k];
        	}
        	j++;
        }
#endif
	    return false;
	}
private:
	void displayCurrentInitializedValue( int currentPos) {

		for( int i=0; i<mBlockData[currentPos].mNumInitializedVar; i++ ) {
			errs()<<" "<<mBlockData[currentPos].mInitializedVar[i]<<" ";
		}
		errs()<<"\n";
	}
	void displayUninitVar() {
		for( int i=0; i<mNumOfUninitVar; i++ ) {
			errs()<<mUninitVar[i]<<"\n";
		}
	}
	void addUninitVar( StringRef val ) {
		for( int i=0; i<mNumOfUninitVar; i++ ) {
			if( !mUninitVar[i].compare(val) ) {
				return;
			}
		}
		mUninitVar[mNumOfUninitVar++] = val;
	}

	void copyEntryValue( int current, int smallestPred, int isFirstTime ) {
		if( isFirstTime ) {
			for( int i=0; i<mBlockData[smallestPred].mNumInitializedVar; i++ ) {
				mBlockData[current].addInitializedVar(mBlockData[smallestPred].mInitializedVar[i]);
			}
		} else { //Anding the input with the current input
			int i,j;
			for( i=0; i<mBlockData[current].mNumInitializedVar; i++ ) {
				for ( j=0; j<mBlockData[smallestPred].mNumInitializedVar; j++ ) {
					if( !mBlockData[current].mInitializedVar[i].compare(mBlockData[smallestPred].mInitializedVar[j])) {
						break;
					}
				}			
				//Remove temp since it doesnot belong to this value
				if( j == mBlockData[smallestPred].mNumInitializedVar ) {
					mBlockData[current].mInitializedVar[i] = 
						mBlockData[current].mInitializedVar[mBlockData[current].mNumInitializedVar-1];
					mBlockData[current].mNumInitializedVar--;
					//This value has to be checked again if it is not the last one in the list
					if( i < (mBlockData[current].mNumInitializedVar-1))
						i--;
				}
			}
		}
	}

	void addInitializedVar(int current, StringRef val) {
		mBlockData[current].addInitializedVar(val);
	}

	int isVariableInitialized(int current, StringRef val) {
		for( int i=0; i<mBlockData[current].mNumInitializedVar; i++ ) {
			if( !mBlockData[current].mInitializedVar[i].compare(val) ) {
				return 1;
			}
		}
		return 0;
	}

	//Tracks a single argument in a function which is passed by reference
	int trackPointerArgument(Function *F, int pos, StringRef name) {
		int index = 0, ptrTrackerSet=0;
		StringRef strAppend = "track";
		Twine trackerName = name + strAppend;
		StringRef ptrTrackerName;
		if( F == NULL ) {
			errs() <<"Function called is null.Returning."<<"\n";
			return 0;
		}
      	for (Function::iterator b = F->begin(), be = F->end(); b != be; ++b) {
        	for (BasicBlock::iterator i = b->begin(), ie = b->end(); i != ie; ++i) {
        		if(index == pos ) {
        			if(!i->hasName()) {
        				i->setName(name);
        			}
        		} else if (index > pos && !ptrTrackerSet) {

        			if( isa<LoadInst>(*i) ) {
        				if( !i->getOperand(0)->getName().compare(name)) {
        					//The pointer to pointer is being stored in local variable again
        					if( !i->hasName() ) {
        						i->setName(trackerName);
        						ptrTrackerName = i->getName();
        					}
        					ptrTrackerSet = 1;
        				}
        			}
        		} else {
        			//Track for the changes in the trackerName
        			if(isa<LoadInst>(*i)) {
        				//Value is being used before initializing in the called function. Return Unsuccessful.
        				if(  !i->getOperand(0)->getName().compare(ptrTrackerName)) {
        					return -1; //prorbably -1;
        				}
        			}
        			if(isa<StoreInst>(*i)) {
        				//Value is getting initialized in the called function. Return successful.
        				if(  !i->getOperand(1)->getName().compare(ptrTrackerName)) {
        					return 1; 
        				}
        			}
        		}
        		index++;
        	}
        }
        //Value is not being used in the called function.
        return 0;
	}
};

class FixingPass : public FunctionPass {
public:
	static char ID;
	FixingPass() : FunctionPass(ID){}

	virtual bool runOnFunction(Function &F){
            // TODO
            errs() << "fix-pass\n";
	    return true;
	}
};
} // namespace


char DefinitionPass::ID = 0;
char FixingPass::ID = 1;

// Pass registrations
static RegisterPass<DefinitionPass> X("def-pass", "Reaching definitions pass");
static RegisterPass<FixingPass> Y("fix-pass", "Fixing initialization pass");



