/// @param left
/// @param top
/// @param right
/// @param bottom

function clean_rectangle(_left, _top, _right, _bottom)
{
    var _struct = new __clean_class_rectangle(_left, _top, _right, _bottom);
    if (is_array(global.__clean_batch)) global.__clean_batch[@ array_length(global.__clean_batch)] = _struct;
    return _struct;
}

function __clean_class_rectangle(_left, _top, _right, _bottom) constructor
{
    __shader = sh_clean_rectangle;
    __format = global.__clean_vertex_format_rectangle;
    
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
    
    __border_thickness = CLEAN_DEFAULT_RECTANGLE_BORDER_THICKNESS;
    __border_colour    = CLEAN_DEFAULT_RECTANGLE_BORDER_COLOUR;
    __border_alpha     = CLEAN_DEFAULT_RECTANGLE_BORDER_ALPHA;
    
    __rounding = CLEAN_DEFAULT_RECTANGLE_ROUNDING;
    
    /// @param color
    /// @param alpha
    blend = function(_colour, _alpha)
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
    blend4 = function(_colour1, _alpha1, _colour2, _alpha2, _colour3, _alpha3, _colour4, _alpha4)
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
    
    border = function(_thickness, _colour, _alpha)
    {
        __border_thickness = _thickness;
        __border_colour    = _colour;
        __border_alpha     = _alpha;
        
        return self;
    }
    
    /// @param radius
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
        var _width  = abs(__right - __left);
        var _height = abs(__bottom - __top);
        var _max    = max(_width, _height);
        
        var _aspect = _width / _height;
        
        var _rounding = 2*__rounding / _max;
        var _border_t = 2*__border_thickness / _max;
        
        //Compress the colour down to 22 bits to fit into the mantissa of a 32-bit float
        //This trims off one bit from the green + blue channels
        //TODO - Oops, this should remove a bit from the red+green channels since the eye is sensitive to blue
        var _border_c  = (((__border_colour >> 17) & 0x7F) << 15)
            _border_c |= (((__border_colour >>  9) & 0x7F) <<  8)
            _border_c |= (__border_colour & 0xFF);
        
        vertex_position_3d(_vbuff, __left , __top   , 0); vertex_normal(_vbuff, _rounding, _border_c, _border_t); vertex_colour(_vbuff, __colour1, __alpha1); vertex_texcoord(_vbuff, _aspect, 0);
        vertex_position_3d(_vbuff, __right, __top   , 1); vertex_normal(_vbuff, _rounding, _border_c, _border_t); vertex_colour(_vbuff, __colour2, __alpha2); vertex_texcoord(_vbuff, _aspect, 0);
        vertex_position_3d(_vbuff, __left , __bottom, 2); vertex_normal(_vbuff, _rounding, _border_c, _border_t); vertex_colour(_vbuff, __colour3, __alpha3); vertex_texcoord(_vbuff, _aspect, 0);
        
        vertex_position_3d(_vbuff, __right, __top   , 1); vertex_normal(_vbuff, _rounding, _border_c, _border_t); vertex_colour(_vbuff, __colour2, __alpha2); vertex_texcoord(_vbuff, _aspect, 0);
        vertex_position_3d(_vbuff, __right, __bottom, 3); vertex_normal(_vbuff, _rounding, _border_c, _border_t); vertex_colour(_vbuff, __colour4, __alpha4); vertex_texcoord(_vbuff, _aspect, 0);
        vertex_position_3d(_vbuff, __left , __bottom, 2); vertex_normal(_vbuff, _rounding, _border_c, _border_t); vertex_colour(_vbuff, __colour3, __alpha3); vertex_texcoord(_vbuff, _aspect, 0);
        
        return undefined;
    }
}