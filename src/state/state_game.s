.text
debug:		.asciz	"You have %lu turns"

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

	call	render_game_keys

	call	render_game_doors

	call	render_game_chests

	# Render the gui
	call	render_game_gui

	jmp	state_render_ret

game_control:

	incq	player_nodmg_turns

	call	control_player


	call	timing_update


	call	control_action

	call	control_attack

	call	control_mobs

	# Heal a heart if needed
	cmpq	$10, player_nodmg_turns
	jne	state_control_ret
	movq	$0, player_nodmg_turns
	cmpq	$10, player_health
	je	state_control_ret
	incq	player_health
	movq	$0, player_nodmg_turns

	jmp	state_control_ret
