function CleanBatchEnd()
{
    var _batchArray = global.__cleanBatch;
    
    if (!is_array(_batchArray))
    {
        __CleanError("Cannot end a batch, no batch started");
        exit;
    }
    
    //Don't bother doing anything if our batch is empty
    if (array_length(_batchArray) <= 0)
    {
        global.__cleanBatch = undefined;
        exit;
    }
    
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
    
    var _vbuff = vertex_create_buffer();
    vertex_begin(_vbuff, global.__cleanVertexFormat);
    
    var _i = 0;
    repeat(array_length(_batchArray))
    {
        _batchArray[_i].Build(_vbuff);
        ++_i;
    }
    
    vertex_end(_vbuff);
    
    if (global.__cleanAntialias)
    {
        shader_set(__shdCleanAntialias);
        shader_set_uniform_f(global.__clean_u_vInvOutputScale, _invScale[0], _invScale[1]);
    }
    else
    {
        shader_set(__shdCleanJaggies);
    }
    
    vertex_submit(_vbuff, pr_trianglelist, -1);
    shader_reset();
    vertex_delete_buffer(_vbuff);
    
    global.__cleanBatch = undefined;
}