//GM doesn't usually enable standard derivative functions, but we can force it on
#extension GL_OES_standard_derivatives : require

varying vec4 v_vColour;

void main()
{
    gl_FragColor = v_vColour;
}
