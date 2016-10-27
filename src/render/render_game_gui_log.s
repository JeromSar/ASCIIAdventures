.text

.global render_game_gui_log

#
# Subroutine - render_game_gui_log
# Prints the action log in the game window
#
render_game_gui_log:
	push	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r14
	pushq	%r15

	call	color_start_cyan

	movq	action_log_index, %r13				# r13 - index we're currently printing
	movq	$4, %r14					# r14 - amount of lines left

render_log_loop:
	movq	%r13, %r15					# r15 - current offset
	shl	$3, %r15
	shl	$2, %r15

	# Is there a value
	movq	action_log(%r15), %rdx				# Get the value at the index, store in r8
	cmpq	$0, %rdx					# If the value is 0
	je	render_log_skip					# Don't print it

	# Call mvprintw(y,x, action_log())
	movq	%r14, %rdi
	addq	$18, %rdi
	movq	$20, %rsi
	# rdx is already set
	addq	$8, %r15
	movq	action_log(%r15), %rcx
	addq	$8, %r15
	movq	action_log(%r15), %r8
	addq	$8, %r15
	movq	action_log(%r15), %r9
	movq	$0, %rax
	call	mvprintw

render_log_skip:

	cmpq	$0, %r13					# Was this the last index?
	jne	render_log_no_reset				# If not, continue

	movq	$4, %r13					# Reset the index
render_log_no_reset:
	decq	%r13						# index--

	decq	%r14						# lines--
	cmpq	$0, %r14
	jne	render_log_loop					# As long as the amount of lines != 0, loop

	call	color_stop_cyan

	popq	%r15
	pushq	%r14
	pushq	%r13
	movq	%rbp, %rsp
	popq	%rbp
	ret
