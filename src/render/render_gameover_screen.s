.text

amount_killed:					.asciz	"And you killed %ld wolves!"
primes_earned:					.asciz	"You found %ld primes!"

.global render_gameover_screen

render_gameover_screen:
	pushq	%rbp
	movq	%rsp, %rbp

	cmpq	$1, %rdi
	jne	gameover_state0

	# Print gameover screen
	movq	$0, %rdi
	movq	$0, %rsi
	movq	$lvl_1_game, %rdx
	call	mvprintw

	movq	$19, %rdi
	movq	$30, %rsi
	movq	$primes_earned, %rdx
	movq	player_money, %rcx
	call	mvprintw

	movq	$20, %rdi
	movq	$28, %rsi
	movq	$amount_killed, %rdx
	movq	player_kills, %rcx
	call	mvprintw

#	movq	sound_haha, %rdi
#	call	sound_play

	jmp	gameover_ret

gameover_state0:
	# Print gameover screen
	movq	$0, %rdi
	movq	$0, %rsi
	movq	$lvl_1_over, %rdx
	call	mvprintw

	movq	$19, %rdi
	movq	$30, %rsi
	movq	$primes_earned, %rdx
	movq	player_money, %rcx
	call	mvprintw

	movq	$20, %rdi
	movq	$28, %rsi
	movq	$amount_killed, %rdx
	movq	player_kills, %rcx
	call	mvprintw

gameover_ret:
	movq	%rbp, %rsp
	popq	%rbp
	ret
