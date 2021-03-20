CleanTriangle(150, 150,   50, 100,   60, 200)
.Blend3(c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0)
.Border(5, c_black, 1.0)
.Rounding(5)
.Draw();

CleanConvex([170, 200,   260, 170,   250, 130,   160, 100])
.BlendExt([c_yellow, 1.0, c_aqua, 1.0, c_white, 1.0, c_fuchsia, 1.0])
.Border(5, c_black, 0.75)
.Rounding(15)
.Draw();