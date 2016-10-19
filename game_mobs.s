.text
mob_char:		.asciz	"W"

.global mobs_print

mobs_print:
	pushq	%rbp
	movq	%rsp, %rbp

	# Calculate scr id, store in r14
	movq	screen_y, %rdx
	movq	$4, %rax
	mulq	%rdx
	addq	screen_x, %rax
	movq	%rax, %r14

	# Print mobs
	movq	mobs_count, %r15
	decq	%r15

mobs_print_loop:
	cmpq	$0, %r15
	je	mobs_print_done

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
	jne	mobs_print_continue

	movq	cp_blue, %rdi
	#call	color_start

	# Get the x y and print
	movq	24(%rax), %rdi
	movq	32(%rax), %rsi
	movq	$mob_char, %rdx
	call	mvprintw

	movq	cp_blue, %rdi
	#call	color_stop

mobs_print_continue:
	decq	%r15
	jmp	mobs_print_loop

mobs_print_done:
	jmp	print_state_ret

	movq	%rbp, %rsp
	popq	%rbp
	ret
