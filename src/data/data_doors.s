.text
bytes_per_door:	.quad	64

.bss
#
# Lever Data Representation (LDR)
# 	Length	Offset	Name		Values
#	8	0	id		-
#	8	8	scr_id		-
#	8	16	x_door		-
#	8	24	y_door		-
#	8	32	door_colour	-
#					0 for blue
#					1 for red
#					2 for green
#	8	40	door_state	-
#					0 for closed
#					1 for open
doors:			.skip	2048

.data
doors_count:		.quad	1

.global doors_count

.global doors_init
.global doors_id_to_addr
.global make_door

doors_init:
	pushq	%rbp
	movq	%rsp, %rbp

	# values to be placed
	movq	$10, %rdi				# scr_id
	movq	$7, %rsi				# x_key
	movq	$13, %rdx				# y_key
	movq	$0, %rcx				# key_colour
	movq	$0, %r8
	call	make_door

	movq	%rbp, %rsp
	popq	%rbp
	ret

# Subroutine - lever_id_to_addr
# Takes a lever ID and returns its address
# %rdi - The lever ID
doors_id_to_addr:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, %rax
	movq	bytes_per_door, %rdx			# Amt. of bytes reserved per lever
	mulq	%rdx					# Result in rax

	addq	$doors, %rax				# %rax acts as the offset

	movq	%rbp, %rsp
	popq	%rbp
	ret

make_door:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13

	movq	doors_count, %r12			# Store lever ID in r12
	incq	doors_count

	# So sorry...
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	pushq	%rcx
	pushq	%r8
	movq	%r12, %rdi
	call	door_id_to_addr
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
	movq	%rcx, 32(%r13)				# door_colour	%rcx
	movq	%r8, 40(%r13)				# state door	%r8

	# Return the door ID
	movq	%r12, %rax

	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret
