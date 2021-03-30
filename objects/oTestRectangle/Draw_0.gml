CleanRectangle(10, 10, 110, 110).Draw();

gpu_set_blendmode(bm_add);
CleanRectangle(10, 120, 110, 220).Blend(c_red,  0.5).Draw();
CleanRectangle(60, 120, 160, 220).Blend(c_lime, 0.5).Draw();
gpu_set_blendmode(bm_normal);

CleanRectangle(10, 230, 110, 330).Blend4(c_white, 1.0, c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0).Draw();

CleanRectangle(120, 10, 220, 110).Rotate(5).Draw();

CleanRectangle(120, 230, 220, 330).Border(5, c_red, 1.0).Draw();

CleanRectangleXYWH(350, 150, 100, 200)
.Rotate(current_time/20)
.Blend4(c_white, 0.5, c_yellow, 0.5, c_aqua, 0.5, c_fuchsia, 0.5)
.Border4(5, c_white, 1.0, c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0)
.Rounding(10).Draw();

CleanRectangle(230, 230, 330, 330).Border(5, c_blue, 1.0).Rounding(10).Draw();

CleanRectangle(340, 230, 440, 330).Border4(5, c_white, 1.0, c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0).Draw();