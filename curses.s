.text
no_color_err:		.asciz	"Your terminal does not support color :C"
color_black:		.quad	0
color_red:		.quad	1
color_green:		.quad	2
color_yellow:		.quad	3
color_blue:		.quad	4
color_magenta:		.quad	5
color_cyan:		.quad	6
color_white:		.quad	7

.global curses_init
.global curses_deinit

curses_init:
	pushq	%rbp
	movq	%rsp, %rbp

	# Init curses
	# http://tldp.org/HOWTO/NCURSES-Programming-HOWTO/helloworld.html#COMPILECURSES
	call	initscr

	# No line bufering
	call	cbreak

	# Don't echo back characters
	call	noecho

	# Enable the function keys (arrows, keypad, etc)
	movq	$stdscr, %rdi
	movq	$1, %rsi
	#call	keypad				# Or not

	# Hide the cursor
	movq	$0, %rdi
	call	curs_set

	# Check that colors are supported
	call	has_colors
	cmpq	$0, %rax
	jne	curses_init_color


	call	endwin
	movq	$no_color_err, %rdi
	call	printf

	movq	$1, %rdi
	call	exit


curses_init_color:

	# Initialise some colors
	call	start_color

	# 1 - red on black
	movq	$1, %rdi
	movq	color_red, %rsi
	movq	color_black, %rdx
	call	init_pair

	# End of init
	movq	%rbp, %rsp
	popq	%rbp
	ret

curses_deinit:
	pushq	%rbp
	movq	%rsp, %rbp

	# Deinit curses
	call	endwin

	movq	%rbp, %rsp
	popq	%rbp
	ret
