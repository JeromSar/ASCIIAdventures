.text

.global render_gameover_screen

render_gameover_screen:
	pushq	%rbp
	movq	%rsp, %rbp

	# Print gameover screen
	movq	$0, %rdi
	movq	$0, %rsi
	movq	$screen_gameover, %rdx
	call	mvprintw

	movq	%rbp, %rsp
	popq	%rbp
	ret
