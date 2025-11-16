function TaskManager(_json_filename, _x, _y, _responses_y, _y_sep) constructor {
	self.json_filename = _json_filename;
	
	core_tasks = [];
	side_tasks = [];
	
	selected_core_task = undefined; // The currently active core task struct
	selected_side_tasks = []; // Array of the 2 active side task structs
	
	self.current_task = undefined; // The task being shown (core or side)
	self.current_task_index = -1; // 0 = core, 1 = side1, 2 = side2
	self.hover_response_index = -1;
	
	self.draw_x = _x;
	self.draw_y = _y;
	self.draw_y_responses = _responses_y;
	self.y_sep = _y_sep;
	self.button_height = 100;
	self.button_padding = 60;
	
	// Text wrapping
	self.wrap_string = "mmmmmmmmmmmmmmmmmmmm";
	self.wrap_width = 0;
	self.line_height = 0;
	
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
		
		self.current_task_index = 0;
		self.current_task = self.selected_core_task;
		
		show_debug_message("TaskManager: New tasks selected.");
	}
	
	static show_next_task = function() {
		self.current_task_index++;
		
		if (self.current_task_index == 1) {
			self.current_task = array_length(self.selected_side_tasks) > 0 ? self.selected_side_tasks[0] : undefined;
		}
		else if (self.current_task_index == 2) {
			self.current_task = array_length(self.selected_side_tasks) > 1 ? self.selected_side_tasks[1] : undefined;
		}
		else {
			self.current_task = undefined;
			show_debug_message("TaskManager: All tasks completed.");
			// TODO: Either move on to the next set of tasks or display game/day end.
		}
	}
	
	static apply_effect = function(_effect_struct) {
		if (!variable_global_exists("timer_manager")) {
			show_debug_message("TaskManager Warning: global.timer_manager not found. Cannot apply stats.");
			return;
		}
		
		var _stat_manager = global.timer_manager;
		
		if (variable_struct_exists(_effect_struct, "energy")) {
			_stat_manager.energy += _effect_struct.energy;
			show_debug_message("Applied: " + string(_effect_struct.energy) + " energy.");
		}
		if (variable_struct_exists(_effect_struct, "intelligence")) {
			_stat_manager.intelligence += _effect_struct.intelligence;
			show_debug_message("Applied: " + string(_effect_struct.intelligence) + " intelligence.");
		}
		if (variable_struct_exists(_effect_struct, "social")) {
			_stat_manager.social += _effect_struct.social;
			show_debug_message("Applied: " + string(_effect_struct.social) + " social.");
		}
		
		_stat_manager.energy = clamp(_stat_manager.energy, 0, 100);
		_stat_manager.intelligence = clamp(_stat_manager.intelligence, 0, 100);
		_stat_manager.social = clamp(_stat_manager.social, 0, 100);
	}
	
	// This handles all button logic (hover/click) and MUST be called in a manager's step event
	static step_tasks = function() {
		if (self.current_task == undefined) {
			self.hover_response_index = -1;
			return; // No task = nothing to check
		}
		
		var _mx = device_mouse_x(0);
		var _my = device_mouse_y(0);
		
		self.hover_response_index = -1;
		
		var _button_y = self.draw_y_responses;
		
		var _responses = self.current_task.responses;
		for (var i = 0; i < array_length(_responses); i++) {
			var _btn_x1 = self.draw_x - (self.wrap_width / 2);
			var _btn_x2 = self.draw_x + (self.wrap_width / 2);
			var _btn_y1 = _button_y;
			var _btn_y2 = _button_y + self.button_height;
			
			if (point_in_rectangle(_mx, _my, _btn_x1, _btn_y1, _btn_x2, _btn_y2)) {
				self.hover_response_index = i;
				
				if (mouse_check_button_pressed(mb_left)) {
					var _effect = _responses[i].effect;
					self.apply_effect(_effect);
					self.show_next_task();
					
					self.hover_response_index = -1;
					break;
				}
			}
			
			_button_y += self.button_height + self.button_padding;
		}
	}
	
	static draw_tasks = function() {
		draw_set_font(fnt_righteous);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(#22454c);
		
		if (self.wrap_width == 0) {
			self.wrap_width = string_width(self.wrap_string);
			self.line_height = string_height("Test");
		}
		
		if (self.current_task == undefined) {
			draw_text_ext(self.draw_x, self.draw_y, "All tasks complete!", self.line_height, self.wrap_width);
			return;
		}
		
		var _text = self.current_task.scenario;
		draw_text_ext(self.draw_x, self.draw_y, _text, self.line_height, self.wrap_width);
		
		var _button_y = self.draw_y_responses;
		
		var _responses = self.current_task.responses;
		for (var i = 0; i < array_length(_responses); i++) {
			var _btn_text = _responses[i].text;
			
			var _bg_color = #ffffff;
			var _text_color = #22454c;
			
			if (self.hover_response_index == i) {
				_bg_color = #22454c;
				_text_color = #ffffff;
			}
			
			draw_set_color(_bg_color);
			draw_rectangle(
                self.draw_x - (self.wrap_width / 2),
                _button_y,
                self.draw_x + (self.wrap_width / 2),
                _button_y + self.button_height,
                false
            );
			
			draw_set_color(_text_color);
            draw_set_valign(fa_middle);
            draw_text(
                self.draw_x,
                _button_y + (self.button_height / 2),
                _btn_text
            );
			
			draw_set_valign(fa_top);
			_button_y += self.button_height + self.button_padding;
		}
			
	}
	
	// Initialization
	__load_tasks();
}