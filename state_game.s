.global game_print
.global game_control
.global screen_x
.global screen_y

game_print:

	# Print the background
	call	screen_print

	# Print the player
	call	player_print

	# Print the mobs
	call	mobs_print

	# Print the gui
	call	gui_print

	jmp	print_state_ret

game_control:

	call	player_control

	jmp	control_state_ret
