.text
y_in:			.asciz "input y value\n"
x_in:			.asciz "input x value\n"
mob:			.asciz "for mob"
player:			.asciz "for player"
num:			.asciz "%ld"
num_out:		.asciz "mob needs to walk %ld\n"
num_out_test:		.asciz "counter %ld\n"
test_message:		.asciz "%ld, %ld =/= %ld, %ld\n"
debug:			.asciz "%ld, %ld\n"
debug2:			.asciz "still working\n"

player_x:		.quad	8
player_y:		.quad	8

bytes_per_node:		.quad	24

.bss
#
# Node Representation
#	Lenght	Offset	Name
#	8	0	X
#	8	8	y
#	8	16	distance
nodes:			.skip	34536		# 1920 (row), 24 (node), 34512 (-node), 32616 (-row)

.data
counter:		.quad	1
mob_address:		.quad	0
player_address:		.quad	0
mob_gotto:		.quad	4
test_x:			.quad	0
test_y:			.quad	0

.global main

main:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13

	subq	$16, %rsp			# reserve stack space for var

	movq	$x_in, %rdi			# first argument: base
	movq	$0, %rax			# no vector arguments
	call	printf				# calling the print function

	movq	$0, %rax			# no vector registers for scanf
	movq	$num, %rdi			# arg1: format
	leaq	-8(%rbp), %rsi			# arg2: load addres of stackvar
	call	scanf				# calls scanf

	movq	$y_in, %rdi			# first argument: base
	movq	$0, %rax			# no vector arguments
	call	printf				# calling the print function

	movq	$0, %rax			# no vector registers for scanf
	movq	$num, %rdi			# arg1: format
	leaq	-16(%rbp), %rsi			# arg2: load addres of stackvar
	call	scanf				# calls scanf

	movq	-8(%rbp), %r12
	movq	-16(%rbp), %r13

	movq	%r12, %rdi
	movq	%r13, %rsi
	call	node_address

	movq	%rax, %rdi
	call	walk_check

	cmpq	%r12, test_x
	jne	error_message
	cmpq	%r13, test_y
	jne	error_message

	movq	%r12, %rdi
	movq	%r13, %rsi
	call	pathfinding

	movq	$num_out, %rdi
	movq	mob_gotto, %rsi
	movq	$0, %rax
	call	printf
	jmp	end

error_message:
	movq	$test_message, %rdi		# first argument: base
	movq	%r12, %rsi
	movq	%r13, %rdx
	movq	test_x, %rcx
	movq	test_y, %r8
	movq	$0, %rax			# no vector arguments
	call	printf				# calling the print function


	popq	%r13
	popq	%r12
	movq	%rbp, %rsp			# moving stack pointer to base pointer
	popq	%rbp

	mov	$0, %rdi			# load program exit code
	call	exit

end:
	popq	%r13
	popq	%r12
	movq	%rbp, %rsp			# moving stack pointer to base pointer
	popq	%rbp				# popping the old base pointer from the stack

	mov	$0, %rdi			# load program exit code
	call	exit



node_address:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	$80, %rax			# every row is 80 chars long
	mulq	%rsi				# multiply by y to get wich row you need
	addq	%rdi, %rax			# add x to get wich char you need
	movq	$24, %r8
	mulq	%r8
	addq	$nodes, %rax

	movq	%rbp, %rsp
	popq	%rbp
	ret

pathfinding:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12				# pushes r12 to save it
	movq	%rdi, %r12			# moves rdi (x) to r12 for savekeeping
	pushq	%r13				# pushes r13 to save it
	movq	%rsi, %r13			# moves rsi (y) to r13 for savekeeping
	pushq	%r14				# pushes r14 to save it
	pushq	%r15

	movq	player_x, %rdi			# moving player_x to rdi
	movq	player_y, %rsi			# moving player_y to rsi
	call	node_address			# returns addres of x and y
	movq	%rax, player_address		# now the coords of the player are in player_address

	movq	%r12, %rdi			# moving r12 (x) to rdi
	movq	%r13, %rsi			# moving r13 (y) to rsi
	call	node_address			# returns the offset at which the starting node can be found
	movq	%rax, mob_address		# now the coords of the mod are in mob_address

	movq	counter, %r8
	movq	%r8, 16(%rax)			# load the counter value to the third place of the node

pathfinding_loop:
	movq	$nodes, %r15


loop_inside_loop:
	movq	counter, %r8
	cmpq	%r8, 16(%r15)

	jne	loop_inside_loop_end
	movq	16(%r15), %rdi

	movq	%r15, %rdi
	call	find_path

	cmpq	$4, mob_gotto
	jne	pathfinding_end
loop_inside_loop_end:
	addq	$24, %r15

	movq	$nodes, %r8
	addq	$34536, %r8
	cmpq	%r8, %r15

	jl	loop_inside_loop
	incq	counter

	jmp	pathfinding_loop

pathfinding_end:
	movq	mob_gotto, %rax			# return value in rax
	popq	%r15				#
	popq	%r14				# returns r14 to the old value
	popq	%r13				# returns r13 to the old value
	popq	%r12				# returns r12 to the old value
	movq	%rbp, %rsp
	popq	%rbp
	ret

#
# subroutine:	find_path
# function:	initializes the distance of nodes that can be walked on
#
find_path:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14				# pushes %r14 for save keeping
	pushq	%r12

	movq	%rdi, %r12			#
	movq	counter, %r14			# moves the value of counter to r14
	incq	%r14				# increment the counter

east:
	movq	$nodes, %r9
	addq	$34512, %r9
	cmpq	%r9, %r12			# checs if there is a node east
	jg	north				#

	cmpq	player_address, %r12		# checs if the node is the destination
	je	path_found			#
						#
	addq	$24, %r12			# adds 40 to gain acces to the node east

	pushq	%rax
	movq	%rax, %rdi
	call	walk_check
	cmpq	$0, %rax
	popq	%rax
	je	east_end

	cmpq	$0, 16(%r12)			# compare distance of node with 0
	jne	east_end			#

	movq	%r14, 16(%r12)			# updating the distance

east_end:					#
	subq	$24, %r12			# reset rax


north:
	movq	$nodes, %r9
	addq	$1920, %r9
	cmpq	%r9, %r12			# checks if there is a node north
	jl	west				#

	cmpq	player_address, %r12		# checs if the node is the destination
	je	path_found			#						#
	subq	$1920, %r12			# subs 3200 to gain acces to the node north

	pushq	%rax
	movq	%rax, %rdi
	call	walk_check
	cmpq	$0, %rax
	popq	%rax
	je	north_end

	cmpq	$0, 16(%r12)			# compare distance of node with 0
	jne	north_end			#
	movq	%r14, 16(%r12)			# updating the distance

north_end:					#
	addq	$1920, %r12			# reset rax


west:
	movq	$nodes, %r9
	addq	$24, %r9
	cmpq	%r9, %r12			# checs if there is a node west
	jl	south				#
	cmpq	player_address, %r12		# checs if the node is the destination
	je	path_found			#
						#
	subq	$24, %r12			# subs 24 to rax to gain acces to the node west

	pushq	%rax
	movq	%rax, %rdi
	call	walk_check
	cmpq	$0, %rax
	popq	%rax
	je	west_end

	cmpq	$0, 16(%r12)			# compare distance of node with 0
	jne	west_end			#

	movq	%r14, 16(%r12)			# updating the distance

west_end:					#
	addq	$24, %r12			# resets rax

south:
	pushq	%rax

	movq	$nodes, %r9
	addq	$32616, %r9
	cmpq	%r9, %r12			# checs if there is a node south
	jg	find_path_end			#
	cmpq	player_address, %r12		# checs if the node is the destination
	je	path_found			#
	addq	$1920, %r12			# adds 3200 to rax to gain acces to the node south

	pushq	%rax
	movq	%rax, %rdi
	call	walk_check
	cmpq	$0, %rax
	popq	%rax
	je	south_end

	cmpq	$0, 16(%r12)			# compare distance of node with 0
	jne	south_end			#

	movq	%r14, 16(%r12)			# updating the distance

south_end:					#
	subq	$1920, %r12			# resets rax


find_path_end:
	popq	%r12
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret


path_found:

	decq	counter
f_east:
	movq	$nodes, %r9
	addq	$34512, %r9
	cmpq	%r9, %r12			# checs if there is a node east
	jg	f_north				#
						#
	addq	$24, %r12			# adds 40 to rax to gain acces to the node left the we where just at
	cmpq	$1, 16(%r12)			# compare distance of node with 0
	je	found_west
	movq	counter, %r8
	cmpq	16(%r12), %r8			# compare distance of node with 0
	je	path_found			#
						#
f_east_end:					#
	subq	$24, %r12			# reset rax


f_north:
	movq	$nodes, %r9
	addq	$1920, %r9
	cmpq	%r9, %r12			# checks if there is a node north
	jl	f_west				#
						#
	subq	$1920, %r12			#
	cmpq	$1, 16(%r12)			# compare distance of node with 0
	je	found_south
	cmpq	16(%r12), %r8			# compare distance of node with 0
	je	path_found			#
						#
f_north_end:					#
	addq	$1920, %r12			# reset rax


f_west:
	movq	$nodes, %r9
	addq	$24, %r9
	cmpq	%r9, %r12			# checs if there is a node west
	jl	f_south				#
	subq	$24, %r12			# subs 40 to rax to gain acces to the node west
	cmpq	$1, 16(%r12)			# compare distance of node with 0
	je	found_east			#
	cmpq	16(%r12), %r8			# compare distance of node with 0
	je	path_found			#
						#
f_west_end:					#
	addq	$24, %r12			# resets rax

f_south:
	movq	$nodes, %r9
	addq	$32616, %r9
	cmpq	%r9, %r12			# checs if there is a node south
	jg	path_found			#
						#
	addq	$1920, %r12			# adds 3200 to rax to gain acces to the node south
	cmpq	$1, 16(%r12)			# compare distance of node with 0
	je	found_north			#
	jmp	path_found			#

found_east:
	movq	$0, mob_gotto
	jmp	path_found_end
found_north:
	movq	$1, mob_gotto
	jmp	path_found_end
found_west:
	movq	$2, mob_gotto
	jmp	path_found_end
found_south:
	movq	$3, mob_gotto
	jmp	path_found_end

path_found_end:
	movq	$mob_gotto, %rax
	jmp	find_path_end

#
# subroutine:
# function:
#
walk_check:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13				# y value
	pushq	%r14				# x value

	movq	$0, %r13
	movq	$0, %r14

	movq	%rdi, %r12
	subq	$nodes, %r12
address_y_loop:
	cmpq	$1919, %r12
	jle	address_x_loop
	subq	$1920, %r12
	incq	%r13
	jmp	address_y_loop

address_x_loop:
	cmpq	$24, %r12
	jl	walk_check_end
	subq	$24, %r12
	incq	%r14

	jmp	address_x_loop


walk_check_end:
	movq	%r14, %rdi
	movq	%r14, test_x
	movq	%r13, %rsi
	movq	%r13, test_y
#	call	is_traversable			# comment for grip with no walls
	movq	$1, %rax			# uncomment for grid with no walls

	popq	%r14
	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret
