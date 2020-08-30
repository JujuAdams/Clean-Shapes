attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec4  v_vColour;
varying float v_fRounding;
varying vec3  v_vBorderColour;
varying float v_fBorderThickness;
varying float v_fFlag1;
varying float v_fFlag2;
varying vec2  v_vTextureCoord;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position.xyz, 1.0);
    v_vColour = in_Colour;
    
    //Uncompress the colour of the border
    vec3 borderColour = vec3(0.0);
    float working = in_Normal.y;
    borderColour.b = floor(working / 32768.0);
    working -= borderColour.b*32768.0;
    borderColour.g = floor(working / 256.0);
    working -= borderColour.g*256.0;
    borderColour.r = working;
    borderColour /= vec3(255.0, 127.0, 127.0);
    
    v_vBorderColour = borderColour;
    v_fBorderThickness = in_Normal.z;
    v_vTextureCoord = in_TextureCoord;
    v_fRounding = in_Normal.x;
    
    float flags = in_Position.z;
    if (flags >= 2.0) { v_fFlag2 = 1.0; flags -= 2.0; }
    if (flags >= 1.0) { v_fFlag1 = 1.0; flags -= 1.0; }
}