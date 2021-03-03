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

//Line
varying vec2  v_vLineA;
varying vec2  v_vLineB;
varying float v_fLineThickness;

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

float SquareLength(vec2 vector)
{
    return max(abs(vector.x), abs(vector.y));
}

float PointLength(vec2 vector)
{
    return abs(vector.x) + abs(vector.y);
}

float LineNoCapDistance( in vec2 p, in vec2 a, in vec2 b, float th )
{
    float l = length(b-a);
    vec2  d = (b-a)/l;
    vec2  q = (p-(a+b)*0.5);
          q = mat2(d.x,-d.y,d.y,d.x)*q;
          q = abs(q)-vec2(l,th)*0.5;
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0);    
}

vec2 LineNoCapDerivatives(vec2 pos, vec2 posA, vec2 posB, float thickness)
{
    //Emulates dFdx/dFdy
    return vec2(LineNoCapDistance(pos + vec2(u_vInvOutputScale.x, 0.0), posA, posB, thickness),
                LineNoCapDistance(pos + vec2(0.0, u_vInvOutputScale.y), posA, posB, thickness));
}

float LineRoundCapDistance(vec2 position, vec2 posA, vec2 posB, float thickness)
{
    vec2 pos  = position - posA;
    vec2 para = normalize(posB - posA);
    
    return (length(pos - para*max(0.0, min(length(posB - posA), dot(pos, para)))) - 0.5*thickness);
}

vec2 LineRoundCapDerivatives(vec2 pos, vec2 posA, vec2 posB, float thickness)
{
    //Emulates dFdx/dFdy
    return vec2(LineRoundCapDistance(pos + vec2(u_vInvOutputScale.x, 0.0), posA, posB, thickness),
                LineRoundCapDistance(pos + vec2(0.0, u_vInvOutputScale.y), posA, posB, thickness));
}

float LineSquareCapDistance( in vec2 p, in vec2 a, in vec2 b, float th )
{
    float l = th + length(b-a);
    vec2  d = (b-a)/(l - th);
    vec2  q = (p-(a+b)*0.5);
          q = mat2(d.x,-d.y,d.y,d.x)*q;
          q = abs(q)-vec2(l,th)*0.5;
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0);    
}

vec2 LineSquareCapDerivatives(vec2 pos, vec2 posA, vec2 posB, float thickness)
{
    //Emulates dFdx/dFdy
    return vec2(LineSquareCapDistance(pos + vec2(u_vInvOutputScale.x, 0.0), posA, posB, thickness),
                LineSquareCapDistance(pos + vec2(0.0, u_vInvOutputScale.y), posA, posB, thickness));
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
    
    if (v_fMode <= 0.0)
    {
        gl_FragColor = v_vFillColour;
    }
    else
    {
        if (v_fMode == 1.0) //Circle
        {
            dist        = CircleDistance(   v_vPosition, v_vCircleXYR);
            derivatives = CircleDerivatives(v_vPosition, v_vCircleXYR);
            gl_FragColor = mix(v_vBorderColour, v_vFillColour, Feather(-dist, -derivatives, v_fBorderThickness));
        }
        else if (v_fMode == 2.0) //Rectangle + Capsule
        {
            dist        = RectangleDistance(   v_vPosition, v_vRectangleXY, 0.5*v_vRectangleWH, v_fRounding);
            derivatives = RectangleDerivatives(v_vPosition, v_vRectangleXY, 0.5*v_vRectangleWH, v_fRounding);
            gl_FragColor = mix(v_vBorderColour, v_vFillColour, Feather(-dist, -derivatives, v_fBorderThickness));
        }
        else if (v_fMode == 3.0) //Line with no cap
        {
            dist        = LineNoCapDistance(   v_vPosition, v_vLineA, v_vLineB, v_fLineThickness);
            derivatives = LineNoCapDerivatives(v_vPosition, v_vLineA, v_vLineB, v_fLineThickness);
            gl_FragColor = v_vFillColour;
        }
        else if (v_fMode == 4.0) //Line with square cap
        {
            dist        = LineSquareCapDistance(   v_vPosition, v_vLineA, v_vLineB, v_fLineThickness);
            derivatives = LineSquareCapDerivatives(v_vPosition, v_vLineA, v_vLineB, v_fLineThickness);
            gl_FragColor = v_vFillColour;
        }
        else if (v_fMode == 5.0) //Line with round cap
        {
            dist        = LineRoundCapDistance(   v_vPosition, v_vLineA, v_vLineB, v_fLineThickness);
            derivatives = LineRoundCapDerivatives(v_vPosition, v_vLineA, v_vLineB, v_fLineThickness);
            gl_FragColor = v_vFillColour;
        }
        
        gl_FragColor.a *= 1.0 - Feather(dist, derivatives, 0.0);
    }
}