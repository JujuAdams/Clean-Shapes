attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour1;
attribute vec3 in_Colour2; //Second boundary
attribute vec4 in_Colour3; //Border colour
attribute vec2 in_TextureCoord; //Rounding, border thickness

varying vec4  v_vColour;
varying vec2  v_vPosition;
varying vec3  v_vLine1;
varying vec3  v_vLine2;
varying float v_fRounding;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position.xyz, 1.0);
    
    v_vPosition        = in_Position.xy;
    v_vLine1           = in_Normal;
    v_vLine2           = in_Colour2;
    v_vColour          = in_Colour1;
    v_fRounding        = in_TextureCoord.x * tan(0.5*acos(dot(v_vLine1.xy, v_vLine2.xy)));
    v_fBorderThickness = in_TextureCoord.y;
    v_vBorderColour    = in_Colour3;
}