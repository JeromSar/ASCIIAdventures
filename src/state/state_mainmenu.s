.text

.global mainmenu_print
.global mainmenu_control

mainmenu_print:

	# Render the screen
	call	render_mainmenu_screen

	jmp	state_render_ret

mainmenu_control:

	# Control
	call	control_mainmenu

	jmp	state_control_ret
