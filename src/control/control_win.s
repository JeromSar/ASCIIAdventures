.text

.global control_win

control_win:
	pushq	%rbp
	movq	%rsp, %rbp

	# The char is stored in r12

	cmpq	%r12, key_enter
	je	control_win_enter

	# Unknown key

control_win_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret

# Enter key
control_win_enter:
	movq	$1, exit_game
	jmp	control_win_done
