/// @param x
/// @param y
/// @param radius

function CleanCircle(_x, _y, _radius)
{
    var _struct = new __CleanClassCircle(_x, _y, _radius);
    if (is_array(global.__cleanBatch)) array_push(global.__cleanBatch, _struct);
    return _struct;
}

function __CleanClassCircle(_x, _y, _radius) constructor
{
    __shader = shdClean;
    __format = global.__cleanVertexFormat;
    
    __x      = _x;
    __y      = _y;
    __radius = _radius;
    
    __colour = CLEAN_DEFAULT_CIRCLE_COLOUR;
    __alpha  = CLEAN_DEFAULT_CIRCLE_ALPHA;
    
    __ringThickness = CLEAN_DEFAULT_CIRCLE_RING_THICKNESS;
    
    __borderThickness = CLEAN_DEFAULT_CIRCLE_BORDER_THICKNESS;
    __borderColour    = CLEAN_DEFAULT_CIRCLE_BORDER_COLOUR;
    __borderAlpha     = CLEAN_DEFAULT_CIRCLE_BORDER_ALPHA;
    
    __segmentCentre = 0.0;
    __segmentSize   = 999999;
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colour = _colour;
        __alpha  = _alpha;
        
        return self;
    }
    
    /// @param thickness
    static Ring = function(_thickness)
    {
        __ringThickness = _thickness;
        
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
    
    /// @param startAngle
    /// @param endAngle
    static Segment = function(_start, _end)
    {
        __segmentSize   = degtorad(_end - _start);
        __segmentCentre = degtorad(_start) + __segmentSize/2;
        
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
        var _x             = __x;
        var _y             = __y;
        var _r             = __radius;
        var _segmentCentre = __segmentCentre;
        var _segmentSize   = __segmentSize;
        var _colour        = __colour;
        var _alpha         = __alpha;
        
        var _border_r = colour_get_red(  __borderColour)/255;
        var _border_g = colour_get_green(__borderColour)/255;
        var _border_b = colour_get_blue( __borderColour)/255;
        var _border_a = __borderAlpha;
        
        var _ring_thickness   = __ringThickness   / _r;
        var _border_thickness = __borderThickness / _r;
        
        vertex_position_3d(_vbuff, _x-_r, _y-_r, 1); vertex_normal(_vbuff, _segmentCentre, _segmentSize, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        vertex_position_3d(_vbuff, _x+_r, _y-_r, 3); vertex_normal(_vbuff, _segmentCentre, _segmentSize, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        vertex_position_3d(_vbuff, _x-_r, _y+_r, 5); vertex_normal(_vbuff, _segmentCentre, _segmentSize, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        
        vertex_position_3d(_vbuff, _x+_r, _y-_r, 3); vertex_normal(_vbuff, _segmentCentre, _segmentSize, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        vertex_position_3d(_vbuff, _x-_r, _y+_r, 5); vertex_normal(_vbuff, _segmentCentre, _segmentSize, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        vertex_position_3d(_vbuff, _x+_r, _y+_r, 7); vertex_normal(_vbuff, _segmentCentre, _segmentSize, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _ring_thickness, 0, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, 0, _border_thickness);
        
        return undefined;
    }
}