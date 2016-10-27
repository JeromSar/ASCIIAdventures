.text
bytes_per_mob:		.quad	128
name_wolf:		.asciz	"wolf"
name_unknown:		.asciz	"monster"
debug:			.asciz	"debug"

.bss
#
# Mob Data Representation (MDR)
# 	Length	Offset	Name		Values
#	8	0	id		-
#	8 	8	type		0	-> Wolf
#	8	16	scr_id		-
#	8	24	x_pos		-
#	8	32	y_pos		-
#	8	40	health		0	-> Dead
#					1.. 	-> Alive with this amount of health
#	8	48	damage		-
#	8	56	sleeping	0, 1
mobs_bytes:		.skip	2048			# 16 mobs (128*8)

.data
mobs_count:		.quad	1


.global mobs_bytes
.global mobs_count

.global mobs
.global mobs_init
.global mobs_id_to_addr
.global mobs_type_to_name
.global mobs_get_at_coords

mobs_init:
	pushq	%rbp
	movq	%rsp, %rbp

	# Make a wolf at (9, 10, 10)
	movq	$9, %rdi
	movq	$10, %rsi
	movq	$10, %rdx
	call	make_wolf

	# Make a wolf at (9, 30, 10)
	movq	$9, %rdi
	movq	$55, %rsi
	movq	$5, %rdx
	call	make_wolf

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

	addq	$mobs_bytes, %rax			# %rax acts as the offset

	movq	%rbp, %rsp
	popq	%rbp
	ret

mobs_type_to_name:
	pushq	%rbp
	movq	%rsp, %rbp

	cmpq	$0, %rdi
	je	mobs_type_to_name_wolf

	movq	$name_unknown, %rax
	jmp	mobs_type_to_name_done

mobs_type_to_name_wolf:
	movq	$name_wolf, %rax
	jmp	mobs_type_to_name_done

mobs_type_to_name_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret


mobs_get_at_coords:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15

	movq	%rdi, %r14					# x in r14
	movq	%rsi, %r15					# y in r15

	call	screen_get_id
	movq	%rax, %r13					# screen id in r13

	movq	mobs_count, %r12				# counter in r12
	decq	%r12

mobs_get_at_coords_loop:
	# Get the mobs address
	movq	%r12, %rdi
	call	mobs_id_to_addr

	# Check that the mob is on the current screen
	cmpq	%r13, 16(%rax)
	jne	mobs_get_at_coords_continue

	# Compare the x and y
	cmpq	24(%rax), %r14
	jne	mobs_get_at_coords_continue

	cmpq	32(%rax), %r15
	jne	mobs_get_at_coords_continue

	jmp	mobs_get_at_coords_done

mobs_get_at_coords_continue:
	decq	%r12
	cmpq	$0, %r12
	je	mobs_get_at_coords_loop
	movq	$0, %rax

mobs_get_at_coords_done:
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
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
	movq	$1, 48(%r13)				# damage	1
	movq	$1, 56(%r13)				# sleeping	1

	# Return the mob ID
	movq	%r12, %rax

	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret
