.text
bytes_per_mob:		.quad	128

.bss
#
# Mob Data Representation (MDR)
# 	Length	Offset	Name	Values
#	8	0	id	-
#	8 	8	type	0 -> Wolf
#	8	16	scr_id	-
#	8	24	x_pos	-
#	8	32	y_pos	-
#	8	40	health	-
#	8	48	damage	-
mobs:			.skip	2048			# 16 mobs (128*8)

.data
mobs_count:		.quad	1


.global mobs_count
.global mobs
.global mobs_init
.global mobs_id_to_addr

mobs_init:
	pushq	%rbp
	movq	%rsp, %rbp

	# Make a wolf at (15, 10, 10)
	movq	$15, %rdi
	movq	$10, %rsi
	movq	$10, %rdx
	call	make_wolf


	# Make a wolf at (15, 10, 10)
	movq	$15, %rdi
	movq	$20, %rsi
	movq	$20, %rdx
	call	make_wolf

	# Make a wolf at (10, 5, 6)
	movq	$10, %rdi
	movq	$5, %rsi
	movq	$6, %rdx
	#call	make_wolf

	# Make a wolf at (4, 5, 6)
	movq	$4, %rdi
	movq	$6, %rsi
	movq	$3, %rdx
	#call	make_wolf

	movq	%rbp, %rsp
	popq	%rbp
	ret

# Subroutine - mobs_id_to_addr
# Takes a mob ID and returns its address
# %rdi - The mob ID
mobs_id_to_addr:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, %rax
	movq	bytes_per_mob, %rdx			# Amt. of bytes reserved per mob
	mulq	%rdx					# Result in rax

	addq	$mobs, %rax				# %rax acts as the offset

	movq	%rbp, %rsp
	popq	%rbp
	ret

# Subroutine - make_wolf
# Creates a new wolf, and returns its ID
# %rdi - the screen id
# %rsi - the x coord
# %rdx - the y coord
make_wolf:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13

	movq	mobs_count, %r12			# Store mob ID in r12
	incq	mobs_count

	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%r12, %rdi
	call	mobs_id_to_addr
	movq	%rax, %r13				# Store mob addr in r13
	popq	%rdx
	popq	%rsi
	popq	%rdi

	# Init the data
	movq	%r12, 0(%r13)				# id		%r12
	movq	$0, 8(%r13)				# type		0
	movq	%rdi, 16(%r13)				# scr_id	%rdi
	movq	%rsi, 24(%r13)				# x_pos		%rsi
	movq	%rdx, 32(%r13)				# y_pos		%rdx
	movq	$10, 40(%r13)				# health	10
	movq	$2, 48(%r13)				# damage	2

	# Return the mob ID
	movq	%r12, %rax

	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret
