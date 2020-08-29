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
    __colour      = c_white;
    __alpha       = 1.0;
    __blend_array = undefined;
    
    __border_thickness = 0.0;
    __border_colour    = c_white;
    __border_alpha     = 1.0;
    
    __rounding = 0;
    
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
}