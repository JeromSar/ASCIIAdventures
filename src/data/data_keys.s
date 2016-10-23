.text
bytes_per_key:	.quad	64

.bss
#
# Lever Data Representation (LDR)
# 	Length	Offset	Name		Values
#	8	0	id		-
#	8	8	scr_id		-
#	8	16	x_key		-
#	8	24	y_key		-
#	8	32	key_colour	-
#					0 for blue
#					1 for red
#					2 for green
#	8	40	key_state	-
#					0 -> key not picked up
#					1 -> key picked up
keys:			.skip	2048

.data
keys_count:		.quad	1

.global keys_count

.global keys_init
.global keys_id_to_addr
.global make_key

keys_init:
	pushq	%rbp
	movq	%rsp, %rbp

	# values to be placed
	movq	$10, %rdi				# scr_id
	movq	$5, %rsi				# x_key
	movq	$12, %rdx				# y_key
	movq	$0, %rcx				# key_colour
	movq	$0, %r8					# key_state
	call	make_key

	movq	%rbp, %rsp
	popq	%rbp
	ret

# Subroutine - lever_id_to_addr
# Takes a lever ID and returns its address
# %rdi - The lever ID
keys_id_to_addr:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, %rax
	movq	bytes_per_key, %rdx			# Amt. of bytes reserved per lever
	mulq	%rdx					# Result in rax

	addq	$keys, %rax				# %rax acts as the offset

	movq	%rbp, %rsp
	popq	%rbp
	ret

make_key:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13

	movq	keys_count, %r12			# Store lever ID in r12
	incq	keys_count

	# So sorry...
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	pushq	%rcx
	pushq	%r8
	movq	%r12, %rdi
	call	key_id_to_addr
	movq	%rax, %r13				# Store lever addr in r13
	popq	%r8
	popq	%rcx
	popq	%rdx
	popq	%rsi
	popq	%rdi

	# Init the data
	movq	%r12, 0(%r13)				# id		%r12
	movq	%rdi, 8(%r13)				# scr_door	%rdi
	movq	%rsi, 16(%r13)				# x_door	%rsi
	movq	%rdx, 24(%r13)				# y_door	%rdx
	movq	%rcx, 32(%r13)				# scr_lever	%rcx
	movq	%r8, 40(%r13)

	# Return the lever ID
	movq	%r12, %rax

	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret
