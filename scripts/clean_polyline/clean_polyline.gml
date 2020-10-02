/// @param pointArray

function clean_polyline(_array)
{
    var _struct = new __clean_class_polyline(_array);
    if (is_array(global.__clean_batch)) global.__clean_batch[@ array_length(global.__clean_batch)] = _struct;
    return _struct;
}

function __clean_class_polyline(_array) constructor
{
    __shader = shd_clean_polyline;
    __format = global.__clean_vertex_format;
    
    __point_array = _array;
    __colour      = CLEAN_DEFAULT_POLYLINE_COLOUR;
    __alpha       = CLEAN_DEFAULT_POLYLINE_ALPHA;
    
    __thickness = CLEAN_DEFAULT_POLYLINE_THICKNESS;
    
    __cap_start = CLEAN_DEFAULT_POLYLINE_START_CAP;
    __cap_end   = CLEAN_DEFAULT_POLYLINE_END_CAP;
    
    /// @param color
    /// @param alpha
    blend = function(_colour, _alpha)
    {
        __colour = _colour;
        __alpha  = _alpha;
        
        return self;
    }
    
    thickness = function(_thickness)
    {
        __thickness = _thickness;
        
        return self;
    }
    
    /// @param startType
    /// @param endType
    cap = function(_cap_start, _cap_end)
    {
        __cap_start = _cap_start;
        __cap_end   = _cap_end;
        
        return self;
    }
    
    draw = function()
    {
        __clean_draw();
        return undefined;
    }
    
    /// @param vertexBuffer
    build = function(_vbuff)
    {
        var _x1 = undefined;
        var _y1 = undefined;
        var _x2 = __point_array[0];
        var _y2 = __point_array[1];
        var _x3 = __point_array[2];
        var _y3 = __point_array[3];
        
        var _mx12 = undefined;
        var _my12 = undefined;
        var _mx23 = 0.5*(_x2 + _x3);
        var _my23 = 0.5*(_y2 + _y3);
        
        ///Start cap
        var _dx = _x3 - _x2;
        var _dy = _y3 - _y2;
        var _d  = __thickness / sqrt(_dx*_dx + _dy*_dy);
        _dx *= _d;
        _dy *= _d;
        _x1 = _x2 - _dx;
        _y1 = _y2 - _dy;
        
        vertex_position_3d(_vbuff,   _x1,   _y1, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff, -__thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, _mx23, _my23, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff,  __thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        vertex_position_3d(_vbuff,   _x1,   _y1, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff,  __thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        
        vertex_position_3d(_vbuff,   _x1,   _y1, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff, -__thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, _mx23, _my23, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff, -__thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        vertex_position_3d(_vbuff, _mx23, _my23, 0); vertex_normal(_vbuff, _x2, _y2, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _mx23, _my23); vertex_float4(_vbuff,  __thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        
        //Points along the line
        var _i = 4;
        repeat((array_length(__point_array) div 2) - 2)
        {
            _x1 = _x2;
            _y1 = _y2;
            _x2 = _x3;
            _y2 = _y3;
            _x3 = __point_array[_i  ];
            _y3 = __point_array[_i+1];
            
            _mx12 = _mx23;
            _my12 = _my23;
            _mx23 = 0.5*(_x2 + _x3);
            _my23 = 0.5*(_y2 + _y3);
            
            __write_vertex(_vbuff, _mx12, _my12, _x2, _y2, _mx23, _my23, __colour, __alpha, __thickness);
            
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
        _d  = __thickness / sqrt(_dx*_dx + _dy*_dy);
        _dx *= _d;
        _dy *= _d;
        
        _x3 = _x2 + _dx;
        _y3 = _y2 + _dy;
        
        //AB midpoint to B
        vertex_position_3d(_vbuff, _mx12, _my12, 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff, -__thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, _x3  , _y3  , 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff,  __thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        vertex_position_3d(_vbuff, _mx12, _my12, 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff,  __thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        
        vertex_position_3d(_vbuff, _mx12, _my12, 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff, -__thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, _x3  , _y3  , 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff,  __thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        vertex_position_3d(_vbuff, _x3  , _y3  , 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff, -__thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
    }
    
    __write_vertex = function(_vbuff, _x1, _y1, _x2, _y2, _x3, _y3, _colour, _alpha, _thickness)
    {
        //AB midpoint to B
        vertex_position_3d(_vbuff, _x1, _y1, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, _x2, _y2, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 2, 0);
        vertex_position_3d(_vbuff, _x1, _y1, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        
        vertex_position_3d(_vbuff, _x1, _y1, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, _x2, _y2, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 2, 0);
        vertex_position_3d(_vbuff, _x2, _y2, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 2, 0);
        
        //B to BC midpoint
        vertex_position_3d(_vbuff, _x2, _y2, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 2, 0);
        vertex_position_3d(_vbuff, _x3, _y3, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        vertex_position_3d(_vbuff, _x2, _y2, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 2, 0);
        
        vertex_position_3d(_vbuff, _x2, _y2, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 2, 0);
        vertex_position_3d(_vbuff, _x3, _y3, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        vertex_position_3d(_vbuff, _x3, _y3, 0); vertex_normal(_vbuff, _x1, _y1, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x3, _y3); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
    }
}