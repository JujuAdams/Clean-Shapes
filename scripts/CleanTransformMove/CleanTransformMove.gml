/// @param xOffset
/// @param yOfFset

function CleanTransformMove(_xOffset, _yOffset)
{
    global.__cleanMatrixIdentity = false;
    
    global.__cleanMatrix = matrix_multiply(global.__cleanMatrix, matrix_build(_xOffset, _yOffset, 0,   0,0,0,   1,1,1));
}