//Press arrows to navigate rooms

if (keyboard_check_pressed(vk_left))
{
    if (room_previous(room) >= 0)
    {
        room_goto(room_previous(room));
    }
    else
    {
        room_goto(room_last);
    }
}

if (keyboard_check_pressed(vk_right))
{
    if (room_next(room) >= 0)
    {
        room_goto(room_next(room));
    }
    else
    {
        room_goto(room_first);
    }
}