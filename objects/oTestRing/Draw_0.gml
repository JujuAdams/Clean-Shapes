CleanRing(70, 70, 40, 60, 30, -30).Draw();

CleanRing(70, 200, 40, 60, 30, -30).Blend(c_white, 0.5).Border(3, c_red, 0.5).Draw();
CleanRing(70, 200, 40, 60, 70, 230).Blend(c_white, 0.5).Border(3, c_lime, 0.5).Draw();

CleanRing(200, 200, 40, 60, 120, lerp(130, 420, 0.5 + 0.5*dsin(current_time/30))).Blend(c_gray, 1.0).Border(3, c_white, 1.0).Draw();