#macro __CLEAN_VERSION  "0.0.0"
#macro __CLEAN_DATE     "2021-02-27"

__CleanTrace("Welcome to Clean Shapes by @jujuadams! This is version ", __CLEAN_VERSION, ", ", __CLEAN_DATE);

global.__cleanBatch = undefined;
global.__cleanSmoothness = CLEAN_DEFAULT_SMOOTHNESS;

global.__clean_u_fSmoothness     = shader_get_uniform(shdCleanCircle, "u_fSmoothness");
global.__clean_u_vInvOutputScale = shader_get_uniform(shdCleanCircle, "u_vInvOutputScale");

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_colour();
vertex_format_add_texcoord();
global.__cleanVertexFormatPolyline = vertex_format_end();

vertex_format_begin();                                            //LINE:                CIRCLE:                     CONVEX:
vertex_format_add_position_3d();                                  //XY, type             XY, type                    XY, type
vertex_format_add_normal();                                       //x1, y1, x2           Unused                      First boundary
vertex_format_add_colour();                                       //Colour               Fill colour                 Fill colour
vertex_format_add_custom(vertex_type_float3, vertex_usage_color); //y2, x3, y3           Ring thickness, unused      Second boundary
vertex_format_add_custom(vertex_type_float4, vertex_usage_color); //Thickness, unused    Border colour               Border colour
vertex_format_add_texcoord();                                     //Cap, join            Unused, Border thickness    Rounding, border thickness
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
    if (!is_array(global.__cleanBatch)) //Ignore draw calls if we're in a batch
    {
        //Find the inverse scale of our output surface
        //These values are passed in our shader and are used for resolution independent rendering
        var _invScale = TargetCurrentProjectionScale();
        _invScale[@ 0] = 1/_invScale[0];
        _invScale[@ 1] = 1/_invScale[1];
        
        var _vbuff = vertex_create_buffer();
        vertex_begin(_vbuff, __format);
        Build(_vbuff);
        vertex_end(_vbuff);
        shader_set(__shader);
        shader_set_uniform_f(global.__clean_u_fSmoothness, global.__cleanSmoothness);
        shader_set_uniform_f(global.__clean_u_vInvOutputScale, _invScale[0], _invScale[1]);
        vertex_submit(_vbuff, pr_trianglelist, -1);
        shader_reset();
        vertex_delete_buffer(_vbuff);
    }
    
    return undefined;
}