/// @param pointArray

function CleanPolyline(_array)
{
    var _struct = new __CleanClassPolyline(_array);
    if (is_array(global.__cleanBatch)) array_push(global.__cleanBatch, _struct);
    return _struct;
}

function __CleanClassPolyline(_array) constructor
{
    __shader = __shdClean;
    __format = global.__cleanVertexFormat;
    
    __pointArray = _array;
    __colour     = CLEAN_DEFAULT_POLYLINE_COLOUR;
    __alpha      = CLEAN_DEFAULT_POLYLINE_ALPHA;
    
    __thickness = CLEAN_DEFAULT_POLYLINE_THICKNESS;
    
    __join     = CLEAN_DEFAULT_POLYLINE_JOIN;
    __capStart = CLEAN_DEFAULT_POLYLINE_START_CAP;
    __capEnd   = CLEAN_DEFAULT_POLYLINE_END_CAP;
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colour = _colour;
        __alpha  = _alpha;
        
        return self;
    }
    
    static Thickness = function(_thickness)
    {
        __thickness = _thickness;
        
        return self;
    }
    
    /// @param startType
    /// @param endType
    static Cap = function(_cap_start, _cap_end)
    {
        __capStart = _cap_start;
        __capEnd   = _cap_end;
        
        return self;
    }
    
    static Draw = function()
    {
        __CleanDraw();
        return undefined;
    }
    
    /// @param vertexBuffer
    static Build = function(_vbuff)
    {
        var _colour     = __colour;
        var _alpha      = __alpha;
        var _thickness  = __thickness;
        var _pointArray = __pointArray;
        
        var _join = 9; //Default to rounded joints
        if (__join == "miter") _join = 7;
        if (__join == "mitre") _join = 7;
        if (__join == "bevel") _join = 8;
        
        var _ix1 = undefined;
        var _iy1 = undefined;
        var _ix2 = _pointArray[0];
        var _iy2 = _pointArray[1];
        var _ix3 = _pointArray[2];
        var _iy3 = _pointArray[3];
        
        //Calculate the size of the cap
        var _dx1 = undefined;
        var _dy1 = undefined;
        var _dx2 = _ix3 - _ix2;
        var _dy2 = _iy3 - _iy2;
        var _d = 0.5 * _thickness / sqrt(_dx2*_dx2 + _dy2*_dy2);
        _dx2 *= _d;
        _dy2 *= _d;
        
        var _x1 = undefined;
        var _y1 = undefined;
        var _x2 = undefined;
        var _y2 = undefined;
        var _x3 = _ix2 - _dx2 - _dy2;
        var _y3 = _iy2 - _dy2 + _dx2;
        var _x4 = _ix2 - _dx2 + _dy2;
        var _y4 = _iy2 - _dy2 - _dx2;
        var _x5 = 0.5*(_ix2 + _ix3) - _dy2;
        var _y5 = 0.5*(_iy2 + _iy3) + _dx2;
        var _x6 = 0.5*(_ix2 + _ix3) + _dy2;
        var _y6 = 0.5*(_iy2 + _iy3) - _dx2;
        
        var _cap = 5; //Default to rounded lines
        if (__capStart == "none"  ) _cap = 3;
        if (__capStart == "square") _cap = 4;
        
        vertex_position_3d(_vbuff, _x3, _y3, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x5, _y5, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x6, _y6, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        
        vertex_position_3d(_vbuff, _x3, _y3, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x6, _y6, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x4, _y4, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        
        
        
        
        //Points along the line
        var _i = 4;
        repeat((array_length(_pointArray) div 2) - 2)
        {
            _ix1 = _ix2;
            _iy1 = _iy2;
            _ix2 = _ix3;
            _iy2 = _iy3;
            _ix3 = _pointArray[_i  ];
            _iy3 = _pointArray[_i+1];
            
            _dx1 = _dx2;
            _dy1 = _dy2;
            _dx2 = _ix3 - _ix2;
            _dy2 = _iy3 - _iy2;
            _d = 0.5 * _thickness / sqrt(_dx2*_dx2 + _dy2*_dy2);
            _dx2 *= _d;
            _dy2 *= _d;
            
            //deltaAB = normalize(deltaAB);
            //deltaBC = normalize(deltaBC);
            //
            //float ABcrossBC = deltaAB.x*deltaBC.y - deltaAB.y*deltaBC.x;
            //float offset = 0.0;
            //if (ABcrossBC != 0.0) offset = (dot(deltaAB, deltaBC) - 1.0) / ABcrossBC;
            //
            //normal = vec2(-deltaAB.y + offset*deltaAB.x, deltaAB.x + offset*deltaAB.y);
            
            _x1 = _x5;
            _y1 = _y5;
            _x2 = _x6;
            _y2 = _y6;
            _x3 = _ix2 - _dy1;
            _y3 = _iy2 + _dx1;
            _x4 = _ix2 + _dy1;
            _y4 = _iy2 - _dx1;
            _x5 = 0.5*(_ix2 + _ix3) - _dy2;
            _y5 = 0.5*(_iy2 + _iy3) + _dx2;
            _x6 = 0.5*(_ix2 + _ix3) + _dy2;
            _y6 = 0.5*(_iy2 + _iy3) - _dx2;
            
            //AB midpoint to B
            vertex_position_3d(_vbuff, _x1, _y1, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x3, _y3, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x4, _y4, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            
            vertex_position_3d(_vbuff, _x1, _y1, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x4, _y4, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x2, _y2, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            
            _x3 = _ix2 - _dy2;
            _y3 = _iy2 + _dx2;
            _x4 = _ix2 + _dy2;
            _y4 = _iy2 - _dx2;
            
            //B to BC midpoint
            vertex_position_3d(_vbuff, _x3, _y3, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x5, _y5, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x6, _y6, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                                                         
            vertex_position_3d(_vbuff, _x3, _y3, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x6, _y6, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            vertex_position_3d(_vbuff, _x4, _y4, _join); vertex_normal(_vbuff, _ix1, _iy1, _ix3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix2, _iy2, _iy3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            
            _i += 2;
        }
        
        
        
        
        //Calculate the size of the cap
        var _dx = _ix3 - _ix2;
        var _dy = _iy3 - _iy2;
        var _d  = 0.5 * _thickness / sqrt(_dx*_dx + _dy*_dy);
        _dx *= _d;
        _dy *= _d;
        
        var _x1 = _x5;
        var _y1 = _y5;
        var _x2 = _x6;
        var _y2 = _y6;
        var _x3 = _ix3 + _dx - _dy;
        var _y3 = _iy3 + _dy + _dx;
        var _x4 = _ix3 + _dx + _dy;
        var _y4 = _iy3 + _dy - _dx;
        
        var _cap = 5; //Default to rounded lines
        if (__capEnd == "none"  ) _cap = 3;
        if (__capEnd == "square") _cap = 4;
        
        vertex_position_3d(_vbuff, _x1, _y1, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x3, _y3, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x4, _y4, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        
        vertex_position_3d(_vbuff, _x1, _y1, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x4, _y4, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x2, _y2, _cap); vertex_normal(_vbuff, _ix2, _iy2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ix3, _iy3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
    }
    
    /*
    /// @param vertexBuffer
    static Build = function(_vbuff)
    {
        var _colour     = __colour;
        var _alpha      = __alpha;
        var _thickness  = __thickness;
        var _pointArray = __pointArray;
        
        var _x1 = undefined;
        var _y1 = undefined;
        var _x2 = _pointArray[0];
        var _y2 = _pointArray[1];
        var _x3 = _pointArray[2];
        var _y3 = _pointArray[3];
        
        var _mx12 = undefined;
        var _my12 = undefined;
        var _mx23 = 0.5*(_x2 + _x3);
        var _my23 = 0.5*(_y2 + _y3);
        
        ///Start cap
        var _dx = _x3 - _x2;
        var _dy = _y3 - _y2;
        var _d  = _thickness / sqrt(_dx*_dx + _dy*_dy);
        _dx *= _d;
        _dy *= _d;
        _x1 = _x2 - _dx;
        _y1 = _y2 - _dy;
        
        vertex_position_3d(_vbuff,   _x1,   _y1, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, _mx23, _my23, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        vertex_position_3d(_vbuff,   _x1,   _y1, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        
        vertex_position_3d(_vbuff,   _x1,   _y1, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, _mx23, _my23, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        vertex_position_3d(_vbuff, _mx23, _my23, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        
        //Points along the line
        var _i = 4;
        repeat((array_length(_pointArray) div 2) - 2)
        {
            _x1 = _x2;
            _y1 = _y2;
            _x2 = _x3;
            _y2 = _y3;
            _x3 = _pointArray[_i  ];
            _y3 = _pointArray[_i+1];
            
            _mx12 = _mx23;
            _my12 = _my23;
            _mx23 = 0.5*(_x2 + _x3);
            _my23 = 0.5*(_y2 + _y3);
            
            __WriteVertex(_vbuff, _mx12, _my12, _x2, _y2, _mx23, _my23, _colour, _alpha, _thickness);
            
            _i += 2;
        }
        
        _x1 = _x2;
        _y1 = _y2;
        _x2 = _x3;
        _y2 = _y3;
        
        _mx12 = _mx23;
        _my12 = _my23;
        
        //BC midpoint to C
        _dx = _x2 - _x1;
        _dy = _y2 - _y1;
        _d  = _thickness / sqrt(_dx*_dx + _dy*_dy);
        _dx *= _d;
        _dy *= _d;
        
        _x3 = _x2 + _dx;
        _y3 = _y2 + _dy;
        
        //AB midpoint to B
        vertex_position_3d(_vbuff, _mx12, _my12, 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x3  , _y3  , 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _mx12, _my12, 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        
        vertex_position_3d(_vbuff, _mx12, _my12, 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x3  , _y3  , 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x3  , _y3  , 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
    }
    
    static __WriteVertex = function(_vbuff, _x1, _y1, _x2, _y2, _x3, _y3, _colour, _alpha, _thickness)
    {
        //AB midpoint to B
        vertex_position_3d(_vbuff, _x1, _y1, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x2, _y2, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x1, _y1, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        
        vertex_position_3d(_vbuff, _x1, _y1, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x2, _y2, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x2, _y2, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        
        //B to BC midpoint
        vertex_position_3d(_vbuff, _x2, _y2, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x3, _y3, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x2, _y2, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        
        vertex_position_3d(_vbuff, _x2, _y2, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x3, _y3, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
        vertex_position_3d(_vbuff, _x3, _y3, 7); vertex_normal(_vbuff, _x1, _y1, _x3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _x2, _y2, _y3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
    }
    */
}