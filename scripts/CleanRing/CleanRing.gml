/// @param x
/// @param y
/// @param innerRadius
/// @param outerRadius
/// @param angleStart
/// @param angleEnd

function CleanRing(_x, _y, _innerRadius, _outerRadius, _angleStart, _angleEnd)
{
    return new __CleanClassRing(_x, _y, _innerRadius, _outerRadius, _angleStart, _angleEnd);
}

function __CleanClassRing(_x, _y, _innerRadius, _outerRadius, _angleStart, _angleEnd) constructor
{
    __x           = _x;
    __y           = _y;
    __innerRadius = _innerRadius;
    __outerRadius = _outerRadius;
    __angleStart  = _angleStart;
    __angleEnd    = _angleEnd;
    
    __colour = CLEAN_DEFAULT_CIRCLE_OUTER_COLOUR;
    __alpha  = CLEAN_DEFAULT_CIRCLE_OUTER_ALPHA;
    
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
        var _x           = __x;
        var _y           = __y;
        var _innerRadius = __innerRadius;
        var _outerRadius = __outerRadius;
        var _angleStart  = __angleStart;
        var _angleEnd    = __angleEnd;
        
        _angleStart = (_angleStart >= 0)? (_angleStart mod 360) : (360 - ((-_angleStart) mod 360));
        _angleEnd   = (_angleEnd   >= 0)? (_angleEnd   mod 360) : (360 - ((-_angleEnd)   mod 360));
        
        if (_angleStart < _angleEnd)
        {
            var _wedgeSize = degtorad(0.5*(_angleEnd - _angleStart));
        }
        else
        {
            var _wedgeSize = degtorad(0.5*(360 + _angleEnd - _angleStart));
        }
        
        var _wedgeCentre = degtorad(_angleStart + 180) + _wedgeSize;
        
        var _colour = __colour;
        var _alpha  = __alpha;
        
        var _borderR = colour_get_red(  __borderColour)/255;
        var _borderG = colour_get_green(__borderColour)/255;
        var _borderB = colour_get_blue( __borderColour)/255;
        var _borderA = __borderAlpha;
        
        var _borderThickness = __borderThickness;
        
        vertex_position_3d(_vbuff, _x-_outerRadius, _y-_outerRadius, 12); vertex_normal(_vbuff, _x, _y, _innerRadius); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _outerRadius, _wedgeCentre, _wedgeSize); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, 0, _borderThickness);
        vertex_position_3d(_vbuff, _x+_outerRadius, _y-_outerRadius, 12); vertex_normal(_vbuff, _x, _y, _innerRadius); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _outerRadius, _wedgeCentre, _wedgeSize); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, 0, _borderThickness);
        vertex_position_3d(_vbuff, _x-_outerRadius, _y+_outerRadius, 12); vertex_normal(_vbuff, _x, _y, _innerRadius); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _outerRadius, _wedgeCentre, _wedgeSize); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, 0, _borderThickness);
        
        vertex_position_3d(_vbuff, _x+_outerRadius, _y-_outerRadius, 12); vertex_normal(_vbuff, _x, _y, _innerRadius); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _outerRadius, _wedgeCentre, _wedgeSize); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, 0, _borderThickness);
        vertex_position_3d(_vbuff, _x-_outerRadius, _y+_outerRadius, 12); vertex_normal(_vbuff, _x, _y, _innerRadius); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _outerRadius, _wedgeCentre, _wedgeSize); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, 0, _borderThickness);
        vertex_position_3d(_vbuff, _x+_outerRadius, _y+_outerRadius, 12); vertex_normal(_vbuff, _x, _y, _innerRadius); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _outerRadius, _wedgeCentre, _wedgeSize); vertex_float4(_vbuff, _borderR, _borderG, _borderB, _borderA); vertex_texcoord(_vbuff, 0, _borderThickness);
        
        return undefined;
    }
}