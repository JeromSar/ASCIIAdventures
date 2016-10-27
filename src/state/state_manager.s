.text
state_mainmenu:		.quad	0
state_game:		.quad	1
state_gamemenu:		.quad	2
state_gameover:		.quad	3
debug:			.asciz	"Not running control: %lu"

.data
current_state:		.quad	0

.global state_mainmenu
.global state_game
.global state_gamemenu
.global state_gameover
.global current_state

.global state_render
.global state_render_ret
.global state_control
.global state_control_ret

#
# Subroutine - state_render
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

	cmpq	%r13, state_mainmenu
	je	mainmenu_print

	cmpq	%r13, state_game
	je	game_print

	cmpq	%r13, state_gamemenu
	je	gamemenu_print

	cmpq	%r13, state_gameover
	je	gameover_print

state_render_ret:
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret

#
# Subroutine - state_control
# Reads a character from stdin and processes it
#
state_control:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15

	call	getch					# Read a character
	movq	%rax, %r12				# Store it in r12

	cmpq	%r12, key_error
	jle	state_control_nochar

	# Current states
	movq	current_state, %r13

	cmpq	%r13, state_mainmenu
	je	mainmenu_control

	cmpq	%r13, state_game
	je	game_control

	cmpq	%r13, state_gamemenu
	je	gamemenu_control

	cmpq	%r13, state_gameover
	je	gameover_control

	# Unknown state?
	jmp	state_control_ret

state_control_nochar:
state_control_ret:
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret
