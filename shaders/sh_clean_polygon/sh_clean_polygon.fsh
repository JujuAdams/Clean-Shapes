//GM doesn't usually enable standard derivative functions, but we can force it on
#extension GL_OES_standard_derivatives : require

const float softness  = 2.0;
const float threshold = 1.0;

varying vec4  v_vColour;
varying vec2  v_vPosition;
varying vec3  v_vLine1;
varying vec3  v_vLine2;
varying float v_fRounding;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;

void main()
{
    gl_FragColor = v_vColour;
    
    float dist1 = v_vLine1.z - dot(v_vLine1.xy, v_vPosition) + v_fRounding;
    float dist2 = v_vLine2.z - dot(v_vLine2.xy, v_vPosition) + v_fRounding;
    
    float dist = min(max(dist1, dist2), 0.0) + length(max(vec2(dist1, dist2), 0.0)) - v_fRounding;
    
    gl_FragColor = mix(gl_FragColor, v_vBorderColour, 1.0 - smoothstep(v_fBorderThickness - softness*fwidth(-dist), v_fBorderThickness, -dist));
    
    gl_FragColor.a *= 1.0 - smoothstep(threshold - softness*fwidth(dist), threshold, dist);
}