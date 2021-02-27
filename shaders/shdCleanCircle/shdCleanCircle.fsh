//Shared
varying vec2  v_vPosition;
varying float v_fMode;
varying vec4  v_vFillColour;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;
varying float v_fRounding;

//Circle
varying vec3 v_vCircleData;

//Convex
varying vec3 v_vLine1;
varying vec3 v_vLine2;

uniform float u_fSmoothness;
uniform vec2  u_vInvOutputScale;

float CircleDistance(vec2 pos, vec3 circleData)
{
    return length(pos - circleData.xy) - circleData.z;
}

vec2 CircleDerivatives(vec2 pos, vec3 circleData)
{
    //Emulates dFdx/dFdy
    return vec2(CircleDistance(pos + vec2(u_vInvOutputScale.x, 0.0), circleData),
                CircleDistance(pos + vec2(0.0, u_vInvOutputScale.y), circleData));
}

float Feather(float dist, vec2 derivatives, float threshold)
{
    //Emulates fwidth
    float fw = abs(dist - derivatives.x) + abs(dist - derivatives.y);
    
    return smoothstep(threshold - u_fSmoothness*fw, threshold, dist);
}

void main()
{
    float dist = 0.0;
    vec2  derivatives = vec2(0.0);
    
    dist        = CircleDistance(   v_vPosition, v_vCircleData);
    derivatives = CircleDerivatives(v_vPosition, v_vCircleData);
    
    gl_FragColor = mix(v_vBorderColour, v_vFillColour, Feather(-dist, derivatives, v_fBorderThickness));
    gl_FragColor.a *= 1.0 - Feather(dist, derivatives, 0.0);
}