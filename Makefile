objects =\
	build/game.o \
	build/curses.o \
	build/keyboard.o \
	build/state_manager.o \
	build/state_main_menu.o \
	build/state_game.o \
	build/data_player.o \
	build/data_mobs.o \
	build/data_levers.o \
	build/data_menu.o \
	build/data_actionlog.o \
	build/render_game_screen.o \
	build/render_game_screen_selector.o \
	build/render_game_gui.o \
	build/render_game_player.o \
	build/render_game_mobs.o \
	build/render_game_levers.o \
	build/render_mainmenu_screen.o \
	build/control_action.o \
	build/control_player.o \
	build/control_mainmenu.o \
	build/screen_mainmenu.o \
	build/screen_gui.o \
	build/screen_lvl_1.o \

.PHONY: all run game clean debug

all: clean game

run: clean game
	./game

game: $(objects)
	$(CC) -gstabs -o "$@" $^ -lncurses

build:
	mkdir build

build/%.o: %.s | build
	$(CC) -gstabs -c -o "$@" "$<"

clean:
	rm -rf game build

debug: clean game
	gdb -ex run ./game
