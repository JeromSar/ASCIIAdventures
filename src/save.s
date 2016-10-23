.text
save_one_fn:			.asciz	"save.dat"
read_mode:			.asciz	"rb"
write_mode:			.asciz	"w+b"

.global save_game
.global load_game

save_game:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12

	# https://www.tutorialspoint.com/cprogramming/c_file_io.htm
	movq	$save_one_fn, %rdi
	movq	$write_mode, %rsi
	call	fopen
	movq	%rax, %r12				# File pointer

	# Start writing
	movq	player_x, %rdi
	movq	%r12, %rsi
	call	fputc

	movq	player_y, %rdi
	movq	%r12, %rsi
	call	fputc

	# Close the stream
	movq	%r12, %rdi
	call	fclose

	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret

load_game:
	pushq	%rbp
	movq	%rsp, %rbp

	# https://www.tutorialspoint.com/cprogramming/c_file_io.htm
	movq	$save_one_fn, %rdi
	movq	$read_mode, %rsi
	call	fopen
	movq	%rax, %r12				# File pointer

	cmpq	$0, %r12
	je	load_game_fail

	# Start writing
	movq	%r12, %rdi
	call	fgetc
	movq	%rax, player_x

	movq	%r12, %rdi
	call	fgetc
	movq	%rax, player_y

	# Close the stream
	movq	%r12, %rdi
	call	fclose

	movq	$1, %rax
load_game_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret

load_game_fail:
	movq	$0, %rax
	jmp	load_game_done
