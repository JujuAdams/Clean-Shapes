var _worldMatrix = matrix_get(matrix_world);
var _viewMatrix  = matrix_get(matrix_view);
var _projMatrix  = matrix_get(matrix_projection);

var _matrix = matrix_multiply(matrix_multiply(_worldMatrix, _viewMatrix), _projMatrix);

var _a = MatrixTransformVertex(_matrix, 0, 0, 0, 1);
var _b = MatrixTransformVertex(_matrix, mouse_x, mouse_y, 0, 1);
var _c = [_b[0] - _a[0], _b[1] - _a[1]];

draw_text(10, 10, Vec4ToString(_a));
draw_text(10, 30, Vec4ToString(_b));
draw_text(10, 50, Vec2ToString(Vec2ToScreen(_c)));
draw_text(10, 70, Vec2ToString([mouse_x, mouse_y]));










CleanSetSmoothness(1.5);

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

//CleanCircle(1000, 550, 150)
//.Blend(c_white, 1.0)
//.Border(5, c_black, 1.0)
//.Ring(100)
//.Segment(45, 135)
//.Draw();

CleanBatchEnd();