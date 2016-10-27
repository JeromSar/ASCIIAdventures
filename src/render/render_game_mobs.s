.text
mob_char:		.asciz	"W"
mob_sleep_char:		.asciz	"z"

.global render_game_mobs

render_game_mobs:
	pushq	%rbp
	movq	%rsp, %rbp

	# Calculate scr id, store in r14
	call	screen_get_id
	movq	%rax, %r14

	movq	mobs_count, %r15
	decq	%r15

render_loop:
	cmpq	$0, %r15
	je	mobs_render_done

	# Get the mobs address
	movq	%r15, %rdi
	call	mobs_id_to_addr
	movq	%rax, %r12

	# Check that the mob is on the current screen
	cmpq	%r14, 16(%r12)
	jne	mobs_render_continue

	# Check that the mob is alive
	cmpq	$0, 40(%r12)
	je	mobs_render_continue

	# Check if the mob is sleeping
	cmpq	$0, 56(%r12)
	je	mob_awake

	# Check if the sleeping char should be printed
	cmpq	$0, timing_state
	je	mob_awake

	# Mob is not sleeping
	movq	$mob_sleep_char, %rdx
	jmp	print_mob

mob_awake:
	call	color_start_cyan
	movq	$mob_char, %rdx

print_mob:
	# Get the x y and print
	movq	32(%r12), %rdi
	movq	24(%r12), %rsi
	call	mvprintw

	# Stop color if necessary
	cmpq	$0, 56(%r12)
	je	mobs_render_continue
	cmpq	$0, timing_state
	je	mobs_render_continue
	call	color_stop_cyan

mobs_render_continue:
	decq	%r15
	jmp	render_loop

mobs_render_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret
