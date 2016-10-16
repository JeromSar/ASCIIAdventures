objects = build/game.o build/screen_lvl_1.o build/keys.o build/game_screen.o build/game_player.o build/game_mobs.o build/screen_old.o build/screen_selector.o build/curses.o build/state_manager.o build/mobs.o build/state_main_menu.o build/state_game.o
.PHONY: clean debug

game: $(objects)
	$(CC) -g -o "$@" $^ -lncurses

build:
	mkdir build

build/%.o: %.s | build
	$(CC) -g -c -o "$@" "$<"

clean:
	rm -rf game build

debug:	clean game
	./game
