.text

.data
screen_x:		.quad	1
screen_y:		.quad	2

.global screen_x
.global screen_y

.global	screen_is_traversable
.global screen_get_id

screen_is_traversable:
	push	%rbp
	movq	%rsp, %rbp

	# Switch y and x positions
	movq	%rdi, %r8
	movq	%rsi, %rdi
	movq	%r8, %rsi

	# Call mvinch
	# https://www.mkssoftware.com/docs/man3/curs_inch.3.asp
	call	mvinch

	cmpq	%rax, key_space
	je	screen_is_traversable_yes

	# Not traversable
	movq	$0, %rax
	jmp	screen_is_traversable_done

screen_is_traversable_yes:
	movq	$1, %rax

screen_is_traversable_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret

screen_get_id:
	push	%rbp
	movq	%rsp, %rbp

	movq	screen_y, %rdx
	movq	$4, %rax
	mulq	%rdx
	addq	screen_x, %rax

	movq	%rbp, %rsp
	popq	%rbp
	ret
