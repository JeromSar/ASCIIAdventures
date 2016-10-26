.text
no_screen_err:	.asciz	"No such screen: (x=%u, y=%u)\n"
screentable:
	.quad	lvl_1_00
	.quad	lvl_1_10
	.quad	lvl_1_20
	.quad	lvl_1_30
	.quad	lvl_1_01
	.quad	lvl_1_11
	.quad	lvl_1_21
	.quad	lvl_1_31
	.quad	lvl_1_02
	.quad	lvl_1_12
	.quad	lvl_1_22
	.quad	lvl_1_32
	.quad	lvl_1_03
	.quad	lvl_1_13
	.quad	lvl_1_23
	.quad	lvl_1_33

.global select_screen

select_screen:
	pushq	%rbp
	movq	%rsp, %rbp

	# Calculate scr id, store in r14
	movq	screen_y, %rdx
	movq	$4, %rax
	mulq	%rdx
	addq	screen_x, %rax

	cmpq	$15, %rax
	jg	screen_not_found

	shl	$3, %rax
	movq	screentable(%rax), %rax


#	movq	$lvl_1_12, %rax

	movq	%rbp, %rsp
	popq	%rbp
	ret


screen_not_found:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, %r12
	movq	%rsi, %r13

	call	endwin

	# Screen not found
	movq	$no_screen_err, %rdi
	movq	%r12, %rsi
	movq	%r13, %rdx
	call	printf

	movq	$0, %rdi
	call	exit
