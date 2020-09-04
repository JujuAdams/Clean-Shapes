attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour1;
attribute vec3 in_Colour2;
attribute vec2 in_TextureCoord;

varying vec4 v_vColour;
varying vec2 v_vTexcoord;
varying vec2 v_vPosition;
varying vec3 v_vLine1;
varying vec3 v_vLine2;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position.xyz, 1.0);
    
    v_vPosition = in_Position.xy;
    v_vLine1    = in_Normal;
    v_vLine2    = in_Colour2;
    v_vColour   = in_Colour1;
    v_vTexcoord = in_TextureCoord;
}