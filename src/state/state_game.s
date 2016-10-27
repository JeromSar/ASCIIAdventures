.text
debug:		.asciz	"You have %lu turns"

.global game_print
.global game_control
.global screen_x
.global screen_y

game_print:
	call	render_game_screen
	call	render_game_player
	call	render_game_mobs
	call	render_game_levers
	call	render_game_keys
	call	render_game_doors
	call	render_game_chests
	call	render_game_gui

	jmp	state_render_ret

game_control:
	# Reset values
	movq	$0, control_player_attack

	call	control_player
	call	control_action
	call	control_attack
	call	control_mobs

	jmp	state_control_ret
