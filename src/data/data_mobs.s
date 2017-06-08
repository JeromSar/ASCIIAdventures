.text
bytes_per_mob:		.quad	128
name_wolf:		.asciz	"wolf"
name_unknown:		.asciz	"monster"

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
mobs_bytes:		.skip	16392			# 64 mobs (128*64)

.data
mobs_count:		.quad	0


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
	movq	$25, %rsi
	movq	$7, %rdx
	call	make_wolf

	# Make a wolf at (9, 30, 10)
	movq	$9, %rdi
	movq	$50, %rsi
	movq	$10, %rdx
	call	make_wolf

	# Make a wolf at (0, 54, 3)
	movq	$0, %rdi
	movq	$54, %rsi
	movq	$3, %rdx
	call	make_wolf

	# Make a wolf at (0, 31, 9)
	movq	$0, %rdi
	movq	$31, %rsi
	movq	$9, %rdx
	call	make_wolf

	# Make a wolf at (0, 23, 15)
	movq	$0, %rdi
	movq	$23, %rsi
	movq	$15, %rdx
	call	make_wolf

	# Make a wolf at (1, 36, 8)
	movq	$1, %rdi
	movq	$36, %rsi
	movq	$8, %rdx
	call	make_wolf

	# Make a wolf at (1, 53, 6)
	movq	$1, %rdi
	movq	$53, %rsi
	movq	$6, %rdx
	call	make_wolf

	# Make a wolf at (2, 45, 9)
	movq	$2, %rdi
	movq	$45, %rsi
	movq	$10, %rdx
	call	make_wolf

	# Make a wolf at (2, 45, 11)
	movq	$2, %rdi
	movq	$45, %rsi
	movq	$10, %rdx
	call	make_wolf

	# Make a wolf at (2, 64, 14)
	movq	$2, %rdi
	movq	$64, %rsi
	movq	$14, %rdx
	call	make_wolf

	# Make a wolf at (2, 19, 2)
	movq	$2, %rdi
	movq	$19, %rsi
	movq	$2, %rdx
	call	make_wolf

	# Make a wolf at (5, 31, 11)
	movq	$5, %rdi
	movq	$31, %rsi
	movq	$11, %rdx
	call	make_wolf

	# Make a wolf at (5, 48, 6)
	movq	$5, %rdi
	movq	$48, %rsi
	movq	$6, %rdx
	call	make_wolf

	# Make a wolf at (5, 29, 16)
	movq	$5, %rdi
	movq	$29, %rsi
	movq	$16, %rdx
	call	make_wolf

	# Make a wolf at (6, 51, 2)
	movq	$6, %rdi
	movq	$51, %rsi
	movq	$2, %rdx
	call	make_wolf

	# Make a wolf at (6, 11, 13)
	movq	$6, %rdi
	movq	$11, %rsi
	movq	$13, %rdx
	call	make_wolf

	# Make a wolf at (8, 27, 9)
	movq	$8, %rdi
	movq	$27, %rsi
	movq	$9, %rdx
	call	make_wolf

	# Make a wolf at (10, 48, 2)
	movq	$10, %rdi
	movq	$48, %rsi
	movq	$2, %rdx
	call	make_wolf

	# Make a wolf at (11, 56, 2)
	movq	$11, %rdi
	movq	$56, %rsi
	movq	$2, %rdx
	call	make_wolf

	# Make a wolf at (11, 40, 11)
	movq	$11, %rdi
	movq	$40, %rsi
	movq	$11, %rdx
	call	make_wolf

	# Make a wolf at (12, 18, 12)
	movq	$12, %rdi
	movq	$18, %rsi
	movq	$12, %rdx
	call	make_wolf

	# Make a wolf at (12, 15, 1)
	movq	$12, %rdi
	movq	$15, %rsi
	movq	$1, %rdx
	call	make_wolf

	# Make a wolf at (13, 18, 11)
	movq	$13, %rdi
	movq	$18, %rsi
	movq	$11, %rdx
	call	make_wolf

	# Make a wolf at (14, 37, 14)
	movq	$14, %rdi
	movq	$37, %rsi
	movq	$14, %rdx
	call	make_wolf

	# Make a wolf at (14, 3, 13)
	movq	$14, %rdi
	movq	$3, %rsi
	movq	$13, %rdx
	call	make_wolf

	# Make a wolf at (14, 14, 11)
	movq	$14, %rdi
	movq	$14, %rsi
	movq	$11, %rdx
	call	make_wolf

	# Make a wolf at (15, 57, 10)
	movq	$15, %rdi
	movq	$57, %rsi
	movq	$10, %rdx
	call	make_wolf

	# Make a wolf at (15, 57, 10)
	movq	$15, %rdi
	movq	$15, %rsi
	movq	$2, %rdx
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

	pushq	$0						# Result value on stack
	movq	mobs_count, %r12				# counter in r12

mobs_get_at_coords_loop:
	cmpq	$0, %r12
	je	mobs_get_at_coords_done
	decq	%r12

	# Get the mobs address
	movq	%r12, %rdi
	call	mobs_id_to_addr

	# Check that the mob is on the current screen
	cmpq	%r13, 16(%rax)
	jne	mobs_get_at_coords_loop

	# Check that the x and y match
	cmpq	24(%rax), %r14
	jne	mobs_get_at_coords_loop
	cmpq	32(%rax), %r15
	jne	mobs_get_at_coords_loop

	# Check that the mob is not dead
	cmpq	$0, 40(%rax)
	je	mobs_get_at_coords_loop

	popq	%r8
	pushq	%rax

mobs_get_at_coords_done:
	popq	%rax

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
	movq	$7, 40(%r13)				# health	10
	movq	$1, 48(%r13)				# damage	1
	movq	$1, 56(%r13)				# sleeping	1

	# Return the mob ID
	movq	%r12, %rax

	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret
