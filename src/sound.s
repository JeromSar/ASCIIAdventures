.text
sound_clank_file:	.asciz	"clank.ogg"
debug:			.asciz	"BASS audio says: Channel: %lu, Play: %lu"
channel_flags:		.quad	0x20000				# Override the longest playing channel

.data
sound_clank:		.quad	0

.global sound_init
.global sound_load
.global sound_play
.global sound_play_clank
.global sound_deinit

sound_init:
	pushq	%rbp
	movq	%rsp, %rbp

	# http://stackoverflow.com/questions/7180920/bass-play-a-stream
	movq	$1, %rdi
	negq	%rdi
	movq	$44100, %rsi
	movq	$0, %rdx
	movq	$0, %rcx
	movq	$0, %r8
	call	BASS_Init

#	movq	$debug, %rdi
#	movq	%rax, %rsi
#	call	printf
#	call	BASS_ErrorGetCode
#	movq	$debug2, %rdi
#	movq	%rax, %rsi
#	call	printf

	movq	%rbp, %rsp
	popq	%rbp
	ret

sound_load:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	$0, %rdi
	movq	$sound_clank_file, %rsi
	movq	$0, %rdx
	movq	$0, %rcx
	movq	$3, %r8
	movq	channel_flags, %r9
	call	BASS_SampleLoad
	movq	%rax, sound_clank

	movq	%rbp, %rsp
	popq	%rbp
	ret

sound_play:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%r15

	movq	sound_clank, %rdi
	movq	$0, %rsi
	call	BASS_SampleGetChannel
	pushq	%rax

	call	BASS_ErrorGetCode
	movq	%rax, %r14

#	movq	$debug, %rdi
#	movq	%rax, %rsi
#	call	printf
#	call	BASS_ErrorGetCode
#	movq	$debug2, %rdi
#	movq	%rax, %rsi
#	call	printf

	popq	%rdi
	movq	$0, %rsi
	call	BASS_ChannelPlay

	call	BASS_ErrorGetCode

	movq	$debug, %rdi
	movq	%r14, %rdx
	movq	%rax, %rcx
#	call	log_push

	popq	%r15
	popq	%r14
	movq	%rbp, %rsp
	popq	%rbp
	ret


sound_deinit:
	pushq	%rbp
	movq	%rsp, %rbp

	call	BASS_Stop
	call	BASS_Free

	movq	%rbp, %rsp
	popq	%rbp
	ret

sound_play_clank:
	pushq	%rbp
	movq	%rsp, %rbp

	call	sound_play

	movq	%rbp, %rsp
	popq	%rbp
	ret
