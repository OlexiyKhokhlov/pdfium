CMAKE_MINIMUM_REQUIRED (VERSION 3.31 FATAL_ERROR)
project(agg
    VERSION 2.3
    DESCRIPTION "High quality rendering engine library for C++"
    HOMEPAGE_URL "https://github.com/OlexiyKhokhlov/pdfium"
    LANGUAGES CXX
)

set(SOURCES
    agg_array.h
    agg_basics.h
    agg_clip_liang_barsky.h
    agg_color_gray.h
    agg_conv_adaptor_vcgen.h
    agg_conv_dash.h
    agg_conv_stroke.h
    agg_curves.cpp
    agg_curves.h
    agg_math.h
    agg_math_stroke.h
    agg_path_storage.cpp
    agg_path_storage.h
    agg_pixfmt_gray.h
    agg_rasterizer_scanline_aa.cpp
    agg_rasterizer_scanline_aa.h
    agg_render_scanlines.h
    agg_renderer_base.h
    agg_renderer_scanline.h
    agg_rendering_buffer.h
    agg_scanline_u.h
    agg_shorten_path.h
    agg_vcgen_dash.cpp
    agg_vcgen_dash.h
    agg_vcgen_stroke.cpp
    agg_vcgen_stroke.h
    agg_vertex_sequence.h
)

add_library(agg STATIC ${SOURCES})
set_target_properties(agg PROPERTIES POSITION_INDEPENDENT_CODE ON)
target_include_directories(agg PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../..)
set_property(TARGET agg PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)

add_library(AGG::agg ALIAS agg)
