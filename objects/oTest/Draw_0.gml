CleanRing(100, 100, 90, 100, 90, 45)
.Border(3, c_red, 1.0)
.Draw();

exit;



//Shapes can be drawn by themselves
CleanRectangle(20, 20, 610, 330)
.Blend4(c_white, 1.0, c_white, 0.5, c_white, 1.0, c_white, 0.5)
.Border(10, c_black, 1.0)
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