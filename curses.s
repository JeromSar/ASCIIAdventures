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
cp_blue:		.quad	3

.global cp_blue

.global curses_init
.global curses_deinit
.global	color_start_red
.global	color_stop_red
.global color_start_yellow
.global color_stop_yellow
.global color_start_blue
.global color_stop_blue
.global color_start
.global color_stop

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

	# Enable special character
	movq	$178, %rdi
	call	addch

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

	# 2 - yellow on black
	movq	$2, %rdi
	movq	color_yellow, %rsi
	movq	color_black, %rdx
	call	init_pair

	# 3 - blue on black
	movq	$3, %rdi
	movq	color_blue, %rsi
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

color_start:
	pushq	%rbp
	movq	%rsp, %rbp

	call	COLOR_PAIR
	movq	%rax, %rdi
	call	attron

	movq	%rbp, %rsp
	popq	%rbp
	ret


color_stop:
	pushq	%rbp
	movq	%rsp, %rbp

	call	COLOR_PAIR
	movq	%rax, %rdi
	call	attroff

	movq	%rbp, %rsp
	popq	%rbp
	ret

color_start_red:
	pushq	%rbp
	movq	%rsp, %rbp

	# Enable color 1
	movq	$1, %rdi
	call	COLOR_PAIR
	movq	%rax, %rdi
	call	attron

	movq	%rbp, %rsp
	popq	%rbp
	ret

color_stop_red:
	pushq	%rbp
	movq	%rsp, %rbp

	# Disable color 1
	movq	$1, %rdi
	call	COLOR_PAIR
	movq	%rax, %rdi
	call	attroff

	movq	%rbp, %rsp
	popq	%rbp
	ret

color_start_yellow:
	pushq	%rbp
	movq	%rsp, %rbp

	# Enable color 2
	movq	$2, %rdi
	call	COLOR_PAIR
	movq	%rax, %rdi
	call	attron

	movq	%rbp, %rsp
	popq	%rbp
	ret

color_stop_yellow:
	pushq	%rbp
	movq	%rsp, %rbp

	# Disable color 2
	movq	$2, %rdi
	call	COLOR_PAIR
	movq	%rax, %rdi
	call	attroff

	movq	%rbp, %rsp
	popq	%rbp
	ret

color_start_blue:
	pushq	%rbp
	movq	%rsp, %rbp

	# Enable color 3
	movq	$3, %rdi
	call	COLOR_PAIR
	movq	%rax, %rdi
	call	attron

	movq	%rbp, %rsp
	popq	%rbp
	ret

color_stop_blue:
	pushq	%rbp
	movq	%rsp, %rbp

	# Disable color 3
	movq	$3, %rdi
	call	COLOR_PAIR
	movq	%rax, %rdi
	call	attroff

	movq	%rbp, %rsp
	popq	%rbp
	ret
