.text

.global control_mobs

control_mobs:
	push	%rbp
	movq	%rsp, %rbp


	# Calculate scr id, store in r14
	call	screen_get_id
	movq	%rax, %r14

	# Current mob,store in r15
	movq	mobs_count, %r15
	decq	%r15

control_loop:
	cmpq	$0, %r15
	je	control_done

	# Get the mobs address, store in r13
	movq	%r15, %rdi
	call	mobs_id_to_addr
	movq	%rax, %r13

	# DEBUG - Print some debug information
	# pushq	%rax
	# movq	%r14, %rdi
	# movq	$4, %rsi
	# incq	%r14
	# movq	$debug, %rdx
	# movq	16(%rax), %rcx
	# movq	24(%rax), %r8
	# movq	32(%rax), %r9
	# movq	$0, %rax
	# call	mvprintw
	# popq	%rax
	# DEBUG - end

	# Check that the mob is on the current screen
	cmpq	%r14, 16(%r13)
	jne	control_continue

	# Do pathfinding
	movq	24(%r13), %rdi
	movq	32(%r13), %rsi
	call	pathfinding

	cmpq	$0, %rax
	je	go_east

	cmpq	$1, %rax
	je	go_north

	cmpq	$2, %rax
	je	go_west

	cmpq	$3, %rax
	je	go_south

	# No path found...

control_continue:
	decq	%r15

	# Update the screen so mobs see each other's position
	# TODO: fix
	call	refresh

	jmp	control_loop

control_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret

go_east:
	incq	24(%r13)
	jmp	control_continue

go_north:
	decq	32(%r13)
	jmp	control_continue

go_west:
	decq	24(%r13)
	jmp	control_continue

go_south:
	incq	32(%r13)
	jmp	control_continue
