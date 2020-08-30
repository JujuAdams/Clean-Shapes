attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec4 v_vColour;
varying vec2 v_vPosition;
varying vec3 v_vBoundary1;
varying vec3 v_vBoundary2;
varying vec3 v_vBoundary3;

void main()
{
    v_vBoundary1 = vec3(cos(in_Position.z), -sin(in_Position.z), in_Normal.z      );
    v_vBoundary2 = vec3(cos(in_Normal.x  ), -sin(in_Normal.x  ), in_TextureCoord.x);
    v_vBoundary3 = vec3(cos(in_Normal.y  ), -sin(in_Normal.y  ), in_TextureCoord.y);
    
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position.xyz, 1.0);
    v_vColour = in_Colour;
    v_vPosition = in_Position.xy;
}