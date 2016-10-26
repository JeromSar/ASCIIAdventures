.text
title:		.asciz	"Main Menu"
opt_play:	.asciz	"[play]"
opt_load:	.asciz	"[load]"
opt_exit:	.asciz	"[exit]"
arrow:		.asciz	">"

.global render_mainmenu_screen

render_mainmenu_screen:
	pushq	%rbp
	movq	%rsp, %rbp

	# Print menu background
	movq	$0, %rdi
	movq	$0, %rsi
	movq	$screen_mainmenu, %rdx
	call	mvprintw

	#
	# Print menu entries
	#

	# Row (y) - r12
	movq	$1, %r12

	# Column (x) - r13
	movq	HALF_WIDTH, %r13
	subq	$4, %r13

	# Title
	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	$title, %rdx
	call	mvprintw

	movq	$11, %r12

	# Play
	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	$opt_play, %rdx
	call	mvprintw

	addq	$2, %r12

	# Load
	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	$opt_load, %rdx
	call	mvprintw

	addq	$2, %r12

	# Exit
	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	$opt_exit, %rdx
	call	mvprintw

	#
	# Print '>' character
	#

	# Multiply the selected option by 2, and add 11
	movq	mainmenu_selection, %rax
	movq	$2, %rdx
	mulq	%rdx
	movq	%rax, %r12
	addq	$11, %r12

	subq	$2, %r13			# Print it 2 characters left of the options

	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	$arrow, %rdx
	call	mvprintw

	movq	%rbp, %rsp
	popq	%rbp
	ret
