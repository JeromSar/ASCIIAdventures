.text
no_screen_err:	.asciz	"No such screen: (x=%u, y=%u)\n"

.data


.global select_screen

select_screen:
	pushq	%rbp
	movq	%rsp, %rbp

	# x = 3
	cmpq	$3, %rdi
	je	x_3

	cmpq	$4, %rdi
	je	x_4

	call	screen_not_found

	#
	# X = 3
	#
x_3:
	# y = 3
	cmpq	$3, %rsi
	je	x_3_y_3

	# y = 2
	cmpq	$2, %rsi
	je	x_3_y_2

	call	screen_not_found


x_3_y_3:
	movq	$screen_game_1, %rax
	jmp	screen_select_end

x_3_y_2:
	movq	$screen_game_2, %rax
	jmp	screen_select_end

	#
	# X = 4
	#
x_4:
	cmpq	$3, %rsi
	je	x_4_y_3

	call	screen_not_found

x_4_y_3:
	movq	$screen_game_3, %rax
	jmp	screen_select_end

screen_select_end:
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
