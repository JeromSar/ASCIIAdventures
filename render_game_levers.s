.text
lever_char:		.asciz	"L"
door_char:		.asciz	"D"
debug:			.asciz	"There is a lever at (%ul, %ul, %ul)"
debug2:			.asciz	"Now printing..."

.global render_game_levers

render_game_levers:
	pushq	%rbp
	movq	%rsp, %rbp

	call	levers_render_lever

	call	levers_render_door

	movq	%rbp, %rsp
	popq	%rbp



# Subroutine - levers_render_door
# Prints all the door-objects in the current screen
levers_render_door:
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

door_render_loop:
	cmpq	$0, %r15
	je	door_render_done

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
	jne	door_render_continue

	# Check that the door is closed
	cmpq	$0, 8(%rax)
	jne	door_render_continue

	pushq	%rax
	call	color_start_yellow
	popq	%rax

	# Get the x y and print
	movq	32(%rax), %rdi
	movq	24(%rax), %rsi
	movq	$door_char, %rdx
	call	mvprintw

	call	color_stop_yellow

door_render_continue:
	decq	%r15
	jmp	door_render_loop

door_render_done:
	popq	%r15
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret



# Subroutine - levers_render_levers
# Prints all the levers-objects for the current screen
levers_render_lever:
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

lever_render_loop:
	cmpq	$0, %r15
	je	lever_render_done

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
	jne	lever_render_continue

	# Check if the door is closed (color)
	movq	8(%r13), %r8
	cmpq	$0, %r8
	je	lever_render_closed
	call	color_start_green
	jmp	lever_render_colored
lever_render_closed:
	call	color_start_red
lever_render_colored:

	# Get the x y and print
	movq	56(%r13), %rdi
	movq	48(%r13), %rsi
	movq	$lever_char, %rdx
	call	mvprintw

	# Check if the door is closed (color)
	movq	8(%r13), %r8
	cmpq	$0, %r8
	je	lever_render_closed_stop
	call	color_stop_green
	jmp	lever_render_continue
lever_render_closed_stop:
	call	color_stop_red

lever_render_continue:
	decq	%r15
	jmp	lever_render_loop

lever_render_done:
	popq	%r15
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret
