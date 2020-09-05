function clean_batch_end()
{
    if (!is_array(global.__clean_batch))
    {
        __clean_error("Cannot end a batch, no batch started");
        exit;
    }
    
    var _shader = undefined;
    var _format = undefined;
    var _vbuff  = undefined;
    
    var _i = 0;
    repeat(array_length(global.__clean_batch))
    {
        var _struct = global.__clean_batch[_i];
        
        //If our shader/format aren't defined then set those straight away
        if (_shader == undefined) _shader = _struct.__shader;
        if (_format == undefined) _format = _struct.__format;
        
        //If our shader/format has changed versus what they were then submit this vertex buffer
        if ((_shader != _struct.__shader) || (_format != _struct.__format))
        {
            if (_shader == undefined) shader_reset() else shader_set(_shader);
            vertex_end(_vbuff);
            shader_set_uniform_f(global.__clean_u_fSmoothness, global.__clean_smoothness);
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
        
        _struct.build(_vbuff);
        
        ++_i;
    }
    
    //If we have a vertex buffer that still needs to be submitted, do that now
    if (_vbuff != undefined)
    {
        if (_shader == undefined) shader_reset() else shader_set(_shader);
        vertex_end(_vbuff);
        shader_set_uniform_f(global.__clean_u_fSmoothness, global.__clean_smoothness);
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
    
    global.__clean_batch = undefined;
}