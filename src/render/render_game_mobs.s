.text
mob_char:		.asciz	"W"

.global render_game_mobs

render_game_mobs:
	pushq	%rbp
	movq	%rsp, %rbp

	# Calculate scr id, store in r14
	call	screen_get_id
	movq	%rax, %r14

	movq	mobs_count, %r15
	decq	%r15

render_loop:
	cmpq	$0, %r15
	je	mobs_render_done

	# Get the mobs address
	movq	%r15, %rdi
	call	mobs_id_to_addr

	# DEBUG - Print some debug information
	#pushq	%rax
	#movq	%r14, %rdi
	#movq	$4, %rsi
	#incq	%r14
	#movq	$debug, %rdx
	#movq	16(%rax), %rcx
	#movq	24(%rax), %r8
	#movq	32(%rax), %r9
	#movq	$0, %rax
	#call	mvprintw
	#popq	%rax
	# DEBUG - end

	# Check that the mob is on the current screen
	cmpq	%r14, 16(%rax)
	jne	mobs_render_continue

	pushq	%rax
	call	color_start_cyan
	popq	%rax

	# Get the x y and print
	movq	32(%rax), %rdi
	movq	24(%rax), %rsi
	movq	$mob_char, %rdx
	call	mvprintw

	call	color_stop_cyan

mobs_render_continue:
	decq	%r15
	jmp	render_loop

mobs_render_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret
