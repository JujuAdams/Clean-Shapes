/// @param x
/// @param y
/// @param radius

function CleanCircle(_x, _y, _radius)
{
    return new __CleanClassCircle(_x, _y, _radius);
}

function __CleanClassCircle(_x, _y, _radius) constructor
{
    __x      = _x;
    __y      = _y;
    __radius = _radius;
    
    __colour = CLEAN_DEFAULT_CIRCLE_COLOUR;
    __alpha  = CLEAN_DEFAULT_CIRCLE_ALPHA;
    
    __borderThickness = CLEAN_DEFAULT_CIRCLE_BORDER_THICKNESS;
    __borderColour    = CLEAN_DEFAULT_CIRCLE_BORDER_COLOUR;
    __borderAlpha     = CLEAN_DEFAULT_CIRCLE_BORDER_ALPHA;
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colour = _colour;
        __alpha  = _alpha;
        
        return self;
    }
    
    /// @param thickness
    /// @param colour
    /// @param alpha
    static Border = function(_thickness, _colour, _alpha)
    {
        __borderThickness = _thickness;
        __borderColour    = _colour;
        __borderAlpha     = _alpha;
        
        return self;
    }
    
    static Draw = function()
    {
        __CleanDraw();
        return undefined;
    }
    
    /// @param vertexBuffer
    static __Build = function(_vbuff)
    {
        var _x      = __x;
        var _y      = __y;
        var _r      = __radius;
        var _colour = __colour;
        var _alpha  = __alpha;
        
        var _border_r = colour_get_red(  __borderColour)/255;
        var _border_g = colour_get_green(__borderColour)/255;
        var _border_b = colour_get_blue( __borderColour)/255;
        var _border_a = __borderAlpha;
        
        var _borderThickness = __borderThickness;
        
        vertex_position_3d(_vbuff, _x-_r, _y-_r, 1); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, 0, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _borderThickness);
        vertex_position_3d(_vbuff, _x+_r, _y-_r, 1); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, 0, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _borderThickness);
        vertex_position_3d(_vbuff, _x-_r, _y+_r, 1); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, 0, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _borderThickness);
        
        vertex_position_3d(_vbuff, _x+_r, _y-_r, 1); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, 0, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _borderThickness);
        vertex_position_3d(_vbuff, _x-_r, _y+_r, 1); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, 0, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _borderThickness);
        vertex_position_3d(_vbuff, _x+_r, _y+_r, 1); vertex_normal(_vbuff, _x, _y, _r); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, 0, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _borderThickness);
        
        return undefined;
    }
}