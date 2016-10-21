.text
state_main_menu:	.quad	0
state_game:		.quad	1

.data
current_state:		.quad	0

.global state_render
.global state_control
.global state_main_menu
.global state_game
.global current_state
.global state_control_ret
.global state_render_ret

#
# Subroutine - render_state
# Prints the current state
#
state_render:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15

	movq	current_state, %r13

	cmpq	%r13, state_main_menu
	je	main_menu_print

	cmpq	%r13, state_game
	je	game_print

state_render_ret:
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret

#
# Subroutine - control_state
# Reads a character from stdin and processes it
#
state_control:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15

	# Resize the terminal
	#movq	HEIGHT, %rdi
	#movq	WIDTH, %rsi
	#call	resizeterm

	call	getch					# Read a character
	movq	%rax, %r12				# Store it in r12

	movq	$0, %rax				# Default return code is 0, each state can modify this value if needed
							# For example, if 1 is returned, the game exits


	movq	current_state, %r13

	cmpq	%r13, state_main_menu
	je	main_menu_control

	cmpq	%r13, state_game
	je	game_control

state_control_ret:
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret
