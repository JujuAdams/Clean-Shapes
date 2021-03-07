//var _scale = TargetCurrentProjectionScale();
//
//shader_set(shdCleanCircle);
//shader_set_uniform_f(shader_get_uniform(shdCleanCircle, "u_fSmoothness"), CleanGetSmoothness());
//shader_set_uniform_f(shader_get_uniform(shdCleanCircle, "u_vInvOutputScale"), 1/_scale[0], 1/_scale[1]);
//draw_rectangle(0, 0, room_width, room_height, false);
//shader_reset();

CleanBatchStart();

CleanPolyline([x1, y1,   x2, y2,   x3, y3,   x4, y4])
.Thickness(8)
.Blend(c_white, 0.5)
.Cap("round", "round")
.Join("round")
.Draw();

//CleanLine(x1, y1, x2, y2)
//.Blend(c_white, 1.0)
//.Thickness(30)
//.Cap("none", "square")
//.Draw();

//CleanLine(x3, y3,   x4, y4)
//.Blend(c_lime, 0.5)
//.Thickness(30)
//.Draw();

//CleanTriangle(x1, y1,   x2, y2,   x3, y3)
//.Blend3(c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0)
//.Border(5, c_black, 1.0)
//.Rounding(10)
//.Draw();
//
//CleanConvex([x1, y1,   x2, y2,   x3, y3,   x4, y4])
//.BlendExt([c_yellow, 1.0, c_aqua, 1.0, c_white, 1.0, c_fuchsia, 1.0])
//.Border(5, c_black, 1.0)
//.Rounding(5)
//.Draw();

//CleanCapsule(x1, y1, x2, y2, true)
//.Blend(0xCBC0FF, 1.0)
//.Border(10, c_white, 1.0)
//.Draw();

//CleanCapsuleVertical(x1, y1, x2, y2, false)
//.Blend(0xCBC0FF, 1.0)
//.Border(10, c_black, 1.0)
//.Draw();

//CleanRectangle(x1, y1, x2, y2)
//.Blend(0xCBC0FF, 1.0)
//.Border(10, c_white, 1.0)
//.Rounding(40)
//.Draw();
//
//CleanCircle(x3, y3, 80)
//.Blend(0xCBC0FF, 1.0)
//.Border(10, c_white, 1.0)
//.Draw();
//
//CleanCircle(x4, y4, 60)
//.Blend(0xCBC0FF, 1.0)
//.Border(10, c_white, 1.0)
//.Draw();

CleanBatchEnd();