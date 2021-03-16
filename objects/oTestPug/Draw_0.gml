CleanTransformReset()

// Head
var _x = room_width/2
var _y = room_height/2

var c_pugface = $94e2ff
var pug_w = 300
var pug_h = 200
var pug_d = 100 // this changes nothing

CleanTransformOriginSet(_x, _y)
CleanTransformAddScale(pug_w/pug_d, pug_h/pug_d)

CleanCircle(_x, _y, pug_d)
.Blend(c_pugface, 1)
.Draw()

CleanTransformReset()
CleanTransformOriginSet(_x, _y)

// Mouth
var c_mouth = $003754
var mouth_x = _x
var mouth_y = _y + 50
//var mouth_w = 160
//var mouth_h = 80
var mouth_r = 80

CleanTransformAddScale(2, 1)

CleanCircle(mouth_x, mouth_y, mouth_r)
.Blend(c_mouth, 1)
.Draw()

CleanTransformReset()
CleanTransformOriginSet(_x, _y)

// Nose
var c_nose = c_black
var nose_r = 40
var nose_x = _x
var nose_y = _y

CleanCircle(nose_x, nose_y, nose_r)
.Blend(c_nose, 1)
.Draw()


// Eyes
var c_eye1 = c_black
var c_eye2 = c_white
var eye_dx = 180
var eye_dy = -60
var eye_r1 = 35
var eye_r2 = 15

// left eye
CleanCircle(_x - eye_dx, _y + eye_dy, eye_r1)
.Blend(c_eye1, 1)
.Draw()

CleanCircle(_x - eye_dx, _y + eye_dy, eye_r2)
.Blend(c_eye2, 1)
.Draw()

// right eye
CleanCircle(_x + eye_dx, _y + eye_dy, eye_r1)
.Blend(c_eye1, 1)
.Draw()

CleanCircle(_x + eye_dx, _y + eye_dy, eye_r2)
.Blend(c_eye2, 1)
.Draw()


// Ears
var c_ear = $003754
var ear_dx = 200
var ear_dy = -150

// left ear
var x1 = _x - ear_dx
var y1 = _y + ear_dy

var dx1 = 80
var dy1 = -50
var x2 = x1 - dx1
var y2 = y1 + dy1

var dx2 = 150
var dy2 = 130
var x3 = x2 - dx2
var y3 = y2 + dy2

// the order is messed up because it's counter-clockwise
CleanTriangle(x1, y1, x3, y3, x2, y2)
.Blend(c_ear, 1)
.Draw()

// right ear
var x1 = _x + ear_dx
var x2 = x1 + dx1
var x3 = x2 + dx2

// the order is messed up because it's counter-clockwise
CleanTriangle(x3, y3, x1, y1, x2, y2)
.Blend(c_ear, 1)
.Draw()


// tongue
var c_tongue = $d3a6ff
var tongue_x = _x
var tongue_y = _y + 40
var tongue_w = 40
var tongue_h = 60
var tongue_d = 20 // this changes nothing

CleanTransformAddScale(tongue_w/tongue_d, tongue_h/tongue_d)

CleanCircle(tongue_x, tongue_y, tongue_d)
.Blend(c_tongue, 1)
.Draw()