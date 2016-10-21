.text
player_char:		.asciz	"@"
format_char:		.asciz	"%c"

.global render_game_player

render_game_player:
	push	%rbp
	movq	%rsp, %rbp

	call	color_start_red

	# Draw the player
	movq	player_y, %rdi
	movq	player_x, %rsi
	movq	$player_char, %rdx
	call	mvprintw

	call	color_stop_red

	movq	%rbp, %rsp
	popq	%rbp
	ret
