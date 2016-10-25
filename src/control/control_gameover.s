.text

.global control_gameover

control_gameover:
	pushq	%rbp
	movq	%rsp, %rbp

	# The char is stored in r12

	cmpq	%r12, key_enter
	je	control_enter

	# Unknown key

control_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret

# Enter key
control_enter:
	movq	state_mainmenu, %r8
	movq	%r8, current_state

	jmp	control_done
