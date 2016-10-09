.text
player_char:		.asciz	"@"
format_char:		.asciz	"%c"

.data
player_x:		.quad	10
player_y:		.quad	10

.global game_print
.global game_control

game_print:

	# Print background
	movq	$0, %rdi
	movq	$0, %rsi
	movq	$screen_game, %rdx
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
	subq	$1, %r14
	jmp	control_post

control_s:
	addq	$1, %r14
	jmp	control_post

control_a:
	subq	$1, %r13
	jmp	control_post

control_d:
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

	# Update the player position
	movq	%r13, player_x
	movq	%r14, player_y

	jmp	control_state_ret
