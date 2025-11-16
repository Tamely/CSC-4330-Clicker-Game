function TaskManager(_json_filename) constructor {
	self.json_filename = _json_filename;
	
	core_tasks = [];
	side_tasks = [];
	
	selected_core_task = undefined; // The currently active core task struct
	selected_side_tasks = []; // Array of the 2 active side task structs
	
	static __load_tasks = function() {
		show_debug_message("TaskManager: Loading tasks from " + self.json_filename);
		
		if (!file_exists(self.json_filename)) {
			show_error("TaskManager Error: JSON file not found: " + self.json_filename, true);
			return;
		}
		
		var _buffer = buffer_load(self.json_filename);
		var _json_string = buffer_read(_buffer, buffer_string);
		buffer_delete(_buffer);
		
		var _data = json_parse(_json_string);
		
		if (!is_struct(_data)) {
			show_error("TaskManager Error: Failed to parse JSON or root is not an object.", true);
			return;
		}
		
		if (variable_struct_exists(_data, "core_tasks") && is_array(_data.core_tasks)) {
			self.core_tasks = _data.core_tasks;
			show_debug_message("TaskManager: Loaded " + string(array_length(self.core_tasks)) + " core tasks.");
		}
		else {
			show_debug_message("TaskManager Warning: 'core_tasks' key not found or not an array in JSON.");
		}
		
		if (variable_struct_exists(_data, "side_tasks") && is_array(_data.side_tasks)) {
			self.side_tasks = _data.side_tasks;
			show_debug_message("TaskManager: Loaded " + string(array_length(self.side_tasks)) + " side tasks.");
		}
		else {
			show_debug_message("TaskManager Warning: 'side_tasks' key not found or not an array in JSON.");
		}
	}
	
	
	static select_new_tasks = function() {
		randomize();
		
		var _core_count = array_length(self.core_tasks);
		if (_core_count > 0) {
			var _core_index = irandom(_core_count - 1);
			self.selected_core_task = self.core_tasks[_core_index];
		}
		else {
			self.selected_core_task = undefined;
			show_debug_message("TaskManager Warning: No core tasks to select from.");
		}
		
		self.selected_side_tasks = [];
		var _side_count = array_length(self.side_tasks);
		
		if (_side_count == 0) {
			show_debug_message("TaskManager Warning: No side tasks to select from.");
		}
		else if (_side_count == 1) {
			array_push(self.selected_side_tasks, self.side_tasks[0]);
		}
		else {
			var _side_index_1 = irandom(_side_count - 1);
			var _side_index_2 = _side_index_1;
			
			// Keep picking a new index 2 until it's different from index 1
			while (_side_index_2 == _side_index_1) {
				_side_index_2 = irandom(_side_count - 1);
			}
			
			array_push(self.selected_side_tasks, self.side_tasks[_side_index_1]);
			array_push(self.selected_side_tasks, self.side_tasks[_side_index_2]);
		}
		
		show_debug_message("TaskManager: New tasks selected.");
	}
	
	static draw_tasks = function(_x, _y, _y_sep) {
		draw_set_font(fnt_righteous);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(#22454c);
		
		var _draw_y = _y;
		
		var _wrap_string = "mmmmmmmmmmmmmmmmmmmm";
        var _wrap_width = string_width(_wrap_string);
		
		var _line_height = string_height("Test");
		
		if (self.selected_core_task != undefined) {
			var _core_text = self.selected_core_task.scenario;
			draw_text_ext(_x, _draw_y, _core_text, _line_height, _wrap_width);
			
			var _core_text_height = string_height_ext(_core_text, _line_height, _wrap_width);
			_draw_y += _core_text_height + (_y_sep * 1.5);
		}
			
	}
	
	// Initialization
	__load_tasks();
}