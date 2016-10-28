.text

amount_killed:					.asciz	"And you killed %ld wolves!"
primes_earned:					.asciz	"You found %ld primes!"

.global render_win_screen

render_win_screen:
	pushq	%rbp
	movq	%rsp, %rbp

	# Print win screen
	movq	$0, %rdi
	movq	$0, %rsi
	movq	$lvl_1_win, %rdx
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

	movq	%rbp, %rsp
	popq	%rbp
	ret
