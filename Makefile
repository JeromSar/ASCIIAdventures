objects =\
	build/game.o \
	build/curses.o \
	build/keyboard.o \
	build/data_mobs.o \
	build/data_levers.o \
	build/state_manager.o \
	build/state_main_menu.o \
	build/state_game.o \
	build/game_screen.o \
	build/game_gui.o \
	build/game_player.o \
	build/game_mobs.o \
	build/game_levers.o \
	build/control_action.o \
	build/screen_selector.o \
	build/screen_main_menu.o \
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
