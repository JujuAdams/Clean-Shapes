if (!surface_exists(surface)) surface = surface_create(260, 260);

surface_set_target(surface);
draw_clear_alpha(c_black, 0.0);

gpu_set_blendmode(bm_add);

CleanRectangle(30, 30, 230, 230).Blend4(c_white, 1.0, c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0).Border(10, c_gray, 1.0).Rounding(20).Draw();

gpu_set_blendmode(bm_normal);
surface_reset_target();

draw_surface_ext(surface, 0, 0, 1, 1, 0, c_white, 1.0);