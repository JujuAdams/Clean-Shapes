/// @param vertexBuffer
/// @param [destroyVertexBuffer]

function CleanBatchDrawVertexBuffer()
{
    var _vertexBuffer = argument[0];
    var _destroyAfter = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : false;
    
    if (_vertexBuffer == undefined) return undefined;
    
    if (!global.__cleanMatrixIdentity)
    {
        var _oldWorldMatrix = matrix_get(matrix_world);
        
        if ((global.__cleanMatrixOriginX != 0) || (global.__cleanMatrixOriginX != 0))
        {
            var _matrix = matrix_build(-global.__cleanMatrixOriginX, -global.__cleanMatrixOriginY, 0,   0,0,0,   1,1,1);
                _matrix = matrix_multiply(_matrix, global.__cleanMatrix);
                _matrix = matrix_multiply(_matrix, matrix_build(global.__cleanMatrixOriginX, global.__cleanMatrixOriginY, 0,   0,0,0,   1,1,1));
                _matrix = matrix_multiply(_matrix, _oldWorldMatrix);
        }
        else
        {
            var _matrix = matrix_multiply(global.__cleanMatrix, _oldWorldMatrix);
        }
        
        matrix_set(matrix_world, _matrix);
    }
    
    if (global.__cleanAntialias)
    {
        shader_set(__shdCleanAntialias);
    }
    else
    {
        shader_set(__shdCleanJaggies);
    }
    
    vertex_submit(_vertexBuffer, pr_trianglelist, -1);
    shader_reset();
    
    if (!global.__cleanMatrixIdentity) matrix_set(matrix_world, _oldWorldMatrix);
    
    if (_destroyAfter) vertex_delete_buffer(_vertexBuffer);
}