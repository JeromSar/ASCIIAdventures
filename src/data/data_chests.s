.text

primes_found:		.asciz "You found %ld primes!"
Health_found:		.asciz "You found a potion it healed you to full!"
item_found:		.asciz "You found %s!"

weapon_tiers_1:		.asciz "an old club (+1)"
weapon_tiers_2:		.asciz "a rusty sword (+2)"
weapon_tiers_3:		.asciz "a spiky club (+3)"

armour_tiers_1:		.asciz "a wool jacket (+2)"
armour_tiers_2:		.asciz "a leather coat (+4)"
armour_tiers_3:		.asciz "a chain vest (+6)"

bytes_per_chest:	.quad	64

.bss
#
# Lever Data Representation (LDR)
# 	Length	Offset	Name		Values
#	8	0	id		-
#	8	8	scr_id		-
#	8	16	x_chest		-
#	8	24	y_chest		-
#	8	32	chest_state	-
#					0 -> chest not found
#					1 -> chest found
#	8	40	function	-
#	8	48	tier		-
#					0 for tier 1
#					1 for tier 2
#					2 for tier 3

chests:			.skip	2048

.data
chests_count:		.quad	1

.global chests_count

.global chests_init
.global chest_id_to_addr
.global make_chest
chests_init:
	pushq	%rbp
	movq	%rsp, %rbp

	# values to be placed in the chest
	movq	$0, %rdi				# scr_id
	movq	$28, %rsi				# x_chest
	movq	$12, %rdx				# y_chest
	movq	$0, %rcx				# chest_state
	movq	$chest_armour, %r8			# chest function
	movq	$2, %r9					# chest tier
	call	make_chest

	# values to be placed in the chest
	movq	$2, %rdi				# scr_id
	movq	$6, %rsi				# x_chest
	movq	$3, %rdx				# y_chest
	movq	$0, %rcx				# chest_state
	movq	$chest_primes, %r8			# chest function
	movq	$1, %r9					# chest tier
	call	make_chest

	movq	$11, %rdi				# scr_id
	movq	$65, %rsi				# x_chest
	movq	$4, %rdx				# y_chest
	movq	$0, %rcx				# chest_state
	movq	$chest_primes, %r8			# chest function
	movq	$0, %r9					# chest tier
	call	make_chest

	movq	$13, %rdi				# scr_id
	movq	$49, %rsi				# x_chest
	movq	$13, %rdx				# y_chest
	movq	$0, %rcx				# chest_state
	movq	$chest_health, %r8			# chest function
	movq	$0, %r9					# chest tier
	call	make_chest

	movq	$14, %rdi				# scr_id
	movq	$73, %rsi				# x_chest
	movq	$1, %rdx				# y_chest
	movq	$0, %rcx				# chest_state
	movq	$chest_weapon, %r8			# chest function
	movq	$1, %r9					# chest tier
	call	make_chest

	movq	$14, %rdi				# scr_id
	movq	$73, %rsi				# x_chest
	movq	$16, %rdx				# y_chest
	movq	$0, %rcx				# chest_state
	movq	$chest_armour, %r8			# chest function
	movq	$1, %r9					# chest tier
	call	make_chest

	movq	$12, %rdi				# scr_id
	movq	$14, %rsi				# x_chest
	movq	$3, %rdx				# y_chest
	movq	$0, %rcx				# chest_state
	movq	$chest_health, %r8			# chest function
	movq	$0, %r9					# chest tier
	call	make_chest

	movq	$12, %rdi				# scr_id
	movq	$6, %rsi				# x_chest
	movq	$14, %rdx				# y_chest
	movq	$0, %rcx				# chest_state
	movq	$chest_weapon, %r8			# chest function
	movq	$0, %r9					# chest tier
	call	make_chest

	movq	$5, %rdi				# scr_id
	movq	$19, %rsi				# x_chest
	movq	$10, %rdx				# y_chest
	movq	$0, %rcx				# chest_state
	movq	$chest_health, %r8			# chest function
	movq	$0, %r9					# chest tier
	call	make_chest

	movq	$6, %rdi				# scr_id
	movq	$7, %rsi				# x_chest
	movq	$9, %rdx				# y_chest
	movq	$0, %rcx				# chest_state
	movq	$chest_health, %r8			# chest function
	movq	$0, %r9					# chest tier
	call	make_chest

	movq	%rbp, %rsp
	popq	%rbp
	ret

# Subroutine - chest_id_to_addr
# Takes a lever ID and returns its address
# %rdi - The chest ID
chest_id_to_addr:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, %rax
	movq	bytes_per_chest, %rdx			# Amt. of bytes reserved per chest
	mulq	%rdx					# Result in rax

	addq	$chests, %rax				# %rax acts as the offset

	movq	%rbp, %rsp
	popq	%rbp
	ret

make_chest:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13

	movq	chests_count, %r12			# Store chest ID in r12
	incq	chests_count

	# So sorry... again...
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	pushq	%rcx
	pushq	%r8
	pushq	%r9
	movq	%r12, %rdi
	call	chest_id_to_addr
	movq	%rax, %r13				# Store lever addr in r13
	popq	%r9
	popq	%r8
	popq	%rcx
	popq	%rdx
	popq	%rsi
	popq	%rdi

	# Init the data
	movq	%r12, 0(%r13)				# id		%r12
	movq	%rdi, 8(%r13)				# scr_chest	%rdi
	movq	%rsi, 16(%r13)				# x_chest	%rsi
	movq	%rdx, 24(%r13)				# y_chest	%rdx
	movq	%rcx, 32(%r13)				# state chest	%rcx
	movq	%r8, 40(%r13)				# function of chest
	movq	%r9, 48(%r13)				# tier of the chest

	# Return the key ID
	movq	%r12, %rax

	popq	%r13
	popq	%r12
	movq	%rbp, %rsp
	popq	%rbp
	ret



# expects chest address in r13
chest_primes:
	# tier 1
	cmpq	$0, 48(%r13)
	jne	primes_tier_2

	addq	$11, player_money
	movq	$primes_found, %rdi
	movq	$11, %rsi
	call	log_push

	jmp	chest_primes_done

primes_tier_2:
	# tier 2
	cmpq	$1, 48(%r13)
	jne	primes_tier_3

	addq	$13, player_money
	movq	$primes_found, %rdi
	movq	$13, %rsi
	call	log_push

	jmp	chest_primes_done

primes_tier_3:
	# tier 3
	addq	$17, player_money
	movq	$primes_found, %rdi
	movq	$17, %rsi
	call	log_push

chest_primes_done:
	jmp	control_chest_return



# When you find health
chest_health:
	movq	$Health_found, %rdi
	call	log_push
	movq	player_max_health, %r10
	movq	%r10, player_health
	jmp	control_chest_return



# when you find a weapon
chest_weapon:
	# tier 1
	cmpq	$0, 48(%r13)
	jne	weapon_tier_2

	movq	$4, player_damage
	movq	$item_found, %rdi
	movq	$weapon_tiers_1, %rsi
	call	log_push

	jmp	chest_weapon_done

weapon_tier_2:
	# tier 2
	cmpq	$1, 48(%r13)
	jne	weapon_tier_3

	movq	$5, player_damage
	movq	$item_found, %rdi
	movq	$weapon_tiers_2, %rsi
	call	log_push

	jmp	chest_weapon_done

weapon_tier_3:
	# tier 3

	movq	$6, player_damage
	movq	$item_found, %rdi
	movq	$weapon_tiers_3, %rsi
	call	log_push

chest_weapon_done:
	jmp	control_chest_return



# when you find some armour
chest_armour:
	# tier 1
	cmpq	$0, 48(%r13)
	jne	armour_tier_2

	cmpq	$12, player_max_health
	jl	chest_armour_done
	movq	$12, player_max_health
	movq	$12, player_health
	movq	$item_found, %rdi
	movq	$armour_tiers_1, %rsi
	call	log_push

	jmp	chest_armour_done

armour_tier_2:
	# tier 2
	cmpq	$1, 48(%r13)
	jne	armour_tier_3

	cmpq	$14, player_max_health
	jl	chest_armour_done
	movq	$14, player_max_health
	movq	$14, player_health
	movq	$item_found, %rdi
	movq	$armour_tiers_2, %rsi
	call	log_push

	jmp	chest_armour_done

armour_tier_3:
	# tier 3
	cmpq	$16, player_max_health
	jl	chest_armour_done
	movq	$16, player_max_health
	movq	$16, player_health
	movq	$item_found, %rdi
	movq	$armour_tiers_3, %rsi
	call	log_push

chest_armour_done:
	jmp	control_chest_return
