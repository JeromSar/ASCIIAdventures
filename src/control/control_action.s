.text
lever_activate:			.asciz	"You activated the lever"
lever_deactivate:		.asciz	"You deactivated the lever"

.data

.global control_action

control_action:
	pushq	%rbp
	movq	%rsp, %rbp

	call	screen_get_id
	movq	%rax, %r14				# r14, screen id

	cmpq	%r12, key_e
	je	control_e

	cmpq	%r12, key_p
	je	control_p

control_action_done:
	movq	%rsp, %rbp
	popq	%rbp
	ret


# The action key is pressed - action
control_e:

	movq	levers_count, %r15			# r15 - current lever processing

control_e_loop:
	cmpq	$0, %r15
	je	control_e_done

	# Get the lever object's address
	movq	%r15, %rdi
	call	levers_id_to_addr
	movq	%rax, %r13				# r13 - current lever address

	# Check that the lever is on the current screen
	cmpq	%r14, 40(%r13)
	jne	control_e_continue

	# Compare the x and y of the lever
	movq	player_x, %r8
	movq	player_y, %r9
	incq	%r8

	cmpq	%r8, 48(%r13)
	jne	control_e_continue
	cmpq	%r9, 56(%r13)
	jne	control_e_continue

	#movq	$1, %rdi
	#movq	$1, %rsi
	#movq	$debug, %rdx
	#movq	40(%r13), %rcx
	#movq	48(%r13), %r8
	#movq	56(%r13), %r9
	#movq	$0, %rax
	#call	mvprintw
	#call	getch

	# Toggle the lever
	movq	8(%r13), %r8
	cmpq	$0, %r8
	je	control_e_val_0

	# Value is nonzero
	movq	$0, 8(%r13)
	movq	$lever_deactivate, %rdi
	call	log_push

	jmp	control_e_continue

control_e_val_0:
	# Value is zero
	movq	$1, 8(%r13)
	movq	$lever_activate, %rdi
	call	log_push


control_e_continue:
	decq	%r15
	jmp	control_e_loop

control_e_done:

	jmp	control_action_done

# The pause key is pressed
control_p:
	movq	state_gamemenu, %r8
	movq	%r8, current_state

	jmp	control_action_done
