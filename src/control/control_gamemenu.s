.text

.global control_gamemenu

control_gamemenu:
	push	%rbp
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
	cmpq	$0, gamemenu_selection
	je	control_up_low

	subq	$1, gamemenu_selection
	jmp	control_done
control_up_low:
	movq	gamemenu_opts_count, %r13
	movq	%r13, gamemenu_selection
	jmp	control_done

	# Down key
control_down:
	movq	gamemenu_opts_count, %r13
	cmpq	%r13, gamemenu_selection
	je	control_down_high

	addq	$1, gamemenu_selection
	jmp	control_done
control_down_high:
	movq	gamemenu_opts_count, %r13
	movq	$0, gamemenu_selection
	jmp	control_done

	# Enter key
control_enter:
	cmpq	$0, gamemenu_selection
	je	control_enter_return

	cmpq	$2, gamemenu_selection
	je	control_enter_exit

	jmp	control_done

control_enter_return:
	movq	state_game, %r8
	movq	%r8, current_state
	jmp	control_done

control_enter_exit:
	# movq	$1, %rax			# rax=1 - exit
	movq	state_mainmenu, %r8
	movq	%r8, current_state
	jmp	control_done

control_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret

	movq	%rbp, %rsp
	popq	%rbp
	ret
