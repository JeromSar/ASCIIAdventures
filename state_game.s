.global game_print
.global game_control

game_print:

	# Print the background
	call	screen_print

	# Print the player
	call	player_print

	# Print the mobs
	call	mobs_print

	jmp	print_state_ret

game_control:

	call	player_control

	jmp	control_state_ret
