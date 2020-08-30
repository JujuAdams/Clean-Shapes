//GM doesn't usually enable standard derivative functions, but we can force it on
#extension GL_OES_standard_derivatives : require

const float softness  = 2.0;
const float threshold = 1.0;

varying vec4 v_vColour;
varying vec2 v_vPosition;
varying vec3 v_vBoundary1;
varying vec3 v_vBoundary2;
varying vec3 v_vBoundary3;

void main()
{
    gl_FragColor = v_vColour;
    
    float dist1 = dot(v_vPosition, v_vBoundary1.xy) - v_vBoundary1.z + 40.0;
    float dist2 = dot(v_vPosition, v_vBoundary2.xy) - v_vBoundary2.z + 40.0;
    float dist3 = dot(v_vPosition, v_vBoundary3.xy) - v_vBoundary3.z + 40.0;
    
    //float dist = max(dist1, max(dist2, dist3));
    //gl_FragColor = vec4(dist, 0.1, 0.1, 1.0);
    
    float dist = min(max(dist1, max(dist2, dist3)), 0.0) + length(max(vec3(dist1, dist2, dist3), 0.0)) - 40.0;
    gl_FragColor.a *= 1.0 - smoothstep(threshold - softness*fwidth(dist), threshold, dist);
    
    
    
    
    //float dist1 = 1.0 + 0.01*(dot(v_vPosition, vec2(0.707, -0.707))) + 0.2;
    //float dist2 = 1.0 + 0.01*(dot(v_vPosition, vec2(0.000,  1.000)) - 500.0) + 0.2;
    ////float dist = max(dist1, dist2);
    //
    //float dist = min(max(dist1, dist2), 0.0) + length(max(vec2(dist1, dist2), 0.0)) - 0.2;
    //
    //gl_FragColor.a *= 1.0 - smoothstep(threshold - softness*fwidth(dist), threshold, dist);
    ////gl_FragColor = vec4(-dist1/100.0, -dist2/100.0, 0.0, 1.0);
}