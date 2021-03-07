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
varying vec2  v_vLineC;
varying float v_fLineThickness;

//Convex
varying vec3 v_vLine1;
varying vec3 v_vLine2;

uniform vec2  u_vInvOutputScale;

const float SMOOTHNESS = 0.0;

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



float BoundaryDistance(vec2 position, vec2 norm, float distanceFromOrigin)
{
    return (distanceFromOrigin - dot(norm, position));
}

float ConvexDistance(vec2 position, vec3 boundary1, vec3 boundary2, float rounding)
{
    vec2 delta = vec2(BoundaryDistance(position, boundary1.xy, boundary1.z),
                      BoundaryDistance(position, boundary2.xy, boundary2.z)) + rounding;
    return min(max(delta.x, delta.y), 0.0) + length(max(delta, 0.0)) - rounding;
}

vec2 ConvexDerivatives(vec2 pos, vec3 line1, vec3 line2, float rounding)
{
    //Emulates dFdx/dFdy
    return vec2(ConvexDistance(pos + vec2(u_vInvOutputScale.x, 0.0), line1, line2, rounding),
                ConvexDistance(pos + vec2(0.0, u_vInvOutputScale.y), line1, line2, rounding));
}



float LineDistance(vec2 position, vec2 posA, vec2 posB)
{
    vec2 pos  = position - posA;
    vec2 para = normalize(posB - posA);
    
    return length(pos - para*dot(pos, para));
}

float PolylineMitreJoinDistance(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    float dist = min(LineDistance(position, posA, posB), LineDistance(position, posB, posC)) - 0.5*thickness;
    
    vec2 norm1 = normalize(posA - posB);
    vec2 norm2 = normalize(posB - posC);
    
    float crossSign = -sign(norm1.x*norm2.y - norm1.y*norm2.x);
    
    norm1 = crossSign*vec2(-norm1.y, norm1.x);
    float dot1 = dot(posB, norm1) - 0.5*thickness;
    
    norm2 = crossSign*vec2(-norm2.y, norm2.x);
    float dot2 = dot(posB, norm2) - 0.5*thickness;
    
    return max(dist, ConvexDistance(position, vec3(norm1, dot1), vec3(norm2, dot2), 0.0));
}

vec2 PolylineMitreJoinDerivatives(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    //Emulates dFdx/dFdy
    return vec2(PolylineMitreJoinDistance(position + vec2(u_vInvOutputScale.x, 0.0), posA, posB, posC, thickness),
                PolylineMitreJoinDistance(position + vec2(0.0, u_vInvOutputScale.y), posA, posB, posC, thickness));
}



float PolylineBevelJoinDistance(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    float mitreDist = PolylineMitreJoinDistance(position, posA, posB, posC, thickness);
    
    vec2 norm = normalize(posB - posA) + normalize(posB - posC);
    if (length(norm) < 0.0001) return mitreDist;
    norm = normalize(norm);
    
    vec2 point = thickness*norm + posB;
    float pointDot = dot(point, norm) - 0.5*thickness;
    
    return max(mitreDist, -BoundaryDistance(position, norm, pointDot));
}

vec2 PolylineBevelJoinDerivatives(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    //Emulates dFdx/dFdy
    return vec2(PolylineBevelJoinDistance(position + vec2(u_vInvOutputScale.x, 0.0), posA, posB, posC, thickness),
                PolylineBevelJoinDistance(position + vec2(0.0, u_vInvOutputScale.y), posA, posB, posC, thickness));
}



float PolylineRoundJoinDistance(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    return min(LineRoundCapDistance(position, posA, posB, thickness), LineRoundCapDistance(position, posC, posB, thickness));
}

vec2 PolylineRoundJoinDerivatives(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    //Emulates dFdx/dFdy
    return vec2(PolylineRoundJoinDistance(position + vec2(u_vInvOutputScale.x, 0.0), posA, posB, posC, thickness),
                PolylineRoundJoinDistance(position + vec2(0.0, u_vInvOutputScale.y), posA, posB, posC, thickness));
}



float Feather(float dist, vec2 derivatives, float threshold)
{
    //Emulates fwidth
    float fw = abs(dist - derivatives.x) + abs(dist - derivatives.y);
    
    return smoothstep(threshold - SMOOTHNESS*fw, threshold, dist);
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
        else if (v_fMode == 6.0) //Triangle + Convex
        {
            dist        = ConvexDistance(   v_vPosition, v_vLine1, v_vLine2, v_fRounding);
            derivatives = ConvexDerivatives(v_vPosition, v_vLine1, v_vLine2, v_fRounding);
            gl_FragColor = mix(v_vBorderColour, v_vFillColour, Feather(-dist, -derivatives, v_fBorderThickness));
        }
        else if (v_fMode == 7.0) //Polyline with mitre joint
        {
            dist        = PolylineMitreJoinDistance(   v_vPosition, v_vLineA, v_vLineB, v_vLineC, v_fLineThickness);
            derivatives = PolylineMitreJoinDerivatives(v_vPosition, v_vLineA, v_vLineB, v_vLineC, v_fLineThickness);
            gl_FragColor = v_vFillColour;
        }
        else if (v_fMode == 8.0) //Polyline with bevel joint
        {
            dist        = PolylineBevelJoinDistance(   v_vPosition, v_vLineA, v_vLineB, v_vLineC, v_fLineThickness);
            derivatives = PolylineBevelJoinDerivatives(v_vPosition, v_vLineA, v_vLineB, v_vLineC, v_fLineThickness);
            gl_FragColor = v_vFillColour;
        }
        else if (v_fMode == 9.0) //Polyline with round joint
        {
            dist        = PolylineRoundJoinDistance(   v_vPosition, v_vLineA, v_vLineB, v_vLineC, v_fLineThickness);
            derivatives = PolylineRoundJoinDerivatives(v_vPosition, v_vLineA, v_vLineB, v_vLineC, v_fLineThickness);
            gl_FragColor = v_vFillColour;
        }
        
        gl_FragColor.a *= 1.0 - Feather(dist, derivatives, 0.0);
    }
}