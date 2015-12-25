	.file	"test_func_pass.cpp"

	.ident	"GCC: (Ubuntu/Linaro 4.7.3-12ubuntu1) 4.7.3 LLVM: 3.3"


	.text
	.globl	_Z5hellov
	.align	16, 0x90
	.type	_Z5hellov,@function
_Z5hellov:
	.cfi_startproc
	pushq	%rbp
.Ltmp2:
	.cfi_def_cfa_offset 16
.Ltmp3:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp4:
	.cfi_def_cfa_register %rbp
	jmp	.LBB0_2
.LBB0_2:
	popq	%rbp
	ret
.Ltmp5:
	.size	_Z5hellov, .Ltmp5-_Z5hellov
	.cfi_endproc


	.section	".note.GNU-stack","",@progbits
