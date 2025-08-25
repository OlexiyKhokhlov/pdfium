CMAKE_MINIMUM_REQUIRED (VERSION 3.31 FATAL_ERROR)
project(lcms
    VERSION 2.15
    DESCRIPTION "A lightweight, speed optimized color management engine"
    HOMEPAGE_URL "https://github.com/OlexiyKhokhlov/pdfium"
    LANGUAGES C
)

set(SOURCES
    include/lcms2.h
    include/lcms2_plugin.h
    src/cmsalpha.c
    src/cmscam02.c
    src/cmscgats.c
    src/cmscnvrt.c
    src/cmserr.c
    src/cmsgamma.c
    src/cmsgmt.c
    src/cmshalf.c
    src/cmsintrp.c
    src/cmsio0.c
    src/cmsio1.c
    src/cmslut.c
    src/cmsmd5.c
    src/cmsmtrx.c
    src/cmsnamed.c
    src/cmsopt.c
    src/cmspack.c
    src/cmspcs.c
    src/cmsplugin.c
    src/cmsps2.c
    src/cmssamp.c
    src/cmssm.c
    src/cmstypes.c
    src/cmsvirt.c
    src/cmswtpnt.c
    src/cmsxform.c
)

add_library(lcms STATIC ${SOURCES})
set_target_properties(lcms PROPERTIES POSITION_INDEPENDENT_CODE ON)
target_include_directories(lcms PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../..)
set_property(TARGET lcms PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)

add_library(LCMS::lcms ALIAS lcms)
