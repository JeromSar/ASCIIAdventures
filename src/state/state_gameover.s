.text

.data
.global gameover_print
.global gameover_control

gameover_print:

	# Render the screen
	call	render_gameover_screen

	jmp	state_render_ret

gameover_control:

	# Control
	call	control_gameover

	jmp	state_control_ret
