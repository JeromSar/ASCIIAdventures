.text
title:				.asciz	"Paused"
text_return:			.asciz	"[Return to game]"
text_save:			.asciz	"[Save game]"
text_exit:			.asciz	"[Exit]"
arrow:				.asciz	">"

.global render_gamemenu_screen

render_gamemenu_screen:
	pushq	%rbp
	movq	%rsp, %rbp

	call	color_start_cyan

	movq	$0, %r13

render_screen_loop:
	movq	$4, %rdi					# Y coord
	addq	%r13, %rdi					# Add the offset

	movq	$23, %rsi					# X coord

	# Print each line seperately
	movq	screen_gamemenu_line_length, %rax
	movq	%r13, %rdx
	mulq	%rdx
	movq	%rax, %rdx

	addq	$screen_gamemenu, %rdx				# Add the offset

	call	mvprintw



	incq	%r13
	cmpq	%r13, screen_gamemenu_count
	jne	render_screen_loop
render_screen_loop_done:
	call	color_stop_cyan

	# Print title
	movq	$5, %rdi
	movq	$37, %rsi
	movq	$title, %rdx
	call 	mvprintw

	# Print options
	movq	$8, %rdi
	movq	$34, %rsi
	movq	$text_return, %rdx
	call	mvprintw

	movq	$9, %rdi
	movq	$34, %rsi
	movq	$text_save, %rdx
	call	mvprintw

	movq	$10, %rdi
	movq	$34, %rsi
	movq	$text_exit, %rdx
	call	mvprintw

	#
	# Print '>' character
	#

	# Multiply the selected option by 2, and add 11
	movq	$8, %rdi
	addq	gamemenu_selection, %rdi
	movq	$32, %rsi
	movq	$arrow, %rdx
	call	mvprintw

	movq	%rbp, %rsp
	popq	%rbp
	ret
