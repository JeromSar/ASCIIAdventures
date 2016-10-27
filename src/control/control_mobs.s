.text
attacked:		.asciz	"The %s attacked you and dealt %lu damage"

.global control_mobs

control_mobs:
	push	%rbp
	movq	%rsp, %rbp

	# Calculate scr id, store in r14
	call	screen_get_id
	movq	%rax, %r14

	# Current mob,store in r15
	movq	mobs_count, %r15

control_loop:
	cmpq	$0, %r15
	je	control_done
	decq	%r15

	# Get the mobs address, store in r13
	movq	%r15, %rdi
	call	mobs_id_to_addr
	movq	%rax, %r13

	# Check that the mob is on the current screen
	cmpq	%r14, 16(%r13)
	jne	control_continue

	# Check that the mob is not dead
	cmpq	$0, 40(%r13)
	je	control_continue

	# Check that the mob is awake
	cmpq	$1, 56(%r13)
	je	control_sleeping

	# (x,y) in r8, r9
	movq	24(%r13), %r8
	movq	32(%r13), %r9

	# Compare x
	cmpq	%r8, player_x
	je	equal_x

	# Compare y
	cmpq	%r9, player_y
	je	equal_y

	# GO PATHFINDING! :D

control_pathfinding:
	# Do pathfinding
	movq	%r8, %rdi
	movq	%r9, %rsi
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
	jmp	control_continue

control_sleeping:
	movq	24(%r13), %rdi
	movq	32(%r13), %rsi
	call	pathfinding

	# Path found?
	cmpq	$4, %rax
	je	control_continue

	# In the range?
	cmpq	$12, pathfinding_path_length
	jg	control_continue

	# Wake the mob
	movq	$0, 56(%r13)

control_continue:
	# Update the screen so mobs see each other's position
	# TODO: fix
	call	refresh

	jmp	control_loop

control_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret

equal_x:
	incq	%r9
	cmpq	%r9, player_y
	je	attack_player

	subq	$2, %r9
	cmpq	%r9, player_y
	je	attack_player

	jmp	control_pathfinding

equal_y:
	incq	%r8
	cmpq	%r8, player_x
	je	attack_player

	subq	$2, %r8
	cmpq	%r8, player_x
	je	attack_player

	jmp	control_pathfinding

attack_player:
	movq	48(%r13), %r8

	cmpq	$1, control_player_attack
	jne	control_continue

	# Is the player dead
	cmpq	%r8, player_health
	jle	player_dead

	# Do the damage
	subq	%r8, player_health

	# Get the mob name
	movq	8(%r13), %rdi
	call	mobs_type_to_name

	# Push a message
	movq	$attacked, %rdi
	movq	%rax, %rsi
	movq	48(%r13), %rdx
	call	log_push

	jmp	control_continue

player_dead:
	movq	state_gameover, %r8
	movq	%r8, current_state
	jmp	control_continue

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
