

#region Interal Macros

#macro __CLEAN_VERSION  "0.0.0"
#macro __CLEAN_DATE     "2020-08-29"

__clean_trace("Welcome to Clean Shapes by @jujuadams! This is version ", __CLEAN_VERSION, ", ", __CLEAN_DATE);

global.__clean_batch = undefined;

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_colour();
vertex_format_add_texcoord();
global.__clean_vertex_format_polyline = vertex_format_end();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_colour();
vertex_format_add_texcoord();
global.__clean_vertex_format_polygon = vertex_format_end();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_colour();
vertex_format_add_texcoord();
global.__clean_vertex_format_circle = vertex_format_end();

/// @param [value...]
function __clean_trace()
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
function __clean_error()
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

function __clean_draw()
{
    if (!is_array(global.__clean_batch)) //Ignore draw calls if we're in a batch
    {
        var _vbuff = vertex_create_buffer();
        vertex_begin(_vbuff, __format);
        build(_vbuff);
        vertex_end(_vbuff);
        shader_set(__shader);
        vertex_submit(_vbuff, pr_trianglelist, -1);
        shader_reset();
        vertex_delete_buffer(_vbuff);
    }
    
    return undefined;
}

#endregion