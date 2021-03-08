#macro __CLEAN_VERSION  "1.0.1 alpha"
#macro __CLEAN_DATE     "2021-03-08"

__CleanTrace("Welcome to Clean Shapes by @jujuadams! This is version ", __CLEAN_VERSION, ", ", __CLEAN_DATE);

global.__cleanBatch     = undefined;
global.__cleanAntialias = CLEAN_DEFAULT_ANTIALIAS;

global.__clean_u_vInvOutputScale = shader_get_uniform(__shdCleanAntialias, "u_vInvOutputScale");

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
        __CleanSubmit(_vbuff);
        vertex_delete_buffer(_vbuff);
    }
    
    return undefined;
}

function __CleanSubmit(_vbuff)
{
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
        
        var _invScale = matrix_transform_vertex(matrix_get(matrix_projection), 0.5*_surfaceWidth, 0.5*_surfaceHeight, 0);
        _invScale[@ 0] = abs(1/_invScale[0]);
        _invScale[@ 1] = abs(1/_invScale[1]);
        
        shader_set(__shdCleanAntialias);
        shader_set_uniform_f(global.__clean_u_vInvOutputScale, _invScale[0], _invScale[1]);
    }
    else
    {
        shader_set(__shdCleanJaggies);
    }
    
    vertex_submit(_vbuff, pr_trianglelist, -1);
    shader_reset();
}