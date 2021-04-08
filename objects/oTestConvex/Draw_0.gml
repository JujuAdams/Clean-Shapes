CleanConvex([10, 10, 110, 10, 110, 110, 40, 80])
.Blend(c_white, 0.0)
.Border(10, c_white, 1.0)
.Rounding(10)
.Draw();

CleanConvex([120, 10, 220, 10, 220, 110, 150, 80])
.Blend(c_white, 0.0)
.BorderExt(10, [c_yellow, 1.0, c_fuchsia, 1.0, c_white, 1.0, c_aqua, 1.0])
.Rounding(10)
.Draw();

CleanConvex([10, 120, 110, 120, 110, 220, 40, 190])
.BlendExt([c_red, 1.0, c_lime, 1.0, c_blue, 1.0, c_white, 1.0])
.Rounding(10)
.Border(10, c_white, 1.0)
.Draw();

CleanConvex([120, 120, 220, 120, 220, 220, 150, 190])
.BlendExt([c_red, 1.0, c_lime, 1.0, c_blue, 1.0, c_white, 1.0])
.BorderExt(10, [c_yellow, 1.0, c_fuchsia, 1.0, c_white, 1.0, c_aqua, 1.0])
.Rounding(10)
.Draw();