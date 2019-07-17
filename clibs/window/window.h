#ifndef ant_window_h
#define ant_window_h

#include <stdint.h>
#include <stddef.h>

#define ANT_WINDOW_UPDATE 0
#define ANT_WINDOW_INIT 1
#define ANT_WINDOW_EXIT 2
#define ANT_WINDOW_TOUCH 3
#define ANT_WINDOW_KEYBOARD 4
#define ANT_WINDOW_MOUSE 5
#define ANT_WINDOW_MOUSE_WHEEL 6
#define ANT_WINDOW_SIZE 7
#define ANT_WINDOW_CHAR 8
#define ANT_WINDOW_CHAR_UTF16 9

#define ANT_WINDOW_CALLBACK "ANT_WINDOW_CALLBACK"

struct ant_window_update {
	size_t dump;
};

struct ant_window_init {
	void* window;
	void* context;
	int   w;
	int   h;
};

struct ant_window_exit {
	size_t dump;
};

struct ant_window_touch {
	uintptr_t id;
	int x;
	int y;
	uint8_t state; // 1: down ; 2: move ; 3: up
};

typedef enum {
	KB_CTRL,
	KB_ALT,
	KB_SHIFT,
	KB_SYS,
	KB_CAPSLOCK,
}KEYBOARD_STATE;

struct ant_window_keyboard {
	int key;
	uint8_t state; // ctrl, alt, shift, in low 3 bits; left or right, in low 4 bit
	uint8_t press; // 0: up ; 1: down
};

struct ant_window_mouse_wheel {
	int x;
	int y;
	float delta;
};

struct ant_window_mouse {
	int x;
	int y;
	uint8_t type;  // 1: lbutton; 2: rbutton; 3: mbutton
	uint8_t state; // 1: down ; 2: move ; 3: up
};

struct ant_window_size {
	int x;
	int y;
	uint8_t type;	// 0: SIZE_RESTORED 1: SIZE_MINIMIZED 2: SIZE_MAXIMIZED
};

struct ant_window_char {
	int code;
};

struct ant_window_message {
	int type;
	union {
		struct ant_window_update update;
		struct ant_window_init init;
		struct ant_window_exit exit;
		struct ant_window_touch touch;
		struct ant_window_keyboard keyboard;
		struct ant_window_mouse mouse;
		struct ant_window_mouse_wheel mouse_wheel;
		struct ant_window_size size;
		struct ant_window_char unichar;
	} u;
};

struct ant_window_callback {
	void (*message)(void *ud, struct ant_window_message *);
	void *ud;
};

#endif
