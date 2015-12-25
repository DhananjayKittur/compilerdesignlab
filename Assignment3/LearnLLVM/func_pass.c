#include <llvm/Pass.h>
#include <llvm/IR/Function.h>

class TestPass : public llvm::FunctionPass {
public:
	virutal bool runOnFunction(llvm::Function &F) {
		if( F.getName().startswith("hello")) {
			std::cout <<"Function name starts with hello\n";
		}
		return false;
	}

	static char ID;
};

char TestPass::ID = 'a';
static llvm::RegisterPass<TestPass> global_("test_pass", "test pass", false, false );
