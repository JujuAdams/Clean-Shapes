#macro CLEAN_DEFAULT_LINE_COLOUR                 draw_get_colour()
#macro CLEAN_DEFAULT_LINE_ALPHA                  draw_get_alpha()
#macro CLEAN_DEFAULT_LINE_START_CAP              "round"
#macro CLEAN_DEFAULT_LINE_END_CAP                "round"
#macro CLEAN_DEFAULT_LINE_THICKNESS              10

#macro CLEAN_DEFAULT_RECTANGLE_COLOUR            draw_get_colour()
#macro CLEAN_DEFAULT_RECTANGLE_ALPHA             draw_get_alpha()
#macro CLEAN_DEFAULT_RECTANGLE_BORDER_THICKNESS  3
#macro CLEAN_DEFAULT_RECTANGLE_BORDER_COLOUR     c_white
#macro CLEAN_DEFAULT_RECTANGLE_BORDER_ALPHA      draw_get_alpha()
#macro CLEAN_DEFAULT_RECTANGLE_ROUNDING          10

#macro CLEAN_DEFAULT_CIRCLE_COLOUR               draw_get_colour()
#macro CLEAN_DEFAULT_CIRCLE_ALPHA                draw_get_alpha()
#macro CLEAN_DEFAULT_CIRCLE_RING_THICKNESS       0
#macro CLEAN_DEFAULT_CIRCLE_BORDER_THICKNESS     10
#macro CLEAN_DEFAULT_CIRCLE_BORDER_COLOUR        c_white
#macro CLEAN_DEFAULT_CIRCLE_BORDER_ALPHA         draw_get_alpha()

#macro CLEAN_DEFAULT_TRIANGLE_COLOUR             draw_get_colour()
#macro CLEAN_DEFAULT_TRIANGLE_ALPHA              draw_get_alpha()
#macro CLEAN_DEFAULT_TRIANGLE_BORDER_THICKNESS   3
#macro CLEAN_DEFAULT_TRIANGLE_BORDER_COLOUR      c_white
#macro CLEAN_DEFAULT_TRIANGLE_BORDER_ALPHA       draw_get_alpha()
#macro CLEAN_DEFAULT_TRIANGLE_ROUNDING           10

#macro CLEAN_DEFAULT_POLYLINE_COLOUR             draw_get_colour()
#macro CLEAN_DEFAULT_POLYLINE_ALPHA              draw_get_alpha()
#macro CLEAN_DEFAULT_POLYLINE_START_CAP          "round"
#macro CLEAN_DEFAULT_POLYLINE_END_CAP            "round"
#macro CLEAN_DEFAULT_POLYLINE_THICKNESS          20

#macro CLEAN_DEFAULT_CONVEX_COLOUR               draw_get_colour()
#macro CLEAN_DEFAULT_CONVEX_ALPHA                draw_get_alpha()
#macro CLEAN_DEFAULT_CONVEX_BORDER_THICKNESS     3
#macro CLEAN_DEFAULT_CONVEX_BORDER_COLOUR        c_white
#macro CLEAN_DEFAULT_CONVEX_BORDER_ALPHA         draw_get_alpha()
#macro CLEAN_DEFAULT_CONVEX_ROUNDING             10















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
global.__clean_vertex_format_rectangle = vertex_format_end();

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