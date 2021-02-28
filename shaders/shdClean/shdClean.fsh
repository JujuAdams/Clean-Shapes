//Shared
varying vec2  v_vPosition;
varying float v_fMode;
varying vec4  v_vFillColour;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;
varying float v_fRounding;

//Circle
varying vec3 v_vCircleXYR;

//Rectangle
varying vec2 v_vRectangleXY;
varying vec2 v_vRectangleWH;

//Convex
varying vec3 v_vLine1;
varying vec3 v_vLine2;

uniform float u_fSmoothness;
uniform vec2  u_vInvOutputScale;

float CircleDistance(vec2 pos, vec3 circleXYR)
{
    return length(pos - circleXYR.xy) - circleXYR.z;
}

vec2 CircleDerivatives(vec2 pos, vec3 circleXYR)
{
    //Emulates dFdx/dFdy
    return vec2(CircleDistance(pos + vec2(u_vInvOutputScale.x, 0.0), circleXYR),
                CircleDistance(pos + vec2(0.0, u_vInvOutputScale.y), circleXYR));
}

float RectangleDistance(vec2 pos, vec2 rectCentre, vec2 rectSize, float radius)
{
    return length(max(abs(pos - rectCentre) - rectSize + radius, 0.0)) - radius;
}

vec2 RectangleDerivatives(vec2 pos, vec2 rectCentre, vec2 rectSize, float radius)
{
    //Emulates dFdx/dFdy
    return vec2(RectangleDistance(pos + vec2(u_vInvOutputScale.x, 0.0), rectCentre, rectSize, radius),
                RectangleDistance(pos + vec2(0.0, u_vInvOutputScale.y), rectCentre, rectSize, radius));
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
    
    if (v_fMode == 1.0)
    {
        dist        = CircleDistance(   v_vPosition, v_vCircleXYR);
        derivatives = CircleDerivatives(v_vPosition, v_vCircleXYR);
    }
    else if (v_fMode == 2.0)
    {
        dist        = RectangleDistance(   v_vPosition, v_vRectangleXY, 0.5*v_vRectangleWH, v_fRounding);
        derivatives = RectangleDerivatives(v_vPosition, v_vRectangleXY, 0.5*v_vRectangleWH, v_fRounding);
    }
    
    gl_FragColor = v_vFillColour; //mix(v_vBorderColour, v_vFillColour, Feather(-dist, -derivatives, v_fBorderThickness));
    gl_FragColor.a *= 1.0 - Feather(dist, derivatives, 0.0);
}