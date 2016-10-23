.text
title:		.asciz	"Main Menu"
opt_play:	.asciz	"[play]"
opt_exit:	.asciz	"[exit]"
arrow:		.asciz	">"
mainmenu_opts_count:	.quad	1			# Zero-indexed

.data
mainmenu_selection:	.quad	0

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
