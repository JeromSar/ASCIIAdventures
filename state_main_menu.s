.text
title:		.asciz	"Main Menu"
opt_play:	.asciz	"[play]"
opt_exit:	.asciz	"[exit]"
arrow:		.asciz	">"
num_opts:	.quad	1			# Zero-indexed

.data
select_option:	.quad	0

.global main_menu_print
.global main_menu_control

main_menu_print:

	# Render the screen
	call	render_mainmenu_screen

	jmp	state_render_ret

main_menu_control:

	# Control
	call	control_mainmenu

	jmp	state_control_ret
