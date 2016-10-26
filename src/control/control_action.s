.text
lever_activate:			.asciz	"You activated the lever"
lever_deactivate:		.asciz	"You deactivated the lever"
key_deactivate:			.asciz	"You found a key"
door_deactivate:		.asciz	"You open the door with the key"
door_door_no_keys:		.asciz	"You do not have the right key"
debuq:				.asciz	"runs till here"
debuq2:				.asciz	"screen id is %ld"

.data
this_x:				.quad 0
this_y:				.quad 0

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

	# east
	movq	player_x, %r8
	movq	%r8, this_x
	movq	player_y, %r9
	movq	%r9, this_y
	incq	this_x

	# call east
	call	control_levers
	call	control_keys
#	call	control_doors

	# north
	decq	this_x
	incq	this_y

	# call north
	call	control_levers
	call	control_keys
#	call	control_doors

	# west
	decq	this_x
	decq	this_y

	# call west
	call	control_levers
	call	control_keys
#	call	control_doors

	# south
	incq	this_x
	decq	this_y

	# call south
	call	control_levers
	call	control_keys
#	call	control_doors

	jmp	control_action_done


control_levers:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r14
	pushq	%r15
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
	movq	this_y,	%r9				# moving y to r9 (y)
	movq	this_x,	%r8				# moving x to r8 (x)

	cmpq	%r8, 48(%r13)
	jne	control_e_continue
	cmpq	%r9, 56(%r13)
	jne	control_e_continue

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
	popq	%r15
	popq	%r14
	popq	%r13
	movq	%rbp, %rsp
	popq	%rbp
	ret



control_keys:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r14
	pushq	%r15
	movq	keys_count, %r15			# r15 - current lever processing

control_key_loop:
	cmpq	$0, %r15
	je	control_key_done

	# Get the key object's address
	movq	%r15, %rdi
	call	keys_id_to_addr
	movq	%rax, %r13				# r13 - current lever address

	# Check that the key is on the current screen
	cmpq	%r14, 8(%r13)
	jne	control_key_continue

	# Compare the x and y of the key
	movq	this_y,	%r9				# moving y to r9 (y)
	movq	this_x,	%r8				# moving x to r8 (x)

	cmpq	%r8, 16(%r13)
	jne	control_key_continue

	cmpq	%r9, 24(%r13)
	jne	control_key_continue

	# Toggle the lever
	movq	40(%r13), %r8
	cmpq	$1, %r8
	je	control_key_continue

	# Value is zero
	movq	$1, 40(%r13)
	movq	$key_deactivate, %rdi
	call	log_push

	cmpq	$0, 32(%r13)
	jne	red

	incq	player_blue_keys
	jmp	key_colour_done

red:
	cmpq	$1, 32(%r13)
	jne	green

	incq	player_red_keys
	jmp	key_colour_done

green:
	incq	player_green_keys

key_colour_done:
	jmp	control_key_continue

control_key_continue:
	decq	%r15
	jmp	control_key_loop

control_key_done:
	popq	%r15
	popq	%r14
	popq	%r13
	movq	%rbp, %rsp
	popq	%rbp
	ret



control_doors:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r14
	pushq	%r15
	movq	doors_count, %r15			# r15 - current door processing

control_door_loop:
	cmpq	$0, %r15
	je	control_door_done

	# Get the door object's address
	movq	%r15, %rdi
	call	doors_id_to_addr
	movq	%rax, %r13				# r13 - current lever address

	# Check that the door is on the current screen
#	cmpq	%r14, 8(%r13)
	cmpq	$9, %r14
	jne	control_door_continue

	# Compare the x and y of the door
	movq	this_y,	%r9				# moving y to r9 (y)
	movq	this_x,	%r8				# moving x to r8 (x)

	cmpq	%r8, 16(%r13)
	jne	control_door_continue

	movq	$debuq2, %rdi
	movq	%r15, %rsi
	call	log_push

	cmpq	%r9, 24(%r13)
	jne	control_door_continue

	# Toggle the door
	movq	40(%r13), %r8
	cmpq	$1, %r8
	je	control_door_continue

	cmpq	$0, 32(%r13)
	jne	red_door

	cmpq	$0, player_blue_keys
	je	key_colour_not_found

	# Value is zero
	movq	$1, 40(%r13)
	movq	$door_deactivate, %rdi
	call	log_push

	decq	player_blue_keys
	jmp	key_colour_done

red_door:
	cmpq	$1, 32(%r13)
	jne	green_door

	cmpq	$1, player_red_keys
	je	key_colour_not_found

	# Value is zero
	movq	$1, 40(%r13)
	movq	$door_deactivate, %rdi
	call	log_push

	decq	player_red_keys
	jmp	control_door_continue

green_door:
	cmpq	$0, player_green_keys
	je	key_colour_not_found

	# Value is zero
	movq	$1, 40(%r13)
	movq	$door_deactivate, %rdi
	call	log_push

	decq	player_green_keys
	jmp	control_door_continue

key_colour_not_found:
	# Value is zero
	movq	$1, 40(%r13)
	movq	$door_door_no_keys, %rdi
	call	log_push

control_door_continue:
	decq	%r15
	jmp	control_key_loop

control_door_done:
	popq	%r15
	popq	%r14
	popq	%r13
	movq	%rbp, %rsp
	popq	%rbp
	ret

# The pause key is pressed
control_p:
	movq	state_gamemenu, %r8
	movq	%r8, current_state

	jmp	control_action_done
