varying vec2 v_vPosition;
varying vec4 v_vColour;

uniform vec2 u_vOutputScale;

void main()
{
    vec2 v_vOutputPos = v_vPosition*u_vOutputScale;
    
    if (mod(floor(v_vPosition.x), 2.0) == 0.0)
    {
        gl_FragColor = v_vColour;
    }
    else
    {
        gl_FragColor = vec4(1.0, 0.0, 0.0, v_vColour.a);
    }
}