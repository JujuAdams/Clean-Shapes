if (keyboard_check_pressed(ord("S")))
{
    surface_save(surface, "surface.png");
    show_debug_message(string(current_time) + "    Saved!");
}

if (keyboard_check(ord("1")))
{
    x1 = mouse_x;
    y1 = mouse_y;
}

if (keyboard_check(ord("2")))
{
    x2 = mouse_x;
    y2 = mouse_y;
}

if (keyboard_check(ord("3")))
{
    x3 = mouse_x;
    y3 = mouse_y;
}

if (keyboard_check(ord("4")))
{
    x4 = mouse_x;
    y4 = mouse_y;
}

if (keyboard_check(ord("5")))
{
    x5 = mouse_x;
    y5 = mouse_y;
}