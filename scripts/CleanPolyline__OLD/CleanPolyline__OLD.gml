/// @param pointArray

function CleanPolyline__OLD(_array)
{
    var _struct = new __CleanClassPolyline(_array);
    if (is_array(global.__cleanBatch)) array_push(global.__cleanBatch, _struct);
    return _struct;
}

function __CleanClassPolyline__OLD(_array) constructor
{
    __shader = __shdCleanPolyline;
    __format = global.__cleanVertexFormat;
    
    __pointArray = _array;
    __colour     = CLEAN_DEFAULT_POLYLINE_COLOUR;
    __alpha      = CLEAN_DEFAULT_POLYLINE_ALPHA;
    
    __thickness = CLEAN_DEFAULT_POLYLINE_THICKNESS;
    
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
        vertex_position_3d(_vbuff, _mx12, _my12, 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, _x3  , _y3  , 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        vertex_position_3d(_vbuff, _mx12, _my12, 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        
        vertex_position_3d(_vbuff, _mx12, _my12, 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, _x3  , _y3  , 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff,  _thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
        vertex_position_3d(_vbuff, _x3  , _y3  , 0); vertex_normal(_vbuff, _mx12, _my12, _x2); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _y2, _x2, _y2); vertex_float4(_vbuff, -_thickness, 0, 0, 0); vertex_texcoord(_vbuff, 3, 0);
    }
    
    static __WriteVertex = function(_vbuff, _x1, _y1, _x2, _y2, _x3, _y3, _colour, _alpha, _thickness)
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