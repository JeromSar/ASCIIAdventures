.text
chest_char:		.asciz "C"

.global render_game_chests

render_game_chests:

	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%r15

	call	screen_get_id
	movq	%rax, %r14

	movq	chests_count, %r15
	decq	%r15

chest_render_loop:
	cmpq	$0, %r15
	je	chest_render_done

	movq	%r15, %rdi

	call	chest_id_to_addr

	cmpq	%r14, 8(%rax)			# checks if door is to be printed
	jne	chest_render_continue

	cmpq	$0, 32(%rax)			# checks if door is to be printed
	jne	chest_render_continue

print_chest:
	pushq	%rax
	call	color_start_yellow
	popq	%rax

	pushq	%rax
	movq	24(%rax), %rdi
	movq	16(%rax), %rsi
	movq	$chest_char, %rdx
	movq	$0, %rax
	call	mvprintw
	popq	%rax

	pushq	%rax
	call	color_stop_yellow
	popq	%rax

chest_render_continue:
	decq	%r15
	jmp	chest_render_loop

chest_render_done:
	popq	%r15
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret
