precision highp float;

//GM doesn't usually enable standard derivative functions, but we can force it on
#extension GL_OES_standard_derivatives : require

const float softness = 2.0;

varying vec4  v_vFillColour;
varying vec2  v_vSegment;
varying float v_fRingThickness;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;
varying vec2  v_vCornerID;

float distanceCircle(vec2 cornerIDs)
{
    return 2.0*length(cornerIDs - 0.5) - 1.0;
}

float feather(float dist, float threshold)
{
    return smoothstep(threshold - softness*fwidth(dist), threshold, dist);
}

void main()
{
    float dist = distanceCircle(v_vCornerID);
    gl_FragColor = mix(v_vBorderColour, v_vFillColour, feather(-dist, v_fBorderThickness));
    gl_FragColor.a *= 1.0 - feather(dist, 0.0);
}