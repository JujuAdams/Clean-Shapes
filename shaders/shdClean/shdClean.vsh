                                //LINE:                CIRCLE:                       CONVEX:
attribute vec3 in_Position;     //XY, type             XY, type                      XY, type
attribute vec3 in_Normal;       //x1, y1, x2           Circle X, Y, radius           First boundary
attribute vec4 in_Colour1;      //Colour               Fill colour                   Fill colour
attribute vec3 in_Colour2;      //y2, x3, y3           Ring thickness, unused        Second boundary
attribute vec4 in_Colour3;      //Thickness, unused    Border colour                 Border colour
attribute vec2 in_TextureCoord; //Cap, join            Rounding, border thickness    Rounding, border thickness

//Shared
varying vec2  v_vPosition;
varying float v_fMode;
varying vec4  v_vFillColour;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;
varying float v_fRounding;

//Circle
varying vec3 v_vCircleXYR;

//Convex
varying vec3 v_vLine1;
varying vec3 v_vLine2;

void main()
{
    float flags = in_Position.z;
    float flag8 = 0.0;
    float flag4 = 0.0;
    float flag2 = 0.0;
    float flag1 = 0.0;
    if (flags >= 8.0) { flag4 = 1.0; flags -= 8.0; }
    if (flags >= 4.0) { flag4 = 1.0; flags -= 4.0; }
    if (flags >= 2.0) { flag2 = 1.0; flags -= 2.0; }
    if (flags >= 1.0) { flag1 = 1.0; flags -= 1.0; }
    
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*vec4(in_Position.xyz, 1.0);
    
    //Shared
    v_fMode            = flag1;
    v_vFillColour      = in_Colour1;
    v_vBorderColour    = in_Colour3;
    v_fBorderThickness = in_TextureCoord.y;
    
    //Circle
    v_vCircleXYR       = in_Normal;
    
    //Polygon
    v_vPosition        = in_Position.xy;
    v_vLine1           = in_Normal;
    v_vLine2           = in_Colour2;
    v_fRounding        = in_TextureCoord.x * tan(0.5*acos(dot(v_vLine1.xy, v_vLine2.xy)));
}