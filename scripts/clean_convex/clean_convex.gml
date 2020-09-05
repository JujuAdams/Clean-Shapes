/// @param pointArray

function clean_convex(_array)
{
    var _struct = new __clean_class_convex(_array);
    if (is_array(global.__clean_batch)) global.__clean_batch[@ array_length(global.__clean_batch)] = _struct;
    return _struct;
}

function __clean_class_convex(_array) constructor
{
    __shader = sh_clean_polygon;
    __format = global.__clean_vertex_format_polygon;
    
    __point_array = _array;
    __colour      = CLEAN_DEFAULT_CONVEX_COLOUR;
    __alpha       = CLEAN_DEFAULT_CONVEX_ALPHA;
    __blend_array = undefined;
    
    __border_thickness = CLEAN_DEFAULT_CONVEX_BORDER_THICKNESS;
    __border_colour    = CLEAN_DEFAULT_CONVEX_BORDER_COLOUR;
    __border_alpha     = CLEAN_DEFAULT_CONVEX_BORDER_ALPHA;
    
    __rounding = CLEAN_DEFAULT_CONVEX_ROUNDING;
    
    /// @param color
    /// @param alpha
    blend = function(_colour, _alpha)
    {
        __colour      = _colour;
        __alpha       = _alpha;
        __blend_array = undefined;
        return self;
    }
    
    /// @param blendArray
    blend_ext = function(_array)
    {
        __colour      = undefined;
        __alpha       = undefined;
        __blend_array = _array;
        return self;
    }
    
    border = function(_thickness, _colour, _alpha)
    {
        __border_thickness = _thickness;
        __border_colour    = _colour;
        __border_alpha     = _alpha;
        return self;
    }
    
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
        var _border_r = colour_get_red(  __border_colour)/255;
        var _border_g = colour_get_green(__border_colour)/255;
        var _border_b = colour_get_blue( __border_colour)/255;
        var _border_a = __border_alpha;
        
        var _size  = array_length(__point_array);
        var _count = _size div 2;
        
        //Find the centre of the polygon
        var _cx = 0;
        var _cy = 0;
        var _r  = 0;
        var _g  = 0;
        var _b  = 0;
        var _ac = 0;
        
        var _i = 0;
        repeat(_count)
        {
            _cx += __point_array[_i  ];
            _cy += __point_array[_i+1];
            
            var _colour = __blend_array[_i];
            _r  += colour_get_red(_colour);
            _g  += colour_get_green(_colour);
            _b  += colour_get_blue(_colour);
            _ac += __blend_array[_i+1];
            
            _i += 2;
        }
        
        _cx /= _count;
        _cy /= _count;
        _r  /= _count;
        _g  /= _count;
        _b  /= _count;
        _ac /= _count;
        var _cc = make_colour_rgb(_r, _g, _b);
        
        //Build the polygon
        var _x0 = undefined;
        var _y0 = undefined;
        var _x1 = __point_array[0];
        var _y1 = __point_array[1];
        var _x2 = __point_array[2];
        var _y2 = __point_array[3];
        
        var _c0 = undefined;
        var _a0 = undefined;
        var _c1 = __blend_array[0];
        var _a1 = __blend_array[1];
        var _c2 = __blend_array[2];
        var _a2 = __blend_array[3];
        
        var _x01 = undefined;
        var _y01 = undefined;
        var _c01 = undefined;
        var _a01 = undefined;
        
        var _x12 = 0.5*(_x1 + _x2);
        var _y12 = 0.5*(_y1 + _y2);
        var _c12 = merge_colour(_c1, _c2, 0.5);
        var _a12 = 0.5*(_a1 + _a2);
        
        var _nx1 = undefined;
        var _ny1 = undefined;
        var _ds1 = undefined;
        
        var _nx2 = _x2 - _x1;
        var _ny2 = _y2 - _y1;
        var _n   = 1/sqrt(_nx2*_nx2 + _ny2*_ny2);
        var _tmp =  _nx2;
            _nx2 = -_ny2*_n;
            _ny2 =  _tmp*_n;
        var _ds2 = dot_product(_x2, _y2, _nx2, _ny2);
        
        var _i = 4 mod _size;
        repeat(_count)
        {
            _x0 = _x1;
            _y0 = _y1;
            _x1 = _x2;
            _y1 = _y2;
            _x2 = __point_array[_i  ];
            _y2 = __point_array[_i+1];
            
            _c0 = _c1;
            _a0 = _a1;
            _c1 = _c2;
            _a1 = _a2;
            _c2 = __blend_array[_i  ];
            _a2 = __blend_array[_i+1];
            
            _x01 = _x12;
            _y01 = _y12;
            _c01 = _c12;
            _a01 = _a12;
            
            _x12 = 0.5*(_x1 + _x2);
            _y12 = 0.5*(_y1 + _y2);
            _c12 = merge_colour(_c1, _c2, 0.5);
            _a12 = 0.5*(_a1 + _a2);
            
            _nx1 = _nx2;
            _ny1 = _ny2;
            _ds1 = _ds2;
            
            _nx2 = _x2 - _x1;
            _ny2 = _y2 - _y1;
            _n   = 1/sqrt(_nx2*_nx2 + _ny2*_ny2);
            _tmp =  _nx2;
            _nx2 = -_ny2*_n;
            _ny2 =  _tmp*_n;
            _ds2 = dot_product(_x2, _y2, _nx2, _ny2);
            
            vertex_position_3d(_vbuff, _x01, _y01, 0); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c01, _a01); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, __rounding, __border_thickness);
            vertex_position_3d(_vbuff, _cx , _cy , 0); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _cc , _ac ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, __rounding, __border_thickness);
            vertex_position_3d(_vbuff, _x1 , _y1 , 0); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c1 , _a1 ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, __rounding, __border_thickness);
            
            vertex_position_3d(_vbuff, _x1 , _y1 , 0); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c1 , _a1 ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, __rounding, __border_thickness);
            vertex_position_3d(_vbuff, _cx , _cy , 0); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _cc , _ac ); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, __rounding, __border_thickness);
            vertex_position_3d(_vbuff, _x12, _y12, 0); vertex_normal(_vbuff, _nx1, _ny1, _ds1); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _nx2, _ny2, _ds2); vertex_float4(_vbuff, _border_r, _border_g, _border_b, _border_a); vertex_texcoord(_vbuff, __rounding, __border_thickness);
            
            _i = (_i + 2) mod _size;
        }
        
        return undefined;
    }
}