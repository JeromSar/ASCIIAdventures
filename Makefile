objects = build/game.o build/keys.o build/screen.o build/curses.o build/state_manager.o build/state_main_menu.o build/state_game.o
.PHONY: clean debug

game: $(objects)
	$(CC) -g -o "$@" $^ -lmenu -lncurses

build:
	mkdir build

build/%.o: %.s | build
	$(CC) -g -c -o "$@" "$<"

clean:
	rm -rf game build

debug:	clean game
	./game
