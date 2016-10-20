.data
screen_x:		.quad	1
screen_y:		.quad	2

.global screen_x
.global screen_y
.global screen_print
.global screen_get_id

screen_print:
	push	%rbp
	movq	%rsp, %rbp

	# Select current screen
	movq	screen_x, %rdi
	movq	screen_y, %rsi
	call	select_screen

	# Print current screen
	movq	$0, %rdi
	movq	$0, %rsi
	movq	%rax, %rdx
	call	mvprintw

	movq	%rbp, %rsp
	popq	%rbp
	ret

screen_get_id:
	push	%rbp
	movq	%rsp, %rbp

	movq	screen_y, %rdx
	movq	$4, %rax
	mulq	%rdx
	addq	screen_x, %rax

	movq	%rbp, %rsp
	popq	%rbp
	ret
