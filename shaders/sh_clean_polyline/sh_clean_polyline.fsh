//GM doesn't usually enable standard derivative functions, but we can force it on
#extension GL_OES_standard_derivatives : require

const float softness  = 2.0;
const float threshold = 0.5;

varying vec4 v_vColour;
varying float v_fFlag1;
varying float v_fFlag2;
varying float v_fFlag4;

void main()
{
    gl_FragColor = v_vColour;
    
    if (v_fFlag4 == 1.0)
    {
        float dist = length(vec2(v_fFlag1 - 0.5, 0.5*v_fFlag2 - 0.5));
        gl_FragColor.a *= 1.0 - smoothstep(threshold - softness*fwidth(dist), threshold, dist);
    }
    else
    {
        float distX = v_fFlag1 - 0.5;
        float distY = 0.5*v_fFlag2 - 0.5;
        gl_FragColor.a *= 1.0 - smoothstep(threshold - softness*max(fwidth(distX), fwidth(distY)), threshold, max(abs(distX), abs(distY)));
    }
}
