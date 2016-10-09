
.text
test:		.asciz	"Hello world!!!"
WIDTH:		.quad	80
HALF_WIDTH:	.quad	40
HEIGHT:		.quad	24
HALF_HEIGHT:	.quad	12
char_w:		.quad	'w'
char_s:		.quad	's'


.global WIDTH
.global HALF_WIDTH
.global HEIGHT
.global HALF_HEIGHT


.global main
.global end

main:
	pushq	%rbp
	movq	%rsp, %rbp

	call	init_curses

main_loop:
	call	print_state				# Print the current screen to the buffer

	call	refresh					# Call Libcurses's refresh to update the screen

	call	control_state				# Get a char, and process it

	cmpq	$1, %rax				# If control_state returned 1
	jne	main_loop				# Don't continue the main_loop

main_end:
	call	deinit_curses

	movq	$0, %rdi
	call	exit
