//Shapes can be drawn by themselves
CleanRectangle(20, 20, 610, 330)
.Blend4(c_white, 1.0, c_white, 0.5, c_white, 1.0, c_white, 0.5)
.Border4(10, c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0, c_white, 1.0)
.Rounding(10)
.Draw();



//If you're drawing lots of shapes, batching is way faster
CleanBatchBegin();

CleanPolyline([580, 50,   570, 130,   490, 70,   510, 150])
.Thickness(20)
.Blend(c_white, 1.0)
.Cap("round", "round")
.Join("round")
.Draw();

CleanLine(50, 50, 450, 50)
.Blend2(c_black, 1.0, c_white, 1.0)
.Thickness(30)
.Cap("round", "square")
.Draw();

CleanTriangle(50, 100,   150, 150,   60, 200)
.Blend3(c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0)
.Border(5, c_black, 1.0)
.Rounding(5)
.Draw();

// epic rotating gamer rgb triangle
var _x = 120, _y = 90, _len = 30, _dir = -current_time / 20;
var _x1 = _x + lengthdir_x(_len, _dir), _y1 = _y + lengthdir_y(_len, _dir);
var _x2 = _x + lengthdir_x(_len, _dir - 120), _y2 = _y + lengthdir_y(_len, _dir - 120);
var _x3 = _x + lengthdir_x(_len, _dir - 240), _y3 = _y + lengthdir_y(_len, _dir - 240);
CleanTriangle(_x1, _y1, _x2, _y2, _x3, _y3)
.Blend3(c_fuchsia, 0.5, c_aqua, 0.5, c_yellow, 0.5)
.Border3(5, c_fuchsia, 1.0, c_aqua, 1.0, c_yellow, 1.0)
.Rounding(0)
.Draw();

CleanConvex([160, 100,   250, 130,   260, 170,   170, 200])
.BlendExt([c_yellow, 1.0, c_aqua, 1.0, c_white, 1.0, c_fuchsia, 1.0])
.Border(5, c_black, 0.75)
.Rounding(15)
.Draw();

CleanConvex([270, 100,   360, 120,   370, 180,   280, 200])
.BlendExt([c_yellow, 1.0, c_aqua, 1.0, c_white, 1.0, c_fuchsia, 1.0])
.Border(5, c_black, 0.50)
.Rounding(25)
.Draw();

CleanConvex([380, 100,   470, 100,   480, 200,   390, 200])
.BlendExt([c_yellow, 1.0, c_aqua, 1.0, c_white, 1.0, c_fuchsia, 1.0])
.Border(5, c_black, 0.25)
.Rounding(30)
.Draw();

CleanCapsule(100, 220, 300, 270, true)
.Blend(c_white, 0.0)
.Border(10, c_black, 1.0)
.Rotate(20)
.Draw();

CleanCapsuleVertical(320, 220, 350, 310, true)
.Blend(c_black, 1.0)
.Border(10, c_white, 1.0)
.Draw();

CleanCircle(450, 260, 50)
.Blend(c_dkgray, 1.0)
.Border(10, 0xCBC0FF, 1.0)
.Draw();

CleanCircle(510, 260, 50)
.BlendRadial(c_white, 0.3, c_black, 1.0)
.Draw();

CleanBatchEndDraw();