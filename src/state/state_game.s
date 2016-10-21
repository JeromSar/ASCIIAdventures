.global game_print
.global game_control
.global screen_x
.global screen_y

game_print:

	# Render the screen
	call	render_game_screen

	# Render the player
	call	render_game_player

	# Render the mobs
	call	render_game_mobs

	# Render the levers
	call	render_game_levers

	# Render the gui
	call	render_game_gui

	jmp	state_render_ret

game_control:

	call	control_player

	call	control_action

	jmp	state_control_ret
