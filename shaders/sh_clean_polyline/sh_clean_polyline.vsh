attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec4 v_vColour;
varying float v_fFlag1;
varying float v_fFlag2;
varying float v_fFlag4;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position.xyz, 1.0);
    v_vColour = in_Colour;
    
    float flags = in_Position.z;
    if (flags >= 4.0) { v_fFlag4 = 1.0; flags -= 4.0; }
    if (flags >= 2.0) { v_fFlag2 = 1.0; flags -= 2.0; }
    if (flags >= 1.0) { v_fFlag1 = 1.0; flags -= 1.0; }
}