.text
door_char:		.asciz "D"

.global render_game_doors

render_game_doors:

	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%r15

	call	get_screen_id
	movq	%rax, %r14

	movq	doors_count, %r15
	decq	%r15

door_render_loop:
	cmpq	$0, %r15
	je	door_render_done

	movq	%r15, %rdi

	call	doors_id_to_addr

	cmpq	%r14, 8(%rax)
	jne	door_render_continue

	cmpq	$0, 40(%rax)
	jne	door_render_continue

	cmpq	$0, 32(%rax)
	jne	red

	pushq	%rax
	call	color_start_blue
	popq	%rax

	jmp	print_door

red:
	cmpq	$1, 32(%rax)
	jne	green

	pushq	%rax
	call	color_start_red
	popq	%rax

	jmp	print_door

green:
	pushq	%rax
	call	color_start_green
	popq	%rax


print_door:
	pushq	%rax
	movq	24(%rax), %rdi
	movq	16(%rax), %rsi
	movq	$door_char, %rdx
	call	mvprintw
	popq	%rax

	cmpq	$0, 32(%rax)
	jne	red_stop
	call	color_stop_blue
	jmp	door_render_continue

red_stop:
	cmpq	$1, 32(%rax)
	jne	green_stop
	call	color_stop_red
	jmp	door_render_continue

green_stop:
	call	color_stop_green

door_render_continue:
	decq	%r15
	jmp	key_render_loop

door_render_done:
	popq	%r15
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret
