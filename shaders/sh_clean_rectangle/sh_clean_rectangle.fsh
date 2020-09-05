precision highp float;

//GM doesn't usually enable standard derivative functions, but we can force it on
#extension GL_OES_standard_derivatives : require

const float softness  = 2.0;
const float threshold = 0.0;

varying vec4  v_vColour;
varying float v_fRounding;
varying vec3  v_vBorderColour;
varying float v_fBorderThickness;
varying float v_fFlag1;
varying float v_fFlag2;
varying vec2  v_vTextureCoord;
varying float v_fAspect;

void main()
{
    gl_FragColor = v_vColour;
    
    vec2 delta = (abs(2.0*vec2(v_fFlag1, v_fFlag2) - 1.0) - vec2(1.0))*vec2(v_fAspect, 1.0) + v_fRounding;
    float dist = min(max(delta.x, delta.y), 0.0) + length(max(delta, 0.0)) - v_fRounding;
    
    //gl_FragColor.rgb = mix(gl_FragColor.rgb, v_vBorderColour, 1.0 - smoothstep(v_fBorderThickness - softness*fwidth(-dist), v_fBorderThickness, -dist));
    
    gl_FragColor.a *= 1.0 - smoothstep(threshold - softness*fwidth(dist), threshold, dist);
}