var _seq_x = room_width * .44;
var _seq_y = room_height * .5;

var _sen_x = room_width * .40;
var _sen_y = room_height * .16;
var _responses_draw_start_y = room_height * .5;
var _line_padding = 80;


global.task_manager = new TaskManager("tasks.json", _sen_x, _sen_y, _responses_draw_start_y, _line_padding);
global.task_manager.select_new_tasks()

seq_id = layer_sequence_create("Assets", _seq_x, _seq_y, seq_task_pop_up);
layer_sequence_xscale(seq_id, 2.3);
layer_sequence_yscale(seq_id, 2.3);