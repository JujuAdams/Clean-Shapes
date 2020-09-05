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
    __shader = shd_clean;
    __format = global.__clean_vertex_format;
    
    __x      = _x;
    __y      = _y;
    __radius = _radius;
    
    __colour = CLEAN_DEFAULT_CIRCLE_COLOUR;
    __alpha  = CLEAN_DEFAULT_CIRCLE_ALPHA;
    
    __ring_thickness = CLEAN_DEFAULT_CIRCLE_RING_THICKNESS;
    
    __border_thickness = CLEAN_DEFAULT_CIRCLE_BORDER_THICKNESS;
    __border_colour    = CLEAN_DEFAULT_CIRCLE_BORDER_COLOUR;
    __border_alpha     = CLEAN_DEFAULT_CIRCLE_BORDER_ALPHA;
    
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
    
    draw = function()
    {
        __clean_draw();
        return undefined;
    }
    
    /// @param vertexBuffer
    build = function(_vbuff)
    {
        var _border_r = colour_get_red(  __border_colour)/255;
        var _border_g = colour_get_green(__border_colour)/255;
        var _border_b = colour_get_blue( __border_colour)/255;
        var _border_a = __border_alpha;
        
        var _ring_thickness = __ring_thickness/__radius;
        var _border_thickness = __border_thickness / __radius;
        
        vertex_position_3d(_vbuff, __x - __radius, __y - __radius, 1); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        vertex_position_3d(_vbuff, __x + __radius, __y - __radius, 3); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        vertex_position_3d(_vbuff, __x - __radius, __y + __radius, 5); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        
        vertex_position_3d(_vbuff, __x + __radius, __y - __radius, 3); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        vertex_position_3d(_vbuff, __x - __radius, __y + __radius, 5); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        vertex_position_3d(_vbuff, __x + __radius, __y + __radius, 7); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        
        return undefined;
    }
}