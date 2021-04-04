// Press arrows to navigate rooms
var _change = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
if _change != 0 {
	current_room_id += _change;
	if current_room_id >= array_length(rooms) current_room_id = 0;
	if current_room_id <= -1 current_room_id = array_length(rooms) - 1;
	room_goto(rooms[current_room_id]);
}