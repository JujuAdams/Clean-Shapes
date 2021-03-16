precision highp float;

const float SMOOTHNESS = 1.41421356237;



//Shared
varying vec2  v_vOutputTexel;
varying vec2  v_vPosition;
varying float v_fMode;
varying vec4  v_vFillColour;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;
varying float v_fRounding;

//Circle
varying vec2  v_vCircleRadius;
varying vec2  v_vCircleCoord;
varying vec4  v_vCircleInnerColour;

//Rectangle
varying vec2  v_vRectangleXY;
varying float v_vRectangleAngle;
varying vec2  v_vRectangleWH;

//Line
varying vec2  v_vLineA;
varying vec2  v_vLineB;
varying vec2  v_vLineC;
varying float v_fLineThickness;

//Convex
varying vec3 v_vLine1;
varying vec3 v_vLine2;

//N-gon
varying vec3  v_vNgonXYR;
varying float v_fNgonSides;
varying float v_fNgonStarFactor;
varying float v_fNgonAngle;

//Segment
varying vec3  v_vSegmentXYR;
varying float v_vSegmentApertureCentre;
varying float v_vSegmentApertureSize;

//Ring
varying vec2  v_vRingCentre;
varying float v_fRingApertureCentre;
varying float v_fRingApertureSize;
varying float v_fRingInnerRadius;
varying float v_fRingOuterRadius;



float CircleDistance(vec2 p, vec2 ab)
{
    // symmetry
    p = abs( p );
    
    // determine in/out and initial omega value
    bool s = dot(p/ab,p/ab)>1.0;
    float w = s ? atan(p.y*ab.x, p.x*ab.y) : 
                  ((ab.x*(p.x-ab.x)<ab.y*(p.y-ab.y))? 1.5707963 : 0.0);
    
    // find root with Newton solver
    for( int i=0; i<4; i++ )
    {
        vec2 cs = vec2(cos(w),sin(w));
        vec2 u = ab*vec2( cs.x,cs.y);
        vec2 v = ab*vec2(-cs.y,cs.x);
        w = w + dot(p-u,v)/(dot(p-u,u)+dot(v,v));
    }
    
    // compute final point and distance
    return length(p-ab*vec2(cos(w),sin(w))) * (s?1.0:-1.0);
}

vec4 CircleDerivatives(vec2 coord, vec2 radius)
{
    //Emulates dFdx/dFdy
    return vec4(CircleDistance(coord - vec2(v_vOutputTexel.x, 0.0), radius),
                CircleDistance(coord - vec2(0.0, v_vOutputTexel.y), radius),
                CircleDistance(coord + vec2(v_vOutputTexel.x, 0.0), radius),
                CircleDistance(coord + vec2(0.0, v_vOutputTexel.y), radius));
}



float RectangleDistance(vec2 pos, vec2 rectCentre, vec2 rectSize, float angle, float radius)
{
    pos -= rectCentre;
    pos = mat2(cos(-angle), -sin(-angle), sin(-angle), cos(-angle)) * pos;
    
    vec2 vector = abs(pos) - 0.5*rectSize + radius;
    return length(max(vector, 0.0)) + min(max(vector.x, vector.y), 0.0) - radius;
}

vec4 RectangleDerivatives(vec2 pos, vec2 rectCentre, vec2 rectSize, float angle, float radius)
{
    //Emulates dFdx/dFdy
    return vec4(RectangleDistance(pos - vec2(v_vOutputTexel.x, 0.0), rectCentre, rectSize, angle, radius),
                RectangleDistance(pos - vec2(0.0, v_vOutputTexel.y), rectCentre, rectSize, angle, radius),
                RectangleDistance(pos + vec2(v_vOutputTexel.x, 0.0), rectCentre, rectSize, angle, radius),
                RectangleDistance(pos + vec2(0.0, v_vOutputTexel.y), rectCentre, rectSize, angle, radius));
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

vec4 LineNoCapDerivatives(vec2 pos, vec2 posA, vec2 posB, float thickness)
{
    //Emulates dFdx/dFdy
    return vec4(LineNoCapDistance(pos - vec2(v_vOutputTexel.x, 0.0), posA, posB, thickness),
                LineNoCapDistance(pos - vec2(0.0, v_vOutputTexel.y), posA, posB, thickness),
                LineNoCapDistance(pos + vec2(v_vOutputTexel.x, 0.0), posA, posB, thickness),
                LineNoCapDistance(pos + vec2(0.0, v_vOutputTexel.y), posA, posB, thickness));
}



float LineRoundCapDistance(vec2 position, vec2 posA, vec2 posB, float thickness)
{
    vec2 pos  = position - posA;
    vec2 para = normalize(posB - posA);
    
    return (length(pos - para*max(0.0, min(length(posB - posA), dot(pos, para)))) - 0.5*thickness);
}

vec4 LineRoundCapDerivatives(vec2 pos, vec2 posA, vec2 posB, float thickness)
{
    //Emulates dFdx/dFdy
    return vec4(LineRoundCapDistance(pos - vec2(v_vOutputTexel.x, 0.0), posA, posB, thickness),
                LineRoundCapDistance(pos - vec2(0.0, v_vOutputTexel.y), posA, posB, thickness),
                LineRoundCapDistance(pos + vec2(v_vOutputTexel.x, 0.0), posA, posB, thickness),
                LineRoundCapDistance(pos + vec2(0.0, v_vOutputTexel.y), posA, posB, thickness));
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

vec4 LineSquareCapDerivatives(vec2 pos, vec2 posA, vec2 posB, float thickness)
{
    //Emulates dFdx/dFdy
    return vec4(LineSquareCapDistance(pos - vec2(v_vOutputTexel.x, 0.0), posA, posB, thickness),
                LineSquareCapDistance(pos - vec2(0.0, v_vOutputTexel.y), posA, posB, thickness),
                LineSquareCapDistance(pos + vec2(v_vOutputTexel.x, 0.0), posA, posB, thickness),
                LineSquareCapDistance(pos + vec2(0.0, v_vOutputTexel.y), posA, posB, thickness));
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

vec4 ConvexDerivatives(vec2 pos, vec3 line1, vec3 line2, float rounding)
{
    //Emulates dFdx/dFdy
    return vec4(ConvexDistance(pos - vec2(v_vOutputTexel.x, 0.0), line1, line2, rounding),
                ConvexDistance(pos - vec2(0.0, v_vOutputTexel.y), line1, line2, rounding),
                ConvexDistance(pos + vec2(v_vOutputTexel.x, 0.0), line1, line2, rounding),
                ConvexDistance(pos + vec2(0.0, v_vOutputTexel.y), line1, line2, rounding));
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

vec4 PolylineMitreJoinDerivatives(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    //Emulates dFdx/dFdy
    return vec4(PolylineMitreJoinDistance(position - vec2(v_vOutputTexel.x, 0.0), posA, posB, posC, thickness),
                PolylineMitreJoinDistance(position - vec2(0.0, v_vOutputTexel.y), posA, posB, posC, thickness),
                PolylineMitreJoinDistance(position + vec2(v_vOutputTexel.x, 0.0), posA, posB, posC, thickness),
                PolylineMitreJoinDistance(position + vec2(0.0, v_vOutputTexel.y), posA, posB, posC, thickness));
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

vec4 PolylineBevelJoinDerivatives(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    //Emulates dFdx/dFdy
    return vec4(PolylineBevelJoinDistance(position - vec2(v_vOutputTexel.x, 0.0), posA, posB, posC, thickness),
                PolylineBevelJoinDistance(position - vec2(0.0, v_vOutputTexel.y), posA, posB, posC, thickness),
                PolylineBevelJoinDistance(position + vec2(v_vOutputTexel.x, 0.0), posA, posB, posC, thickness),
                PolylineBevelJoinDistance(position + vec2(0.0, v_vOutputTexel.y), posA, posB, posC, thickness));
}



float PolylineRoundJoinDistance(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    return min(LineRoundCapDistance(position, posA, posB, thickness), LineRoundCapDistance(position, posC, posB, thickness));
}

vec4 PolylineRoundJoinDerivatives(vec2 position, vec2 posA, vec2 posB, vec2 posC, float thickness)
{
    //Emulates dFdx/dFdy
    return vec4(PolylineRoundJoinDistance(position - vec2(v_vOutputTexel.x, 0.0), posA, posB, posC, thickness),
                PolylineRoundJoinDistance(position - vec2(0.0, v_vOutputTexel.y), posA, posB, posC, thickness),
                PolylineRoundJoinDistance(position + vec2(v_vOutputTexel.x, 0.0), posA, posB, posC, thickness),
                PolylineRoundJoinDistance(position + vec2(0.0, v_vOutputTexel.y), posA, posB, posC, thickness));
}



float NgonDistance(vec2 pos, vec2 ngonXY, float radius, float sides, float angleDivisor, float angle, float rounding)
{
    pos -= ngonXY;
    pos = mat2(cos(-angle), -sin(-angle), sin(-angle), cos(-angle)) * pos;
    
    radius -= rounding;
    
    // next 4 lines can be precomputed for a given shape
    float an = 3.141593/sides;
    float en = 3.141593/angleDivisor;  // m is between 2 and n
    vec2  acs = vec2(cos(an),sin(an));
    vec2  ecs = vec2(cos(en),sin(en)); // ecs=vec2(0,1) for regular polygon

    float bn = mod(atan(pos.x, pos.y), 2.0*an) - an;
    pos = length(pos)*vec2(cos(bn), abs(sin(bn)));
    pos -= radius*acs;
    pos += ecs*clamp(-dot(pos, ecs), 0.0, radius*acs.y/ecs.y);
    return length(pos)*sign(pos.x) - rounding;
}

vec4 NgonDerivatives(vec2 pos, vec2 ngonXY, float radius, float sides, float angleDivisor, float angle, float rounding)
{
    //Emulates dFdx/dFdy
    return vec4(NgonDistance(pos - vec2(v_vOutputTexel.x, 0.0), ngonXY, radius, sides, angleDivisor, angle, rounding),
                NgonDistance(pos - vec2(0.0, v_vOutputTexel.y), ngonXY, radius, sides, angleDivisor, angle, rounding),
                NgonDistance(pos + vec2(v_vOutputTexel.x, 0.0), ngonXY, radius, sides, angleDivisor, angle, rounding),
                NgonDistance(pos + vec2(0.0, v_vOutputTexel.y), ngonXY, radius, sides, angleDivisor, angle, rounding));
}



float SegmentDistance(vec2 pos, vec3 shapeXYR, float apertureCentre, float apertureSize, float rounding)
{
    pos -= shapeXYR.xy;
    pos = mat2(cos(-apertureCentre), -sin(-apertureCentre), sin(-apertureCentre), cos(-apertureCentre)) * pos;
    
    shapeXYR -= rounding;
    
    vec2 trigCoeffs = vec2(sin(apertureSize), cos(apertureSize));
    
    pos.x = abs(pos.x);
    float l = (length(pos) - shapeXYR.z);
    float m = length(pos - trigCoeffs*clamp(dot(pos, trigCoeffs), 0.0, shapeXYR.z)); // c=sin/cos of aperture
    
    return max(l, m*sign(trigCoeffs.y*pos.x - trigCoeffs.x*pos.y)) - rounding;
}

vec4 SegmentDerivatives(vec2 pos, vec3 shapeXYR, float apertureCentre, float apertureSize, float rounding)
{
    //Emulates dFdx/dFdy
    return vec4(SegmentDistance(pos - vec2(v_vOutputTexel.x, 0.0), shapeXYR, apertureCentre, apertureSize, rounding),
                SegmentDistance(pos - vec2(0.0, v_vOutputTexel.y), shapeXYR, apertureCentre, apertureSize, rounding),
                SegmentDistance(pos + vec2(v_vOutputTexel.x, 0.0), shapeXYR, apertureCentre, apertureSize, rounding),
                SegmentDistance(pos + vec2(0.0, v_vOutputTexel.y), shapeXYR, apertureCentre, apertureSize, rounding));
}



float RingDistance(vec2 position, vec2 centre, float apertureCentre, float apertureSize, float innerRadius, float outerRadius)
{
    float thickness = 0.5*(outerRadius - innerRadius);
    outerRadius -= thickness;
    
    vec2 sinCosA = vec2(sin(apertureCentre), cos(apertureCentre));
    vec2 sinCosB = vec2(sin(apertureSize),   cos(apertureSize)  );
    
    position -= centre;
    position *= mat2(sinCosA.x, sinCosA.y, -sinCosA.y, sinCosA.x);
    position.x = abs(position.x);
    
    float k = (sinCosB.y*position.x > sinCosB.x*position.y)? dot(position, sinCosB) : length(position);
    
    return sqrt(max(0.0, dot(position, position) + outerRadius*outerRadius - 2.0*outerRadius*k)) - thickness;
}

vec4 RingDerivatives(vec2 position, vec2 centre, float apertureCentre, float apertureSize, float innerRadius, float outerRadius)
{
    //Emulates dFdx/dFdy
    return vec4(RingDistance(position - vec2(v_vOutputTexel.x, 0.0), centre, apertureCentre, apertureSize, innerRadius, outerRadius),
                RingDistance(position - vec2(0.0, v_vOutputTexel.y), centre, apertureCentre, apertureSize, innerRadius, outerRadius),
                RingDistance(position + vec2(v_vOutputTexel.x, 0.0), centre, apertureCentre, apertureSize, innerRadius, outerRadius),
                RingDistance(position + vec2(0.0, v_vOutputTexel.y), centre, apertureCentre, apertureSize, innerRadius, outerRadius));
}



float GradientVec4(vec4 value)
{
    return 0.5*(abs(value.x) + abs(value.y) + abs(value.z) + abs(value.w));
}

float Feather(float dist, vec4 derivatives, float threshold)
{
    return smoothstep(threshold - SMOOTHNESS*GradientVec4(dist - derivatives), threshold, dist);
}



void main()
{
    float dist = 0.0;
    vec4  derivatives = vec4(0.0);
    
    if (v_fMode <= 0.0)
    {
        gl_FragColor = v_vFillColour;
    }
    else
    {
        if (v_fMode == 1.0) //Circle
        {
            dist        = CircleDistance(   v_vCircleCoord, v_vCircleRadius);
            derivatives = CircleDerivatives(v_vCircleCoord, v_vCircleRadius);
            
            vec4 fillColour = mix(v_vCircleInnerColour, v_vFillColour, length(v_vCircleCoord/v_vCircleRadius));
            gl_FragColor = mix(v_vBorderColour, fillColour, Feather(-dist, -derivatives, v_fBorderThickness));
        }
        if (v_fMode == 2.0) //Rectangle + Capsule
        {
            dist        = RectangleDistance(   v_vPosition, v_vRectangleXY, v_vRectangleWH, v_vRectangleAngle, v_fRounding);
            derivatives = RectangleDerivatives(v_vPosition, v_vRectangleXY, v_vRectangleWH, v_vRectangleAngle, v_fRounding);
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
        else if (v_fMode == 10.0) //N-gon
        {
            dist        = NgonDistance(   v_vPosition, v_vNgonXYR.xy, v_vNgonXYR.z, v_fNgonSides, v_fNgonStarFactor, v_fNgonAngle, v_fRounding);
            derivatives = NgonDerivatives(v_vPosition, v_vNgonXYR.xy, v_vNgonXYR.z, v_fNgonSides, v_fNgonStarFactor, v_fNgonAngle, v_fRounding);
            gl_FragColor = mix(v_vBorderColour, v_vFillColour, Feather(-dist, -derivatives, v_fBorderThickness));
        }
        else if (v_fMode == 11.0) //Segment
        {
            dist        = SegmentDistance(   v_vPosition, v_vSegmentXYR, v_vSegmentApertureCentre, v_vSegmentApertureSize, v_fRounding);
            derivatives = SegmentDerivatives(v_vPosition, v_vSegmentXYR, v_vSegmentApertureCentre, v_vSegmentApertureSize, v_fRounding);
            gl_FragColor = mix(v_vBorderColour, v_vFillColour, Feather(-dist, -derivatives, v_fBorderThickness));
        }
        else if (v_fMode == 12.0) //Ring
        {
            dist        = RingDistance(   v_vPosition, v_vRingCentre, v_fRingApertureCentre, v_fRingApertureSize, v_fRingInnerRadius, v_fRingOuterRadius);
            derivatives = RingDerivatives(v_vPosition, v_vRingCentre, v_fRingApertureCentre, v_fRingApertureSize, v_fRingInnerRadius, v_fRingOuterRadius);
            gl_FragColor = mix(v_vBorderColour, v_vFillColour, Feather(-dist, -derivatives, v_fBorderThickness));
        }
        
        gl_FragColor.a *= 1.0 - Feather(dist, derivatives, 0.0);
    }
}