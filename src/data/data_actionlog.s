.text

.data
action_log:		.quad   0
			.quad	0
			.quad	0
			.quad	0
action_log_index:	.quad	0

.global action_log
.global action_log_index

.global log_push

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
