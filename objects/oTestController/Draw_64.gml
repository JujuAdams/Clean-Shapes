var _string = room_get_name(room);

CleanRectangle(0, 0, string_width(_string) + 20, 30)
.Blend(c_dkgray, 0.5)
.Draw();

draw_text(10, 4, _string);