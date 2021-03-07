function CleanBatchEnd()
{
    var _batchArray = global.__cleanBatch;
    
    if (!is_array(_batchArray))
    {
        __CleanError("Cannot end a batch, no batch started");
        exit;
    }
    
    var _shader = undefined;
    var _format = undefined;
    var _vbuff  = undefined;
    
    //Find the inverse scale of our output surface
    //These values are passed in our shader and are used for resolution independent rendering
    var _surface = surface_get_target();
    if (_surface >= 0)
    {
        var _surfaceWidth  = surface_get_width( _surface);
        var _surfaceHeight = surface_get_height(_surface);
    }
    else
    {
        var _surfaceWidth  = window_get_width();
        var _surfaceHeight = window_get_height();
    }
    
    var _invScale = matrix_transform_vertex(matrix_get(matrix_projection), 0.5*_surfaceWidth, -0.5*_surfaceHeight, 0);
    _invScale[@ 0] = abs(1/_invScale[0]);
    _invScale[@ 1] = abs(1/_invScale[1]);
    
    var _i = 0;
    repeat(array_length(_batchArray))
    {
        var _struct = _batchArray[_i];
        
        //If our shader/format aren't defined then set those straight away
        if (_shader == undefined) _shader = _struct.__shader;
        if (_format == undefined) _format = _struct.__format;
        
        //If our shader/format has changed versus what they were then submit this vertex buffer
        if ((_shader != _struct.__shader) || (_format != _struct.__format))
        {
            if (_shader == undefined) shader_reset() else shader_set(_shader);
            vertex_end(_vbuff);
            shader_set_uniform_f(global.__clean_u_fSmoothness, global.__cleanSmoothness);
            shader_set_uniform_f(global.__clean_u_vInvOutputScale, _invScale[0], _invScale[1]);
            vertex_submit(_vbuff, pr_trianglelist, -1);
            vertex_delete_buffer(_vbuff);
            _vbuff = undefined;
            
            _shader = _struct.__shader;
            _format = _struct.__format;
        }
        
        //If we have no current vertex buffer, create a new one
        if (_vbuff == undefined)
        {
            _vbuff = vertex_create_buffer();
            vertex_begin(_vbuff, _format);
        }
        
        _struct.Build(_vbuff);
        
        ++_i;
    }
    
    //If we have a vertex buffer that still needs to be submitted, do that now
    if (_vbuff != undefined)
    {
        if (_shader == undefined) shader_reset() else shader_set(_shader);
        vertex_end(_vbuff);
        shader_set_uniform_f(global.__clean_u_fSmoothness, global.__cleanSmoothness);
        shader_set_uniform_f(global.__clean_u_vInvOutputScale, _invScale[0], _invScale[1]);
        vertex_submit(_vbuff, pr_trianglelist, -1);
        vertex_delete_buffer(_vbuff);
        _vbuff = undefined;
    }
    
    //If we have a shader set, unset it!
    if (_shader != undefined)
    {
        shader_reset();
        _shader = undefined;
    }
    
    global.__cleanBatch = undefined;
}