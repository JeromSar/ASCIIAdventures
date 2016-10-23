objects =\
	$(BUILD_DIR)/game.o \
	$(BUILD_DIR)/curses.o \
	$(BUILD_DIR)/keyboard.o \
	$(BUILD_DIR)/pathfinding.o \
	$(BUILD_DIR)/state/state_manager.o \
	$(BUILD_DIR)/state/state_game.o \
	$(BUILD_DIR)/state/state_mainmenu.o \
	$(BUILD_DIR)/state/state_gamemenu.o \
	$(BUILD_DIR)/state/state_gameover.o \
	$(BUILD_DIR)/data/data_player.o \
	$(BUILD_DIR)/data/data_screen.o \
	$(BUILD_DIR)/data/data_mobs.o \
	$(BUILD_DIR)/data/data_levers.o \
	$(BUILD_DIR)/data/data_mainmenu.o \
	$(BUILD_DIR)/data/data_gamemenu.o \
	$(BUILD_DIR)/data/data_actionlog.o \
	$(BUILD_DIR)/render/render_game_screen.o \
	$(BUILD_DIR)/render/render_game_screen_selector.o \
	$(BUILD_DIR)/render/render_game_gui.o \
	$(BUILD_DIR)/render/render_game_player.o \
	$(BUILD_DIR)/render/render_game_mobs.o \
	$(BUILD_DIR)/render/render_game_levers.o \
	$(BUILD_DIR)/render/render_mainmenu_screen.o \
	$(BUILD_DIR)/render/render_gamemenu_screen.o \
	$(BUILD_DIR)/render/render_gameover_screen.o \
	$(BUILD_DIR)/control/control_action.o \
	$(BUILD_DIR)/control/control_player.o \
	$(BUILD_DIR)/control/control_mobs.o \
	$(BUILD_DIR)/control/control_mainmenu.o \
	$(BUILD_DIR)/control/control_gamemenu.o \
	$(BUILD_DIR)/control/control_gameover.o \
	$(BUILD_DIR)/screen/screen_mainmenu.o \
	$(BUILD_DIR)/screen/screen_gamemenu.o \
	$(BUILD_DIR)/screen/screen_gameover.o \
	$(BUILD_DIR)/screen/screen_gui.o \
	$(BUILD_DIR)/screen/screen_lvl_1.o \

SRC_DIR = src
BUILD_DIR = build

.PHONY: all run game clean debug

define cc-command
$(CC) -gstabs -O0 -c -o "$@" "$<"
endef

vpath %.s $(SRC_DIR)
vpath %.s $(SRC_DIR)/control
vpath %.s $(SRC_DIR)/data
vpath %.s $(SRC_DIR)/render
vpath %.s $(SRC_DIR)/screen
vpath %.s $(SRC_DIR)/state


all: clean game

run: clean game
	./game

game: $(objects)
	$(CC) -gstabs -o "$@" $^ -lncurses

build:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/control
	mkdir -p $(BUILD_DIR)/data
	mkdir -p $(BUILD_DIR)/render
	mkdir -p $(BUILD_DIR)/screen
	mkdir -p $(BUILD_DIR)/state

$(BUILD_DIR)/%.o: %.s | build
	$(cc-command)

clean:
	rm -rf game build

debug: clean game
	gdb -ex run ./game
