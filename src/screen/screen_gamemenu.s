.text
screen_gamemenu_count:		.quad	9
screen_gamemenu_line_length:	.quad 	35

.global screen_gamemenu_count
.global screen_gamemenu_line_length
.global screen_gamemenu

screen_gamemenu:
	.asciz "[]==============================[]"
	.asciz "||                              ||"
	.asciz "[]==============================[]"
	.asciz "||                              ||"
	.asciz "||                              ||"
	.asciz "||                              ||"
	.asciz "||                              ||"
	.asciz "||                              ||"
	.asciz "[]==============================[]"
