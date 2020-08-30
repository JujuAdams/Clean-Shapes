//clean_rectangle(100, 100, 200, 200)
//.draw();
//
//clean_rectangle(201, 100, 300, 200)
//.draw();

//clean_convex([200, 200,   500, 500,   200, 500,  100, 350])
//.draw();

clean_convex([200, 200,   mouse_x, mouse_y,   200, 500])
.blend_ext([c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0])
.draw();