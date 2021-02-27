precision highp float;
                                //LINE:            
attribute vec3 in_Position;     //XY, type         
attribute vec3 in_Normal;       //x1, y1, x2    
attribute vec4 in_Colour1;      //Colour           
attribute vec3 in_Colour2;      //y2. x3, y3   
attribute vec4 in_Colour3;      //Thickness
attribute vec2 in_TextureCoord; //Cap, join        

varying vec4  v_vFillColour;
varying vec2  v_vPosition;
varying vec2  v_vA;
varying vec2  v_vB;
varying vec2  v_vC;
varying float v_fThickness;

void main()
{
    vec2 posA = in_Normal.xy;
    vec2 posB = vec2(in_Normal.z, in_Colour2.x);
    vec2 posC = in_Colour2.yz;
    
    vec2 deltaAB = posB - posA;
    vec2 deltaBC = posC - posB;
    
    vec2 normal = vec2(0.0);
    if (in_TextureCoord.x == 1.0)
    {
        if (length(deltaAB) < 1.0)
        {
            normal = deltaBC;
        }
        else
        {
            normal = deltaAB;
        }
        
        normal = normalize(vec2(-normal.y, normal.x));
    }
    else if (in_TextureCoord.x == 3.0)
    {
        if (length(deltaBC) < 1.0)
        {
            normal = deltaAB;
        }
        else
        {
            normal = deltaBC;
        }
        
        normal = normalize(vec2(-normal.y, normal.x));
    }
    else
    {
        deltaAB = normalize(deltaAB);
        deltaBC = normalize(deltaBC);
        
        float ABcrossBC = deltaAB.x*deltaBC.y - deltaAB.y*deltaBC.x;
        float offset = 0.0;
        if (ABcrossBC != 0.0) offset = (dot(deltaAB, deltaBC) - 1.0) / ABcrossBC;
        
        normal = vec2(-deltaAB.y + offset*deltaAB.x, deltaAB.x + offset*deltaAB.y);
    }
    
    vec4 wsPos = vec4(in_Position.xyz, 1.0);
    wsPos.xy += in_Colour3.x*normal;
    
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*wsPos;
    
    v_vFillColour = in_Colour1;
    v_vPosition   = wsPos.xy;
    v_vA          = posA;
    v_vB          = posB;
    v_vC          = posC;
    v_fThickness  = abs(in_Colour3.x);
}