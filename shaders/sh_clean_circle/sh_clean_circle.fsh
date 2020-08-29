varying vec4 v_vColour;
varying vec2 v_vTexcoord;

void main()
{
    if (length(v_vTexcoord - 0.5) <= 0.5) gl_FragColor = v_vColour;
}
