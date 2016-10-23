.text
test:			.asciz	"Hello world!!!"
char_w:			.quad	'w'
char_s:			.quad	's'

WIDTH:			.quad	80
WIDTH_MINUS_ONE:	.quad	79
HALF_WIDTH:		.quad	40

HEIGHT:			.quad	24
HEIGHT_MINUS_ONE:	.quad	23
HALF_HEIGHT:		.quad	12

GAME_HEIGHT:		.quad	18
GAME_HEIGHT_MINUS_ONE:	.quad	17

.global WIDTH
.global WIDTH_MINUS_ONE
.global HALF_WIDTH
.global HEIGHT
.global HEIGHT_MINUS_ONE
.global HALF_HEIGHT
.global GAME_HEIGHT
.global GAME_HEIGHT_MINUS_ONE

.global main
.global main_end

main:
	pushq	%rbp
	movq	%rsp, %rbp

	call	curses_init
	call	mobs_init
	call	levers_init

main_loop:
	call	state_render				# Print the current screen to the buffer

	call	refresh					# Call Libcurses's refresh to update the screen

	call	state_control				# Get a char, and process it

	# cmpq	$1, %rax				# If control_state returned 1
	# jne	main_loop				# Don't continue the main_loop
	jmp	main_loop
main_end:

	call	curses_deinit

	movq	$0, %rdi
	call	exit
