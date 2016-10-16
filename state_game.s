.text
player_char:		.asciz	"@"
format_char:		.asciz	"%c"
mob_char:		.asciz	"W"
debug:			.asciz	"There is a mob at (%lu, %lu, %lu)"
debug2:			.asciz	"There are %lu mobs."

.data
player_x:		.quad	39
player_y:		.quad	4
screen_x:		.quad	1
screen_y:		.quad	2

.global game_print
.global game_control
.global screen_x
.global screen_y

game_print:

	# Select current screen
	movq	screen_x, %rdi
	movq	screen_y, %rsi
	call	select_screen

	# Print current screen
	movq	$0, %rdi
	movq	$0, %rsi
	movq	%rax, %rdx
	call	mvprintw

	# Enable color 1
	movq	$1, %rdi
	call	COLOR_PAIR
	movq	%rax, %rdi
	call	attron

	# Draw the player
	movq	player_y, %rdi
	movq	player_x, %rsi
	movq	$player_char, %rdx
	call	mvprintw

	# Disable color 1
	movq	$1, %rdi
	call	COLOR_PAIR
	movq	%rax, %rdi
	call	attroff

	# Calculate scr id, store in r14
	movq	screen_y, %rdx
	movq	$4, %rax
	mulq	%rdx
	addq	screen_x, %rax
	movq	%rax, %r14

	# Print mobs
	movq	mobs_count, %r15
	decq	%r15

print_mobs_loop:
	cmpq	$0, %r15
	je	print_mobs_done

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
	jne	print_mobs_continue

	# Get the x y and print
	movq	24(%rax), %rdi
	movq	32(%rax), %rsi
	movq	$mob_char, %rdx
	call	mvprintw

print_mobs_continue:
	decq	%r15
	jmp	print_mobs_loop

print_mobs_done:
	jmp	print_state_ret


game_control:

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

	jmp	control_state_ret		# Unknown key

control_w:
	cmpq	$0, %r14
	jne	control_w_done

	# We have y=0, go to the above screen
	decq	screen_y
	movq	$18, %r14
	#movq	HEIGHT, %r14
	decq	%r14
	jmp	update_player_pos
control_w_done:
	subq	$1, %r14
	jmp	control_post

control_s:
	cmpq	$17, %r14
	#cmpq	HEIGHT_MINUS_ONE, %r14
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
	jne	control_state_ret

update_player_pos:
	# Update the player position
	movq	%r13, player_x
	movq	%r14, player_y

	jmp	control_state_ret
