CMAKE_MINIMUM_REQUIRED (VERSION 3.31 FATAL_ERROR)
project(pdfium
    VERSION 0.0.1
    DESCRIPTION "PDF rendering library"
    HOMEPAGE_URL "https://github.com/OlexiyKhokhlov/pdfium"
    LANGUAGES C CXX
)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

if(WIN32)
    add_definitions(-DWIN32_LEAN_AND_MEAN -DNOMINMAX -DUNICODE)

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /utf-8")
    # set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions -fvisibility=hidden -Wno-return-type")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} -Wl,-z,defs")
endif()

message(STATUS "System: " ${CMAKE_SYSTEM_NAME} " " ${CMAKE_SYSTEM_VERSION})
message(STATUS "Processor: " ${CMAKE_HOST_SYSTEM_PROCESSOR})
message(STATUS "Build type:" ${CMAKE_BUILD_TYPE})
message(STATUS "C++ Standard: " ${CMAKE_CXX_STANDARD})
message(STATUS "CMake generates: " ${CMAKE_GENERATOR})

set(USE_STATIC_LIBRARY OFF CACHE BOOL "Build as static library. Otherwise - shared")

#3dparty libraries
set(USE_SYSTEM_FREETYPE ON CACHE BOOL "Use system freetype")
set(USE_SYSTEM_LCMS2 ON CACHE BOOL "Use system lcms2")
set(USE_SYSTEM_OPENJPEG OFF CACHE BOOL "Use system openjpeg")
set(USE_SYSTEM_FAST_FLOAT OFF CACHE BOOL "Use system fast_float")
set(USE_TURBO_JPEG OFF CACHE BOOL "Use libjpeg-turbo instead of libjpeg")

#hieroglyphs support
set(USE_GB1_MAPS OFF CACHE BOOL "use GB1 maps")
set(USE_CNS1_MAPS OFF CACHE BOOL "use CNS1 maps")
set(USE_JAPAN1_MAPS OFF CACHE BOOL "use JAPAN1 maps")
set(USE_KOREA1_MAPS OFF CACHE BOOL "use KOREA1 maps")

add_subdirectory(third_party/agg23)

if(USE_SYSTEM_FAST_FLOAT)
    find_package(FastFloat 8.0.0 REQUIRED)
else()
    message(STATUS "Use fast_float library from subrepo")
    add_library(FastFloat::fast_float INTERFACE IMPORTED)
    set_target_properties(FastFloat::fast_float PROPERTIES
      INTERFACE_COMPILE_FEATURES "cxx_std_11"
      INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/third_party/fast_float/fast_float/include"
    )
endif()

if(USE_SYSTEM_FREETYPE)
  find_package(Freetype REQUIRED)
  include_directories(${FREETYPE_INCLUDE_DIRS} SYSTEM ${FREETYPE_INCLUDE_DIRS}/freetype)
  add_definitions(-DUSE_SYSTEM_FREETYPE -DDEFINE_PS_TABLES_DATA)
  #add_library(internal_freetype OBJECT empty.c)
# else(USE_SYSTEM_FREETYPE)
#   add_subdirectory(third_party/freetype)
#   include_directories(third_party/freetype/include third_party/freetype/include/freetype)
endif(USE_SYSTEM_FREETYPE)

if(USE_SYSTEM_LCMS2)
  find_package(LCMS2 2.15 REQUIRED)
  include_directories(${LCMS2_INCLUDE_DIRS})
  add_definitions(-DUSE_SYSTEM_LCMS2)
else(USE_SYSTEM_LCMS2)
   add_subdirectory(third_party/lcms)
endif(USE_SYSTEM_LCMS2)

if(USE_SYSTEM_OPENJPEG)
  find_package(OpenJpeg REQUIRED)
  include_directories(${OPENJPEG_INCLUDE_DIR})
  add_definitions(-DUSE_SYSTEM_OPENJPEG)
else(USE_SYSTEM_OPENJPEG)
   add_subdirectory(third_party/libopenjpeg)
endif(USE_SYSTEM_OPENJPEG)

if(USE_TURBO_JPEG)
   find_package(libjpeg-turbo REQUIRED)
   add_definitions(-DUSE_SYSTEM_JPEG)
   add_library(JPEG::JPEG ALIAS libjpeg-turbo::jpeg)
else()
   find_package(JPEG REQUIRED)
   add_definitions(-DUSE_SYSTEM_JPEG)
endif()

find_package(ZLIB REQUIRED)
include_directories(${ZLIB_INCLUDE_DIRS})
add_definitions(-DUSE_SYSTEM_ZLIB)

if(WIN32)
    # WA for ICU inlclude path. Under Windows it is a part of Windows SDK
    set(ICU_INCLUDE_DIR $ENV{WindowsSdkDir}/Include/$ENV{WindowsSDKLibVersion})
    message(STATUS "ICU_INCLUDE_DIR = ${ICU_INCLUDE_DIR}")
endif()

find_package(ICU COMPONENTS uc REQUIRED)
add_definitions(-DUSE_SYSTEM_ICUUC)

set(CONSTANTS_SOURCES
    constants/access_permissions.h
    constants/annotation_common.h
    constants/annotation_flags.h
    constants/appearance.h
    constants/ascii.h
    constants/font_encodings.h
    constants/form_fields.h
    constants/form_flags.h
    constants/page_object.h
    constants/stream_dict_common.h
    constants/transparency.h
)

set(FDRM_SOURCES
    core/fdrm/fx_crypt.cpp
    core/fdrm/fx_crypt.h
    core/fdrm/fx_crypt_aes.cpp
    core/fdrm/fx_crypt_aes.h
    core/fdrm/fx_crypt_sha.cpp
    core/fdrm/fx_crypt_sha.h
)

set(FPDFAPI_CMAPS_SOURCES
    core/fpdfapi/cmaps/fpdf_cmaps.cpp
    core/fpdfapi/cmaps/fpdf_cmaps.h
)

if(USE_GB1_MAPS)
    list(APPEND FPDFAPI_CMAPS_SOURCES
        core/fpdfapi/cmaps/GB1/GB-EUC-H_0.cpp
        core/fpdfapi/cmaps/GB1/GB-EUC-V_0.cpp
        core/fpdfapi/cmaps/GB1/GBK-EUC-H_2.cpp
        core/fpdfapi/cmaps/GB1/GBK-EUC-V_2.cpp
        core/fpdfapi/cmaps/GB1/GBK2K-H_5.cpp
        core/fpdfapi/cmaps/GB1/GBK2K-V_5.cpp
        core/fpdfapi/cmaps/GB1/GBKp-EUC-H_2.cpp
        core/fpdfapi/cmaps/GB1/GBKp-EUC-V_2.cpp
        core/fpdfapi/cmaps/GB1/GBpc-EUC-H_0.cpp
        core/fpdfapi/cmaps/GB1/GBpc-EUC-V_0.cpp
        core/fpdfapi/cmaps/GB1/UniGB-UCS2-H_4.cpp
        core/fpdfapi/cmaps/GB1/UniGB-UCS2-V_4.cpp
        core/fpdfapi/cmaps/GB1/cmaps_gb1.h
    )
endif()

if(USE_CNS1_MAPS)
    list(APPEND FPDFAPI_CMAPS_SOURCES
        core/fpdfapi/cmaps/CNS1/B5pc-H_0.cpp
        core/fpdfapi/cmaps/CNS1/B5pc-V_0.cpp
        core/fpdfapi/cmaps/CNS1/CNS-EUC-H_0.cpp
        core/fpdfapi/cmaps/CNS1/CNS-EUC-V_0.cpp
        core/fpdfapi/cmaps/CNS1/ETen-B5-H_0.cpp
        core/fpdfapi/cmaps/CNS1/ETen-B5-V_0.cpp
        core/fpdfapi/cmaps/CNS1/ETenms-B5-H_0.cpp
        core/fpdfapi/cmaps/CNS1/ETenms-B5-V_0.cpp
        core/fpdfapi/cmaps/CNS1/HKscs-B5-H_5.cpp
        core/fpdfapi/cmaps/CNS1/HKscs-B5-V_5.cpp
        core/fpdfapi/cmaps/CNS1/UniCNS-UCS2-H_3.cpp
        core/fpdfapi/cmaps/CNS1/UniCNS-UCS2-V_3.cpp
        core/fpdfapi/cmaps/CNS1/UniCNS-UTF16-H_0.cpp
        core/fpdfapi/cmaps/CNS1/cmaps_cns1.h
    )
endif()

if(USE_JAPAN1_MAPS)
    list(APPEND FPDFAPI_CMAPS_SOURCES
        core/fpdfapi/cmaps/Japan1/83pv-RKSJ-H_1.cpp
        core/fpdfapi/cmaps/Japan1/90ms-RKSJ-H_2.cpp
        core/fpdfapi/cmaps/Japan1/90ms-RKSJ-V_2.cpp
        core/fpdfapi/cmaps/Japan1/90msp-RKSJ-H_2.cpp
        core/fpdfapi/cmaps/Japan1/90msp-RKSJ-V_2.cpp
        core/fpdfapi/cmaps/Japan1/90pv-RKSJ-H_1.cpp
        core/fpdfapi/cmaps/Japan1/Add-RKSJ-H_1.cpp
        core/fpdfapi/cmaps/Japan1/Add-RKSJ-V_1.cpp
        core/fpdfapi/cmaps/Japan1/EUC-H_1.cpp
        core/fpdfapi/cmaps/Japan1/EUC-V_1.cpp
        core/fpdfapi/cmaps/Japan1/Ext-RKSJ-H_2.cpp
        core/fpdfapi/cmaps/Japan1/Ext-RKSJ-V_2.cpp
        core/fpdfapi/cmaps/Japan1/H_1.cpp
        core/fpdfapi/cmaps/Japan1/UniJIS-UCS2-HW-H_4.cpp
        core/fpdfapi/cmaps/Japan1/UniJIS-UCS2-HW-V_4.cpp
        core/fpdfapi/cmaps/Japan1/UniJIS-UCS2-H_4.cpp
        core/fpdfapi/cmaps/Japan1/UniJIS-UCS2-V_4.cpp
        core/fpdfapi/cmaps/Japan1/V_1.cpp
        core/fpdfapi/cmaps/Japan1/cmaps_japan1.h
    )
endif()


if(USE_KOREA1_MAPS)
    list(APPEND FPDFAPI_CMAPS_SOURCES
        core/fpdfapi/cmaps/Korea1/KSC-EUC-H_0.cpp
        core/fpdfapi/cmaps/Korea1/KSC-EUC-V_0.cpp
        core/fpdfapi/cmaps/Korea1/KSCms-UHC-HW-H_1.cpp
        core/fpdfapi/cmaps/Korea1/KSCms-UHC-HW-V_1.cpp
        core/fpdfapi/cmaps/Korea1/KSCms-UHC-H_1.cpp
        core/fpdfapi/cmaps/Korea1/KSCms-UHC-V_1.cpp
        core/fpdfapi/cmaps/Korea1/KSCpc-EUC-H_0.cpp
        core/fpdfapi/cmaps/Korea1/UniKS-UCS2-H_1.cpp
        core/fpdfapi/cmaps/Korea1/UniKS-UCS2-V_1.cpp
        core/fpdfapi/cmaps/Korea1/UniKS-UTF16-H_0.cpp
        core/fpdfapi/cmaps/Korea1/cmaps_korea1.h
    )
endif()


set(FPDFAPI_EDIT_SOURCES
    core/fpdfapi/edit/cpdf_creator.cpp
    core/fpdfapi/edit/cpdf_creator.h
    core/fpdfapi/edit/cpdf_npagetooneexporter.cpp
    core/fpdfapi/edit/cpdf_npagetooneexporter.h
    core/fpdfapi/edit/cpdf_pagecontentgenerator.cpp
    core/fpdfapi/edit/cpdf_pagecontentgenerator.h
    core/fpdfapi/edit/cpdf_pagecontentmanager.cpp
    core/fpdfapi/edit/cpdf_pagecontentmanager.h
    core/fpdfapi/edit/cpdf_pageexporter.cpp
    core/fpdfapi/edit/cpdf_pageexporter.h
    core/fpdfapi/edit/cpdf_pageorganizer.cpp
    core/fpdfapi/edit/cpdf_pageorganizer.h
    core/fpdfapi/edit/cpdf_stringarchivestream.cpp
    core/fpdfapi/edit/cpdf_stringarchivestream.h
    core/fpdfapi/edit/cpdf_contentstream_write_utils.cpp
    core/fpdfapi/edit/cpdf_contentstream_write_utils.h
)

set(FPDFAPI_FONT_SOURCES
    core/fpdfapi/font/cfx_cttgsubtable.cpp
    core/fpdfapi/font/cfx_cttgsubtable.h
    core/fpdfapi/font/cfx_stockfontarray.cpp
    core/fpdfapi/font/cfx_stockfontarray.h
    core/fpdfapi/font/cpdf_cid2unicodemap.cpp
    core/fpdfapi/font/cpdf_cid2unicodemap.h
    core/fpdfapi/font/cpdf_cidfont.cpp
    core/fpdfapi/font/cpdf_cidfont.h
    core/fpdfapi/font/cpdf_cmap.cpp
    core/fpdfapi/font/cpdf_cmap.h
    core/fpdfapi/font/cpdf_cmapparser.cpp
    core/fpdfapi/font/cpdf_cmapparser.h
    core/fpdfapi/font/cpdf_font.cpp
    core/fpdfapi/font/cpdf_font.h
    core/fpdfapi/font/cpdf_fontencoding.cpp
    core/fpdfapi/font/cpdf_fontencoding.h
    core/fpdfapi/font/cpdf_fontglobals.cpp
    core/fpdfapi/font/cpdf_fontglobals.h
    core/fpdfapi/font/cpdf_simplefont.cpp
    core/fpdfapi/font/cpdf_simplefont.h
    core/fpdfapi/font/cpdf_tounicodemap.cpp
    core/fpdfapi/font/cpdf_tounicodemap.h
    core/fpdfapi/font/cpdf_truetypefont.cpp
    core/fpdfapi/font/cpdf_truetypefont.h
    core/fpdfapi/font/cpdf_type1font.cpp
    core/fpdfapi/font/cpdf_type1font.h
    core/fpdfapi/font/cpdf_type3char.cpp
    core/fpdfapi/font/cpdf_type3char.h
    core/fpdfapi/font/cpdf_type3font.cpp
    core/fpdfapi/font/cpdf_type3font.h
)

set(FPDFAPI_PAGE_SOURCES
    core/fpdfapi/page/cpdf_allstates.cpp
    core/fpdfapi/page/cpdf_allstates.h
    core/fpdfapi/page/cpdf_annotcontext.cpp
    core/fpdfapi/page/cpdf_annotcontext.h
    core/fpdfapi/page/cpdf_basedcs.cpp
    core/fpdfapi/page/cpdf_basedcs.h
    core/fpdfapi/page/cpdf_clippath.cpp
    core/fpdfapi/page/cpdf_clippath.h
    core/fpdfapi/page/cpdf_color.cpp
    core/fpdfapi/page/cpdf_color.h
    core/fpdfapi/page/cpdf_colorspace.cpp
    core/fpdfapi/page/cpdf_colorspace.h
    core/fpdfapi/page/cpdf_colorstate.cpp
    core/fpdfapi/page/cpdf_colorstate.h
    core/fpdfapi/page/cpdf_contentmarkitem.cpp
    core/fpdfapi/page/cpdf_contentmarkitem.h
    core/fpdfapi/page/cpdf_contentmarks.cpp
    core/fpdfapi/page/cpdf_contentmarks.h
    core/fpdfapi/page/cpdf_contentparser.cpp
    core/fpdfapi/page/cpdf_contentparser.h
    core/fpdfapi/page/cpdf_devicecs.cpp
    core/fpdfapi/page/cpdf_devicecs.h
    core/fpdfapi/page/cpdf_dib.cpp
    core/fpdfapi/page/cpdf_dib.h
    core/fpdfapi/page/cpdf_docpagedata.cpp
    core/fpdfapi/page/cpdf_docpagedata.h
    core/fpdfapi/page/cpdf_expintfunc.cpp
    core/fpdfapi/page/cpdf_expintfunc.h
    core/fpdfapi/page/cpdf_form.cpp
    core/fpdfapi/page/cpdf_form.h
    core/fpdfapi/page/cpdf_formobject.cpp
    core/fpdfapi/page/cpdf_formobject.h
    core/fpdfapi/page/cpdf_function.cpp
    core/fpdfapi/page/cpdf_function.h
    core/fpdfapi/page/cpdf_generalstate.cpp
    core/fpdfapi/page/cpdf_generalstate.h
    core/fpdfapi/page/cpdf_graphicstates.cpp
    core/fpdfapi/page/cpdf_graphicstates.h
    core/fpdfapi/page/cpdf_iccprofile.cpp
    core/fpdfapi/page/cpdf_iccprofile.h
    core/fpdfapi/page/cpdf_image.cpp
    core/fpdfapi/page/cpdf_image.h
    core/fpdfapi/page/cpdf_imageloader.cpp
    core/fpdfapi/page/cpdf_imageloader.h
    core/fpdfapi/page/cpdf_imageobject.cpp
    core/fpdfapi/page/cpdf_imageobject.h
    core/fpdfapi/page/cpdf_indexedcs.cpp
    core/fpdfapi/page/cpdf_indexedcs.h
    core/fpdfapi/page/cpdf_meshstream.cpp
    core/fpdfapi/page/cpdf_meshstream.h
    core/fpdfapi/page/cpdf_occontext.cpp
    core/fpdfapi/page/cpdf_occontext.h
    core/fpdfapi/page/cpdf_page.cpp
    core/fpdfapi/page/cpdf_page.h
    core/fpdfapi/page/cpdf_pageimagecache.cpp
    core/fpdfapi/page/cpdf_pageimagecache.h
    core/fpdfapi/page/cpdf_pagemodule.cpp
    core/fpdfapi/page/cpdf_pagemodule.h
    core/fpdfapi/page/cpdf_pageobject.cpp
    core/fpdfapi/page/cpdf_pageobject.h
    core/fpdfapi/page/cpdf_pageobjectholder.cpp
    core/fpdfapi/page/cpdf_pageobjectholder.h
    core/fpdfapi/page/cpdf_path.cpp
    core/fpdfapi/page/cpdf_path.h
    core/fpdfapi/page/cpdf_pathobject.cpp
    core/fpdfapi/page/cpdf_pathobject.h
    core/fpdfapi/page/cpdf_pattern.cpp
    core/fpdfapi/page/cpdf_pattern.h
    core/fpdfapi/page/cpdf_patterncs.cpp
    core/fpdfapi/page/cpdf_patterncs.h
    core/fpdfapi/page/cpdf_psengine.cpp
    core/fpdfapi/page/cpdf_psengine.h
    core/fpdfapi/page/cpdf_psfunc.cpp
    core/fpdfapi/page/cpdf_psfunc.h
    core/fpdfapi/page/cpdf_sampledfunc.cpp
    core/fpdfapi/page/cpdf_sampledfunc.h
    core/fpdfapi/page/cpdf_shadingobject.cpp
    core/fpdfapi/page/cpdf_shadingobject.h
    core/fpdfapi/page/cpdf_shadingpattern.cpp
    core/fpdfapi/page/cpdf_shadingpattern.h
    core/fpdfapi/page/cpdf_stitchfunc.cpp
    core/fpdfapi/page/cpdf_stitchfunc.h
    core/fpdfapi/page/cpdf_streamcontentparser.cpp
    core/fpdfapi/page/cpdf_streamcontentparser.h
    core/fpdfapi/page/cpdf_streamparser.cpp
    core/fpdfapi/page/cpdf_streamparser.h
    core/fpdfapi/page/cpdf_textobject.cpp
    core/fpdfapi/page/cpdf_textobject.h
    core/fpdfapi/page/cpdf_textstate.cpp
    core/fpdfapi/page/cpdf_textstate.h
    core/fpdfapi/page/cpdf_tilingpattern.cpp
    core/fpdfapi/page/cpdf_tilingpattern.h
    core/fpdfapi/page/cpdf_transferfunc.cpp
    core/fpdfapi/page/cpdf_transferfunc.h
    core/fpdfapi/page/cpdf_transferfuncdib.cpp
    core/fpdfapi/page/cpdf_transferfuncdib.h
    core/fpdfapi/page/cpdf_transparency.cpp
    core/fpdfapi/page/cpdf_transparency.h
    core/fpdfapi/page/ipdf_page.h
    core/fpdfapi/page/jpx_decode_conversion.cpp
    core/fpdfapi/page/jpx_decode_conversion.h
)

set(FPDFAPI_PARSER_SOURCE
    core/fpdfapi/parser/cfdf_document.cpp
    core/fpdfapi/parser/cfdf_document.h
    core/fpdfapi/parser/cpdf_array.cpp
    core/fpdfapi/parser/cpdf_array.h
    core/fpdfapi/parser/cpdf_boolean.cpp
    core/fpdfapi/parser/cpdf_boolean.h
    core/fpdfapi/parser/cpdf_cross_ref_avail.cpp
    core/fpdfapi/parser/cpdf_cross_ref_avail.h
    core/fpdfapi/parser/cpdf_cross_ref_table.cpp
    core/fpdfapi/parser/cpdf_cross_ref_table.h
    core/fpdfapi/parser/cpdf_crypto_handler.cpp
    core/fpdfapi/parser/cpdf_crypto_handler.h
    core/fpdfapi/parser/cpdf_data_avail.cpp
    core/fpdfapi/parser/cpdf_data_avail.h
    core/fpdfapi/parser/cpdf_dictionary.cpp
    core/fpdfapi/parser/cpdf_dictionary.h
    core/fpdfapi/parser/cpdf_document.cpp
    core/fpdfapi/parser/cpdf_document.h
    core/fpdfapi/parser/cpdf_encryptor.cpp
    core/fpdfapi/parser/cpdf_encryptor.h
    core/fpdfapi/parser/cpdf_flateencoder.cpp
    core/fpdfapi/parser/cpdf_flateencoder.h
    core/fpdfapi/parser/cpdf_hint_tables.cpp
    core/fpdfapi/parser/cpdf_hint_tables.h
    core/fpdfapi/parser/cpdf_indirect_object_holder.cpp
    core/fpdfapi/parser/cpdf_indirect_object_holder.h
    core/fpdfapi/parser/cpdf_linearized_header.cpp
    core/fpdfapi/parser/cpdf_linearized_header.h
    core/fpdfapi/parser/cpdf_name.cpp
    core/fpdfapi/parser/cpdf_name.h
    core/fpdfapi/parser/cpdf_null.cpp
    core/fpdfapi/parser/cpdf_null.h
    core/fpdfapi/parser/cpdf_number.cpp
    core/fpdfapi/parser/cpdf_number.h
    core/fpdfapi/parser/cpdf_object.cpp
    core/fpdfapi/parser/cpdf_object.h
    core/fpdfapi/parser/cpdf_object_avail.cpp
    core/fpdfapi/parser/cpdf_object_avail.h
    core/fpdfapi/parser/cpdf_object_stream.cpp
    core/fpdfapi/parser/cpdf_object_stream.h
    core/fpdfapi/parser/cpdf_object_walker.cpp
    core/fpdfapi/parser/cpdf_object_walker.h
    core/fpdfapi/parser/cpdf_page_object_avail.cpp
    core/fpdfapi/parser/cpdf_page_object_avail.h
    core/fpdfapi/parser/cpdf_parser.cpp
    core/fpdfapi/parser/cpdf_parser.h
    core/fpdfapi/parser/cpdf_read_validator.cpp
    core/fpdfapi/parser/cpdf_read_validator.h
    core/fpdfapi/parser/cpdf_reference.cpp
    core/fpdfapi/parser/cpdf_reference.h
    core/fpdfapi/parser/cpdf_security_handler.cpp
    core/fpdfapi/parser/cpdf_security_handler.h
    core/fpdfapi/parser/cpdf_simple_parser.cpp
    core/fpdfapi/parser/cpdf_simple_parser.h
    core/fpdfapi/parser/cpdf_stream.cpp
    core/fpdfapi/parser/cpdf_stream.h
    core/fpdfapi/parser/cpdf_stream_acc.cpp
    core/fpdfapi/parser/cpdf_stream_acc.h
    core/fpdfapi/parser/cpdf_string.cpp
    core/fpdfapi/parser/cpdf_string.h
    core/fpdfapi/parser/cpdf_syntax_parser.cpp
    core/fpdfapi/parser/cpdf_syntax_parser.h
    core/fpdfapi/parser/fpdf_parser_decode.cpp
    core/fpdfapi/parser/fpdf_parser_decode.h
    core/fpdfapi/parser/fpdf_parser_utility.cpp
    core/fpdfapi/parser/fpdf_parser_utility.h
    core/fpdfapi/parser/object_tree_traversal_util.cpp
    core/fpdfapi/parser/object_tree_traversal_util.h
)

set(FPDFAPI_RENDER_SOURCES
    core/fpdfapi/render/charposlist.cpp
    core/fpdfapi/render/charposlist.h
    core/fpdfapi/render/cpdf_devicebuffer.cpp
    core/fpdfapi/render/cpdf_devicebuffer.h
    core/fpdfapi/render/cpdf_docrenderdata.cpp
    core/fpdfapi/render/cpdf_docrenderdata.h
    core/fpdfapi/render/cpdf_imagerenderer.cpp
    core/fpdfapi/render/cpdf_imagerenderer.h
    core/fpdfapi/render/cpdf_pagerendercontext.cpp
    core/fpdfapi/render/cpdf_pagerendercontext.h
    core/fpdfapi/render/cpdf_progressiverenderer.cpp
    core/fpdfapi/render/cpdf_progressiverenderer.h
    core/fpdfapi/render/cpdf_rendercontext.cpp
    core/fpdfapi/render/cpdf_rendercontext.h
    core/fpdfapi/render/cpdf_renderoptions.cpp
    core/fpdfapi/render/cpdf_renderoptions.h
    core/fpdfapi/render/cpdf_rendershading.cpp
    core/fpdfapi/render/cpdf_rendershading.h
    core/fpdfapi/render/cpdf_renderstatus.cpp
    core/fpdfapi/render/cpdf_renderstatus.h
    core/fpdfapi/render/cpdf_rendertiling.cpp
    core/fpdfapi/render/cpdf_rendertiling.h
    core/fpdfapi/render/cpdf_textrenderer.cpp
    core/fpdfapi/render/cpdf_textrenderer.h
    core/fpdfapi/render/cpdf_type3cache.cpp
    core/fpdfapi/render/cpdf_type3cache.h
    core/fpdfapi/render/cpdf_type3glyphmap.cpp
    core/fpdfapi/render/cpdf_type3glyphmap.h
)

if(WIN32)
    set(FPDFAPI_RENDER_SOURCES
        ${FPDFAPI_RENDER_SOURCES}
        core/fpdfapi/render/cpdf_scaledrenderbuffer.cpp
        core/fpdfapi/render/cpdf_scaledrenderbuffer.h
        core/fpdfapi/render/cpdf_windowsrenderdevice.cpp
        core/fpdfapi/render/cpdf_windowsrenderdevice.h
    )
endif()

set(FPDFDOC_SOURCES
    core/fpdfdoc/cpdf_aaction.cpp
    core/fpdfdoc/cpdf_aaction.h
    core/fpdfdoc/cpdf_action.cpp
    core/fpdfdoc/cpdf_action.h
    core/fpdfdoc/cpdf_annot.cpp
    core/fpdfdoc/cpdf_annot.h
    core/fpdfdoc/cpdf_annotlist.cpp
    core/fpdfdoc/cpdf_annotlist.h
    core/fpdfdoc/cpdf_apsettings.cpp
    core/fpdfdoc/cpdf_apsettings.h
    core/fpdfdoc/cpdf_bafontmap.cpp
    core/fpdfdoc/cpdf_bafontmap.h
    core/fpdfdoc/cpdf_bookmark.cpp
    core/fpdfdoc/cpdf_bookmark.h
    core/fpdfdoc/cpdf_bookmarktree.cpp
    core/fpdfdoc/cpdf_bookmarktree.h
    core/fpdfdoc/cpdf_color_utils.cpp
    core/fpdfdoc/cpdf_color_utils.h
    core/fpdfdoc/cpdf_defaultappearance.cpp
    core/fpdfdoc/cpdf_defaultappearance.h
    core/fpdfdoc/cpdf_dest.cpp
    core/fpdfdoc/cpdf_dest.h
    core/fpdfdoc/cpdf_filespec.cpp
    core/fpdfdoc/cpdf_filespec.h
    core/fpdfdoc/cpdf_formcontrol.cpp
    core/fpdfdoc/cpdf_formcontrol.h
    core/fpdfdoc/cpdf_formfield.cpp
    core/fpdfdoc/cpdf_formfield.h
    core/fpdfdoc/cpdf_generateap.cpp
    core/fpdfdoc/cpdf_generateap.h
    core/fpdfdoc/cpdf_icon.cpp
    core/fpdfdoc/cpdf_icon.h
    core/fpdfdoc/cpdf_iconfit.cpp
    core/fpdfdoc/cpdf_iconfit.h
    core/fpdfdoc/cpdf_interactiveform.cpp
    core/fpdfdoc/cpdf_interactiveform.h
    core/fpdfdoc/cpdf_link.cpp
    core/fpdfdoc/cpdf_link.h
    core/fpdfdoc/cpdf_linklist.cpp
    core/fpdfdoc/cpdf_linklist.h
    core/fpdfdoc/cpdf_metadata.cpp
    core/fpdfdoc/cpdf_metadata.h
    core/fpdfdoc/cpdf_nametree.cpp
    core/fpdfdoc/cpdf_nametree.h
    core/fpdfdoc/cpdf_numbertree.cpp
    core/fpdfdoc/cpdf_numbertree.h
    core/fpdfdoc/cpdf_pagelabel.cpp
    core/fpdfdoc/cpdf_pagelabel.h
    core/fpdfdoc/cpdf_structelement.cpp
    core/fpdfdoc/cpdf_structelement.h
    core/fpdfdoc/cpdf_structtree.cpp
    core/fpdfdoc/cpdf_structtree.h
    core/fpdfdoc/cpdf_viewerpreferences.cpp
    core/fpdfdoc/cpdf_viewerpreferences.h
    core/fpdfdoc/cpvt_floatrect.h
    core/fpdfdoc/cpvt_fontmap.cpp
    core/fpdfdoc/cpvt_fontmap.h
    core/fpdfdoc/cpvt_line.h
    core/fpdfdoc/cpvt_lineinfo.h
    core/fpdfdoc/cpvt_section.cpp
    core/fpdfdoc/cpvt_section.h
    core/fpdfdoc/cpvt_variabletext.cpp
    core/fpdfdoc/cpvt_variabletext.h
    core/fpdfdoc/cpvt_word.h
    core/fpdfdoc/cpvt_wordinfo.cpp
    core/fpdfdoc/cpvt_wordinfo.h
    core/fpdfdoc/cpvt_wordplace.h
    core/fpdfdoc/cpvt_wordrange.h
    core/fpdfdoc/ipvt_fontmap.h
)

set(FPDFTEXT_SOURCES
    core/fpdftext/cpdf_linkextract.cpp
    core/fpdftext/cpdf_linkextract.h
    core/fpdftext/cpdf_textpage.cpp
    core/fpdftext/cpdf_textpage.h
    core/fpdftext/cpdf_textpagefind.cpp
    core/fpdftext/cpdf_textpagefind.h
    core/fpdftext/unicodenormalizationdata.cpp
    core/fpdftext/unicodenormalizationdata.h
)

set(FXCODEC_SOURCES
    core/fxcodec/basic/basicmodule.cpp
    core/fxcodec/basic/basicmodule.h
    core/fxcodec/data_and_bytes_consumed.cpp
    core/fxcodec/data_and_bytes_consumed.h
    core/fxcodec/fax/faxmodule.cpp
    core/fxcodec/fax/faxmodule.h
    core/fxcodec/flate/flatemodule.cpp
    core/fxcodec/flate/flatemodule.h
    core/fxcodec/fx_codec.cpp
    core/fxcodec/fx_codec.h
    core/fxcodec/fx_codec_def.h
    core/fxcodec/icc/icc_transform.cpp
    core/fxcodec/icc/icc_transform.h
    core/fxcodec/jbig2/JBig2_ArithDecoder.cpp
    core/fxcodec/jbig2/JBig2_ArithDecoder.h
    core/fxcodec/jbig2/JBig2_ArithIntDecoder.cpp
    core/fxcodec/jbig2/JBig2_ArithIntDecoder.h
    core/fxcodec/jbig2/JBig2_BitStream.cpp
    core/fxcodec/jbig2/JBig2_BitStream.h
    core/fxcodec/jbig2/JBig2_Context.cpp
    core/fxcodec/jbig2/JBig2_Context.h
    core/fxcodec/jbig2/JBig2_Define.h
    core/fxcodec/jbig2/JBig2_DocumentContext.cpp
    core/fxcodec/jbig2/JBig2_DocumentContext.h
    core/fxcodec/jbig2/JBig2_GrdProc.cpp
    core/fxcodec/jbig2/JBig2_GrdProc.h
    core/fxcodec/jbig2/JBig2_GrrdProc.cpp
    core/fxcodec/jbig2/JBig2_GrrdProc.h
    core/fxcodec/jbig2/JBig2_HtrdProc.cpp
    core/fxcodec/jbig2/JBig2_HtrdProc.h
    core/fxcodec/jbig2/JBig2_HuffmanDecoder.cpp
    core/fxcodec/jbig2/JBig2_HuffmanDecoder.h
    core/fxcodec/jbig2/JBig2_HuffmanTable.cpp
    core/fxcodec/jbig2/JBig2_HuffmanTable.h
    core/fxcodec/jbig2/JBig2_Image.cpp
    core/fxcodec/jbig2/JBig2_Image.h
    core/fxcodec/jbig2/JBig2_Page.h
    core/fxcodec/jbig2/JBig2_PatternDict.cpp
    core/fxcodec/jbig2/JBig2_PatternDict.h
    core/fxcodec/jbig2/JBig2_PddProc.cpp
    core/fxcodec/jbig2/JBig2_PddProc.h
    core/fxcodec/jbig2/JBig2_SddProc.cpp
    core/fxcodec/jbig2/JBig2_SddProc.h
    core/fxcodec/jbig2/JBig2_Segment.cpp
    core/fxcodec/jbig2/JBig2_Segment.h
    core/fxcodec/jbig2/JBig2_SymbolDict.cpp
    core/fxcodec/jbig2/JBig2_SymbolDict.h
    core/fxcodec/jbig2/JBig2_TrdProc.cpp
    core/fxcodec/jbig2/JBig2_TrdProc.h
    core/fxcodec/jbig2/jbig2_decoder.cpp
    core/fxcodec/jbig2/jbig2_decoder.h
    core/fxcodec/jpeg/jpeg_common.c
    core/fxcodec/jpeg/jpeg_common.h
    core/fxcodec/jpeg/jpegmodule.cpp
    core/fxcodec/jpeg/jpegmodule.h
    core/fxcodec/jpx/cjpx_decoder.cpp
    core/fxcodec/jpx/cjpx_decoder.h
    core/fxcodec/jpx/jpx_decode_utils.cpp
    core/fxcodec/jpx/jpx_decode_utils.h
    core/fxcodec/scanlinedecoder.cpp
    core/fxcodec/scanlinedecoder.h
)

set(FXCRT_SOURCES
    core/fxcrt/autonuller.h
    core/fxcrt/autorestorer.h
    core/fxcrt/binary_buffer.cpp
    core/fxcrt/binary_buffer.h
    core/fxcrt/byteorder.h
    core/fxcrt/bytestring.cpp
    core/fxcrt/bytestring.h
    core/fxcrt/cfx_bitstream.cpp
    core/fxcrt/cfx_bitstream.h
    core/fxcrt/cfx_datetime.cpp
    core/fxcrt/cfx_datetime.h
    core/fxcrt/cfx_read_only_span_stream.cpp
    core/fxcrt/cfx_read_only_span_stream.h
    core/fxcrt/cfx_read_only_string_stream.cpp
    core/fxcrt/cfx_read_only_string_stream.h
    core/fxcrt/cfx_read_only_vector_stream.cpp
    core/fxcrt/cfx_read_only_vector_stream.h
    core/fxcrt/cfx_seekablestreamproxy.cpp
    core/fxcrt/cfx_seekablestreamproxy.h
    core/fxcrt/cfx_timer.cpp
    core/fxcrt/cfx_timer.h
    core/fxcrt/check.h
    core/fxcrt/check_op.h
    core/fxcrt/code_point_view.h
    core/fxcrt/component_export.h
    core/fxcrt/containers/adapters.h
    core/fxcrt/containers/contains.h
    core/fxcrt/containers/unique_ptr_adapters.h
    core/fxcrt/data_vector.h
    core/fxcrt/debug/alias.cc
    core/fxcrt/debug/alias.h
    core/fxcrt/fileaccess_iface.h
    core/fxcrt/fixed_size_data_vector.h
    core/fxcrt/fx_2d_size.h
    core/fxcrt/fx_bidi.cpp
    core/fxcrt/fx_bidi.h
    core/fxcrt/fx_codepage.cpp
    core/fxcrt/fx_codepage.h
    core/fxcrt/fx_codepage_forward.h
    core/fxcrt/fx_coordinates.cpp
    core/fxcrt/fx_coordinates.h
    core/fxcrt/fx_extension.cpp
    core/fxcrt/fx_extension.h
    core/fxcrt/fx_folder.h
    core/fxcrt/fx_memcpy_wrappers.h
    core/fxcrt/fx_memory.cpp
    core/fxcrt/fx_memory.h
    core/fxcrt/fx_memory_wrappers.h
    core/fxcrt/fx_number.cpp
    core/fxcrt/fx_number.h
    core/fxcrt/fx_random.cpp
    core/fxcrt/fx_random.h
    core/fxcrt/fx_safe_types.h
    core/fxcrt/fx_stream.cpp
    core/fxcrt/fx_stream.h
    core/fxcrt/fx_string.cpp
    core/fxcrt/fx_string.h
    core/fxcrt/fx_string_wrappers.h
    core/fxcrt/fx_system.cpp
    core/fxcrt/fx_system.h
    core/fxcrt/fx_types.h
    core/fxcrt/fx_unicode.cpp
    core/fxcrt/fx_unicode.h
    core/fxcrt/immediate_crash.h
    core/fxcrt/mask.h
    core/fxcrt/maybe_owned.h
    core/fxcrt/notreached.h
    core/fxcrt/numerics/checked_math.h
    core/fxcrt/numerics/checked_math_impl.h
    core/fxcrt/numerics/clamped_math.h
    core/fxcrt/numerics/clamped_math_impl.h
    core/fxcrt/numerics/integral_constant_like.h
    core/fxcrt/numerics/safe_conversions.h
    core/fxcrt/numerics/safe_conversions_arm_impl.h
    core/fxcrt/numerics/safe_conversions_impl.h
    core/fxcrt/numerics/safe_math.h
    core/fxcrt/numerics/safe_math_arm_impl.h
    core/fxcrt/numerics/safe_math_clang_gcc_impl.h
    core/fxcrt/numerics/safe_math_shared_impl.h
    core/fxcrt/observed_ptr.cpp
    core/fxcrt/observed_ptr.h
    core/fxcrt/pauseindicator_iface.h
    core/fxcrt/ptr_util.h
    core/fxcrt/raw_span.h
    core/fxcrt/retain_ptr.h
    core/fxcrt/scoped_set_insertion.h
    core/fxcrt/shared_copy_on_write.h
    core/fxcrt/span.h
    core/fxcrt/span_util.h
    core/fxcrt/stl_util.h
    core/fxcrt/string_data_template.cpp
    core/fxcrt/string_data_template.h
    core/fxcrt/string_pool_template.h
    core/fxcrt/string_template.cpp
    core/fxcrt/string_template.h
    core/fxcrt/string_view_template.h
    core/fxcrt/tree_node.h
    core/fxcrt/unowned_ptr.h
    core/fxcrt/utf16.h
    core/fxcrt/weak_ptr.h
    core/fxcrt/widestring.cpp
    core/fxcrt/widestring.h
    core/fxcrt/widetext_buffer.cpp
    core/fxcrt/widetext_buffer.h
    core/fxcrt/xml/cfx_xmlchardata.cpp
    core/fxcrt/xml/cfx_xmlchardata.h
    core/fxcrt/xml/cfx_xmldocument.cpp
    core/fxcrt/xml/cfx_xmldocument.h
    core/fxcrt/xml/cfx_xmlelement.cpp
    core/fxcrt/xml/cfx_xmlelement.h
    core/fxcrt/xml/cfx_xmlinstruction.cpp
    core/fxcrt/xml/cfx_xmlinstruction.h
    core/fxcrt/xml/cfx_xmlnode.cpp
    core/fxcrt/xml/cfx_xmlnode.h
    core/fxcrt/xml/cfx_xmlparser.cpp
    core/fxcrt/xml/cfx_xmlparser.h
    core/fxcrt/xml/cfx_xmltext.cpp
    core/fxcrt/xml/cfx_xmltext.h
    core/fxcrt/zip.h
    core/fxcrt/fx_memory_malloc.cpp
)

if(WIN32)
set(FXCRT_SOURCES
    ${FXCRT_SOURCES}
    core/fxcrt/cfx_fileaccess_windows.cpp
    core/fxcrt/cfx_fileaccess_windows.h
    #core/fxcrt/code_point_view.cpp
    core/fxcrt/fx_folder_windows.cpp
    core/fxcrt/win/scoped_select_object.h
    core/fxcrt/win/win_util.cc
    core/fxcrt/win/win_util.h
)
else()
    set(FXCRT_SOURCES
        ${FXCRT_SOURCES}
        core/fxcrt/cfx_fileaccess_posix.cpp
        core/fxcrt/cfx_fileaccess_posix.h
        core/fxcrt/fx_folder_posix.cpp
    )
endif()

set(FXGE_SOURCES
    core/fxge/agg/cfx_agg_bitmapcomposer.cpp
    core/fxge/agg/cfx_agg_bitmapcomposer.h
    core/fxge/agg/cfx_agg_cliprgn.cpp
    core/fxge/agg/cfx_agg_cliprgn.h
    core/fxge/agg/cfx_agg_devicedriver.cpp
    core/fxge/agg/cfx_agg_devicedriver.h
    core/fxge/agg/cfx_agg_imagerenderer.cpp
    core/fxge/agg/cfx_agg_imagerenderer.h
    core/fxge/calculate_pitch.cpp
    core/fxge/calculate_pitch.h
    core/fxge/cfx_color.cpp
    core/fxge/cfx_color.h
    core/fxge/cfx_defaultrenderdevice.cpp
    core/fxge/cfx_defaultrenderdevice.h
    core/fxge/cfx_drawutils.cpp
    core/fxge/cfx_drawutils.h
    core/fxge/cfx_face.cpp
    core/fxge/cfx_face.h
    core/fxge/cfx_fillrenderoptions.h
    core/fxge/cfx_folderfontinfo.cpp
    core/fxge/cfx_folderfontinfo.h
    core/fxge/cfx_font.cpp
    core/fxge/cfx_font.h
    core/fxge/cfx_fontcache.cpp
    core/fxge/cfx_fontcache.h
    core/fxge/cfx_fontmapper.cpp
    core/fxge/cfx_fontmapper.h
    core/fxge/cfx_fontmgr.cpp
    core/fxge/cfx_fontmgr.h
    core/fxge/cfx_gemodule.cpp
    core/fxge/cfx_gemodule.h
    core/fxge/cfx_glyphbitmap.cpp
    core/fxge/cfx_glyphbitmap.h
    core/fxge/cfx_glyphcache.cpp
    core/fxge/cfx_glyphcache.h
    core/fxge/cfx_graphstate.cpp
    core/fxge/cfx_graphstate.h
    core/fxge/cfx_graphstatedata.cpp
    core/fxge/cfx_graphstatedata.h
    core/fxge/cfx_path.cpp
    core/fxge/cfx_path.h
    core/fxge/cfx_renderdevice.cpp
    core/fxge/cfx_renderdevice.h
    core/fxge/cfx_substfont.cpp
    core/fxge/cfx_substfont.h
    core/fxge/cfx_textrenderoptions.h
    core/fxge/cfx_unicodeencoding.cpp
    core/fxge/cfx_unicodeencoding.h
    core/fxge/dib/blend.cpp
    core/fxge/dib/blend.h
    core/fxge/dib/cfx_bitmapstorer.cpp
    core/fxge/dib/cfx_bitmapstorer.h
    core/fxge/dib/cfx_cmyk_to_srgb.cpp
    core/fxge/dib/cfx_cmyk_to_srgb.h
    core/fxge/dib/cfx_dibbase.cpp
    core/fxge/dib/cfx_dibbase.h
    core/fxge/dib/cfx_dibitmap.cpp
    core/fxge/dib/cfx_dibitmap.h
    core/fxge/dib/cfx_imagestretcher.cpp
    core/fxge/dib/cfx_imagestretcher.h
    core/fxge/dib/cfx_imagetransformer.cpp
    core/fxge/dib/cfx_imagetransformer.h
    core/fxge/dib/cfx_scanlinecompositor.cpp
    core/fxge/dib/cfx_scanlinecompositor.h
    core/fxge/dib/cstretchengine.cpp
    core/fxge/dib/cstretchengine.h
    core/fxge/dib/fx_dib.cpp
    core/fxge/dib/fx_dib.h
    core/fxge/dib/scanlinecomposer_iface.h
    core/fxge/fontdata/chromefontdata/FoxitDingbats.cpp
    core/fxge/fontdata/chromefontdata/FoxitFixed.cpp
    core/fxge/fontdata/chromefontdata/FoxitFixedBold.cpp
    core/fxge/fontdata/chromefontdata/FoxitFixedBoldItalic.cpp
    core/fxge/fontdata/chromefontdata/FoxitFixedItalic.cpp
    core/fxge/fontdata/chromefontdata/FoxitSans.cpp
    core/fxge/fontdata/chromefontdata/FoxitSansBold.cpp
    core/fxge/fontdata/chromefontdata/FoxitSansBoldItalic.cpp
    core/fxge/fontdata/chromefontdata/FoxitSansItalic.cpp
    core/fxge/fontdata/chromefontdata/FoxitSansMM.cpp
    core/fxge/fontdata/chromefontdata/FoxitSerif.cpp
    core/fxge/fontdata/chromefontdata/FoxitSerifBold.cpp
    core/fxge/fontdata/chromefontdata/FoxitSerifBoldItalic.cpp
    core/fxge/fontdata/chromefontdata/FoxitSerifItalic.cpp
    core/fxge/fontdata/chromefontdata/FoxitSerifMM.cpp
    core/fxge/fontdata/chromefontdata/FoxitSymbol.cpp
    core/fxge/fontdata/chromefontdata/chromefontdata.h
    core/fxge/freetype/fx_freetype.cpp
    core/fxge/freetype/fx_freetype.h
    core/fxge/fx_font.cpp
    core/fxge/fx_font.h
    core/fxge/fx_fontencoding.h
    core/fxge/render_defines.h
    core/fxge/renderdevicedriver_iface.cpp
    core/fxge/renderdevicedriver_iface.h
    core/fxge/scoped_font_transform.cpp
    core/fxge/scoped_font_transform.h
    core/fxge/systemfontinfo_iface.h
    core/fxge/text_char_pos.cpp
    core/fxge/text_char_pos.h
    core/fxge/text_glyph_pos.cpp
    core/fxge/text_glyph_pos.h
)

if(WIN32)
    set(
        FXGE_SOURCES
        ${FXGE_SOURCES}
        core/fxge/cfx_windowsrenderdevice.cpp
        core/fxge/cfx_windowsrenderdevice.h
        core/fxge/win32/cfx_psfonttracker.cpp
        core/fxge/win32/cfx_psfonttracker.h
        core/fxge/win32/cfx_psrenderer.cpp
        core/fxge/win32/cfx_psrenderer.h
        core/fxge/win32/cgdi_device_driver.cpp
        core/fxge/win32/cgdi_device_driver.h
        core/fxge/win32/cgdi_display_driver.cpp
        core/fxge/win32/cgdi_display_driver.h
        core/fxge/win32/cgdi_plus_ext.cpp
        core/fxge/win32/cgdi_plus_ext.h
        core/fxge/win32/cgdi_printer_driver.cpp
        core/fxge/win32/cgdi_printer_driver.h
        core/fxge/win32/cps_printer_driver.cpp
        core/fxge/win32/cps_printer_driver.h
        core/fxge/win32/cpsoutput.cpp
        core/fxge/win32/cpsoutput.h
        core/fxge/win32/ctext_only_printer_driver.cpp
        core/fxge/win32/ctext_only_printer_driver.h
        core/fxge/win32/cwin32_platform.cpp
        core/fxge/win32/cwin32_platform.h
    )
else()
    set(
        FXGE_SOURCES
        ${FXGE_SOURCES}
        # Linux specific
        core/fxge/linux/fx_linux_impl.cpp
    )
endif()

set(FPDF_SDK_SOURCES
    fpdfsdk/cpdfsdk_annot.cpp
    fpdfsdk/cpdfsdk_annot.h
    fpdfsdk/cpdfsdk_annotiteration.cpp
    fpdfsdk/cpdfsdk_annotiteration.h
    fpdfsdk/cpdfsdk_annotiterator.cpp
    fpdfsdk/cpdfsdk_annotiterator.h
    fpdfsdk/cpdfsdk_appstream.cpp
    fpdfsdk/cpdfsdk_appstream.h
    fpdfsdk/cpdfsdk_baannot.cpp
    fpdfsdk/cpdfsdk_baannot.h
    fpdfsdk/cpdfsdk_customaccess.cpp
    fpdfsdk/cpdfsdk_customaccess.h
    fpdfsdk/cpdfsdk_filewriteadapter.cpp
    fpdfsdk/cpdfsdk_filewriteadapter.h
    fpdfsdk/cpdfsdk_formfillenvironment.cpp
    fpdfsdk/cpdfsdk_formfillenvironment.h
    fpdfsdk/cpdfsdk_helpers.cpp
    fpdfsdk/cpdfsdk_helpers.h
    fpdfsdk/cpdfsdk_interactiveform.cpp
    fpdfsdk/cpdfsdk_interactiveform.h
    fpdfsdk/cpdfsdk_pageview.cpp
    fpdfsdk/cpdfsdk_pageview.h
    fpdfsdk/cpdfsdk_pauseadapter.cpp
    fpdfsdk/cpdfsdk_pauseadapter.h
    fpdfsdk/cpdfsdk_renderpage.cpp
    fpdfsdk/cpdfsdk_renderpage.h
    fpdfsdk/cpdfsdk_widget.cpp
    fpdfsdk/cpdfsdk_widget.h
    fpdfsdk/fpdf_annot.cpp
    fpdfsdk/fpdf_attachment.cpp
    fpdfsdk/fpdf_catalog.cpp
    fpdfsdk/fpdf_dataavail.cpp
    fpdfsdk/fpdf_doc.cpp
    fpdfsdk/fpdf_editimg.cpp
    fpdfsdk/fpdf_editpage.cpp
    fpdfsdk/fpdf_editpath.cpp
    fpdfsdk/fpdf_edittext.cpp
    fpdfsdk/fpdf_ext.cpp
    fpdfsdk/fpdf_flatten.cpp
    fpdfsdk/fpdf_formfill.cpp
    fpdfsdk/fpdf_javascript.cpp
    fpdfsdk/fpdf_ppo.cpp
    fpdfsdk/fpdf_progressive.cpp
    fpdfsdk/fpdf_save.cpp
    fpdfsdk/fpdf_searchex.cpp
    fpdfsdk/fpdf_signature.cpp
    fpdfsdk/fpdf_structtree.cpp
    fpdfsdk/fpdf_sysfontinfo.cpp
    fpdfsdk/fpdf_text.cpp
    fpdfsdk/fpdf_thumbnail.cpp
    fpdfsdk/fpdf_transformpage.cpp
    fpdfsdk/fpdf_view.cpp
)

set(FPDF_SDK_FORMFILLER_SOURCES
    fpdfsdk/formfiller/cffl_button.cpp
    fpdfsdk/formfiller/cffl_button.h
    fpdfsdk/formfiller/cffl_checkbox.cpp
    fpdfsdk/formfiller/cffl_checkbox.h
    fpdfsdk/formfiller/cffl_combobox.cpp
    fpdfsdk/formfiller/cffl_combobox.h
    fpdfsdk/formfiller/cffl_fieldaction.cpp
    fpdfsdk/formfiller/cffl_fieldaction.h
    fpdfsdk/formfiller/cffl_formfield.cpp
    fpdfsdk/formfiller/cffl_formfield.h
    fpdfsdk/formfiller/cffl_interactiveformfiller.cpp
    fpdfsdk/formfiller/cffl_interactiveformfiller.h
    fpdfsdk/formfiller/cffl_listbox.cpp
    fpdfsdk/formfiller/cffl_listbox.h
    fpdfsdk/formfiller/cffl_perwindowdata.cpp
    fpdfsdk/formfiller/cffl_perwindowdata.h
    fpdfsdk/formfiller/cffl_pushbutton.cpp
    fpdfsdk/formfiller/cffl_pushbutton.h
    fpdfsdk/formfiller/cffl_radiobutton.cpp
    fpdfsdk/formfiller/cffl_radiobutton.h
    fpdfsdk/formfiller/cffl_textfield.cpp
    fpdfsdk/formfiller/cffl_textfield.h
    fpdfsdk/formfiller/cffl_textobject.cpp
    fpdfsdk/formfiller/cffl_textobject.h
)

set(FPDF_SDK_PWL_SOURCES
    fpdfsdk/pwl/cpwl_button.cpp
    fpdfsdk/pwl/cpwl_button.h
    fpdfsdk/pwl/cpwl_caret.cpp
    fpdfsdk/pwl/cpwl_caret.h
    fpdfsdk/pwl/cpwl_cbbutton.cpp
    fpdfsdk/pwl/cpwl_cbbutton.h
    fpdfsdk/pwl/cpwl_cblistbox.cpp
    fpdfsdk/pwl/cpwl_cblistbox.h
    fpdfsdk/pwl/cpwl_combo_box.cpp
    fpdfsdk/pwl/cpwl_combo_box.h
    fpdfsdk/pwl/cpwl_edit.cpp
    fpdfsdk/pwl/cpwl_edit.h
    fpdfsdk/pwl/cpwl_edit_impl.cpp
    fpdfsdk/pwl/cpwl_edit_impl.h
    fpdfsdk/pwl/cpwl_list_box.cpp
    fpdfsdk/pwl/cpwl_list_box.h
    fpdfsdk/pwl/cpwl_list_ctrl.cpp
    fpdfsdk/pwl/cpwl_list_ctrl.h
    fpdfsdk/pwl/cpwl_sbbutton.cpp
    fpdfsdk/pwl/cpwl_sbbutton.h
    fpdfsdk/pwl/cpwl_scroll_bar.cpp
    fpdfsdk/pwl/cpwl_scroll_bar.h
    fpdfsdk/pwl/cpwl_special_button.cpp
    fpdfsdk/pwl/cpwl_special_button.h
    fpdfsdk/pwl/cpwl_wnd.cpp
    fpdfsdk/pwl/cpwl_wnd.h
    fpdfsdk/pwl/ipwl_fillernotify.h
)

set(FXJS_SOURCES
    fxjs/cjs_event_context_stub.cpp
    fxjs/cjs_event_context_stub.h
    fxjs/cjs_runtimestub.cpp
    fxjs/cjs_runtimestub.h
    fxjs/ijs_event_context.h
    fxjs/ijs_runtime.cpp
    fxjs/ijs_runtime.h
)

set(PDFIUM_PUBLIC_CPP_HEADERS
    public/cpp/fpdf_deleters.h
    public/cpp/fpdf_scopers.h
)

set(PDFIUM_PUBLIC_HEADERS
    public/fpdf_annot.h
    public/fpdf_attachment.h
    public/fpdf_catalog.h
    public/fpdf_dataavail.h
    public/fpdf_doc.h
    public/fpdf_edit.h
    public/fpdf_ext.h
    public/fpdf_flatten.h
    public/fpdf_formfill.h
    public/fpdf_fwlevent.h
    public/fpdf_javascript.h
    public/fpdf_ppo.h
    public/fpdf_progressive.h
    public/fpdf_save.h
    public/fpdf_searchex.h
    public/fpdf_signature.h
    public/fpdf_structtree.h
    public/fpdf_sysfontinfo.h
    public/fpdf_text.h
    public/fpdf_transformpage.h
    public/fpdfview.h
)

set(FPDF_MISC_SOURCES
    build/buildflag.h
    build/build_config.h
)

set(ALL_SOURCES
  ${CONSTANTS_SOURCES}
  ${FDRM_SOURCES}
  ${FPDFAPI_CMAPS_SOURCES}
  ${FPDFAPI_EDIT_SOURCES}
  ${FPDFAPI_FONT_SOURCES}
  ${FPDFAPI_PAGE_SOURCES}
  ${FPDFAPI_PARSER_SOURCE}
  ${FPDFAPI_RENDER_SOURCES}
  ${FPDFDOC_SOURCES}
  ${FPDFTEXT_SOURCES}
  ${FXCODEC_SOURCES}
  ${FXCRT_SOURCES}
  ${FXGE_SOURCES}
  ${FPDF_SDK_SOURCES}
  ${FPDF_SDK_FORMFILLER_SOURCES}
  ${FPDF_SDK_PWL_SOURCES}
  ${FXJS_SOURCES}
  ${FPDF_MISC_SOURCES}
  ${PDFIUM_PUBLIC_HEADERS}
  ${PDFIUM_PUBLIC_CPP_HEADERS}
 )

if(USE_STATIC_LIBRARY)
    add_library(pdfium STATIC
         ${ALL_SOURCES}
    )
else(USE_STATIC_LIBRARY)
    add_library(pdfium SHARED
         ${ALL_SOURCES}
    )
endif(USE_STATIC_LIBRARY)

set_property(TARGET pdfium PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
set_target_properties(pdfium PROPERTIES POSITION_INDEPENDENT_CODE ON)
target_compile_definitions(pdfium PRIVATE COMPONENT_BUILD FPDF_IMPLEMENTATION)
target_include_directories(pdfium PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(pdfium
PRIVATE
    AGG::agg
    FastFloat::fast_float
    JPEG::JPEG
    LCMS::lcms
    OpenJpeg::OpenJpeg
    ${ZLIB_LIBRARY}
    ${FREETYPE_LIBRARIES}
    ICU::uc
)

if(WIN32)
    target_link_libraries(pdfium
        PRIVATE
        advapi32.lib
        gdi32.lib
        user32.lib
    )
endif()

set_property(TARGET pdfium
    PROPERTY PUBLIC_HEADER ${PDFIUM_PUBLIC_HEADERS}
)

target_include_directories(pdfium
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include/pdfium>
)

add_library(Pdfium::pdfium ALIAS pdfium)

### Install
include(GNUInstallDirs)

install(TARGETS ${PROJECT_NAME}
        EXPORT ${PROJECT_NAME}
        LIBRARY DESTINATION  ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION  ${CMAKE_INSTALL_LIBDIR}
        PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/pdfium
)

# Install a few headers manually since install TARGETS ignores nested dirs
install(FILES
    ${PDFIUM_PUBLIC_CPP_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/pdfium/cpp
)

install(EXPORT ${PROJECT_NAME}
        FILE PdfiumTargets.cmake
        NAMESPACE Pdfium::
        DESTINATION  ${CMAKE_INSTALL_LIBDIR}/cmake/pdfium
)

include(CMakePackageConfigHelpers)

configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/PdfiumConfig.cmake"
  INSTALL_DESTINATION  ${CMAKE_INSTALL_LIBDIR}/cmake/pdfium
)

write_basic_package_version_file(
    PdfiumConfigVersion.cmake
    VERSION ${PACKAGE_VERSION}
    COMPATIBILITY ExactVersion
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/PdfiumConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/PdfiumConfigVersion.cmake"
    DESTINATION  ${CMAKE_INSTALL_LIBDIR}/cmake/pdfium
)



