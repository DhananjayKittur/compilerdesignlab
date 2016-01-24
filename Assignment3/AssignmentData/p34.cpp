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
public:
	BlockData mBlockData[26];
	StringRef mUninitVar[100];
	int mNumOfUninitVar;
	static char ID;
	DefinitionPass() : FunctionPass(ID), mNumOfUninitVar(0) {}

	virtual void getAnalysisUsage(AnalysisUsage &au) const {
		au.setPreservesAll();
	}

	virtual bool runOnFunction(Function &F) {
		StringRef ArgInstrName[10] = {"One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};

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

//How should the initialization should be done? Should it be done just before the usage or should it be used 
//just before the usage.
class FixingPass : public FunctionPass {
public:
	BlockData mBlockData[26];
	StringRef mUninitVar[100];
	int mUninitVarType[100];
	int mNumOfUninitVar;
	static char ID;
	FixingPass() : FunctionPass(ID){}

	virtual bool runOnFunction(Function &F){
		StringRef ArgInstrName[10] = {"One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};

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
        //Insert the initialization here

	for (inst_iterator I = inst_begin(F), E = inst_end(F); I != E; ++I) {
		if( isa<AllocaInst>(*I)) {
			AllocaInst *allocaInst = (AllocaInst*) &*I;
  			//errs() << *I <<" Name: " <<I->getName()<<allocaInst->getAllocatedType()->isIntegerTy()<<"\n";
  			if( !isInitialized(I->getName())) {
  				if(allocaInst->getAllocatedType()->isIntegerTy()) {
  					errs()<<"Integer is missing for "<<I->getName()<<"\n";

  					IntegerType *int_type = Type::getInt32Ty(F.getContext());
					Value *num = ConstantInt::get(int_type, 10, true);
					Value *alloc = (Value*) &*I;
					StoreInst *ptr = new StoreInst(num,alloc,false);
					ptr->setAlignment(4);
					Instruction *i = (Instruction*) &*(I); 
					ptr->insertAfter(i);

  				} else if(allocaInst->getAllocatedType()->isFloatTy()) {

  					Type *float_type = Type::getFloatTy(F.getContext());
					Value *num = ConstantFP::get(float_type, 20.0);
					Value *alloc = (Value*) &*I;
					StoreInst *ptr = new StoreInst(num,alloc,false);
					ptr->setAlignment(4);
					Instruction *i = (Instruction*) &*(I); 
					ptr->insertAfter(i);
  					errs()<<"Float is missing for "<<I->getName()<<"\n";
  				} else if(allocaInst->getAllocatedType()->isDoubleTy()) {

  					Type *double_type = Type::getDoubleTy(F.getContext());
					Value *num = ConstantFP::get(double_type, 30.0);
					Value *alloc = (Value*) &*I;
					StoreInst *ptr = new StoreInst(num,alloc,false);
					ptr->setAlignment(4);
					Instruction *i = (Instruction*) &*(I); 
					ptr->insertAfter(i);
  					//errs()<<"Double is missing for "<<I->getName()<<"\n";
  				}
  			}
		}
	}

	errs()<<"\n After the addition of store \n";
	for (inst_iterator I = inst_begin(F), E = inst_end(F); I != E; ++I) {
		errs() << *I <<"\n";
	}
	    return true;
	}

private:
	int isInitialized( StringRef  val ) {
		for( int i=0; i<mNumOfUninitVar; i++ ) {
			if( !mUninitVar[i].compare(val) )
				return 0;
		}
		return 1;
	}
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
} // namespace


char DefinitionPass::ID = 0;
char FixingPass::ID = 1;

// Pass registrations
static RegisterPass<DefinitionPass> X("def-pass", "Reaching definitions pass");
static RegisterPass<FixingPass> Y("fix-pass", "Fixing initialization pass");



