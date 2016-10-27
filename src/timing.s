.text
debug:			.asciz	"Current time: %lu, State: %lu"

.data
timing_last_update:	.quad	0
timing_state:		.quad	0

.global timing_state

.global timing_init
.global timing_update

timing_init:
	pushq	%rbp
	movq	%rsp, %rbp

	subq	$16, %rsp

	# Init timing_last_update
	leaq	-16(%rbp), %rdi
	movq	$1, %rsi					# TIME_UTC = 1
	call	timespec_get

	movq	-16(%rbp), %r8
	movq	%r8, timing_last_update

	movq	%rbp, %rsp
	popq	%rbp
	ret

timing_update:
	pushq	%rbp
	movq	%rsp, %rbp

	subq	$16, %rsp

	# Get the current time
	leaq	-16(%rbp), %rdi
	movq	$1, %rsi					# TIME_UTC = 1
	call	timespec_get

	movq	timing_last_update, %r9				# r9 - last time
	movq	-16(%rbp), %r8					# r8 - current time
	cmpq	%r8, %r9
	je	timing_update_done

	movq	-16(%rbp), %r8
	movq	%r8, timing_last_update				# Toggle state

	cmpq	$0, timing_state
	je	timing_update_zero

	movq	$0, timing_state
	jmp	timing_update_done

timing_update_zero:
	movq	$1, timing_state

timing_update_done:
	movq	$debug, %rdi
	movq	-16(%rbp), %rsi
	movq	timing_state, %rdx
#	call	log_push

	movq	%rbp, %rsp
	popq	%rbp
	ret
