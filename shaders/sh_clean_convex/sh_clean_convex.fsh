precision highp float;

//GM doesn't usually enable standard derivative functions, but we can force it on
#extension GL_OES_standard_derivatives : require

const float softness = 2.0;

varying vec4  v_vFillColour;
varying vec2  v_vPosition;
varying vec3  v_vLine1;
varying vec3  v_vLine2;
varying float v_fRounding;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;

float distanceBoundingLines(vec2 position, vec3 line1, vec3 line2, float offset)
{
    vec2 delta = vec2(line1.z - dot(line1.xy, position),
                      line2.z - dot(line2.xy, position)) + offset;
    return min(max(delta.x, delta.y), 0.0) + length(max(delta, 0.0)) - offset;
}

float feather(float dist, float threshold)
{
    return smoothstep(threshold - softness*fwidth(dist), threshold, dist);
}

void main()
{
    float dist = distanceBoundingLines(v_vPosition, v_vLine1, v_vLine2, v_fRounding);
    gl_FragColor = mix(v_vBorderColour, v_vFillColour, feather(-dist, v_fBorderThickness));
    gl_FragColor.a *= 1.0 - feather(dist, 1.0);
}