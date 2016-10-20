.text
lever_char:		.asciz	"L"
door_char:		.asciz	"D"
debug:			.asciz	"There is a lever at (%ul, %ul, %ul)"
debug2:			.asciz	"Now printing..."

.global levers_print

levers_print:
	pushq	%rbp
	movq	%rsp, %rbp

	call	levers_print_lever

	call	levers_print_door

	movq	%rbp, %rsp
	popq	%rbp



# Subroutine - levers_print_door
# Prints all the door-objects in the current screen
levers_print_door:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%r15

	# Calculate scr id, store in r14
	movq	screen_y, %rdx
	movq	$4, %rax
	mulq	%rdx
	addq	screen_x, %rax
	movq	%rax, %r14

	# Print ldoors
	movq	levers_count, %r15
	decq	%r15

	# DEBUG
	#movq	$1, %r14

door_print_loop:
	cmpq	$0, %r15
	je	door_print_done

	# Get the lever object's address
	movq	%r15, %rdi
	call	levers_id_to_addr

	# DEBUG - Print some debug information
	#pushq	%rax
	#movq	%r14, %rdi
	#movq	$1, %rsi
	#incq	%r14
	#movq	$debug, %rdx
	#movq	40(%rax), %rcx
	#movq	48(%rax), %r8
	#movq	56(%rax), %r9
	#movq	$0, %rax
	#call	mvprintw
	#popq	%rax
	# DEBUG - end

	# Check that the door is on the current screen
	cmpq	%r14, 40(%rax)
	jne	door_print_continue

	# Check that the door is closed
	cmpq	$0, 8(%rax)
	jne	door_print_continue

	pushq	%rax
	call	color_start_yellow
	popq	%rax

	# Get the x y and print
	movq	32(%rax), %rdi
	movq	24(%rax), %rsi
	movq	$door_char, %rdx
	call	mvprintw

	call	color_stop_yellow

door_print_continue:
	decq	%r15
	jmp	door_print_loop

door_print_done:
	popq	%r15
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret



# Subroutine - levers_print_levers
# Prints all the levers-objects for the current screen
levers_print_lever:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%r15

	# Calculate scr id, store in r14
	movq	screen_y, %rdx
	movq	$4, %rax
	mulq	%rdx
	addq	screen_x, %rax
	movq	%rax, %r14

	# Print levers
	movq	levers_count, %r15
	decq	%r15

	# DEBUG
	#movq	$1, %r14

lever_print_loop:
	cmpq	$0, %r15
	je	lever_print_done

	# Get the lever address
	movq	%r15, %rdi
	call	levers_id_to_addr
	movq	%rax, %r13				# r13 - lever addr

	# DEBUG - Print some debug information
	#pushq	%rax
	#movq	%r14, %rdi
	#movq	$1, %rsi
	#incq	%r14
	#movq	$debug, %rdx
	#movq	40(%rax), %rcx
	#movq	48(%rax), %r8
	#movq	56(%rax), %r9
	#movq	$0, %rax
	#call	mvprintw
	#popq	%rax
	# DEBUG - end

	# Check that the lever is on the current screen
	cmpq	%r14, 40(%r13)
	jne	lever_print_continue

	# Check if the door is closed (color)
	movq	8(%r13), %r8
	cmpq	$0, %r8
	je	lever_print_closed
	call	color_start_green
	jmp	lever_print_colored
lever_print_closed:
	call	color_start_red
lever_print_colored:

	# Get the x y and print
	movq	56(%r13), %rdi
	movq	48(%r13), %rsi
	movq	$lever_char, %rdx
	call	mvprintw

	# Check if the door is closed (color)
	movq	8(%r13), %r8
	cmpq	$0, %r8
	je	lever_print_closed_stop
	call	color_stop_green
	jmp	lever_print_continue
lever_print_closed_stop:
	call	color_stop_red

lever_print_continue:
	decq	%r15
	jmp	lever_print_loop

lever_print_done:
	popq	%r15
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret
