if (!surface_exists(surface)) surface = surface_create(260, 260);

surface_set_target(surface);
draw_clear_alpha(c_black, 0.0);

gpu_set_blendmode(bm_add);

var _array = array_create(80, 0);
var _i = 0;
repeat(41)
{
    _array[@ _i  ] = merge_colour(c_fuchsia, c_yellow, _i/82);
    _array[@ _i+1] = 1.0;
    
    _i += 2;
}

CleanSpline([30, 30, 0, 300, 300, 0, 230, 230], 40).Blend(merge_colour(0xFFA687, 0xFFFFFF, 0.3), 1.0).BlendExt(_array).Thickness(30).Draw();
//CleanRectangle(30, 30, 230, 230).Blend4(c_white, 1.0, c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0).Border(10, merge_colour(0xFFA687, 0xFFFFFF, 0.3), 1.0).Rounding(10).Draw();
//CleanCapsule(30, 80, 230, 180, true).Blend4(c_white, 1.0, c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0).Border(10, merge_colour(0x9FEDFF, 0xFFFFFF, 0.3), 1.0).Draw();
//CleanCapsuleVertical(80, 30, 180, 230, true).Blend4(c_white, 1.0, c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0).Border(10, merge_colour(0xFFA687, 0xFFFFFF, 0.3), 1.0).Draw();
//CleanCircle(130, 130, 100).BlendRadial(merge_colour(0xFFA687, 0xE0E0FF, 0.60), 1.0, merge_colour(0xFFA687, 0xFFFFFF, 0.3), 1.0).Border(10, 0x9FEDFF, 1.0).Draw();
//CleanEllipse(130, 130, 100, 70).BlendRadial(merge_colour(0x9FEDFF, 0xE0E0FF, 0.60), 1.0, merge_colour(0x9FEDFF, 0xFFFFFF, 0.3), 1.0).Border(10, 0xFFA687, 1.0).Draw();
//CleanRing(130, 130, 50, 100, 45, 315).Blend(0x9FEDFF, 1.0).Border(10, merge_colour(0xFFA687, 0xFFFFFF, 0.30), 1.0).Draw();
//CleanTriangle(30, 30, 230, 60, 60, 230).Blend3(c_yellow, 1.0, c_fuchsia, 1.0, c_aqua, 1.0).Border(10, 0x9FEDFF, 1.0).Rounding(20).Draw();
//CleanConvex([30, 30, 230, 60, 210, 210, 60, 230]).BlendExt([c_yellow, 1.0, c_fuchsia, 1.0, c_aqua, 1.0, c_white, 1.0]).Border(10, merge_colour(0xFFA687, 0xFFFFFF, 0.3), 1.0).Rounding(20).Draw();

gpu_set_blendmode(bm_normal);
surface_reset_target();

draw_surface_ext(surface, 0, 0, 1, 1, 0, c_white, 1.0);