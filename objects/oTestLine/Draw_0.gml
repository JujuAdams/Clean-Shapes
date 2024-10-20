CleanLine(110, 60, 410, 60).Thickness(10).Draw();

gpu_set_blendmode(bm_add);
CleanLine(110, 90, 410, 90).Thickness(10).Blend(c_red,  0.5).Draw();
CleanLine(210, 90, 510, 90).Thickness(20).Blend(c_lime, 0.3).Draw();
gpu_set_blendmode(bm_normal);

CleanLine(110, 120, 410, 120).Thickness(10).Blend2(c_yellow, 1.0, c_fuchsia, 1.0).Draw();

CleanLine(110, 150, 410, 150).Thickness(10).Blend2(c_white, 0.0, c_white, 1.0).Draw();

CleanLine(110, 180, 410, 180).Thickness(10).Cap("none", "square").Draw();

CleanLine(110, 210, 410, 310)
.Thickness(20)
.Blend2(c_lime, 1.0, c_blue, 1.0)
.Cap("round", "square")
.Draw();