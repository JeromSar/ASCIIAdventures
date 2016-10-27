.text

.global control_player

control_player:
	push	%rbp
	movq	%rsp, %rbp

	movq	player_x, %r13
	movq	player_y, %r14

	# The char is stored in r12
	cmpq	%r12, key_w
	je	control_w

	cmpq	%r12, key_s
	je	control_s

	cmpq	%r12, key_a
	je	control_a

	cmpq	%r12, key_d
	je	control_d

	jmp	control_done			# Unknown key

control_w:
	cmpq	$0, %r14
	jne	control_w_done

	# We have y=0, go to the above screen
	decq	screen_y
	movq	GAME_HEIGHT, %r14
	decq	%r14
	jmp	update_player_pos
control_w_done:
	subq	$1, %r14
	jmp	control_post

control_s:
	cmpq	GAME_HEIGHT_MINUS_ONE, %r14
	jne	control_s_done

	# we have y=HEIGHT-1, go to the below screen
	incq	screen_y
	movq	$0, %r14
	jmp	update_player_pos
control_s_done:
	addq	$1, %r14
	jmp	control_post

control_a:
	cmpq	$0, %r13
	jne	control_a_done

	# we have x=0, go to the screen to the left
	decq	screen_x
	movq	WIDTH_MINUS_ONE, %r13
	jmp	update_player_pos
control_a_done:
	subq	$1, %r13
	jmp	control_post

control_d:
	cmpq	WIDTH_MINUS_ONE, %r13
	jne	control_d_done

	# we have x=WIDTH-1, go to the screen to the right
	incq	screen_x
	movq	$0, %r13
	jmp	update_player_pos
control_d_done:
	addq	$1, %r13
	jmp	control_post

control_post:
	# Player collision check
	# If the new position is not a space, don't continue

	# Call mvinch
	# https://www.mkssoftware.com/docs/man3/curs_inch.3.asp
	movq	%r14, %rdi
	movq	%r13, %rsi
	call	mvinch

	cmpq	%rax, key_space
	jne	control_done

update_player_pos:
	# Update the player position
	movq	%r13, player_x
	movq	%r14, player_y

	call	refresh

control_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret
