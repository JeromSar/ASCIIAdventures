.text
key_char:		.asciz "K"

.global render_game_keys

render_game_keys:

	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%r15

	call	get_screen_id
	movq	%rax, %r14

	movq	keys_count, %r15
	decq	%r15

key_render_loop:
	cmpq	$0, %r15
	je	key_render_done

	movq	%r15, %rdi

	call	keys_id_to_addr

	cmpq	%r14, 8(%rax)
	jne	key_render_continue

	cmpq	$0, 40(%rax)
	jne	key_render_continue

	cmpq	$0, 32(%rax)
	jne	red

	pushq	%rax
	call	color_start_blue
	popq	%rax

	jmp	print_key

red:
	cmpq	$1, 32(%rax)
	jne	green

	pushq	%rax
	call	color_start_red
	popq	%rax

	jmp	print_key

green:
	pushq	%rax
	call	color_start_green
	popq	%rax


print_key:
	pushq	%rax
	movq	24(%rax), %rdi
	movq	16(%rax), %rsi
	movq	$key_char, %rdx
	call	mvprintw
	popq	%rax

	cmpq	$0, 32(%rax)
	jne	red_stop
	call	color_stop_blue
	jmp	key_render_continue

red_stop:
	cmpq	$1, 32(%rax)
	jne	green_stop
	call	color_stop_red
	jmp	key_render_continue

green_stop:
	call	color_stop_green

key_render_continue:
	decq	%r15
	jmp	key_render_loop

key_render_done:
	popq	%r15
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret
