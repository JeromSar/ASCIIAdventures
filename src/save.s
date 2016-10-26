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
	pushq	%r13

	# https://www.tutorialspoint.com/cprogramming/c_file_io.htm
	movq	$save_one_fn, %rdi
	movq	$write_mode, %rsi
	call	fopen
	movq	%rax, %r12					# File pointer

	# player
	movq	player_x, %rdi
	movq	%r12, %rsi
	call	fputc
	movq	player_y, %rdi
	movq	%r12, %rsi
	call	fputc

	# Screen
	movq	screen_x, %rdi
	movq	%r12, %rsi
	call	fputc
	movq	screen_y, %rdi
	movq	%r12, %rsi
	call	fputc

	# Levers
	movq	$0, %r13
save_levers_loop:
	movq	%r13, %r8					# The long ofset to r8
	addq	$levers_bytes, %r8				# Make it an actual address
	movq	$0, %rdx					# Clear rdx
	movb	(%r8), %dl					# Move the byte to dl (lowest byte of rdx)
	movq	%rdx, %rdi					# Get the value at this address, store in the first byte of rdi
	movq	%r12, %rsi
	call	fputc

	incq	%r13
	cmpq	$2048, %r13
	jne	save_levers_loop

	# Mobs
	movq	$0, %r13
save_mobs_loop:
	movq	%r13, %r8					# The long ofset to r8
	addq	$mobs_bytes, %r8				# Make it an actual address
	movq	$0, %rdx					# Clear rdx
	movb	(%r8), %dl					# Move the byte to dl (lowest byte of rdx)
	movq	%rdx, %rdi					# Get the value at this address, store in the first byte of rdi
	movq	%r12, %rsi
	call	fputc

	incq	%r13
	cmpq	$2048, %r13
	jne	save_mobs_loop

	# Close the stream
	movq	%r12, %rdi
	call	fclose

	popq	%r13
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
	movq	%rax, %r12					# File pointer

	cmpq	$0, %r12
	je	load_game_fail

	# Player
	movq	%r12, %rdi
	call	fgetc
	movq	%rax, player_x
	movq	%r12, %rdi
	call	fgetc
	movq	%rax, player_y

	# Screen
	movq	%r12, %rdi
	call	fgetc
	movq	%rax, screen_x
	movq	%r12, %rdi
	call	fgetc
	movq	%rax, screen_y

	# Levers
	movq	$0, %r13
load_levers_loop:
	movq	%r12, %rsi
	call	fgetc
	movq	%rax, %rdx					# Move the value to rdx so we can access dl
	movq	%r13, %r8					# Store the offset in r8
	addq	$levers_bytes, %r8				# Make the offset an address
	movb	%dl, (%r8)

	incq	%r13
	cmpq	$2048, %r13
	jne	load_levers_loop

	# Mobs bytes
	movq	$0, %r13
load_mobs_loop:
	movq	%r12, %rsi
	call	fgetc
	movq	%rax, %rdx					# Move the value to rdx so we can access dl
	movq	%r13, %r8					# Store the offset in r8
	addq	$mobs_bytes, %r8				# Make the offset an address
	movb	%dl, (%r8)

	incq	%r13
	cmpq	$1000, %r13					# This is weird, setting to 2048 crashes.
	jne	load_mobs_loop


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
