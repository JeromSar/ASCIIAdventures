.text
attack_air:		.asciz	"You swung your fist at the air, with very little effect"
attack_mob:		.asciz	"You attacked the %s and dealt %lu damage"
kill_mob:		.asciz	"You killed the %s while dealing %lu damage"

.data
control_player_attack:	.quad	0

.global control_player_attack
.global control_attack

control_attack:
	push	%rbp
	movq	%rsp, %rbp

	movq	$0, control_player_attack

	# The char is stored in r12
	cmpq	%r12, key_q
	je	control_q

	jmp	control_done					# Unknown key

control_q:
	# Find a mob to attack
	movq	player_x, %r12
	movq	player_y, %r13

	decq	%r13						# Above the player
	movq	%r12, %rdi
	movq	%r13, %rsi
	call	mobs_get_at_coords
	cmpq	$0, %rax
	jne	control_q_found

	incq	%r12						# Right of the player
	incq	%r13
	movq	%r12, %rdi
	movq	%r13, %rsi
	call	mobs_get_at_coords
	cmpq	$0, %rax
	jne	control_q_found

	decq	%r12						# Below of the player
	incq	%r13
	movq	%r12, %rdi
	movq	%r13, %rsi
	call	mobs_get_at_coords
	cmpq	$0, %rax
	jne	control_q_found

	decq	%r12						# Left of the player
	decq	%r13
	movq	%r12, %rdi
	movq	%r13, %rsi
	call	mobs_get_at_coords
	cmpq	$0, %rax
	jne	control_q_found

	# No mob here
	movq	$attack_air, %rdi
	call	log_push

	jmp	control_done

control_q_found:
	movq	%rax, %r12					# Store address in r12
	movq	$1, control_player_attack

	# Mob name
	movq	8(%r12), %rdi
	call	mobs_type_to_name
	movq	%rax, %r13					# Mob name in r13

	movq	40(%r12), %r8					# Health
	movq	player_damage, %r9
	cmpq	%r8, %r9
	jge	mob_dead

	subq	%r9, %r8
	movq	%r8, 40(%r12)

	movq	$attack_mob, %rdi
	movq	%r13, %rsi
	movq	%r9, %rdx
	call	log_push

	jmp	control_done

mob_dead:
	movq	$0, 40(%r12)

	movq	$kill_mob, %rdi
	movq	%r13, %rsi
	movq	%r9, %rdx
	call	log_push

control_done:
	movq	%rbp, %rsp
	popq	%rbp
	ret
