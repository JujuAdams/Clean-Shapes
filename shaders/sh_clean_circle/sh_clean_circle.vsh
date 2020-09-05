precision highp float;
                                //LINE:                CIRCLE:                       CONVEX:
attribute vec3 in_Position;     //XY, type             XY, type                      XY, type
attribute vec3 in_Normal;       //x1, y1, x2           Segment start/end, unused     First boundary
attribute vec4 in_Colour1;      //Colour               Fill colour                   Fill colour
attribute vec3 in_Colour2;      //y2, x3, y3           Ring / Border thickness       Second boundary
attribute vec4 in_Colour3;      //Thickness, unused    Border colour                 Border colour
attribute vec2 in_TextureCoord; //Cap, join            Corner IDs, unused            Rounding, border thickness

varying vec4  v_vFillColour;
varying vec2  v_vSegment;
varying float v_fRingThickness;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;
varying vec2  v_vCornerID;

void main()
{
    float flags = in_Position.z;
    float flag1 = 0.0;
    float flag2 = 0.0;
    float flag4 = 0.0;
    if (flags >= 4.0) { flag4 = 1.0; flags -= 4.0; }
    if (flags >= 2.0) { flag2 = 1.0; flags -= 2.0; }
    if (flags >= 1.0) { flag1 = 1.0; flags -= 1.0; }
    
    vec4 wsPos  = gm_Matrices[MATRIX_WORLD]*vec4(in_Position.xyz, 1.0);
    gl_Position = gm_Matrices[MATRIX_PROJECTION]*gm_Matrices[MATRIX_VIEW]*wsPos;
    
    v_vFillColour      = in_Colour1;
    v_vSegment         = in_Normal.xy;
    v_fRingThickness   = in_Colour2.x;
    v_fBorderThickness = in_Colour2.y;
    v_vBorderColour    = in_Colour3;
    v_vCornerID        = vec2(flag2, flag4);
}