/// @param x1
/// @param y1
/// @param x2
/// @param y2

function CleanLine(_x1, _y1, _x2, _y2)
{
    var _struct = new __CleanClassLine(_x1, _y1, _x2, _y2);
    if (is_array(global.__cleanBatch)) array_push(global.__cleanBatch, _struct);
    return _struct;
}

function __CleanClassLine(_x1, _y1, _x2, _y2) constructor
{
    __shader = shdCleanLineStrip;
    __format = global.__cleanVertexFormat;
    
    __x1 = _x1;
    __y1 = _y1;
    __x2 = _x2;
    __y2 = _y2;
    
    __colour = CLEAN_DEFAULT_LINE_COLOUR;
    __alpha  = CLEAN_DEFAULT_LINE_ALPHA;
    
    __thickness = CLEAN_DEFAULT_LINE_THICKNESS;
    
    __capStart = CLEAN_DEFAULT_LINE_START_CAP;
    __capEnd   = CLEAN_DEFAULT_LINE_END_CAP;
    
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
        var _colour    = __colour;
        var _alpha     = __alpha;
        var _thickness = __thickness;
        
        var _x1 = undefined;
        var _y1 = undefined;
        var _x2 = __x1;
        var _y2 = __y1;
        var _x3 = __x2;
        var _y3 = __y2;
        
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
}