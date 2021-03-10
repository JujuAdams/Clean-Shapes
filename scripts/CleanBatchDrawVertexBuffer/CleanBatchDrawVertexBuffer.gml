/// @param vertexBuffer
/// @param [destroyVertexBuffer]

function CleanBatchDrawVertexBuffer()
{
    var _vertexBuffer = argument[0];
    var _destroyAfter = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : false;
    
    if (global.__cleanAntialias)
    {
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
        
        shader_set(__shdCleanAntialias);
        shader_set_uniform_f(global.__clean_u_vOutputSize, _surfaceWidth, _surfaceHeight);
    }
    else
    {
        shader_set(__shdCleanJaggies);
    }
    
    vertex_submit(_vertexBuffer, pr_trianglelist, -1);
    shader_reset();
    
    if (_destroyAfter) vertex_delete_buffer(_vertexBuffer);
}