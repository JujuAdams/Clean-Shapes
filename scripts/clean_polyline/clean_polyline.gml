/// @param pointArray

function clean_polyline(_array)
{
    var _struct = new __clean_class_polyline(_array);
    if (is_array(global.__clean_batch)) global.__clean_batch[@ array_length(global.__clean_batch)] = _struct;
    return _struct;
}

function __clean_class_polyline(_array) constructor
{
    __shader = shd_clean_polyline;
    __format = global.__clean_vertex_format;
    
    __point_array = _array;
    __colour      = CLEAN_DEFAULT_POLYLINE_COLOUR;
    __alpha       = CLEAN_DEFAULT_POLYLINE_ALPHA;
    __blend_array = undefined;
    
    __thickness = CLEAN_DEFAULT_POLYLINE_THICKNESS;
    
    __cap_start = CLEAN_DEFAULT_POLYLINE_START_CAP;
    __cap_end   = CLEAN_DEFAULT_POLYLINE_END_CAP;
    
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
    
    thickness = function(_thickness)
    {
        __thickness = _thickness;
        
        return self;
    }
    
    /// @param startType
    /// @param endType
    cap = function(_cap_start, _cap_end)
    {
        __cap_start = _cap_start;
        __cap_end   = _cap_end;
        
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
        var _x1 = undefined;
        var _y1 = undefined;
        var _x2 = __point_array[0];
        var _y2 = __point_array[1];
        
        if (is_array(__blend_array))
        {
            var _c1 = undefined;
            var _a1 = undefined;
            var _c2 = __blend_array[0];
            var _a2 = __blend_array[1];
            
            var _i = 2;
            repeat((array_length(__point_array) div 2) - 1)
            {
                _x1 = _x2;
                _y1 = _y2;
                _c1 = _c2;
                _a1 = _a2;
                _x2 = __point_array[_i  ];
                _y2 = __point_array[_i+1];
                _c2 = __blend_array[_i  ];
                _a2 = __blend_array[_i+1];
                
                var _dx = _x2 - _x1;
                var _dy = _y2 - _y1;
                var _d  = __thickness / sqrt(_dx*_dx + _dy*_dy);
                var _nx =  _dy*_d;
                var _ny = -_dx*_d;
                
                vertex_position_3d(_vbuff, _x1 + _nx, _y1 + _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c1, _a1); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x2 + _nx, _y2 + _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c2, _a2); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x1 - _nx, _y1 - _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c1, _a1); vertex_texcoord(_vbuff, 0, 0);
                
                vertex_position_3d(_vbuff, _x2 + _nx, _y2 + _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c2, _a2); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x2 - _nx, _y2 - _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c2, _a2); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x1 - _nx, _y1 - _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, _c1, _a1); vertex_texcoord(_vbuff, 0, 0);
                
                _i += 2;
            }
        }
        else
        {
            var _i = 2;
            repeat((array_length(__point_array) div 2) - 1)
            {
                _x1 = _x2;
                _y1 = _y2;
                _x2 = __point_array[_i  ];
                _y2 = __point_array[_i+1];
                
                var _dx = _x2 - _x1;
                var _dy = _y2 - _y1;
                var _d  = __thickness / sqrt(_dx*_dx + _dy*_dy);
                var _nx =  _dy*_d;
                var _ny = -_dx*_d;
                
                vertex_position_3d(_vbuff, _x1 + _nx, _y1 + _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x2 + _nx, _y2 + _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x1 - _nx, _y1 - _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 0);
                
                vertex_position_3d(_vbuff, _x2 + _nx, _y2 + _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x2 - _nx, _y2 - _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 0);
                vertex_position_3d(_vbuff, _x1 - _nx, _y1 - _ny, 0); vertex_normal(_vbuff, 0, 0, 0); vertex_colour(_vbuff, __colour, __alpha); vertex_texcoord(_vbuff, 0, 0);
                
                _i += 2;
            }
        }
        
        return undefined;
    }
}