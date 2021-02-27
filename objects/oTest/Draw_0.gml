//var _scale = TargetCurrentProjectionScale();
//
//shader_set(shdCleanCircle);
//shader_set_uniform_f(shader_get_uniform(shdCleanCircle, "u_fSmoothness"), CleanGetSmoothness());
//shader_set_uniform_f(shader_get_uniform(shdCleanCircle, "u_vInvOutputScale"), 1/_scale[0], 1/_scale[1]);
//draw_rectangle(0, 0, room_width, room_height, false);
//shader_reset();

CleanBatchStart();

//CleanLineStrip([200, 200,   x1, y1,   x2, y2,   600, 200])
//.Thickness(10)
//.Blend(c_yellow, 1.0)
//.Draw();

//CleanLine(x1, y1,   x2, y2)
//.Thickness(3)
//.Draw();

//CleanTriangle(400, 200,   400, 600,   200, 400)
//.Blend3(c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0)
//.Border(10, c_black, 1.0)
//.Rounding(30)
//.Draw();

//CleanConvex([400, 200,   650, 100,   650, 700,   400, 600])
//.BlendExt([c_yellow, 1.0, c_aqua, 1.0, c_white, 1.0, c_fuchsia, 1.0])
//.Border(10, c_black, 1.0)
//.Rounding(10)
//.Draw();

//CleanRectangle(650, 100,   850, 400)
//.Blend4(c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0, c_white, 1.0)
//.Border(10, c_black, 1.0)
//.Rounding(10)
//.Draw();

//CleanRectangle(650, 400,   850, 700)
//.Blend4(c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0, c_white, 1.0)
//.Border(10, c_black, 1.0)
//.Rounding(10)
//.Draw();

CleanCircle(360, 180, 60)
.Blend(c_yellow, 1.0)
.Border(5, c_red, 1.0)
.Draw();

CleanBatchEnd();