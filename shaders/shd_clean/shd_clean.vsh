precision highp float;
                                //LINE:                CIRCLE:                     CONVEX:
attribute vec3 in_Position;     //XY, type             XY, type                    XY, type
attribute vec3 in_Normal;       //x1, y1, x2           Unused                      First boundary
attribute vec4 in_Colour1;      //Colour               Fill colour                 Fill colour
attribute vec3 in_Colour2;      //y2, x3, y3           Ring thickness, unused      Second boundary
attribute vec4 in_Colour3;      //Thickness, unused    Border colour               Border colour
attribute vec2 in_TextureCoord; //Cap, join            Unused, border thickness    Rounding, border thickness

//Shared
varying float v_fMode;
varying vec4  v_vFillColour;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;

//Circle
varying float v_fRingThickness;
varying vec2  v_vCornerID;

//Convex
varying vec2  v_vPosition;
varying vec3  v_vLine1;
varying vec3  v_vLine2;
varying float v_fRounding;

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
    
    vec4 wsPos  = gm_Matrices[MATRIX_WORLD]*vec4(in_Position.xyz, 1.0);
    gl_Position = gm_Matrices[MATRIX_PROJECTION]*gm_Matrices[MATRIX_VIEW]*wsPos;
    
    //Shared
    v_fMode            = flag1;
    v_vFillColour      = in_Colour1;
    v_vBorderColour    = in_Colour3;
    v_fBorderThickness = in_TextureCoord.y;
    
    //Circle
    v_fRingThickness   = in_Colour2.x;
    v_vCornerID        = vec2(flag2, flag4);
    
    //Polygon
    v_vPosition        = wsPos.xy;
    v_vLine1           = in_Normal;
    v_vLine2           = in_Colour2;
    v_fRounding        = in_TextureCoord.x * tan(0.5*acos(dot(v_vLine1.xy, v_vLine2.xy)));
}