/// @param x1
/// @param y1
/// @param x2
/// @param y2

function clean_line(_x1, _y1, _x2, _y2)
{
    var _struct = new __clean_class_line(_x1, _y1, _x2, _y2);
    if (is_array(global.__clean_batch)) global.__clean_batch[@ array_length(global.__clean_batch)] = _struct;
    return _struct;
}

function __clean_class_line(_x1, _y1, _x2, _y2) constructor
{
    __shader = sh_clean_polyline;
    __format = global.__clean_vertex_format_polyline;
    
    __x1 = _x1;
    __y1 = _y1;
    __x2 = _x2;
    __y2 = _y2;
    
    __colour1 = c_white;
    __alpha1  = 1.0;
    __colour2 = c_white;
    __alpha2  = 1.0;
    
    __thickness = 10;
    
    __cap_start = "none";
    __cap_end   = "none";
    
    /// @param color
    /// @param alpha
    blend = function(_colour, _alpha)
    {
        __colour1 = _colour;
        __alpha1  = _alpha;
        __colour2 = _colour;
        __alpha2  = _alpha;
        
        return self;
    }
    
    /// @param color1
    /// @param alpha1
    /// @param color2
    /// @param alpha2
    blend2 = function(_colour1, _alpha1, _colour2, _alpha2)
    {
        __colour1 = _colour1;
        __alpha1  = _alpha1;
        __colour2 = _colour2;
        __alpha2  = _alpha2;
        
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
        var _dx = __x2 - __x1;
        var _dy = __y2 - __y1;
        var _d  = __thickness / sqrt(_dx*_dx + _dy*_dy);
        var _nx =  _dy*_d;
        var _ny = -_dx*_d;
        
        vertex_position_3d(_vbuff, __x1 + _nx, __y1 + _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour1, __alpha1); vertex_texcoord(_vbuff, 0, 0);
        vertex_position_3d(_vbuff, __x2 + _nx, __y2 + _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour2, __alpha2); vertex_texcoord(_vbuff, 0, 0);
        vertex_position_3d(_vbuff, __x1 - _nx, __y1 - _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour1, __alpha1); vertex_texcoord(_vbuff, 0, 0);
        
        vertex_position_3d(_vbuff, __x2 + _nx, __y2 + _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour2, __alpha2); vertex_texcoord(_vbuff, 0, 0);
        vertex_position_3d(_vbuff, __x2 - _nx, __y2 - _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour2, __alpha2); vertex_texcoord(_vbuff, 0, 0);
        vertex_position_3d(_vbuff, __x1 - _nx, __y1 - _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour1, __alpha1); vertex_texcoord(_vbuff, 0, 0);
        
        return undefined;
    }
}