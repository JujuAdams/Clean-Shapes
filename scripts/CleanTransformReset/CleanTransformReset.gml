function CleanTransformReset()
{
    global.__cleanMatrixIdentity = true;
    
    global.__cleanMatrix = matrix_build_identity();
}