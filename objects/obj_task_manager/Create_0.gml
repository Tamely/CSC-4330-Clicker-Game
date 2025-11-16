global.task_manager = new TaskManager("tasks.json");
global.task_manager.select_new_tasks()

seq_x = room_width * .44;
seq_y = room_height * .5;

seq_id = layer_sequence_create("Assets", seq_x, seq_y, seq_task_pop_up);
layer_sequence_xscale(seq_id, 2.3);
layer_sequence_yscale(seq_id, 2.3);