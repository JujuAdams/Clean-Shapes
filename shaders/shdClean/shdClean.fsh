precision highp float;

//GM doesn't usually enable standard derivative functions, but we can force it on
#extension GL_OES_standard_derivatives : require

//Shared
varying float v_fMode;
varying vec4  v_vFillColour;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;
varying float v_fRounding;

//Circle
varying float v_fRingThickness;
varying vec2  v_vSegment;
varying vec2  v_vCornerID;

//Convex
varying vec2  v_vPosition;
varying vec3  v_vLine1;
varying vec3  v_vLine2;

uniform float u_fSmoothness;

float distanceCircle(vec2 cornerIDs, float thickness, vec2 segment, float rounding)
{
    vec2 pos = 2.0*cornerIDs - 1.0;
    float len = length(pos);
    
    vec2 segmentDir = vec2(cos(segment.x), -sin(segment.x));
    float segmentAngle = acos(dot(pos/len, segmentDir)) - segment.y;
    
    vec3 delta = vec3(len*segmentAngle + rounding, len - 1.0 + rounding, -len - (thickness - 1.0) + rounding);
    return min(max(delta.x, max(delta.y, delta.z)), 0.0) + length(max(delta, 0.0)) - rounding;
}

float distanceBoundingLines(vec2 position, vec3 line1, vec3 line2, float rounding)
{
    vec2 delta = vec2(line1.z - dot(line1.xy, position),
                      line2.z - dot(line2.xy, position)) + rounding;
    return min(max(delta.x, delta.y), 0.0) + length(max(delta, 0.0)) - rounding;
}

float feather(float dist, float threshold)
{
    return smoothstep(threshold - u_fSmoothness*fwidth(dist), threshold, dist);
}

void main()
{
    float dist = 0.0;
    
    if (v_fMode == 1.0)
    {
        //Circle
        dist = distanceCircle(v_vCornerID, v_fRingThickness, v_vSegment, v_fRounding);
    }
    else
    {
        //Convex polygons
        dist = distanceBoundingLines(v_vPosition, v_vLine1, v_vLine2, v_fRounding);
    }
    
    gl_FragColor = vec4(dist, -dist, 0.0, 1.0);
    
    gl_FragColor = mix(v_vBorderColour, v_vFillColour, feather(-dist, v_fBorderThickness));
    gl_FragColor.a *= 1.0 - feather(dist, 0.0);
}