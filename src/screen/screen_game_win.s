.text

lvl_1_win:
	.ascii "********************************************************************************"
	.ascii "*                                                                              *"
	.ascii "*     #     #    ######    #     #           #       #####    #######          *"
	.ascii "*      #   #    #      #   #     #          # #     #     #   #                *"
	.ascii "*       # #     #      #   #     #         #   #    #         #######          *"
	.ascii "*        #      #      #   #     #        #######   #         #                *"
	.ascii "*        #       ######     #####         #     #   #         #######          *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*            #       #       #   #   #    #   #    #   #####    #####          *"
	.ascii "*             #     # #     #    #   ##   #   ##   #   #       #     #         *"
	.ascii "*              #   #   #   #     #   # #  #   # #  #   #####   #               *"
	.ascii "*               # #     # #      #   #  # #   #  # #   #       #               *"
	.ascii "*                #       #       #   #   ##   #   ##   #####   #               *"
	.ascii "*                                                                              *"
	.ascii "*                           (to be continued....)                              *"
	.ascii "*                      (probably, maybe, soon... (tm))                         *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "********************************************************************************"
	.asciz ""


lvl_1_game:
	.ascii "********************************************************************************"
	.ascii "*                                                                              *"
	.ascii "*                                   ########                                   *"
	.ascii "*                                 ############                                 *"
	.ascii "*                                ##   ####   ##                                *"
	.ascii "*                                ## *  ##  * ##                                *"
	.ascii "*                                 #   ####   #                                 *"
	.ascii "*                                 ############                                 *"
	.ascii "*                                  ##########                                  *"
	.ascii "*                                     ####                                     *"
	.ascii "*  #####      #     ##   ## #####  ##      ##   ###   #     #  #####   #####   *"
	.ascii "* #     #    # #    # # # # #      ##########  #   #   #   #   #      #     #  *"
	.ascii "* #         #   #   #  #  # #####   ########   #   #   #   #   #####  #        *"
	.ascii "* #   ###  #######  #     # #                  #   #    # #    #      #        *"
	.ascii "*  #####   #     #  #     # #####               ###      #     #####  #        *"
	.ascii "*                                                                              *"
	.ascii "*                         (press the enter key to exit)                        *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "********************************************************************************"
	.asciz ""


lvl_1_over:
	.ascii "********************************************************************************"
	.ascii "*                                                                              *"
	.ascii "*                                   ########                                   *"
	.ascii "*                                 ############                                 *"
	.ascii "*                                ##   ####   ##                                *"
	.ascii "*                                ## *  ##  * ##                                *"
	.ascii "*                                 #   ####   #                                 *"
	.ascii "*                                 ############                                 *"
	.ascii "*                                  ##########                                  *"
	.ascii "*                                  ## #### ##                                  *"
	.ascii "*  #####      #     ##   ## #####  ##########   ###   #     #  #####   #####   *"
	.ascii "* #     #    # #    # # # # #       ########   #   #   #   #   #      #     #  *"
	.ascii "* #         #   #   #  #  # #####              #   #   #   #   #####  #        *"
	.ascii "* #   ###  #######  #     # #                  #   #    # #    #      #        *"
	.ascii "*  #####   #     #  #     # #####               ###      #     #####  #        *"
	.ascii "*                                                                              *"
	.ascii "*                         (press the ENTER key to exit)                        *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "*                                                                              *"
	.ascii "********************************************************************************"
	.asciz ""

.global	lvl_1_win
.global	lvl_1_game
.global	lvl_1_over
