.text

.global gamemenu_print
.global gamemenu_control

gamemenu_print:

	# Render the background
	call	render_game_screen

	# Render the menu screen
	call	render_gamemenu_screen

	jmp	state_render_ret

gamemenu_control:

	# Control
	call	control_gamemenu

	jmp	state_control_ret
