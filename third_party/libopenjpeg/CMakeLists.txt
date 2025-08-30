CMAKE_MINIMUM_REQUIRED (VERSION 3.31 FATAL_ERROR)
project(openjpeg
    VERSION 2.5.3
    DESCRIPTION "Open-source JPEG 2000 library"
    HOMEPAGE_URL "https://github.com/OlexiyKhokhlov/pdfium"
    LANGUAGES C
)

set(SOURCES
    bio.c
    cio.c
    dwt.c
    event.c
    function_list.c
    ht_dec.c
    image.c
    invert.c
    j2k.c
    jp2.c
    mct.c
    mqc.c
    openjpeg.c
    # NOTE: libopenjpeg/opj_clock.c is not used.
    opj_malloc.cc
    opj_malloc.h
    pi.c
    sparse_array.c
    sparse_array.h
    t1.c
    t1_ht_luts.h
    t2.c
    tcd.c
    tgt.c
    thread.c
)

add_library(openjpeg STATIC ${SOURCES})
target_compile_definitions(openjpeg PUBLIC OPJ_STATIC)
target_include_directories(openjpeg PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../..)
set_target_properties(openjpeg PROPERTIES POSITION_INDEPENDENT_CODE ON)

set_property(TARGET openjpeg PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)

add_library(OpenJpeg::OpenJpeg ALIAS openjpeg)
