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
    
    var _vbuff = vertex_create_buffer();
    vertex_begin(_vbuff, global.__cleanVertexFormat);
    
    var _i = 0;
    repeat(array_length(_batchArray))
    {
        _batchArray[_i].__Build(_vbuff);
        ++_i;
    }
    
    vertex_end(_vbuff);
    __CleanSubmit(_vbuff);
    vertex_delete_buffer(_vbuff);
    
    global.__cleanBatch = undefined;
}