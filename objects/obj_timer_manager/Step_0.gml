/// @description Update our timer.
var _timer = get_timer()/1000000 - last_second;
if _timer > 2
{
	last_second = get_timer()/1000000; 
	_timer = get_timer()/1000000 - last_second;
}
if !(global.pause)
{
	timer += _timer;
}

last_second = get_timer()/1000000; 

if (global.task_manager != undefined) {
	global.task_manager.step_tasks();
}