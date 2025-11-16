/// @description Initialise Variables and Function

global.timer_manager = self;

// Our timer, used for keeping track of how long the user is taking.
timer = 0;

// Our stats trackers
intelligence = 50;
social = 50;
energy = 50;

// Our delay, used to add a delay between each carp lerping up to it's base at the top of the screen 
// during our auto solve. Adds to the satisfaction.
delay = 0;

// This is the actual delay, so every quarter of a second we 
delay_act = 0.25;

// Used to normalise our time gain.
last_second = get_timer()/1000000; 
