precision highp float;

//GM doesn't usually enable standard derivative functions, but we can force it on
#extension GL_OES_standard_derivatives : require

varying vec4  v_vFillColour;
varying vec2  v_vPosition;
varying vec2  v_vA;
varying vec2  v_vB;
varying vec2  v_vC;
varying float v_fThickness;

uniform float u_fSmoothness;

float distanceLine(vec2 position, vec2 posA, vec2 posB, float thickness)
{
    vec2 pos = position - posA;
    vec2 delta = normalize(posB - posA);
	return (length(pos - delta*min(length(posB - posA), dot(pos, delta))) - thickness);
}

float distancePolyline(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    return min(distanceLine(position, posA, posB, thickness), distanceLine(position, posC, posB, thickness));
}

float feather(float dist, float threshold)
{
    return smoothstep(threshold - u_fSmoothness*fwidth(dist), threshold, dist);
}

void main()
{
    gl_FragColor = v_vFillColour;
    
    float dist = distancePolyline(v_vPosition, v_vA, v_vB, v_vC, v_fThickness);
    gl_FragColor.a *= 1.0 - feather(dist, 0.0);
    //gl_FragColor = vec4(-dist/30.0, 0.0, 0.0, 1.0);
}
