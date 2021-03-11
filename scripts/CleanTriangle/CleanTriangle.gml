/// @param x1
/// @param y1
/// @param x2
/// @param y2
/// @param x3
/// @param y3

function CleanTriangle(_x1, _y1, _x2, _y2, _x3, _y3)
{
    return new __CleanClassTriangle(_x1, _y1, _x2, _y2, _x3, _y3);
}

function __CleanClassTriangle(_x1, _y1, _x2, _y2, _x3, _y3) constructor
{
    __x1 = _x1;
    __y1 = _y1;
    __x2 = _x2;
    __y2 = _y2;
    __x3 = _x3;
    __y3 = _y3;
    
    __colour1 = CLEAN_DEFAULT_TRIANGLE_COLOUR;
    __alpha1  = CLEAN_DEFAULT_TRIANGLE_ALPHA;
    __colour2 = CLEAN_DEFAULT_TRIANGLE_COLOUR;
    __alpha2  = CLEAN_DEFAULT_TRIANGLE_ALPHA;
    __colour3 = CLEAN_DEFAULT_TRIANGLE_COLOUR;
    __alpha3  = CLEAN_DEFAULT_TRIANGLE_ALPHA;
    
    __borderThickness = CLEAN_DEFAULT_TRIANGLE_BORDER_THICKNESS;
    __borderColour    = CLEAN_DEFAULT_TRIANGLE_BORDER_COLOUR;
    __borderAlpha     = CLEAN_DEFAULT_TRIANGLE_BORDER_ALPHA;
    
    __rounding = CLEAN_DEFAULT_TRIANGLE_ROUNDING;
    
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
        
        return self;
    }
    
    /// @param color1
    /// @param alpha1
    /// @param color2
    /// @param alpha2
    /// @param color3
    /// @param alpha3
    static Blend3 = function(_colour1, _alpha1, _colour2, _alpha2, _colour3, _alpha3)
    {
        __colour1 = _colour1;
        __alpha1  = _alpha1;
        __colour2 = _colour2;
        __alpha2  = _alpha2;
        __colour3 = _colour3;
        __alpha3  = _alpha3;
        
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
    
    static Draw = function()
    {
        __CleanDraw();
        return undefined;
    }
    
    /// @param vertexBuffer
    static __Build = function(_vbuff)
    {
        if ((CLEAN_TRIANGLE_FIX_COUNTERCLOCKWISE_POINTS || CLEAN_TRIANGLE_ERROR_COUNTERCLOCKWISE_POINTS)
        &&  !__CleanIsClockwise(__x1, __y1, __x2, __y2, __x3, __y3))
        {
            if (CLEAN_TRIANGLE_ERROR_COUNTERCLOCKWISE_POINTS)
            {
                __CleanError("Triangle defined with counter-clockwise coordinates\nTriangles should be defined using clockwise coodinates\n(Set CLEAN_TRIANGLE_ERROR_COUNTERCLOCKWISE_POINTS to <false> to turn off this error)\n(Set CLEAN_TRIANGLE_FIX_COUNTERCLOCKWISE_POINTS to <true> to *slowly* fix point ordering automatically)\n \n{", __x1, ",", __y1, ",  ", __x2, ",", __y2, ",  ", __x3, ",", __y3, "}");
            }
            
            var _x1 = __x1;
            var _y1 = __y1;
            var _x2 = __x3;
            var _y2 = __y3;
            var _x3 = __x2;
            var _y3 = __y2;
            
            var _c1 = __colour1;
            var _a1 = __alpha1;
            var _c2 = __colour3;
            var _a2 = __alpha3;
            var _c3 = __colour2;
            var _a3 = __alpha2;
        }
        else
        {
            var _x1 = __x1;
            var _y1 = __y1;
            var _x2 = __x2;
            var _y2 = __y2;
            var _x3 = __x3;
            var _y3 = __y3;
            
            var _c1 = __colour1;
            var _c2 = __colour2;
            var _c3 = __colour3;
            var _a1 = __alpha1;
            var _a2 = __alpha2;
            var _a3 = __alpha3;
        }
        
        var _rounding        = __rounding;
        var _borderThickness = __borderThickness;
        
        var _border_r = colour_get_red(  __borderColour)/255;
        var _border_g = colour_get_green(__borderColour)/255;
        var _border_b = colour_get_blue( __borderColour)/255;
        var _border_a = __borderAlpha;
        
        var _cx = 0.3333*(_x1 + _x2 + _x3);
        var _cy = 0.3333*(_y1 + _y2 + _y3);
        
        var _cc = make_colour_rgb(0.3333*(colour_get_red(  _c1) + colour_get_red(  _c2) + colour_get_red(  _c3)),
                                  0.3333*(colour_get_green(_c1) + colour_get_green(_c2) + colour_get_green(_c3)),
                                  0.3333*(colour_get_blue( _c1) + colour_get_blue( _c2) + colour_get_blue( _c3)));
        var _ac = 0.3333*(_a1 + _a2 + _a3);
        
        
        var _c12 = merge_colour(_c1, _c2, 0.5);
        var _c23 = merge_colour(_c2, _c3, 0.5);
        var _c31 = merge_colour(_c3, _c1, 0.5);
        
        var _a12 = 0.5*(_a1 + _a2);
        var _a23 = 0.5*(_a2 + _a3);
        var _a31 = 0.5*(_a3 + _a1);
        
        var _x12 = 0.5*(_x1 + _x2);
        var _y12 = 0.5*(_y1 + _y2);
        var _x23 = 0.5*(_x2 + _x3);
        var _y23 = 0.5*(_y2 + _y3);
        var _x31 = 0.5*(_x3 + _x1);
        var _y31 = 0.5*(_y3 + _y1);
        
        var _nx12 = _x2 - _x1;
        var _ny12 = _y2 - _y1;
        var _n    = 1/sqrt(_nx12*_nx12 + _ny12*_ny12);
        var _tmp  =  _nx12;
            _nx12 = -_ny12*_n;
            _ny12 =  _tmp*_n;
        var _ds12 = dot_product(_x2, _y2, _nx12, _ny12);
        
        var _nx23 = _x3 - _x2;
        var _ny23 = _y3 - _y2;
        var _n    = 1/sqrt(_nx23*_nx23 + _ny23*_ny23);
        var _tmp  =  _nx23;
            _nx23 = -_ny23*_n;
            _ny23 =  _tmp*_n;
        var _ds23 = dot_product(_x3, _y3, _nx23, _ny23);
        
        var _nx31 = _x1 - _x3;
        var _ny31 = _y1 - _y3;
        var _n    = 1/sqrt(_nx31*_nx31 + _ny31*_ny31);
        var _tmp  =  _nx31;
            _nx31 = -_ny31*_n;
            _ny31 =  _tmp*_n;
        var _ds31 = dot_product(_x1, _y1, _nx31, _ny31);
        
        //Corner 1
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _cc , _ac ); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x31, _y31, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _c31, _a31); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x1,  _y1, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _c1 , _a1 ); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _cc , _ac ); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x1,  _y1, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _c1 , _a1 ); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x12, _y12, 6); vertex_normal(_vbuff, _nx31, _ny31, _ds31); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _nx12, _ny12, _ds12); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        //Corner 2
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _cc , _ac ); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x12, _y12, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x2,  _y2, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _c2 , _a2 ); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _cc , _ac ); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x2,  _y2, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _c2 , _a2 ); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x23, _y23, 6); vertex_normal(_vbuff, _nx12, _ny12, _ds12); vertex_colour(_vbuff, _c23, _a23); vertex_float3(_vbuff, _nx23, _ny23, _ds23); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        //Corner 3
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _cc , _ac ); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x23, _y23, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _c23, _a23); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x3,  _y3, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _c3 , _a3 ); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        vertex_position_3d(_vbuff,  _cx,  _cy, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _cc , _ac ); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff,  _x3,  _y3, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _c3 , _a3 ); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        vertex_position_3d(_vbuff, _x31, _y31, 6); vertex_normal(_vbuff, _nx23, _ny23, _ds23); vertex_colour(_vbuff, _c31, _a31); vertex_float3(_vbuff, _nx31, _ny31, _ds31); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, _rounding, _borderThickness);
        
        return undefined;
    }
}