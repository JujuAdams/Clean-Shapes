precision highp float;

attribute vec3 in_Position;     //XY, unused
attribute vec3 in_Normal;       //First boundary
attribute vec4 in_Colour1;      //Fill colour
attribute vec3 in_Colour2;      //Second boundary
attribute vec4 in_Colour3;      //Border colour
attribute vec2 in_TextureCoord; //Rounding, border thickness

varying vec4  v_vFillColour;
varying vec2  v_vPosition;
varying vec3  v_vLine1;
varying vec3  v_vLine2;
varying float v_fRounding;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;

void main()
{
    vec4 wsPos  = gm_Matrices[MATRIX_WORLD]*vec4(in_Position.xyz, 1.0);
    gl_Position = gm_Matrices[MATRIX_PROJECTION]*gm_Matrices[MATRIX_VIEW]*wsPos;
    
    v_vPosition        = wsPos.xy;
    v_vLine1           = in_Normal;
    v_vLine2           = in_Colour2;
    v_vFillColour      = in_Colour1;
    v_fRounding        = in_TextureCoord.x * tan(0.5*acos(dot(v_vLine1.xy, v_vLine2.xy)));
    v_fBorderThickness = in_TextureCoord.y;
    v_vBorderColour    = in_Colour3;
}