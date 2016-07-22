PROJECT (PDFium)
CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)

set(CMAKE_VERBOSE_MAKEFILE ON)
message(STATUS "System: " ${CMAKE_SYSTEM_NAME} " " ${CMAKE_SYSTEM_VERSION})
message(STATUS "Processor: " ${CMAKE_HOST_SYSTEM_PROCESSOR})
message(STATUS "CMake generates: " ${CMAKE_GENERATOR})
message(STATUS "Build type:" ${CMAKE_BUILD_TYPE})

include(TargetArch.cmake)
target_architecture(TARGET_ARCH)
message(STATUS "Target: " ${TARGET_ARCH})

set(USE_BINUTILS_WORKAROUND ON CACHE BOOL "use gcc-ar and gcc-ranlib instead ar and ranlib (is needed for LTO)")
if(USE_BINUTILS_WORKAROUND)
    set(CMAKE_AR gcc-ar)
    set(CMAKE_RANLIB gcc-ranlib)
endif(USE_BINUTILS_WORKAROUND)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x -Wc++0x-compat -fno-exceptions -fvisibility=hidden")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden")

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

if(WIN32)
  add_definitions(-D_WIN32 -DWIN32_LEAN_AND_MEAN)
  set(WINDOWS_SOURCES
    core/fxge/win32/dwrite_int.h
    core/fxge/win32/fx_win32_device.cpp
    core/fxge/win32/fx_win32_dib.cpp
    core/fxge/win32/fx_win32_dwrite.cpp
    core/fxge/win32/fx_win32_gdipext.cpp
    core/fxge/win32/fx_win32_print.cpp
    core/fxge/win32/win32_int.h
  )
else(WIN32)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -pthread")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -pthread")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} -Wl,-z,defs")
endif(WIN32)

set(USE_STATIC_LIBRARY ON CACHE BOOL "build as static library. Otherwise - shared")

#3dparty libraries
set(USE_SYSTEM_FREETYPE ON CACHE BOOL "use system freetype")
set(USE_SYSTEM_JPEG ON CACHE BOOL "use system libjpeg")
set(USE_SYSTEM_ZLIB ON CACHE BOOL "use system zlib")
set(USE_SYSTEM_LCMS2 ON CACHE BOOL "use system lcms2")
set(USE_SYSTEM_OPENJPEG ON CACHE BOOL "use system openjpeg" )

#hieroglyphs support
set(USE_GB1_MAPS OFF CACHE BOOL "use GB1 maps")
set(USE_CNS1_MAPS OFF CACHE BOOL "use CNS1 maps")
set(USE_JAPAN1_MAPS OFF CACHE BOOL "use JAPAN1 maps")
set(USE_KOREA_MAPS OFF CACHE BOOL "use KOREA maps")
# set(USE_JPX_DECODER OFF CACHE BOOL "use jpx-decoder")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

if(USE_CNS1_MAPS)
  add_definitions(-DUSE_CNS1_MAPS)
  set(FPDFAPI_CNS1_SOURCES
    core/fpdfapi/fpdf_cmaps/CNS1/Adobe-CNS1-UCS2_5.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/B5pc-H_0.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/B5pc-V_0.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/CNS-EUC-H_0.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/CNS-EUC-V_0.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/ETen-B5-H_0.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/ETen-B5-V_0.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/ETenms-B5-H_0.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/ETenms-B5-V_0.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/HKscs-B5-H_5.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/HKscs-B5-V_5.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/UniCNS-UCS2-H_3.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/UniCNS-UCS2-V_3.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/UniCNS-UTF16-H_0.cpp
    core/fpdfapi/fpdf_cmaps/CNS1/cmaps_cns1.cpp
  )
endif(USE_CNS1_MAPS)

if(USE_GB1_MAPS)
  add_definitions(-DUSE_GB1_MAPS)
  set(FPDFAPI_GB1_SOURCES
    core/fpdfapi/fpdf_cmaps/GB1/Adobe-GB1-UCS2_5.cpp
    core/fpdfapi/fpdf_cmaps/GB1/GB-EUC-H_0.cpp
    core/fpdfapi/fpdf_cmaps/GB1/GB-EUC-V_0.cpp
    core/fpdfapi/fpdf_cmaps/GB1/GBK-EUC-H_2.cpp
    core/fpdfapi/fpdf_cmaps/GB1/GBK-EUC-V_2.cpp
    core/fpdfapi/fpdf_cmaps/GB1/GBK2K-H_5.cpp
    core/fpdfapi/fpdf_cmaps/GB1/GBK2K-V_5.cpp
    core/fpdfapi/fpdf_cmaps/GB1/GBKp-EUC-H_2.cpp
    core/fpdfapi/fpdf_cmaps/GB1/GBKp-EUC-V_2.cpp
    core/fpdfapi/fpdf_cmaps/GB1/GBpc-EUC-H_0.cpp
    core/fpdfapi/fpdf_cmaps/GB1/GBpc-EUC-V_0.cpp
    core/fpdfapi/fpdf_cmaps/GB1/UniGB-UCS2-H_4.cpp
    core/fpdfapi/fpdf_cmaps/GB1/UniGB-UCS2-V_4.cpp
    core/fpdfapi/fpdf_cmaps/GB1/cmaps_gb1.cpp
  )
endif(USE_GB1_MAPS)

if(USE_JAPAN1_MAPS)
  set(FPDFAPI_JAPAN1_SOURCES
    core/fpdfapi/fpdf_cmaps/Japan1/83pv-RKSJ-H_1.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/90ms-RKSJ-H_2.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/90ms-RKSJ-V_2.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/90msp-RKSJ-H_2.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/90msp-RKSJ-V_2.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/90pv-RKSJ-H_1.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/Add-RKSJ-H_1.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/Add-RKSJ-V_1.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/Adobe-Japan1-UCS2_4.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/EUC-H_1.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/EUC-V_1.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/Ext-RKSJ-H_2.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/Ext-RKSJ-V_2.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/H_1.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/UniJIS-UCS2-HW-H_4.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/UniJIS-UCS2-HW-V_4.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/UniJIS-UCS2-H_4.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/UniJIS-UCS2-V_4.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/V_1.cpp
    core/fpdfapi/fpdf_cmaps/Japan1/cmaps_japan1.cpp
  )
  add_definitions(-DUSE_JAPAN1_MAPS)
endif(USE_JAPAN1_MAPS)

if(USE_KOREA_MAPS)
  add_definitions(-DUSE_KOREA_MAPS)
  set(FPDFAPI_KOREA_SOURCES
    core/fpdfapi/fpdf_cmaps/Korea1/Adobe-Korea1-UCS2_2.cpp
    core/fpdfapi/fpdf_cmaps/Korea1/KSC-EUC-H_0.cpp
    core/fpdfapi/fpdf_cmaps/Korea1/KSC-EUC-V_0.cpp
    core/fpdfapi/fpdf_cmaps/Korea1/KSCms-UHC-HW-H_1.cpp
    core/fpdfapi/fpdf_cmaps/Korea1/KSCms-UHC-HW-V_1.cpp
    core/fpdfapi/fpdf_cmaps/Korea1/KSCms-UHC-H_1.cpp
    core/fpdfapi/fpdf_cmaps/Korea1/KSCms-UHC-V_1.cpp
    core/fpdfapi/fpdf_cmaps/Korea1/KSCpc-EUC-H_0.cpp
    core/fpdfapi/fpdf_cmaps/Korea1/UniKS-UCS2-H_1.cpp
    core/fpdfapi/fpdf_cmaps/Korea1/UniKS-UCS2-V_1.cpp
    core/fpdfapi/fpdf_cmaps/Korea1/UniKS-UTF16-H_0.cpp
    core/fpdfapi/fpdf_cmaps/Korea1/cmaps_korea1.cpp
  )
endif(USE_KOREA_MAPS)

if(USE_SYSTEM_FREETYPE)
  find_package(Freetype REQUIRED)
  include_directories(${FREETYPE_INCLUDE_DIRS} ${FREETYPE_INCLUDE_DIRS}/freetype)
  add_definitions(-DUSE_SYSTEM_FREETYPE)
  add_library(internal_freetype OBJECT empty.c)
else(USE_SYSTEM_FREETYPE)
  add_subdirectory(third_party/freetype)
  include_directories(third_party/freetype/include third_party/freetype/include/freetype)
endif(USE_SYSTEM_FREETYPE)

if(USE_SYSTEM_JPEG)
  find_package(JPEG REQUIRED)
  include_directories(${JPEG_INCLUDE_DIRS})
  add_definitions(-DUSE_SYSTEM_JPEG)
  add_library(internal_jpeg OBJECT empty.c)
else(USE_SYSTEM_JPEG)
  add_subdirectory(third_party/libjpeg)
endif(USE_SYSTEM_JPEG)

if(USE_SYSTEM_ZLIB)
  find_package(ZLIB REQUIRED)
  include_directories(${ZLIB_INCLUDE_DIRS})
  add_definitions(-DUSE_SYSTEM_ZLIB)
  add_library(internal_zlib OBJECT empty.c)
else(USE_SYSTEM_ZLIB)
  add_subdirectory(third_party/zlib_v128)
endif(USE_SYSTEM_ZLIB)

if(USE_SYSTEM_LCMS2)
  find_package(LCMS2 REQUIRED)
  include_directories(${LCMS2_INCLUDE_DIRS})
  add_definitions(-DUSE_SYSTEM_LCMS2)
  add_library(internal_lcms2 OBJECT empty.c third_party/lcms2-2.6/src/cmsmd5.c)
else(USE_SYSTEM_LCMS2)
  add_subdirectory(third_party/lcms2-2.6)
endif(USE_SYSTEM_LCMS2)

if(USE_SYSTEM_OPENJPEG)
  find_package(OpenJpeg REQUIRED)
  include_directories(${OPENJPEG_INCLUDE_DIR})
  add_definitions(-DUSE_SYSTEM_OPENJPEG)
  add_library(internal_openjpeg OBJECT empty.c)
else(USE_SYSTEM_OPENJPEG)
  add_subdirectory(third_party/libopenjpeg20)
  add_definitions(-DOPJ_STATIC)
endif(USE_SYSTEM_OPENJPEG)

#Use own jbig2 in anytime
add_subdirectory(core/fxcodec/jbig2)

add_definitions(
#  -D_FPDFSDK_LIB
  -D_NO_GDIPLUS_ # workaround text rendering issues on Windows
  )

if(TARGET_ARCH STREQUAL "x86_64")
    add_definitions(
	-D_FX_CPU_=_FX_X64_
    )
elseif(TARGET_ARCH STREQUAL "i386")
    add_definitions(
	-D_FX_CPU_=_FX_X86_
    )
endif(TARGET_ARCH STREQUAL "x86_64")

######################### FPDFSDK #############################################
set(FPDFSDK_HEDAERS
    public/fpdf_dataavail.h
    public/fpdf_doc.h
    public/fpdf_edit.h
    public/fpdf_ext.h
    public/fpdf_flatten.h
    public/fpdf_formfill.h
    public/fpdf_fwlevent.h
    public/fpdf_ppo.h
    public/fpdf_progressive.h
    public/fpdf_save.h
    public/fpdf_searchex.h
    public/fpdf_sysfontinfo.h
    public/fpdf_text.h
    public/fpdf_transformpage.h
    public/fpdfview.h
)

set(FPDFSDK_SOURCES
    fpdfsdk/cfx_systemhandler.cpp
    fpdfsdk/cfx_systemhandler.h
    fpdfsdk/include/fsdk_actionhandler.h
    fpdfsdk/include/fsdk_annothandler.h
    fpdfsdk/include/fsdk_baseannot.h
    fpdfsdk/include/fsdk_baseform.h
    fpdfsdk/fpdfdoc.cpp
    fpdfsdk/fpdfeditimg.cpp
    fpdfsdk/fpdfeditpage.cpp
    fpdfsdk/fpdfformfill.cpp
    fpdfsdk/fpdfppo.cpp
    fpdfsdk/fpdfsave.cpp
    fpdfsdk/fpdftext.cpp
    fpdfsdk/fpdfview.cpp
    fpdfsdk/fpdf_dataavail.cpp
    fpdfsdk/fpdf_ext.cpp
    fpdfsdk/fpdf_flatten.cpp
    fpdfsdk/fpdf_progressive.cpp
    fpdfsdk/fpdf_searchex.cpp
    fpdfsdk/fpdf_sysfontinfo.cpp
    fpdfsdk/fpdf_transformpage.cpp
    fpdfsdk/fsdk_actionhandler.cpp
    fpdfsdk/fsdk_annothandler.cpp
    fpdfsdk/fsdk_baseannot.cpp
    fpdfsdk/fsdk_baseform.cpp
    fpdfsdk/fsdk_mgr.cpp
    fpdfsdk/fsdk_rendercontext.cpp
)

######################## FDRM #############################################
set(FDRM_HEDAERS
  core/fdrm/crypto/include/fx_crypt.h
)

set(FDRM_SOURCES
    core/fdrm/crypto/fx_crypt.cpp
    core/fdrm/crypto/fx_crypt_aes.cpp
    core/fdrm/crypto/fx_crypt_sha.cpp
)

######################## FPDFDOC ###########################################
set(FPDFDOC_HEDAERS
    core/fpdfdoc/clines.h
    core/fpdfdoc/include/fpdf_doc.h
    core/fpdfdoc/include/fpdf_tagged.h
    core/fpdfdoc/cpdf_annot.h
    core/fpdfdoc/cpdf_annotlist.h
    core/fpdfdoc/cpvt_color.h
    core/fpdfdoc/cpvt_dash.h
    core/fpdfdoc/cpvt_floatrect.h
    core/fpdfdoc/cpvt_fontmap.h
    core/fpdfdoc/cpvt_generateap.h
    core/fpdfdoc/cpvt_lineinfo.h
    core/fpdfdoc/cpvt_sectioninfo.h
    core/fpdfdoc/csection.h
    core/fpdfdoc/ctypeset.h
    core/fpdfdoc/doc_utils.h
    core/fpdfdoc/include/cpdf_variabletext.h
    core/fpdfdoc/include/cpvt_line.h
    core/fpdfdoc/include/cpvt_secprops.h
    core/fpdfdoc/include/cpvt_section.h
    core/fpdfdoc/include/cpvt_word.h
    core/fpdfdoc/include/cpvt_wordplace.h
    core/fpdfdoc/include/cpvt_wordprops.h
    core/fpdfdoc/include/cpvt_wordrange.h
    core/fpdfdoc/include/ipvt_fontmap.h
    core/fpdfdoc/pdf_vt.h
    core/fpdfdoc/tagged_int.h
)

set(FPDFDOC_SOURCES
    core/fpdfdoc/clines.cpp
    core/fpdfdoc/cpdf_variabletext.cpp
    core/fpdfdoc/cpdf_annot.cpp
    core/fpdfdoc/cpdf_annotlist.cpp
    core/fpdfdoc/cpvt_color.cpp
    core/fpdfdoc/cpvt_fontmap.cpp
    core/fpdfdoc/cpvt_generateap.cpp
    core/fpdfdoc/cpvt_sectioninfo.cpp
    core/fpdfdoc/cpvt_wordinfo.cpp
    core/fpdfdoc/csection.cpp
    core/fpdfdoc/ctypeset.cpp
    core/fpdfdoc/doc_action.cpp
    core/fpdfdoc/doc_basic.cpp
    core/fpdfdoc/doc_bookmark.cpp
    core/fpdfdoc/doc_form.cpp
    core/fpdfdoc/doc_formcontrol.cpp
    core/fpdfdoc/doc_formfield.cpp
    core/fpdfdoc/doc_link.cpp
    core/fpdfdoc/doc_metadata.cpp
    core/fpdfdoc/doc_ocg.cpp
    core/fpdfdoc/doc_tagged.cpp
    core/fpdfdoc/doc_utils.cpp
    core/fpdfdoc/doc_viewerPreferences.cpp
    core/fpdfdoc/doc_vt.cpp
)

######################## FPDFAPI ###########################################
set(FPDFAPI_HEDAERS
    core/fpdfapi/fpdf_cmaps/cmap_int.h
    core/fpdfapi/fpdf_edit/editint.h
    core/fpdfapi/fpdf_edit/include/cpdf_creator.h
    core/fpdfapi/fpdf_edit/include/cpdf_pagecontentgenerator.h
    core/fpdfapi/fpdf_font/cpdf_cidfont.h
    core/fpdfapi/fpdf_font/cpdf_simplefont.h
    core/fpdfapi/fpdf_font/cpdf_truetypefont.h
    core/fpdfapi/fpdf_font/cpdf_type1font.h
    core/fpdfapi/fpdf_font/cpdf_type3char.h
    core/fpdfapi/fpdf_font/cpdf_type3font.h
    core/fpdfapi/fpdf_font/font_int.h
    core/fpdfapi/fpdf_font/include/cpdf_font.h
    core/fpdfapi/fpdf_font/include/cpdf_fontencoding.h
    core/fpdfapi/fpdf_font/ttgsubtable.h
    core/fpdfapi/fpdf_page/cpdf_allstates.h
    core/fpdfapi/fpdf_page/cpdf_clippathdata.h
    core/fpdfapi/fpdf_page/cpdf_colorstate.h
    core/fpdfapi/fpdf_page/cpdf_colorstatedata.h
    core/fpdfapi/fpdf_page/cpdf_contentmark.h
    core/fpdfapi/fpdf_page/cpdf_contentmarkdata.h
    core/fpdfapi/fpdf_page/cpdf_contentmarkitem.h
    core/fpdfapi/fpdf_page/cpdf_countedobject.h
    core/fpdfapi/fpdf_page/cpdf_graphicstates.h
    core/fpdfapi/fpdf_page/cpdf_graphstate.h
    core/fpdfapi/fpdf_page/cpdf_meshstream.h
    core/fpdfapi/fpdf_page/cpdf_pagemodule.h
    core/fpdfapi/fpdf_page/cpdf_pageobjectlist.h
    core/fpdfapi/fpdf_page/cpdf_pattern.h
    core/fpdfapi/fpdf_page/cpdf_shadingpattern.h
    core/fpdfapi/fpdf_page/cpdf_textstate.h
    core/fpdfapi/fpdf_page/cpdf_tilingpattern.h
    core/fpdfapi/fpdf_page/include/cpdf_clippath.h
    core/fpdfapi/fpdf_page/include/cpdf_color.h
    core/fpdfapi/fpdf_page/include/cpdf_colorspace.h
    core/fpdfapi/fpdf_page/include/cpdf_form.h
    core/fpdfapi/fpdf_page/include/cpdf_formobject.h
    core/fpdfapi/fpdf_page/include/cpdf_generalstatedata.h
    core/fpdfapi/fpdf_page/include/cpdf_image.h
    core/fpdfapi/fpdf_page/include/cpdf_imageobject.h
    core/fpdfapi/fpdf_page/include/cpdf_page.h
    core/fpdfapi/fpdf_page/include/cpdf_pageobject.h
    core/fpdfapi/fpdf_page/include/cpdf_pageobjectholder.h
    core/fpdfapi/fpdf_page/include/cpdf_path.h
    core/fpdfapi/fpdf_page/include/cpdf_pathobject.h
    core/fpdfapi/fpdf_page/include/cpdf_shadingobject.h
    core/fpdfapi/fpdf_page/include/cpdf_textobject.h
    core/fpdfapi/fpdf_page/include/cpdf_textstatedata.h
    core/fpdfapi/fpdf_page/pageint.h
    core/fpdfapi/fpdf_parser/cpdf_boolean.h
    core/fpdfapi/fpdf_parser/cpdf_crypto_handler.h
    core/fpdfapi/fpdf_parser/cpdf_hint_tables.h
    core/fpdfapi/fpdf_parser/cpdf_null.h
    core/fpdfapi/fpdf_parser/cpdf_security_handler.h
    core/fpdfapi/fpdf_parser/cpdf_syntax_parser.h
    core/fpdfapi/fpdf_parser/fpdf_parser_utility.h
    core/fpdfapi/fpdf_parser/include/cfdf_document.h
    core/fpdfapi/fpdf_parser/include/cpdf_array.h
    core/fpdfapi/fpdf_parser/include/cpdf_data_avail.h
    core/fpdfapi/fpdf_parser/include/cpdf_dictionary.h
    core/fpdfapi/fpdf_parser/include/cpdf_document.h
    core/fpdfapi/fpdf_parser/include/cpdf_indirect_object_holder.h
    core/fpdfapi/fpdf_parser/include/cpdf_name.h
    core/fpdfapi/fpdf_parser/include/cpdf_number.h
    core/fpdfapi/fpdf_parser/include/cpdf_object.h
    core/fpdfapi/fpdf_parser/include/cpdf_parser.h
    core/fpdfapi/fpdf_parser/include/cpdf_reference.h
    core/fpdfapi/fpdf_parser/include/cpdf_simple_parser.h
    core/fpdfapi/fpdf_parser/include/cpdf_stream.h
    core/fpdfapi/fpdf_parser/include/cpdf_stream_acc.h
    core/fpdfapi/fpdf_parser/include/cpdf_string.h
    core/fpdfapi/fpdf_parser/include/fpdf_parser_decode.h
    core/fpdfapi/fpdf_render/cpdf_pagerendercache.h
    core/fpdfapi/fpdf_render/include/cpdf_progressiverenderer.h
    core/fpdfapi/fpdf_render/include/cpdf_rendercontext.h
    core/fpdfapi/fpdf_render/include/cpdf_renderoptions.h
    core/fpdfapi/fpdf_render/include/cpdf_textrenderer.h
    core/fpdfapi/fpdf_render/render_int.h
    core/fpdfapi/include/cpdf_modulemgr.h
)

set(FPDFAPI_SOURCES
    core/fpdfapi/cpdf_modulemgr.cpp
    core/fpdfapi/fpdf_cmaps/fpdf_cmaps.cpp
    core/fpdfapi/fpdf_edit/cpdf_pagecontentgenerator.cpp
    core/fpdfapi/fpdf_edit/fpdf_edit_create.cpp
    core/fpdfapi/fpdf_font/cpdf_cidfont.cpp
    core/fpdfapi/fpdf_font/cpdf_font.cpp
    core/fpdfapi/fpdf_font/cpdf_fontencoding.cpp
    core/fpdfapi/fpdf_font/cpdf_simplefont.cpp
    core/fpdfapi/fpdf_font/cpdf_truetypefont.cpp
    core/fpdfapi/fpdf_font/cpdf_type1font.cpp
    core/fpdfapi/fpdf_font/cpdf_type3char.cpp
    core/fpdfapi/fpdf_font/cpdf_type3font.cpp
    core/fpdfapi/fpdf_font/fpdf_font.cpp
    core/fpdfapi/fpdf_font/fpdf_font_cid.cpp
    core/fpdfapi/fpdf_font/ttgsubtable.cpp
    core/fpdfapi/fpdf_page/cpdf_allstates.cpp
    core/fpdfapi/fpdf_page/cpdf_clippath.cpp
    core/fpdfapi/fpdf_page/cpdf_clippathdata.cpp
    core/fpdfapi/fpdf_page/cpdf_color.cpp
    core/fpdfapi/fpdf_page/cpdf_colorspace.cpp
    core/fpdfapi/fpdf_page/cpdf_colorstate.cpp
    core/fpdfapi/fpdf_page/cpdf_colorstatedata.cpp
    core/fpdfapi/fpdf_page/cpdf_contentmark.cpp
    core/fpdfapi/fpdf_page/cpdf_contentmarkdata.cpp
    core/fpdfapi/fpdf_page/cpdf_contentmarkitem.cpp
    core/fpdfapi/fpdf_page/cpdf_form.cpp
    core/fpdfapi/fpdf_page/cpdf_formobject.cpp
    core/fpdfapi/fpdf_page/cpdf_generalstate.cpp
    core/fpdfapi/fpdf_page/cpdf_generalstatedata.cpp
    core/fpdfapi/fpdf_page/cpdf_graphicstates.cpp
    core/fpdfapi/fpdf_page/cpdf_image.cpp
    core/fpdfapi/fpdf_page/cpdf_imageobject.cpp
    core/fpdfapi/fpdf_page/cpdf_meshstream.cpp
    core/fpdfapi/fpdf_page/cpdf_page.cpp
    core/fpdfapi/fpdf_page/cpdf_pagemodule.cpp
    core/fpdfapi/fpdf_page/cpdf_pageobject.cpp
    core/fpdfapi/fpdf_page/cpdf_pageobjectholder.cpp
    core/fpdfapi/fpdf_page/cpdf_pageobjectlist.cpp
    core/fpdfapi/fpdf_page/cpdf_pathobject.cpp
    core/fpdfapi/fpdf_page/cpdf_pattern.cpp
    core/fpdfapi/fpdf_page/cpdf_shadingobject.cpp
    core/fpdfapi/fpdf_page/cpdf_shadingpattern.cpp
    core/fpdfapi/fpdf_page/cpdf_textobject.cpp
    core/fpdfapi/fpdf_page/cpdf_textstate.cpp
    core/fpdfapi/fpdf_page/cpdf_textstatedata.cpp
    core/fpdfapi/fpdf_page/cpdf_tilingpattern.cpp
    core/fpdfapi/fpdf_page/fpdf_page_colors.cpp
    core/fpdfapi/fpdf_page/fpdf_page_doc.cpp
    core/fpdfapi/fpdf_page/fpdf_page_func.cpp
    core/fpdfapi/fpdf_page/fpdf_page_parser.cpp
    core/fpdfapi/fpdf_page/fpdf_page_parser_old.cpp
    core/fpdfapi/fpdf_parser/cfdf_document.cpp
    core/fpdfapi/fpdf_parser/cpdf_array.cpp
    core/fpdfapi/fpdf_parser/cpdf_boolean.cpp
    core/fpdfapi/fpdf_parser/cpdf_crypto_handler.cpp
    core/fpdfapi/fpdf_parser/cpdf_data_avail.cpp
    core/fpdfapi/fpdf_parser/cpdf_dictionary.cpp
    core/fpdfapi/fpdf_parser/cpdf_document.cpp
    core/fpdfapi/fpdf_parser/cpdf_hint_tables.cpp
    core/fpdfapi/fpdf_parser/cpdf_indirect_object_holder.cpp
    core/fpdfapi/fpdf_parser/cpdf_name.cpp
    core/fpdfapi/fpdf_parser/cpdf_null.cpp
    core/fpdfapi/fpdf_parser/cpdf_number.cpp
    core/fpdfapi/fpdf_parser/cpdf_object.cpp
    core/fpdfapi/fpdf_parser/cpdf_parser.cpp
    core/fpdfapi/fpdf_parser/cpdf_reference.cpp
    core/fpdfapi/fpdf_parser/cpdf_security_handler.cpp
    core/fpdfapi/fpdf_parser/cpdf_simple_parser.cpp
    core/fpdfapi/fpdf_parser/cpdf_stream.cpp
    core/fpdfapi/fpdf_parser/cpdf_stream_acc.cpp
    core/fpdfapi/fpdf_parser/cpdf_string.cpp
    core/fpdfapi/fpdf_parser/cpdf_syntax_parser.cpp
    core/fpdfapi/fpdf_parser/fpdf_parser_decode.cpp
    core/fpdfapi/fpdf_parser/fpdf_parser_utility.cpp
    core/fpdfapi/fpdf_render/fpdf_render.cpp
    core/fpdfapi/fpdf_render/fpdf_render_cache.cpp
    core/fpdfapi/fpdf_render/fpdf_render_image.cpp
    core/fpdfapi/fpdf_render/fpdf_render_loadimage.cpp
    core/fpdfapi/fpdf_render/fpdf_render_pattern.cpp
    core/fpdfapi/fpdf_render/fpdf_render_text.cpp
)

######################## FPDFTEXT #############################################
set(FPDFTEXT_HEDAERS
    core/fpdftext/include/cpdf_linkextract.h
    core/fpdftext/include/cpdf_textpage.h
    core/fpdftext/include/cpdf_textpagefind.h
    core/fpdftext/unicodenormalizationdata.h
)

set(FPDFTEXT_SOURCES
    core/fpdftext/fpdf_text_int.cpp
    core/fpdftext/unicodenormalizationdata.cpp
)

######################## FXCODEC #############################################
set(FXCODEC_HEDAERS
    core/fxcodec/include/fx_codec.h
    core/fxcodec/include/fx_codec_def.h
    core/fxcodec/codec/ccodec_basicmodule.h
    core/fxcodec/codec/ccodec_faxmodule.h
    core/fxcodec/codec/ccodec_flatemodule.h
    core/fxcodec/codec/ccodec_iccmodule.h
    core/fxcodec/codec/ccodec_jbig2module.h
    core/fxcodec/codec/ccodec_jpegmodule.h
    core/fxcodec/codec/ccodec_jpxmodule.h
    core/fxcodec/codec/ccodec_scanlinedecoder.h
    core/fxcodec/codec/codec_int.h
)

set(FXCODEC_SOURCES
    core/fxcodec/codec/fx_codec.cpp
    core/fxcodec/codec/fx_codec_fax.cpp
    core/fxcodec/codec/fx_codec_flate.cpp
    core/fxcodec/codec/fx_codec_icc.cpp
    core/fxcodec/codec/fx_codec_jbig.cpp
    core/fxcodec/codec/fx_codec_jpeg.cpp
    core/fxcodec/codec/fx_codec_jpx_opj.cpp
)

######################## FXCRT #############################################
set(FXCRT_HEDAERS
    core/fxcrt/cfx_string_c_template.h
    core/fxcrt/cfx_string_data_template.h
    core/fxcrt/extension.h
    core/fxcrt/fx_bidi.h
    core/fxcrt/fxcrt_posix.h
    core/fxcrt/fxcrt_windows.h
    core/fxcrt/include/cfx_retain_ptr.h
    core/fxcrt/include/fx_basic.h
    core/fxcrt/include/fx_coordinates.h
    core/fxcrt/include/fx_ext.h
    core/fxcrt/include/fx_memory.h
    core/fxcrt/include/fx_safe_types.h
    core/fxcrt/include/fx_stream.h
    core/fxcrt/include/fx_string.h
    core/fxcrt/include/fx_system.h
    core/fxcrt/include/fx_ucd.h
    core/fxcrt/include/fx_xml.h
    core/fxcrt/plex.h
    core/fxcrt/xml_int.h
)

set(FXCRT_SOURCES
    core/fxcrt/fx_basic_array.cpp
    core/fxcrt/fx_basic_bstring.cpp
    core/fxcrt/fx_basic_buffer.cpp
    core/fxcrt/fx_basic_coords.cpp
    core/fxcrt/fx_basic_gcc.cpp
    core/fxcrt/fx_basic_list.cpp
    core/fxcrt/fx_basic_memmgr.cpp
    core/fxcrt/fx_basic_plex.cpp
    core/fxcrt/fx_basic_utf.cpp
    core/fxcrt/fx_basic_util.cpp
    core/fxcrt/fx_basic_wstring.cpp
    core/fxcrt/fx_bidi.cpp
    core/fxcrt/fx_extension.cpp
    core/fxcrt/fx_ucddata.cpp
    core/fxcrt/fx_unicode.cpp
    core/fxcrt/fx_xml_composer.cpp
    core/fxcrt/fx_xml_parser.cpp
    core/fxcrt/fxcrt_posix.cpp
    core/fxcrt/fxcrt_stream.cpp
    core/fxcrt/fxcrt_windows.cpp
)

######################## FXGE #############################################
set(FXGE_HEDAERS
    core/fxge/agg/fx_agg_driver.h
    core/fxge/android/fpf_skiafont.h
    core/fxge/android/fpf_skiafontmgr.h
    core/fxge/android/fpf_skiamodule.h
    core/fxge/android/fx_android_font.h
    core/fxge/apple/apple_int.h
    core/fxge/dib/dib_int.h
    core/fxge/fontdata/chromefontdata/chromefontdata.h
    core/fxge/ge/fx_text_int.h
    core/fxge/include/fx_dib.h
    core/fxge/include/fx_font.h
    core/fxge/include/fx_freetype.h
    core/fxge/include/fx_ge.h
    core/fxge/include/fx_ge_apple.h
    core/fxge/include/fx_ge_win32.h
    core/fxge/include/ifx_renderdevicedriver.h
)

set(FXGE_SOURCES
    core/fxge/agg/fx_agg_driver.cpp
    core/fxge/android/fpf_skiafont.cpp
    core/fxge/android/fpf_skiafontmgr.cpp
    core/fxge/android/fpf_skiamodule.cpp
    core/fxge/android/fx_android_font.cpp
    core/fxge/android/fx_android_imp.cpp
    core/fxge/apple/fx_apple_platform.cpp
    core/fxge/apple/fx_mac_imp.cpp
    core/fxge/apple/fx_quartz_device.cpp
    core/fxge/dib/fx_dib_composite.cpp
    core/fxge/dib/fx_dib_convert.cpp
    core/fxge/dib/fx_dib_engine.cpp
    core/fxge/dib/fx_dib_main.cpp
    core/fxge/dib/fx_dib_transform.cpp
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
    core/fxge/freetype/fx_freetype.cpp
    core/fxge/ge/fx_ge.cpp
    core/fxge/ge/fx_ge_device.cpp
    core/fxge/ge/fx_ge_font.cpp
    core/fxge/ge/fx_ge_fontmap.cpp
    core/fxge/ge/fx_ge_linux.cpp
    core/fxge/ge/fx_ge_path.cpp
    core/fxge/ge/fx_ge_text.cpp
    core/fxge/ifx_renderdevicedriver.cpp
)

######################## FXEDIT #############################################
set(FXEDIT_HEDAERS
    fpdfsdk/fxedit/include/fx_edit.h
    fpdfsdk/fxedit/include/fxet_edit.h
    fpdfsdk/fxedit/include/fxet_list.h
)

set(FXEDIT_SOURCES
    fpdfsdk/fxedit/fxet_ap.cpp
    fpdfsdk/fxedit/fxet_edit.cpp
    fpdfsdk/fxedit/fxet_list.cpp
)

######################## PDFWINDOW #############################################
set(PDFWINDOW_HEDAERS
    fpdfsdk/pdfwindow/PWL_Button.h
    fpdfsdk/pdfwindow/PWL_Caret.h
    fpdfsdk/pdfwindow/PWL_ComboBox.h
    fpdfsdk/pdfwindow/PWL_Edit.h
    fpdfsdk/pdfwindow/PWL_EditCtrl.h
    fpdfsdk/pdfwindow/PWL_FontMap.h
    fpdfsdk/pdfwindow/PWL_Icon.h
    fpdfsdk/pdfwindow/PWL_ListBox.h
    fpdfsdk/pdfwindow/PWL_ScrollBar.h
    fpdfsdk/pdfwindow/PWL_SpecialButton.h
    fpdfsdk/pdfwindow/PWL_Utils.h
    fpdfsdk/pdfwindow/PWL_Wnd.h
)

set(PDFWINDOW_SOURCES
    fpdfsdk/pdfwindow/PWL_Button.cpp
    fpdfsdk/pdfwindow/PWL_Caret.cpp
    fpdfsdk/pdfwindow/PWL_ComboBox.cpp
    fpdfsdk/pdfwindow/PWL_Edit.cpp
    fpdfsdk/pdfwindow/PWL_EditCtrl.cpp
    fpdfsdk/pdfwindow/PWL_FontMap.cpp
    fpdfsdk/pdfwindow/PWL_Icon.cpp
    fpdfsdk/pdfwindow/PWL_ListBox.cpp
    fpdfsdk/pdfwindow/PWL_ScrollBar.cpp
    fpdfsdk/pdfwindow/PWL_SpecialButton.cpp
    fpdfsdk/pdfwindow/PWL_Utils.cpp
    fpdfsdk/pdfwindow/PWL_Wnd.cpp
)

######################## FORMFILLER #############################################
set(FORMFILLER_HEDAERS
    fpdfsdk/formfiller/cba_fontmap.h
    fpdfsdk/formfiller/cffl_checkbox.h
    fpdfsdk/formfiller/cffl_combobox.h
    fpdfsdk/formfiller/cffl_formfiller.h
    fpdfsdk/formfiller/cffl_iformfiller.h
    fpdfsdk/formfiller/cffl_listbox.h
    fpdfsdk/formfiller/cffl_pushbutton.h
    fpdfsdk/formfiller/cffl_radiobutton.h
    fpdfsdk/formfiller/cffl_textfield.h
)

set(FORMFILLER_SOURCES
    fpdfsdk/formfiller/cba_fontmap.cpp
    fpdfsdk/formfiller/cffl_checkbox.cpp
    fpdfsdk/formfiller/cffl_combobox.cpp
    fpdfsdk/formfiller/cffl_formfiller.cpp
    fpdfsdk/formfiller/cffl_iformfiller.cpp
    fpdfsdk/formfiller/cffl_listbox.cpp
    fpdfsdk/formfiller/cffl_pushbutton.cpp
    fpdfsdk/formfiller/cffl_radiobutton.cpp
    fpdfsdk/formfiller/cffl_textfield.cpp
)

######################## JS #############################################
set(JS_STUB_HEADERS
    fpdfsdk/javascript/ijs_context.h
    fpdfsdk/javascript/ijs_runtime.h
)
set(JS_STUB_SOURCES
    fpdfsdk/javascript/JS_Runtime_Stub.cpp
)

######################## BIGINT #############################################
set(BIGINT_HEADERS
    third_party/bigint/BigInteger.hh
    third_party/bigint/BigIntegerLibrary.hh
    third_party/bigint/BigIntegerUtils.hh
    third_party/bigint/BigUnsigned.hh
    third_party/bigint/NumberlikeArray.hh
    third_party/bigint/BigUnsignedInABase.hh
)
set(BIGINT_SOURCES
    third_party/bigint/BigInteger.cc
    third_party/bigint/BigIntegerUtils.cc
    third_party/bigint/BigUnsigned.cc
    third_party/bigint/BigUnsignedInABase.cc
)

######################## AGG #############################################
set(AGG_HEADERS
    third_party/agg23/agg_basics.h
    third_party/agg23/agg_clip_liang_barsky.h
    third_party/agg23/agg_conv_dash.h
    third_party/agg23/agg_conv_stroke.h
    third_party/agg23/agg_curves.h
    third_party/agg23/agg_path_storage.h
    third_party/agg23/agg_rasterizer_scanline_aa.h
    third_party/agg23/agg_renderer_scanline.h
    third_party/agg23/agg_rendering_buffer.h
    third_party/agg23/agg_scanline_u.h
)
set(AGG_SOURCES
    third_party/agg23/agg_curves.cpp
    third_party/agg23/agg_path_storage.cpp
    third_party/agg23/agg_rasterizer_scanline_aa.cpp
    third_party/agg23/agg_vcgen_dash.cpp
    third_party/agg23/agg_vcgen_stroke.cpp
)

set(ALL_SOURCES
  ${FDRM_HEDAERS} ${FDRM_SOURCES}
  ${FPDFDOC_HEDAERS} ${FPDFDOC_SOURCES}
  ${FPDFSDK_HEDAERS} ${FPDFSDK_SOURCES}
  ${FPDFAPI_HEDAERS} ${FPDFAPI_SOURCES} ${FPDFAPI_GB1_SOURCES} ${FPDFAPI_CNS1_SOURCES} ${FPDFAPI_JAPAN1_SOURCES} ${FPDFAPI_KOREA_SOURCES}
  ${FPDFTEXT_HEDAERS} ${FPDFTEXT_SOURCES}
  ${FXCODEC_HEDAERS} ${FXCODEC_SOURCES}
  ${FXC_HEDAERS} ${FXCRT_SOURCES}
  ${FXGE_HEDAERS} ${FXGE_SOURCES}
  ${FXEDIT_HEDAERS} ${FXEDIT_SOURCES}
  ${PDFWINDOW_HEDAERS} ${PDFWINDOW_SOURCES}
  ${FORMFILLER_HEDAERS} ${FORMFILLER_SOURCES}
  ${FPDFSDK_HEDAERS} ${FPDFSDK_SOURCES}
  ${WINDOWS_SOURCES}
  ${JS_STUB_HEADERS} ${JS_STUB_SOURCES}
  ${BIGINT_HEADERS} ${BIGINT_SOURCES}
  ${AGG_HEADERS} ${AGG_SOURCES}
)

if(USE_STATIC_LIBRARY)
    add_library(pdfium STATIC
        ${ALL_SOURCES}
        $<TARGET_OBJECTS:internal_jpeg>
        $<TARGET_OBJECTS:internal_zlib>
        $<TARGET_OBJECTS:internal_lcms2>
        $<TARGET_OBJECTS:internal_openjpeg>
        $<TARGET_OBJECTS:internal_jbig2>
        $<TARGET_OBJECTS:internal_freetype>
    )
else(USE_STATIC_LIBRARY)
    add_library(pdfium SHARED
        ${ALL_SOURCES}
        $<TARGET_OBJECTS:internal_jpeg>
        $<TARGET_OBJECTS:internal_zlib>
        $<TARGET_OBJECTS:internal_lcms2>
        $<TARGET_OBJECTS:internal_openjpeg>
        $<TARGET_OBJECTS:internal_jbig2>
        $<TARGET_OBJECTS:internal_freetype>
    )
endif(USE_STATIC_LIBRARY)

target_link_libraries(pdfium
  ${FREETYPE_LIBRARIES}
  ${JPEG_LIBRARY}
  ${LCMS2_LIBRARY}
  ${ZLIB_LIBRARY}
  ${OPENJPEG_LIBRARY}
)

include_directories(./fpdfsdk/include)

#Install
file(GLOB INSTALL_HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/public/*)
install(FILES ${INSTALL_HEADERS} DESTINATION include/pdfium)

install (TARGETS pdfium DESTINATION lib)
