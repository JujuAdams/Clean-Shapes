clean_batch_start();

clean_triangle(400, 200,   400, 600,   200, 400)
.blend3(c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0)
.border(10, c_black, 1.0)
.rounding(30)
.draw();

clean_convex([400, 200,   650, 100,   650, 700,   400, 600])
.blend_ext([c_yellow, 1.0, c_aqua, 1.0, c_white, 1.0, c_fuchsia, 1.0])
.border(10, c_black, 1.0)
.rounding(10)
.draw();

clean_rectangle(650, 100,   850, 400)
.blend4(c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0, c_white, 1.0)
.border(10, c_black, 1.0)
.rounding(10)
.draw();

clean_rectangle(650, 400,   850, 700)
.blend4(c_yellow, 1.0, c_aqua, 1.0, c_fuchsia, 1.0, c_white, 1.0)
.border(10, c_black, 1.0)
.rounding(10)
.draw();

clean_circle(1000, 550, 150)
.blend(c_white, 1.0)
.border(5, c_black, 1.0)
.ring(50)
.draw();

clean_batch_end();