.text
text_health:		.asciz	"HP: "
text_heart:		.asciz	"*"
text_half_heart:	.asciz	"*"
text_money:		.asciz	"Pr: %lu"
health_y_coord:		.quad	20
money_y_coord:		.quad	21

.global render_game_gui
.global log_push

render_game_gui:
	push	%rbp
	movq	%rsp, %rbp

	# Print the gui box
	call	color_start_blue
	movq	GAME_HEIGHT, %rdi
	movq	$0, %rsi
	movq	$screen_gui, %rdx
	call	mvprintw
	call	color_stop_blue

	# Print health
	call	render_health

	# Print money
	call	render_money

	call	render_log

	movq	%rbp, %rsp
	popq	%rbp
	ret


render_health:
	push	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%r15

	call	color_start_red

	movq	health_y_coord, %rdi
	movq	$3, %rsi
	movq	$text_health, %rdx
	call	mvprintw

	# Print the hearts
	movq	player_health, %r14				# The remaining health to print
	movq	$8, %r15					# The x co-ordinate
render_health_loop:
	cmpq	$1, %r14
	je	render_health_last

	cmpq	$0, %r14
	je	render_health_done

	# Print a full heart
	movq	health_y_coord, %rdi
	movq	%r15, %rsi
	movq	$text_heart, %rdx
	call	mvprintw

	subq	$2, %r14
	incq	%r15
	jmp	render_health_loop

render_health_last:
	call	color_stop_red
	call	color_start_yellow

	# Print a half heart
	movq	health_y_coord, %rdi
	movq	%r15, %rsi
	movq	$text_half_heart, %rdx
	call	mvprintw

	call	color_stop_yellow
	call	color_start_red

render_health_done:
	call	color_stop_red

	popq	%r15
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret


render_money:
	push	%rbp
	movq	%rsp, %rbp

	call	color_start_yellow

	# Print money text
	movq	money_y_coord, %rdi
	movq	$3, %rsi
	movq	$text_money, %rdx
	movq	player_money, %rcx
	call	mvprintw

	call	color_stop_yellow

	movq	%rbp, %rsp
	popq	%rbp
	ret

#
# Subroutine - render_log
# Prints the action log in the game window
#
render_log:
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
