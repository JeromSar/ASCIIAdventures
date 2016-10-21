.global render_game_screen
.global screen_get_id

render_game_screen:
	push	%rbp
	movq	%rsp, %rbp

	# Select current screen
	movq	screen_x, %rdi
	movq	screen_y, %rsi
	call	select_screen

	# Print current screen
	movq	$0, %rdi
	movq	$0, %rsi
	movq	%rax, %rdx
	call	mvprintw

	movq	%rbp, %rsp
	popq	%rbp
	ret

screen_get_id:
	push	%rbp
	movq	%rsp, %rbp

	movq	screen_y, %rdx
	movq	$4, %rax
	mulq	%rdx
	addq	screen_x, %rax

	movq	%rbp, %rsp
	popq	%rbp
	ret
