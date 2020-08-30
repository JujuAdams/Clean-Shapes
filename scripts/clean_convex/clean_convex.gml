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
        var _size  = array_length(__point_array);
        var _count = _size div 2;
        
        //Find the centre of the polygon
        var _cx = 0;
        var _cy = 0;
        var _r  = 0;
        var _g  = 0;
        var _b  = 0;
        var _c_alpha = 0;
        
        var _i = 0;
        repeat(_count)
        {
            _cx += __point_array[_i  ];
            _cy += __point_array[_i+1];
            
            var _colour = __blend_array[_i];
            _r += colour_get_red(_colour);
            _g += colour_get_green(_colour);
            _b += colour_get_blue(_colour);
            _c_alpha += __blend_array[_i+1];
            
            _i += 2;
        }
        
        _cx /= _count;
        _cy /= _count;
        _r  /= _count;
        _g  /= _count;
        _b  /= _count;
        _c_alpha /= _count;
        
        var _c_colour = make_colour_rgb(_r, _g, _b);
        
        //Build the polygon
        var _x1 = undefined;
        var _y1 = undefined;
        var _x2 = __point_array[0];
        var _y2 = __point_array[1];
        var _x3 = __point_array[2];
        var _y3 = __point_array[3];
        var _x4 = __point_array[4];
        var _y4 = __point_array[5];
        
        var _c2 = undefined;
        var _a2 = undefined;
        var _c3 = __blend_array[2];
        var _a3 = __blend_array[3];
        var _c4 = __blend_array[4];
        var _a4 = __blend_array[5];
        
        var _dir12 = undefined;
        var _dir23 = degtorad((point_direction(_x2, _y2, _x3, _y3) + 90) mod 360);
        var _dir34 = degtorad((point_direction(_x3, _y3, _x4, _y4) + 90) mod 360);
        
        var _dist12 = undefined;
        var _dist23 = dot_product(_x3, _y3, cos(_dir23), -sin(_dir23));
        var _dist34 = dot_product(_x3, _y3, cos(_dir34), -sin(_dir34));
        
        var _j = 0;
        var _i = 6 mod _size;
        repeat(_count)
        {
            _x1 = _x2;
            _y1 = _y2;
            _x2 = _x3;
            _y2 = _y3;
            _x3 = _x4;
            _y3 = _y4;
            _x4 = __point_array[_i  ];
            _y4 = __point_array[_i+1];
            
            _dir12 = _dir23;
            _dir23 = _dir34;
            _dir34 = degtorad((point_direction(_x3, _y3, _x4, _y4) + 90) mod 360);
            
            _dist12 = _dist23;
            _dist23 = _dist34;
            _dist34 = dot_product(_x3, _y3, cos(_dir34), -sin(_dir34));
            
            _c2 = _c3;
            _a2 = _a3;
            _c3 = _c4;
            _a3 = _a4;
            _c4 = __blend_array[_i  ];
            _a4 = __blend_array[_i+1];
            
            //__clean_trace(_j, ":   ang=", _dir12, ", dist=", _dist12, ",   ang=", _dir23, ", dist=", _dist23, ",   ang=", _dir34, ", dist=", _dist34)
            
            vertex_position_3d(_vbuff, _cx, _cy, _dir12); vertex_normal(_vbuff, _dir23, _dir34, _dist12); vertex_colour(_vbuff, _c_colour, _c_alpha); vertex_texcoord(_vbuff, _dist23, _dist34);
            vertex_position_3d(_vbuff, _x1, _y1, _dir12); vertex_normal(_vbuff, _dir23, _dir34, _dist12); vertex_colour(_vbuff, _c2, _a2); vertex_texcoord(_vbuff, _dist23, _dist34);
            vertex_position_3d(_vbuff, _x2, _y2, _dir12); vertex_normal(_vbuff, _dir23, _dir34, _dist12); vertex_colour(_vbuff, _c3, _a3); vertex_texcoord(_vbuff, _dist23, _dist34);
            
            _i = (_i + 2) mod _size;
            ++_j;
        }
        
        return undefined;
    }
    
    /*
    /// @param vertexBuffer
    build = function(_vbuff)
    {
        var _x1 = __point_array[0];
        var _y1 = __point_array[1];
        var _x2 = undefined;
        var _y2 = undefined;
        var _x3 = __point_array[2];
        var _y3 = __point_array[3];
        
        if (is_array(__blend_array))
        {
            var _c1 = __blend_array[0];
            var _a1 = __blend_array[1];
            var _c2 = undefined;
            var _a2 = undefined;
            var _c3 = __blend_array[2];
            var _a3 = __blend_array[3];
            
            var _i = 4;
            repeat((array_length(__point_array) div 2) - 2)
            {
                _x2 = _x3;
                _y2 = _y3;
                _c2 = _c3;
                _a2 = _a3;
                _x3 = __point_array[_i  ];
                _y3 = __point_array[_i+1];
                _c3 = __blend_array[_i  ];
                _a3 = __blend_array[_i+1];
                
                vertex_position_3d(_vbuff, _x1, _y1, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c1, _a1); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x2, _y2, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c2, _a2); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x3, _y3, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c3, _a3); vertex_texcoord(_vbuff, 0, 0);
                
                _i += 2;
            }
        }
        else
        {
            var _i = 4;
            repeat((array_length(__point_array) div 2) - 2)
            {
                _x2 = _x3;
                _y2 = _y3;
                _x3 = __point_array[_i  ];
                _y3 = __point_array[_i+1];
                
                vertex_position_3d(_vbuff, _x1, _y1, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x2, _y2, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x3, _y3, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 0);
                
                _i += 2;
            }
        }
        
        return undefined;
    }
    */
}