.text
text_health:		.asciz	"HP: "
text_heart:		.asciz	"*"
text_half_heart:	.asciz	"*"
text_money:		.asciz	"Pr: %lu"
health_y_coord:		.quad	20
money_y_coord:		.quad	21

.global render_game_gui
.global log_push

render_game_gui:
	push	%rbp
	movq	%rsp, %rbp

	# Print the gui box
	call	color_start_blue
	movq	GAME_HEIGHT, %rdi
	movq	$0, %rsi
	movq	$screen_gui, %rdx
	call	mvprintw
	call	color_stop_blue

	# Print health
	call	render_health

	# Print money
	call	render_money

	# Render log
	call	render_game_gui_log

	movq	%rbp, %rsp
	popq	%rbp
	ret


render_health:
	push	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%r15

	call	color_start_red

	movq	health_y_coord, %rdi
	movq	$3, %rsi
	movq	$text_health, %rdx
	call	mvprintw

	# Print the hearts
	movq	player_health, %r14				# The remaining health to print
	movq	$8, %r15					# The x co-ordinate
render_health_loop:
	cmpq	$1, %r14
	je	render_health_last

	cmpq	$0, %r14
	je	render_health_done

	# Print a full heart
	movq	health_y_coord, %rdi
	movq	%r15, %rsi
	movq	$text_heart, %rdx
	call	mvprintw

	subq	$2, %r14
	incq	%r15
	jmp	render_health_loop

render_health_last:
	call	color_stop_red
	call	color_start_yellow

	# Print a half heart
	movq	health_y_coord, %rdi
	movq	%r15, %rsi
	movq	$text_half_heart, %rdx
	call	mvprintw

	call	color_stop_yellow
	call	color_start_red

render_health_done:
	call	color_stop_red

	popq	%r15
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret

#
# Subroutine - render_money
# Renders the money in the gui
#
render_money:
	push	%rbp
	movq	%rsp, %rbp

	call	color_start_yellow

	# Print money text
	movq	money_y_coord, %rdi
	movq	$3, %rsi
	movq	$text_money, %rdx
	movq	player_money, %rcx
	call	mvprintw

	call	color_stop_yellow

	movq	%rbp, %rsp
	popq	%rbp
	ret
