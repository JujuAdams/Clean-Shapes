/// @param left
/// @param top
/// @param right
/// @param bottom

function CleanRectangle(_left, _top, _right, _bottom)
{
    return new __CleanClassRectangle(_left, _top, _right, _bottom);
}

function __CleanClassRectangle(_left, _top, _right, _bottom) constructor
{
    __left   = _left;
    __top    = _top;
    __right  = _right;
    __bottom = _bottom;
    
    __colour1 = CLEAN_DEFAULT_RECTANGLE_COLOUR;
    __alpha1  = CLEAN_DEFAULT_RECTANGLE_ALPHA;
    __colour2 = CLEAN_DEFAULT_RECTANGLE_COLOUR;
    __alpha2  = CLEAN_DEFAULT_RECTANGLE_ALPHA;
    __colour3 = CLEAN_DEFAULT_RECTANGLE_COLOUR;
    __alpha3  = CLEAN_DEFAULT_RECTANGLE_ALPHA;
    __colour4 = CLEAN_DEFAULT_RECTANGLE_COLOUR;
    __alpha4  = CLEAN_DEFAULT_RECTANGLE_ALPHA;
    
    __borderThickness = CLEAN_DEFAULT_RECTANGLE_BORDER_THICKNESS;
    __borderColour    = CLEAN_DEFAULT_RECTANGLE_BORDER_COLOUR;
    __borderAlpha     = CLEAN_DEFAULT_RECTANGLE_BORDER_ALPHA;
    
    __rounding = CLEAN_DEFAULT_RECTANGLE_ROUNDING;
    __rotation = 0;
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colour1 = _colour;
        __alpha1  = _alpha;
        __colour2 = _colour;
        __alpha2  = _alpha;
        __colour3 = _colour;
        __alpha3  = _alpha;
        __colour4 = _colour;
        __alpha4  = _alpha;
        
        return self;
    }
    
    /// @param color1
    /// @param alpha1
    /// @param color2
    /// @param alpha2
    /// @param color3
    /// @param alpha3
    /// @param color4
    /// @param alpha4
    static Blend4 = function(_colour1, _alpha1, _colour2, _alpha2, _colour3, _alpha3, _colour4, _alpha4)
    {
        __colour1 = _colour1;
        __alpha1  = _alpha1;
        __colour2 = _colour2;
        __alpha2  = _alpha2;
        __colour3 = _colour3;
        __alpha3  = _alpha3;
        __colour4 = _colour4;
        __alpha4  = _alpha4;
        
        return self;
    }
    
    static Border = function(_thickness, _colour, _alpha)
    {
        __borderThickness = _thickness;
        __borderColour    = _colour;
        __borderAlpha     = _alpha;
        
        return self;
    }
    
    /// @param radius
    static Rounding = function(_radius)
    {
        __rounding = _radius;
        
        return self;
    }
    
    /// @param angle
    static Rotate = function(_angle)
    {
        __rotation = _angle;
        
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
        var _rounding        = __rounding;
        var _rotation        = degtorad(__rotation);
        var _borderThickness = __borderThickness;
        
        var _border_r = colour_get_red(  __borderColour)/255;
        var _border_g = colour_get_green(__borderColour)/255;
        var _border_b = colour_get_blue( __borderColour)/255;
        var _border_a = __borderAlpha;
        
        var _c1  = __colour1;
        var _c2  = __colour2;
        var _c3  = __colour3;
        var _c4  = __colour4;
        var _a1  = __alpha1;
        var _a2  = __alpha2;
        var _a3  = __alpha3;
        var _a4  = __alpha4;
        
        var _l = __left;
        var _t = __top;
        var _r = __right;
        var _b = __bottom;
        
        var _w  = _r - _l;
        var _h  = _b - _t;
        var _cx = 0.5*(_l + _r);
        var _cy = 0.5*(_t + _b);
        
        if (__rotation == 0)
        {
            vertex_position_3d(_vbuff, _l, _t, 2); vertex_normal(_vbuff, _cx, _cy, 0); vertex_colour(_vbuff, _c1, _a1); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _r, _t, 2); vertex_normal(_vbuff, _cx, _cy, 0); vertex_colour(_vbuff, _c2, _a2); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _r, _b, 2); vertex_normal(_vbuff, _cx, _cy, 0); vertex_colour(_vbuff, _c4, _a4); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            
            vertex_position_3d(_vbuff, _l, _t, 2); vertex_normal(_vbuff, _cx, _cy, 0); vertex_colour(_vbuff, _c1, _a1); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _r, _b, 2); vertex_normal(_vbuff, _cx, _cy, 0); vertex_colour(_vbuff, _c4, _a4); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _l, _b, 2); vertex_normal(_vbuff, _cx, _cy, 0); vertex_colour(_vbuff, _c3, _a3); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        }
        else
        {
            var _hw = 0.5*_w;
            var _hh = 0.5*_h;
            
            var _sin = sin(-_rotation);
            var _cos = cos(-_rotation);
            
            var _ox1 = _cx - _hw*_cos + _hh*_sin;
            var _oy1 = _cy - _hw*_sin - _hh*_cos;
            var _ox2 = _cx + _hw*_cos + _hh*_sin;
            var _oy2 = _cy + _hw*_sin - _hh*_cos;
            var _ox3 = _cx - _hw*_cos - _hh*_sin;
            var _oy3 = _cy - _hw*_sin + _hh*_cos;
            var _ox4 = _cx + _hw*_cos - _hh*_sin;
            var _oy4 = _cy + _hw*_sin + _hh*_cos;
            
            vertex_position_3d(_vbuff, _ox1, _oy1, 2); vertex_normal(_vbuff, _cx, _cy, _rotation); vertex_colour(_vbuff, _c1, _a1); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _ox2, _oy2, 2); vertex_normal(_vbuff, _cx, _cy, _rotation); vertex_colour(_vbuff, _c2, _a2); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _ox4, _oy4, 2); vertex_normal(_vbuff, _cx, _cy, _rotation); vertex_colour(_vbuff, _c4, _a4); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            
            vertex_position_3d(_vbuff, _ox1, _oy1, 2); vertex_normal(_vbuff, _cx, _cy, _rotation); vertex_colour(_vbuff, _c1, _a1); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _ox4, _oy4, 2); vertex_normal(_vbuff, _cx, _cy, _rotation); vertex_colour(_vbuff, _c4, _a4); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
            vertex_position_3d(_vbuff, _ox3, _oy3, 2); vertex_normal(_vbuff, _cx, _cy, _rotation); vertex_colour(_vbuff, _c3, _a3); vertex_float3(_vbuff, _w, _h, 0); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        }
        
        return undefined;
    }
}