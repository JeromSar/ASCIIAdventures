.data

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
	cmpq	$0, select_option
	je	control_up_low

	subq	$1, select_option
	jmp	control_done
control_up_low:
	movq	num_opts, %r13
	movq	%r13, select_option
	jmp	control_done

	# Down key
control_down:
	movq	num_opts, %r13
	cmpq	%r13, select_option
	je	control_down_high

	addq	$1, select_option
	jmp	control_done
control_down_high:
	movq	num_opts, %r13
	movq	$0, select_option
	jmp	control_done

	# Enter key
control_enter:
	cmpq	$0, select_option
	je	control_enter_play

	cmpq	$1, select_option
	je	control_enter_exit

	jmp	control_done
control_enter_play:
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
