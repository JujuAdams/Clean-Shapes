// List of rooms we wanna be able to browse through
rooms = [];
array_push(rooms, rmExample);
array_push(rooms, rmTestSpline);
array_push(rooms, rmTestSurface);
array_push(rooms, rmTestRectangle);
array_push(rooms, rmTestMatrix);
array_push(rooms, rmTestRing);
array_push(rooms, rmTestSegment);
array_push(rooms, rmTestLine);
array_push(rooms, rmTestCircle);
array_push(rooms, rmTestPug);
// array_push(rooms, rmTestClockwise); // This room would crash... on purpose ;)
array_push(rooms, rmTestPolyline);

// ID of current room in array
current_room_id = 0;