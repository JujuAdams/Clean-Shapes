#macro __CLEAN_VERSION  "1.0.5 alpha"
#macro __CLEAN_DATE     "2021-03-14"

__CleanTrace("Welcome to Clean Shapes by @jujuadams! This is version ", __CLEAN_VERSION, ", ", __CLEAN_DATE);

global.__cleanBatch     = undefined;
global.__cleanAntialias = CLEAN_DEFAULT_ANTIALIAS;

global.__cleanMatrixIdentity = false;
global.__cleanMatrix         = matrix_build_identity();
global.__cleanMatrixOriginX  = 0;
global.__cleanMatrixOriginY  = 0;

global.__clean_u_vOutputSize = shader_get_uniform(__shdCleanAntialias, "u_vOutputSize");

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_colour();
vertex_format_add_custom(vertex_type_float3, vertex_usage_color);
vertex_format_add_custom(vertex_type_float4, vertex_usage_color);
vertex_format_add_texcoord();
global.__cleanVertexFormat = vertex_format_end();

/// @param [value...]
function __CleanTrace()
{
    var _string = "";
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }

    show_debug_message("Clean Shapes: " + _string);

    return _string;
}

/// @param [value...]
function __CleanError()
{
    var _string = "";
    
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_error("Clean Shapes:\n" + _string + "\n ", false);
    
    return _string;
}

function __CleanDraw()
{
    if (is_array(global.__cleanBatch)) //Ignore draw calls if we're in a batch
    {
        array_push(global.__cleanBatch, self);
    }
    else
    {
        var _vbuff = vertex_create_buffer();
        vertex_begin(_vbuff, global.__cleanVertexFormat);
        __Build(_vbuff);
        vertex_end(_vbuff);
        
        CleanBatchDrawVertexBuffer(_vbuff, true);
    }
    
    return undefined;
}

function __CleanIsClockwise(_x1, _y1, _x2, _y2, _x3, _y3)
{
    return (((_x2 - _x1)*(_y3 - _y1) + (_y1 - _y2)*(_x3 - _x1)) > 0);    
}

//Easter Egg!
function draw_cool_s(_x, _y, _size)
{
    CleanTransformOriginSet(2.5, 2.5);
    CleanTransformAddScale(_size/5, _size/5);
    CleanTransformAddMove(_x, _y);
    CleanBatchBegin();
    
    CleanPolyline([2.5, 4,   2.5, 3,   0, 2,   0, 1,   2.5, 0,   5, 1,   5, 2,   3.75, 2.5])
    .Thickness(0.3)
    .Join("miter")
    .Cap("none", "none")
    .Draw();
    
    CleanPolyline([2.5, 1,   2.5, 2,   5, 3,   5, 4,   2.5, 5,   0, 4,   0, 3,   1.25, 2.5])
    .Thickness(0.3)
    .Join("miter")
    .Cap("none", "none")
    .Draw();
    
    CleanBatchEndDraw();
    CleanTransformOriginSet(0, 0);
    CleanTransformReset();
}