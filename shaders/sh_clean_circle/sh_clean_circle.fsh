//GM doesn't usually enable standard derivative functions, but we can force it on
#extension GL_OES_standard_derivatives : require

const float softness = 1.5;

varying vec4 v_vColour;
varying vec2 v_vTexcoord;

void main()
{
    gl_FragColor = v_vColour;
    float dist = length(v_vTexcoord - 0.5);
    gl_FragColor.a *= 1.0 - smoothstep(0.5 - softness*fwidth(dist), 0.5, dist);
}