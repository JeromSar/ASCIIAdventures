.text

.data
.global win_print
.global win_control

win_print:

	# Render the scree
	movq	timing_state, %rdi
	call	render_win_screen

	jmp	state_render_ret

win_control:

	# Control
	call	control_win

	jmp	state_control_ret
