.text
bytes_per_lever:	.quad	128

.bss
#
# Lever Data Representation (LDR)
# 	Length	Offset	Name		Values
#	8	0	id		-
#	8 	8	state		0 -> closed
#					1 -> open
#	8	16	scr_door	-
#	8	24	x_door		-
#	8	32	y_door		-
#	8	40	scr_lever	-
#	8	48	x_lever		-
#	8	56	y_lever		-
levers:			.skip	2048

.data
levers_count:		.quad	1

.global levers_count

.global levers_init
.global levers_id_to_addr
.global make_lever

levers_init:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	$9, %rdi				# scr_door
	movq	$40, %rsi				# x_door
	movq	$6, %rdx				# y_door
	movq	$9, %rcx				# scr_lever
	movq	$43, %r8				# x_lever
	movq	$10, %r9				# y_lever
	call	make_lever

	movq	%rbp, %rsp
	popq	%rbp
	ret

# Subroutine - lever_id_to_addr
# Takes a lever ID and returns its address
# %rdi - The lever ID
levers_id_to_addr:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, %rax
	movq	bytes_per_lever, %rdx			# Amt. of bytes reserved per lever
	mulq	%rdx					# Result in rax

	addq	$levers, %rax				# %rax acts as the offset

	movq	%rbp, %rsp
	popq	%rbp
	ret

# Subroutine - make_lever
# Creates a new lever activated door, and returns its ID
# %rdi - the screen id of the door
# %rsi - the x coord of the door
# %rdx - the y coord of the door
# %rcx - the screen id of the lever
# %r8 - the x coord of the lever
# %r9 - the y coord of the lever
make_lever:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13

	movq	levers_count, %r12			# Store lever ID in r12
	incq	levers_count

	# So sorry...
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	pushq	%rcx
	pushq	%r8
	pushq	%r9
	movq	%r12, %rdi
	call	levers_id_to_addr
	movq	%rax, %r13				# Store lever addr in r13
	popq	%r9
	popq	%r8
	popq	%rcx
	popq	%rdx
	popq	%rsi
	popq	%rdi

	# Init the data
	movq	%r12, 0(%r13)				# id		%r12
	movq	$0, 8(%r13)				# state		0 (closed)
	movq	%rdi, 16(%r13)				# scr_door	%rdi
	movq	%rsi, 24(%r13)				# x_door	%rsi
	movq	%rdx, 32(%r13)				# y_door	%rdx
	movq	%rcx, 40(%r13)				# scr_lever	%rcx
	movq	%r8, 48(%r13)				# x_lever	%r8
	movq	%r9, 56(%r13)				# y_lever	%r9

	# Return the lever ID
	movq	%r12, %rax

	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret
