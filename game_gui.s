.text
text_health:		.asciz	"H: "
text_heart:		.asciz	"*"
text_half_heart:	.asciz	"*"
text_money:		.asciz	"P: %lu"
health_y_coord:		.quad	20
money_y_coord:		.quad	21
debug_log:		.asciz	"Test log 1"
debug_log2:		.asciz	"Test log 2"

.data
action_log:		.quad   0
			.quad	0
			.quad	0
			.quad	0
action_log_index:	.quad	0

.global gui_print
.global log_push

gui_print:
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
	call	print_health

	# Print money
	call	print_money

	call	print_log

	movq	%rbp, %rsp
	popq	%rbp
	ret


print_health:
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
	movq	$6, %r15					# The x co-ordinate
print_health_loop:
	cmpq	$1, %r14
	je	print_health_last

	cmpq	$0, %r14
	je	print_health_done

	# Print a full heart
	movq	health_y_coord, %rdi
	movq	%r15, %rsi
	movq	$text_heart, %rdx
	call	mvprintw

	subq	$2, %r14
	incq	%r15
	jmp	print_health_loop

print_health_last:
	call	color_stop_red
	call	color_start_yellow

	# Print a half heart
	movq	health_y_coord, %rdi
	movq	%r15, %rsi
	movq	$text_half_heart, %rdx
	call	mvprintw

	call	color_stop_yellow
	call	color_start_red

print_health_done:
	call	color_stop_red

	popq	%r15
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret


print_money:
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
# Subroutine - log_push
# Adds a string of text to the action log
# %rdi - pointer to the text
#
log_push:
	push	%rbp
	movq	%rsp, %rbp

	# Get and increment the index
	movq	action_log_index, %r8
	incq	%r8

	cmpq	$4, %r8						# If the index is not 4
	jne	log_push_index					# Then jump to log_push_index

	movq	$0, %r8						# Reset the index back to zero

log_push_index:
	movq	%r8, %r9
	shl	$3, %r9
	movq	%rdi, action_log(%r9)				# Put the value in action_log(index)
	movq	%r8, action_log_index				# Update the index

	movq	%rbp, %rsp
	popq	%rbp
	ret

#
# Subroutine - print_log
# Prints the action log in the game window
#
print_log:
	push	%rbp
	movq	%rsp, %rbp
	pushq	%r13
	pushq	%r14

	movq	action_log_index, %r13				# r13 - index we're currently printing
	movq	$4, %r14					# r14 - amount of lines left

print_log_loop:
	movq	%r13, %r9
	shl	$3, %r9
	movq	action_log(%r9), %r8				# Get the value at the index, store in r8
	cmpq	$0, %r8						# If the value is 0
	je	print_log_skip					# Don't print it
	# Call mvprintw(y,x, action_log())
	movq	%r14, %rdi
	addq	$18, %rdi
	movq	$20, %rsi
	movq	%r8, %rdx
	call	mvprintw
print_log_skip:

	cmpq	$0, %r13					# Was this the last index?
	jne	print_log_no_reset				# If not, continue

	movq	$4, %r13					# Reset the index
print_log_no_reset:
	decq	%r13						# index--

	decq	%r14						# One line less
	cmpq	$0, %r14
	jne	print_log_loop					# As long as the amount of lines != 0, loop

	pushq	%r14
	pushq	%r13
	movq	%rbp, %rsp
	popq	%rbp
	ret
