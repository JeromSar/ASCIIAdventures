.text
game_loaded:		.asciz	"Game loaded from save"

.global control_mainmenu

control_mainmenu:
	pushq	%rbp
	movq	%rsp, %rbp

	# The char is stored in r12

	cmpq	%r12, key_w
	je	control_up

	cmpq	%r12, key_s
	je	control_down

	cmpq	%r12, key_enter
	je	control_enter

	jmp	control_done			# Unknown key

	# Up key
control_up:
	cmpq	$0, mainmenu_selection
	je	control_up_low

	subq	$1, mainmenu_selection
	jmp	control_done
control_up_low:
	movq	mainmenu_opts_count, %r13
	movq	%r13, mainmenu_selection
	jmp	control_done

	# Down key
control_down:
	movq	mainmenu_opts_count, %r13
	cmpq	%r13, mainmenu_selection
	je	control_down_high

	addq	$1, mainmenu_selection
	jmp	control_done
control_down_high:
	movq	mainmenu_opts_count, %r13
	movq	$0, mainmenu_selection
	jmp	control_done

	# Enter key
control_enter:
	cmpq	$0, mainmenu_selection
	je	control_enter_play

	cmpq	$1, mainmenu_selection
	je	control_enter_load

	cmpq	$2, mainmenu_selection
	je	control_enter_exit

	jmp	control_done

control_enter_play:
	movq	state_game, %r8
	movq	%r8, current_state
	jmp	control_done

control_enter_load:
	call	load_game

	movq	$game_loaded, %rdi
	call	log_push

	movq	state_game, %r8
	movq	%r8, current_state
	jmp	control_done

control_enter_exit:
	movq	$1, %rax			# rax=1 - exit
	jmp	control_done

control_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret
