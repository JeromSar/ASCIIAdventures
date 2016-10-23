.text

.bss
action_log:		.skip	128				# 8 * 4 * 4

.data
action_log_index:	.quad	0

.global action_log
.global action_log_index
.global action_log_params

.global log_push

#
# Subroutine - log_push
# Adds a string of text to the action log
# %rdi - pointer to the text
# %rsi
# %rdx
# %rcx - Optional parameters
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
	shl	$3, %r9						# 2^3 = 8 bytes per value
	shl	$2, %r9						# 2^2 = 4 values per entry (value + 3 params)

	movq	%rdi, action_log(%r9)				# Put the value in action_log(index)
	addq	$8, %r9
	movq	%rsi, action_log(%r9)
	addq	$8, %r9
	movq	%rdx, action_log(%r9)
	addq	$8, %r9
	movq	%rcx, action_log(%r9)

	movq	%r8, action_log_index				# Update the index

	movq	%rbp, %rsp
	popq	%rbp
	ret
