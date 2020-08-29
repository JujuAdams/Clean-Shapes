/// @param x1
/// @param y1
/// @param x2
/// @param y2
/// @param x3
/// @param y3

function clean_triangle(_x1, _y1, _x2, _y2, _x3, _y3)
{
    var _struct = new __clean_class_triangle(_x1, _y1, _x2, _y2, _x3, _y3);
    if (is_array(global.__clean_batch)) global.__clean_batch[@ array_length(global.__clean_batch)] = _struct;
    return _struct;
}

function __clean_class_triangle(_x1, _y1, _x2, _y2, _x3, _y3) constructor
{
    __shader = sh_clean_polygon;
    __format = global.__clean_vertex_format_polygon;
    
    __x1 = _x1;
    __y1 = _y1;
    __x2 = _x2;
    __y2 = _y2;
    __x3 = _x3;
    __y3 = _y3;
    
    __colour1 = c_white;
    __alpha1  = 1.0;
    __colour2 = c_white;
    __alpha2  = 1.0;
    __colour3 = c_white;
    __alpha3  = 1.0;
    
    __border_thickness = 0.0;
    __border_colour    = c_white;
    __border_alpha     = 1.0;
    
    __rounding = 0.0;
    
    /// @param color
    /// @param alpha
    blend = function(_colour, _alpha)
    {
        __colour1 = _colour;
        __alpha1  = _alpha;
        __colour2 = _colour;
        __alpha2  = _alpha;
        __colour3 = _colour;
        __alpha3  = _alpha;
        
        return self;
    }
    
    /// @param color1
    /// @param alpha1
    /// @param color2
    /// @param alpha2
    /// @param color3
    /// @param alpha3
    blend3 = function(_colour1, _alpha1, _colour2, _alpha2, _colour3, _alpha3)
    {
        __colour1 = _colour1;
        __alpha1  = _alpha1;
        __colour2 = _colour2;
        __alpha2  = _alpha2;
        __colour3 = _colour3;
        __alpha3  = _alpha3;
        
        return self;
    }
    
    border = function(_thickness, _colour, _alpha)
    {
        __border_thickness = _thickness;
        __border_colour    = _colour;
        __border_alpha     = _alpha;
        
        return self;
    }
    
    /// @param radius
    rounding = function(_radius)
    {
        __rounding = _radius;
        
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
        vertex_position_3d(_vbuff, __x1, __y1, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour1, __alpha1); vertex_texcoord(_vbuff, 0, 0);
        vertex_position_3d(_vbuff, __x2, __y2, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour2, __alpha2); vertex_texcoord(_vbuff, 0, 0);
        vertex_position_3d(_vbuff, __x3, __y3, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour3, __alpha3); vertex_texcoord(_vbuff, 0, 0);
        
        return undefined;
    }
}