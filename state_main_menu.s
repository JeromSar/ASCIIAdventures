.text
title:		.asciz	"Main Menu"
opt_play:	.asciz	"[play]"
opt_exit:	.asciz	"[exit]"
arrow:		.asciz	">"
num_opts:	.quad	1			# Zero-indexed

.data
select_option:	.quad	0

.global main_menu_print
.global main_menu_control

main_menu_print:
	# Print menu background
	movq	$0, %rdi
	movq	$0, %rsi
	movq	$screen_main_menu, %rdx
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

	# Exit
	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	$opt_exit, %rdx
	call	mvprintw

	#
	# Print '>' character
	#

	# Multiply the selected option by 2, and add 11
	movq	select_option, %rax
	movq	$2, %rdx
	mulq	%rdx
	movq	%rax, %r12
	addq	$11, %r12

	subq	$2, %r13			# Print it 2 characters left of the options

	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	$arrow, %rdx
	call	mvprintw


	jmp	print_state_ret


main_menu_control:

	# The char is stored in r12

	cmpq	%r12, key_w
	je	control_up

	cmpq	%r12, key_s
	je	control_down

	cmpq	%r12, key_enter
	je	control_enter

	jmp	control_state_ret		# Unknown key

# Up key
control_up:
	cmpq	$0, select_option
	je	control_up_low

	subq	$1, select_option
	jmp	control_state_ret
control_up_low:
	movq	num_opts, %r13
	movq	%r13, select_option
	jmp	control_state_ret

# Down key
control_down:
	movq	num_opts, %r13
	cmpq	%r13, select_option
	je	control_down_high

	addq	$1, select_option
	jmp	control_state_ret
control_down_high:
	movq	num_opts, %r13
	movq	$0, select_option
	jmp	control_state_ret

# Enter key
control_enter:
	cmpq	$0, select_option
	je	control_enter_play

	cmpq	$1, select_option
	je	control_enter_exit

	jmp	control_state_ret
control_enter_play:
	movq	state_game, %r8
	movq	%r8, current_state
	jmp	control_state_ret

control_enter_exit:
	movq	$1, %rax			# rax=1 - exit
	jmp	control_state_ret
