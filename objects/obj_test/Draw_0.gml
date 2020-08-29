clean_convex([10, 10,   400, 10,   400, 400,   10, 400])
.blend_ext([c_red, 1.0, c_lime, 1.0, c_blue, 1.0, c_yellow, 1.0])
.draw();

gpu_set_blendmode(bm_add);
clean_circle(room_width/2 - 40, room_height/2     , 100).blend(c_red , 1.0).draw();
clean_circle(room_width/2     , room_height/2 - 56, 100).blend(c_lime, 1.0).draw();
clean_circle(room_width/2 + 40, room_height/2     , 100).blend(c_blue, 1.0).draw();
gpu_set_blendmode(bm_normal);