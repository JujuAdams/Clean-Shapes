                                //CIRCLE:                           SEGMENT:                           RECTANGLE:                    LINE:                CONVEX:                       POLYLINE:            N-GON
attribute vec3 in_Position;     //XY, type                          XY, type                           XY, type                      XY, type             XY, type                      XY, type             XY, type
attribute vec3 in_Normal;       //Circle XY, radius                 Circle XY, radius                  Rect XY, rotation             x1, y1, unused       First boundary                x1, y1, x3           Centre XY, radius
attribute vec4 in_Colour1;      //Outer fill RGBA                   Outer fill RGBA                    Fill colour                   Fill colour          Fill colour                   Fill colour          Fill RGBA
attribute vec3 in_Colour2;      //Inner fill RGB                    Wedge centre, wedge size, unused   Rect WH, unused               x2, y2, unused       Second boundary               x2. y2, y3           Sides, star factor, rotation
attribute vec4 in_Colour3;      //Border colour                     Border colour                      Border colour                 Unused               Border colour                 Unused               Border colour
attribute vec2 in_TextureCoord; //Inner fill A, border thickness    Unused, border thickness           Rounding, border thickness    Thickness, unused    Rounding, border thickness    Thickness, unused    Rounding, border thickness

//Shared
varying vec2  v_vOutputTexel;
varying vec2  v_vPosition;
varying float v_fMode;
varying vec4  v_vFillColour;
varying float v_fBorderThickness;
varying vec4  v_vBorderColour;
varying float v_fRounding;

//Circle
varying vec3 v_vCircleXYR;
varying vec4 v_vCircleInnerColour;

//Rectangle
varying vec2  v_vRectangleXY;
varying float v_vRectangleAngle;
varying vec2  v_vRectangleWH;

//Line + Polyline
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
varying float v_vSegmentAperatureCentre;
varying float v_vSegmentAperatureSize;

uniform vec2 u_vOutputSize;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*vec4(in_Position.xyz, 1.0);
    
    mat4 wvpMatrix = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION];
    v_vOutputTexel = 1.0 / vec2(length(vec3(wvpMatrix[0][0], wvpMatrix[0][1], wvpMatrix[0][2])),
                                length(vec3(wvpMatrix[1][0], wvpMatrix[1][1], wvpMatrix[1][2])));
    v_vOutputTexel /= 0.5*u_vOutputSize;
    
    //Shared
    v_vPosition        = in_Position.xy;
    v_fMode            = in_Position.z;
    v_vFillColour      = in_Colour1;
    v_vBorderColour    = in_Colour3;
    v_fRounding        = in_TextureCoord.x;
    v_fBorderThickness = in_TextureCoord.y;
    
    //Circle
    v_vCircleXYR         = in_Normal;
    v_vCircleInnerColour = vec4(in_Colour2, in_TextureCoord.x);
    
    //Rectangle
    v_vRectangleXY    = in_Normal.xy;
    v_vRectangleAngle = in_Normal.z;
    v_vRectangleWH    = in_Colour2.xy;
    
    //Line + Polyline
    v_vLineA         = in_Normal.xy;
    v_vLineB         = in_Colour2.xy;
    v_vLineC         = vec2(in_Normal.z, in_Colour2.z);
    v_fLineThickness = in_TextureCoord.x;
    
    //Polygon
    v_vLine1 = in_Normal;
    v_vLine2 = in_Colour2;
    
    //N-gon
    v_vNgonXYR        = in_Normal;
    v_fNgonSides      = in_Colour2.x;
    v_fNgonStarFactor = in_Colour2.y;
    v_fNgonAngle      = in_Colour2.z;
    
    //Segment
    v_vSegmentXYR             = in_Normal;
    v_vSegmentAperatureCentre = in_Colour2.x;
    v_vSegmentAperatureSize   = in_Colour2.y;
}