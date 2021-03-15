/// @param controlPointArray
/// @param segments

function CleanSpline(_controlArray, _segments)
{
    var _controlPoints = array_length(_controlArray);
    
    var _points = _segments + 1;
    var _pointArray = array_create(2*_points);
    
    var _incr = 1/_segments;
    var _t = 0;
    var _i = 0;
    
    if ((_controlPoints mod 2) != 0)
    {
        __CleanError("There must be an even number of elements in the control point array (x/y pairs)");
    }
    else if (_controlPoints < 4)
    {
        __CleanError("Insufficient control points specified");
    }
    else if (_controlPoints == 4)
    {
        //Basic straight line
        
        var _x0 = _controlArray[0];
        var _y0 = _controlArray[1];
        var _x1 = _controlArray[2];
        var _y1 = _controlArray[3];
        
        repeat(_points)
        {
            _pointArray[@ _i  ] = lerp(_x0,  _x1,  _t);
            _pointArray[@ _i+1] = lerp(_y0,  _y1,  _t);
            
            _i += 2;
            _t += _incr;
        }
    }
    else if (_controlPoints == 6)
    {
        //Quadratic curve
        
        var _x0 = _controlArray[0];
        var _y0 = _controlArray[1];
        var _x1 = _controlArray[2];
        var _y1 = _controlArray[3];
        var _x2 = _controlArray[4];
        var _y2 = _controlArray[5];
        
        repeat(_points)
        {
            var _x01 = lerp(_x0,  _x1,  _t);
            var _x12 = lerp(_x1,  _x2,  _t);
            var _x   = lerp(_x01, _x12, _t);
            
            var _y01 = lerp(_y0,  _y1,  _t);
            var _y12 = lerp(_y1,  _y2,  _t);
            var _y   = lerp(_y01, _y12, _t);
            
            _pointArray[@ _i  ] = _x;
            _pointArray[@ _i+1] = _y;
            
            _i += 2;
            _t += _incr;
        }
    }
    else if (_controlPoints == 8)
    {
        //Cubic curve
        
        var _x0 = _controlArray[0];
        var _y0 = _controlArray[1];
        var _x1 = _controlArray[2];
        var _y1 = _controlArray[3];
        var _x2 = _controlArray[4];
        var _y2 = _controlArray[5];
        var _x3 = _controlArray[6];
        var _y3 = _controlArray[7];
        
        repeat(_points)
        {
            var _x01   = lerp(_x0,    _x1,    _t);
            var _x12   = lerp(_x1,    _x2,    _t);
            var _x23   = lerp(_x2,    _x3,    _t);
            var _x0112 = lerp(_x01,   _x12,   _t);
            var _x1223 = lerp(_x12,   _x23,   _t);
            var _x     = lerp(_x0112, _x1223, _t);
            
            var _y01   = lerp(_y0,    _y1,    _t);
            var _y12   = lerp(_y1,    _y2,    _t);
            var _y23   = lerp(_y2,    _y3,    _t);
            var _y0112 = lerp(_y01,   _y12,   _t);
            var _y1223 = lerp(_y12,   _y23,   _t);
            var _y     = lerp(_y0112, _y1223, _t);
            
            _pointArray[@ _i  ] = _x;
            _pointArray[@ _i+1] = _y;
            
            _i += 2;
            _t += _incr;
        }
    }
    else
    {
        repeat(_points)
        {
            var _result = __CleanSplineInterpolate(_controlArray, _t);
            _pointArray[@ _i  ] = _result[0];
            _pointArray[@ _i+1] = _result[1];
            
            _i += 2;
            _t += _incr;
        }
    }
    
    return CleanPolyline(_pointArray);
}

global.__cleanSplineArray = [];

function __CleanSplineInterpolate(_array, _time)
{
    var _result = global.__cleanSplineArray;
    
    if (_time <= 0.0)
    {
        _result[@ 0] = _array[0];
        _result[@ 1] = _array[1];
        return _result;
    }
    
    var _length = array_length(_array);
    
    if (_time >= 1.0)
    {
        _result[@ 0] = _array[_length-2];
        _result[@ 1] = _array[_length-1];
        return _result;
    }
    
    if (_result == undefined) _result = array_create(_length);
    array_resize(_result, _length);
    array_copy(_result, 0, _array, 0, _length);
    
    var _count = _length div 2;
    repeat(_count)
    {
        --_count;
        __CleanSplineReduce(_time, _result, _count);
    }
    
    return _result;
}

function __CleanSplineReduce(_time, _array, _count)
{
    var _x1 = undefined;
    var _y1 = undefined;
    var _x2 = _array[0];
    var _y2 = _array[1];
    
    var _i = 0;
    var _j = 2;
    repeat(_count)
    {
        _x1 = _x2;
        _y1 = _y2;
        _x2 = _array[_j];
        _y2 = _array[_j+1];
        
        _array[@ _i  ] = lerp(_x1, _x2, _time);
        _array[@ _i+1] = lerp(_y1, _y2, _time);
        
        _i = _j;
        _j += 2;
    }
}