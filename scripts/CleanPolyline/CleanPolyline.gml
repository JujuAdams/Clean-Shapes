/// @param pointArray

function CleanPolyline(_array)
{
    return new __CleanClassPolyline(_array);
}

function __CleanClassPolyline(_array) constructor
{
    if (!is_array(_array)) __CleanError("Invalid datatype given for argument0 (", typeof(_array), "), was expecting an array");
    if ((array_length(_array) mod 2) != 0) __CleanError("Points array must have an even number of elements (x/y pairs)");
    
    __pointArray = _array;
    __colour     = CLEAN_DEFAULT_POLYLINE_COLOUR;
    __alpha      = CLEAN_DEFAULT_POLYLINE_ALPHA;
    __blendArray = undefined;
    
    __thickness = CLEAN_DEFAULT_POLYLINE_THICKNESS;
    
    __join     = CLEAN_DEFAULT_POLYLINE_JOIN;
    __capStart = CLEAN_DEFAULT_POLYLINE_START_CAP;
    __capEnd   = CLEAN_DEFAULT_POLYLINE_END_CAP;
    
    /// @param color
    /// @param alpha
    static Blend = function(_colour, _alpha)
    {
        __colour = _colour;
        __alpha  = _alpha;
        
        return self;
    }
    
    /// @param blendArray
    static BlendExt = function(_array)
    {
        if (!is_array(_array)) __CleanError("Invalid datatype given for argument0 (", typeof(_array), "), was expecting an array");
        if ((array_length(_array) mod 2) != 0) __CleanError("Blend array must have an even number of elements (RGB/alpha pairs)");
        
        __colour     = undefined;
        __alpha      = undefined;
        __blendArray = _array;
        
        return self;
    }
    
    static Thickness = function(_thickness)
    {
        __thickness = _thickness;
        
        return self;
    }
    
    /// @param startType
    /// @param endType
    static Cap = function(_cap_start, _cap_end)
    {
        __capStart = _cap_start;
        __capEnd   = _cap_end;
        
        return self;
    }
    
    /// @param type
    static Join = function(_join)
    {
        __join = _join;
        
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
        var _thickness  = __thickness;
        var _pointArray = __pointArray;
        var _blendArray = __blendArray;
        
        var _capStart = 5; //Default to rounded lines
        if (__capStart == "none"  ) _capStart = 3;
        if (__capStart == "square") _capStart = 4;
        if ((__capStart == "closed") || (__capEnd == "closed")) _capStart = undefined;
        
        if (_capStart == undefined)
        {
            var _capEnd = undefined;
        }
        else
        {
            var _capEnd = 5; //Default to rounded lines
            if (__capEnd == "none"  ) _capEnd = 3;
            if (__capEnd == "square") _capEnd = 4;
        }
        
        var _join = 9; //Default to rounded joints
        if (__join == "miter") _join = 7;
        if (__join == "mitre") _join = 7;
        if (__join == "bevel") _join = 8;
        
        if (!is_array(_blendArray))
        {
            #region Uniform colour/alpha
            
            var _colour = __colour;
            var _alpha  = __alpha;
            
            var _px1 = undefined;
            var _py1 = undefined;
            var _px2 = _pointArray[0];
            var _py2 = _pointArray[1];
            var _px3 = _pointArray[2];
            var _py3 = _pointArray[3];
            
            //Calculate the size of the cap
            var _dx1 = undefined;
            var _dy1 = undefined;
            var _dx2 = _px3 - _px2;
            var _dy2 = _py3 - _py2;
            var _inv_length = 1 / sqrt(_dx2*_dx2 + _dy2*_dy2);
            var _nx1 = undefined;
            var _ny1 = undefined;
            var _nx2 = _dx2*_inv_length;
            var _ny2 = _dy2*_inv_length;
            _dx2 *= 0.5*_thickness*_inv_length;
            _dy2 *= 0.5*_thickness*_inv_length;
            
            var _x1 = undefined;
            var _y1 = undefined;
            var _x2 = undefined;
            var _y2 = undefined;
            var _x3 = _px2 - _dx2 - _dy2;
            var _y3 = _py2 - _dy2 + _dx2;
            var _x4 = _px2 - _dx2 + _dy2;
            var _y4 = _py2 - _dy2 - _dx2;
            var _x5 = 0.5*(_px2 + _px3) - _dy2;
            var _y5 = 0.5*(_py2 + _py3) + _dx2;
            var _x6 = 0.5*(_px2 + _px3) + _dy2;
            var _y6 = 0.5*(_py2 + _py3) - _dx2;
            
            if (_capStart != undefined)
            {
                vertex_position_3d(_vbuff, _x3, _y3, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x5, _y5, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x6, _y6, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                
                vertex_position_3d(_vbuff, _x3, _y3, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x6, _y6, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            }
            
            
            
            //Points along the line
            var _arraySize = array_length(_pointArray);
            var _count = _arraySize div 2;
            if (_capStart != undefined) _count -= 2;
            
            var _i = 4;
            repeat(_count)
            {
                var _j = _i mod _arraySize;
                
                _px1 = _px2;
                _py1 = _py2;
                _px2 = _px3;
                _py2 = _py3;
                _px3 = _pointArray[_j  ];
                _py3 = _pointArray[_j+1];
                
                _dx1 = _dx2;
                _dy1 = _dy2;
                _nx1 = _nx2;
                _ny1 = _ny2;
                
                _dx2 = _px3 - _px2;
                _dy2 = _py3 - _py2;
                _inv_length = 1 / sqrt(_dx2*_dx2 + _dy2*_dy2);
                _nx2 = _dx2*_inv_length;
                _ny2 = _dy2*_inv_length;
                _dx2 *= 0.5*_thickness*_inv_length;
                _dy2 *= 0.5*_thickness*_inv_length;
                
                //TODO - Is there a smart way of doing this?
                var _cross = _nx1*_ny2 - _ny1*_nx2;
                var _sigma = (_cross == 0.0)? 0.0 : ((_nx1*_nx2 + _ny1*_ny2 - 1) / _cross);
                var _dx3 = _sigma*_dx1;
                var _dy3 = _sigma*_dy1;
                
                _x1 = _x5;
                _y1 = _y5;
                _x2 = _x6;
                _y2 = _y6;
                _x3 = _px2 - _dy1 + _dx3;
                _y3 = _py2 + _dx1 + _dy3;
                _x4 = _px2 + _dy1 - _dx3;
                _y4 = _py2 - _dx1 - _dy3;
                _x5 = 0.5*(_px2 + _px3) - _dy2;
                _y5 = 0.5*(_py2 + _py3) + _dx2;
                _x6 = 0.5*(_px2 + _px3) + _dy2;
                _y6 = 0.5*(_py2 + _py3) - _dx2;
                
                //AB midpoint to B
                vertex_position_3d(_vbuff, _x1, _y1, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x3, _y3, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                
                vertex_position_3d(_vbuff, _x1, _y1, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x2, _y2, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                
                //B to BC midpoint
                vertex_position_3d(_vbuff, _x3, _y3, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x5, _y5, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x6, _y6, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                
                vertex_position_3d(_vbuff, _x3, _y3, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x6, _y6, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                
                _i += 2;
            }
            
            
            
            if (_capEnd != undefined)
            {
                //Calculate the size of the cap
                var _dx2 = _px3 - _px2;
                var _dy2 = _py3 - _py2;
                var _inv_length = 1 / sqrt(_dx2*_dx2 + _dy2*_dy2);
                _dx2 *= 0.5*_thickness*_inv_length;
                _dy2 *= 0.5*_thickness*_inv_length;
                
                var _x1 = _x5;
                var _y1 = _y5;
                var _x2 = _x6;
                var _y2 = _y6;
                var _x3 = _px3 + _dx2 - _dy2;
                var _y3 = _py3 + _dy2 + _dx2;
                var _x4 = _px3 + _dx2 + _dy2;
                var _y4 = _py3 + _dy2 - _dx2;
                
                vertex_position_3d(_vbuff, _x1, _y1, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x3, _y3, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                
                vertex_position_3d(_vbuff, _x1, _y1, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x2, _y2, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _colour, _alpha); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            }
            
            #endregion
        }
        else
        {
            #region Variable colour/alpha
            
            var _px1 = undefined;
            var _py1 = undefined;
            var _px2 = _pointArray[0];
            var _py2 = _pointArray[1];
            var _px3 = _pointArray[2];
            var _py3 = _pointArray[3];
            
            //Calculate the size of the cap
            var _dx1 = undefined;
            var _dy1 = undefined;
            var _dx2 = _px3 - _px2;
            var _dy2 = _py3 - _py2;
            var _inv_length = 1 / sqrt(_dx2*_dx2 + _dy2*_dy2);
            var _nx1 = undefined;
            var _ny1 = undefined;
            var _nx2 = _dx2*_inv_length;
            var _ny2 = _dy2*_inv_length;
            _dx2 *= 0.5*_thickness*_inv_length;
            _dy2 *= 0.5*_thickness*_inv_length;
            
            var _x1 = undefined;
            var _y1 = undefined;
            var _x2 = undefined;
            var _y2 = undefined;
            var _x3 = _px2 - _dx2 - _dy2;
            var _y3 = _py2 - _dy2 + _dx2;
            var _x4 = _px2 - _dx2 + _dy2;
            var _y4 = _py2 - _dy2 - _dx2;
            var _x5 = 0.5*(_px2 + _px3) - _dy2;
            var _y5 = 0.5*(_py2 + _py3) + _dx2;
            var _x6 = 0.5*(_px2 + _px3) + _dy2;
            var _y6 = 0.5*(_py2 + _py3) - _dx2;
            
            var _c1 = _blendArray[0];
            var _a1 = _blendArray[1];
            var _c2 = _blendArray[2];
            var _a2 = _blendArray[3];
            
            var _c01 = undefined;
            var _a01 = undefined;
            var _c12 = merge_colour(_c1, _c2, 0.5);
            var _a12 = 0.5*(_a1 + _a2);
            
            if (_capStart != undefined)
            {
                vertex_position_3d(_vbuff, _x3, _y3, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c1,  _a1 ); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x5, _y5, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x6, _y6, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                
                vertex_position_3d(_vbuff, _x3, _y3, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c1 , _a1 ); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x6, _y6, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _capStart); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c1 , _a1 ); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            }
            
            
            
            //Points along the line
            var _arraySize = array_length(_pointArray);
            var _count = _arraySize div 2;
            if (_capStart != undefined) _count -= 2;
            
            var _i = 4;
            repeat(_count)
            {
                var _j = _i mod _arraySize;
                
                _px1 = _px2;
                _py1 = _py2;
                _px2 = _px3;
                _py2 = _py3;
                _px3 = _pointArray[_j  ];
                _py3 = _pointArray[_j+1];
                
                _dx1 = _dx2;
                _dy1 = _dy2;
                _nx1 = _nx2;
                _ny1 = _ny2;
                
                _dx2 = _px3 - _px2;
                _dy2 = _py3 - _py2;
                _inv_length = 1 / sqrt(_dx2*_dx2 + _dy2*_dy2);
                _nx2 = _dx2*_inv_length;
                _ny2 = _dy2*_inv_length;
                _dx2 *= 0.5*_thickness*_inv_length;
                _dy2 *= 0.5*_thickness*_inv_length;
                
                //TODO - Is there a smart way of doing this?
                var _cross = _nx1*_ny2 - _ny1*_nx2;
                var _sigma = (_cross == 0.0)? 0.0 : ((_nx1*_nx2 + _ny1*_ny2 - 1) / _cross);
                var _dx3 = _sigma*_dx1;
                var _dy3 = _sigma*_dy1;
                
                _x1 = _x5;
                _y1 = _y5;
                _x2 = _x6;
                _y2 = _y6;
                _x3 = _px2 - _dy1 + _dx3;
                _y3 = _py2 + _dx1 + _dy3;
                _x4 = _px2 + _dy1 - _dx3;
                _y4 = _py2 - _dx1 - _dy3;
                _x5 = 0.5*(_px2 + _px3) - _dy2;
                _y5 = 0.5*(_py2 + _py3) + _dx2;
                _x6 = 0.5*(_px2 + _px3) + _dy2;
                _y6 = 0.5*(_py2 + _py3) - _dx2;
                
                _c1 = _c2;
                _a1 = _a2;
                _c2 = _blendArray[_j  ];
                _a2 = _blendArray[_j+1];
                
                _c01 = _c12;
                _a01 = _a12;
                _c12 = merge_colour(_c1, _c2, 0.5);
                _a12 = 0.5*(_a1 + _a2);
                
                //AB midpoint to B
                vertex_position_3d(_vbuff, _x1, _y1, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c01, _a01); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x3, _y3, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c1 , _a1 ); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c1 , _a1 ); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                                                                                                                            
                vertex_position_3d(_vbuff, _x1, _y1, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c01, _a01); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c1 , _a1 ); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x2, _y2, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c01, _a01); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                
                //B to BC midpoint
                vertex_position_3d(_vbuff, _x3, _y3, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c1,  _a1 ); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x5, _y5, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x6, _y6, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                                                                                                                            
                vertex_position_3d(_vbuff, _x3, _y3, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c1 , _a1 ); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x6, _y6, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _join); vertex_normal(_vbuff, _px1, _py1, _px3); vertex_colour(_vbuff, _c1 , _a1 ); vertex_float3(_vbuff, _px2, _py2, _py3); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                
                _i += 2;
            }
            
            
            
            if (_capEnd != undefined)
            {
                //Calculate the size of the cap
                var _dx2 = _px3 - _px2;
                var _dy2 = _py3 - _py2;
                var _inv_length = 1 / sqrt(_dx2*_dx2 + _dy2*_dy2);
                _dx2 *= 0.5*_thickness*_inv_length;
                _dy2 *= 0.5*_thickness*_inv_length;
                
                var _x1 = _x5;
                var _y1 = _y5;
                var _x2 = _x6;
                var _y2 = _y6;
                var _x3 = _px3 + _dx2 - _dy2;
                var _y3 = _py3 + _dy2 + _dx2;
                var _x4 = _px3 + _dx2 + _dy2;
                var _y4 = _py3 + _dy2 - _dx2;
                
                vertex_position_3d(_vbuff, _x1, _y1, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x3, _y3, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c2,  _a2 ); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c2,  _a2 ); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                
                vertex_position_3d(_vbuff, _x1, _y1, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x4, _y4, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c2,  _a2 ); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
                vertex_position_3d(_vbuff, _x2, _y2, _capEnd); vertex_normal(_vbuff, _px2, _py2, 0); vertex_colour(_vbuff, _c12, _a12); vertex_float3(_vbuff, _px3, _py3, 0); vertex_float4(_vbuff, 0, 0, 0, 0); vertex_texcoord(_vbuff, _thickness, 0);
            }
            
            #endregion
        }
    }
}