/// @param x
/// @param y
/// @param radius

function clean_circle(_x, _y, _radius)
{
    var _struct = new __clean_class_circle(_x, _y, _radius);
    if (is_array(global.__clean_batch)) global.__clean_batch[@ array_length(global.__clean_batch)] = _struct;
    return _struct;
}

function __clean_class_circle(_x, _y, _radius) constructor
{
    __shader = sh_clean_circle;
    __format = global.__clean_vertex_format_circle;
    
    __x      = _x;
    __y      = _y;
    __radius = _radius;
    
    __colour = CLEAN_DEFAULT_CIRCLE_COLOUR;
    __alpha  = CLEAN_DEFAULT_CIRCLE_ALPHA;
    
    __ring_thickness = CLEAN_DEFAULT_CIRCLE_RING_THICKNESS;
    
    __border_thickness = CLEAN_DEFAULT_CIRCLE_BORDER_THICKNESS;
    __border_colour    = CLEAN_DEFAULT_CIRCLE_BORDER_COLOUR;
    __border_alpha     = CLEAN_DEFAULT_CIRCLE_BORDER_ALPHA;
    
    __segment_start =   0.0;
    __segment_end   = 360.0;
    
    /// @param color
    /// @param alpha
    blend = function(_colour, _alpha)
    {
        __colour = _colour;
        __alpha  = _alpha;
        
        return self;
    }
    
    /// @param thickness
    ring = function(_thickness)
    {
        __ring_thickness = _thickness;
        
        return self;
    }
    
    border = function(_thickness, _colour, _alpha)
    {
        __border_thickness = _thickness;
        __border_colour    = _colour;
        __border_alpha     = _alpha;
        
        return self;
    }
    
    /// @param startAngle
    /// @param endAngle
    segment = function(_start, _end)
    {
        __segment_start = _start;
        __segment_end   = _end;
        
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
        vertex_position_3d(_vbuff, __x - __radius, __y - __radius, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 0);
        vertex_position_3d(_vbuff, __x + __radius, __y - __radius, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, __x - __radius, __y + __radius, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 1);
        
        vertex_position_3d(_vbuff, __x + __radius, __y - __radius, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 1, 0);
        vertex_position_3d(_vbuff, __x - __radius, __y + __radius, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 1);
        vertex_position_3d(_vbuff, __x + __radius, __y + __radius, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 1, 1);
        
        return undefined;
    }
}