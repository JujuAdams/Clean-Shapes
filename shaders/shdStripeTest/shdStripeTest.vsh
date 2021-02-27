attribute vec3 in_Position;
attribute vec4 in_Colour;

varying vec2 v_vPosition;
varying vec4 v_vColour;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*vec4(in_Position.xyz, 1.0);
    
    v_vPosition = in_Position.xy;
    v_vColour = in_Colour;
}
