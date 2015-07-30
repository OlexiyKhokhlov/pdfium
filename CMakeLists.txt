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

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -std=c++0x -Wc++0x-compat -fno-exceptions -pthread -fvisibility=hidden")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -pthread -fvisibility=hidden")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} -Wl,-z,defs")

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

if(USE_GB1_MAPS)
  add_definitions(-DUSE_GB1_MAPS)
  set(FPDFAPI_GB1_SOURCES
   core/src/fpdfapi/fpdf_cmaps/GB1/Adobe-GB1-UCS2_5.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/cmaps_gb1.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/GB-EUC-H_0.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/GB-EUC-V_0.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/GBK-EUC-H_2.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/GBK-EUC-V_2.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/GBK2K-H_5.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/GBK2K-V_5.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/GBKp-EUC-H_2.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/GBKp-EUC-V_2.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/GBpc-EUC-H_0.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/GBpc-EUC-V_0.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/UniGB-UCS2-H_4.cpp
   core/src/fpdfapi/fpdf_cmaps/GB1/UniGB-UCS2-V_4.cpp
  )
endif(USE_GB1_MAPS)

if(USE_CNS1_MAPS)
  add_definitions(-DUSE_CNS1_MAPS)
  set(FPDFAPI_CNS1_SOURCES
   core/src/fpdfapi/fpdf_cmaps/CNS1/Adobe-CNS1-UCS2_5.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/B5pc-H_0.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/B5pc-V_0.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/cmaps_cns1.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/CNS-EUC-H_0.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/CNS-EUC-V_0.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/ETen-B5-H_0.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/ETen-B5-V_0.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/ETenms-B5-H_0.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/ETenms-B5-V_0.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/HKscs-B5-H_5.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/HKscs-B5-V_5.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/UniCNS-UCS2-H_3.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/UniCNS-UCS2-V_3.cpp
   core/src/fpdfapi/fpdf_cmaps/CNS1/UniCNS-UTF16-H_0.cpp
  )
endif(USE_CNS1_MAPS)

if(USE_JAPAN1_MAPS)
  set(FPDFAPI_JAPAN1_SOURCES
   core/src/fpdfapi/fpdf_cmaps/Japan1/83pv-RKSJ-H_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/90ms-RKSJ-H_2.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/90ms-RKSJ-V_2.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/90msp-RKSJ-H_2.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/90msp-RKSJ-V_2.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/90pv-RKSJ-H_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/Add-RKSJ-H_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/Add-RKSJ-V_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/Adobe-Japan1-UCS2_4.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/cmaps_japan1.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/EUC-H_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/EUC-V_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/Ext-RKSJ-H_2.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/Ext-RKSJ-V_2.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/H_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/UniJIS-UCS2-HW-H_4.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/UniJIS-UCS2-HW-V_4.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/UniJIS-UCS2-H_4.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/UniJIS-UCS2-V_4.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/UniJIS-UTF16-H_5.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/UniJIS-UTF16-V_5.cpp
   core/src/fpdfapi/fpdf_cmaps/Japan1/V_1.cpp
  )
  add_definitions(-DUSE_JAPAN1_MAPS)
endif(USE_JAPAN1_MAPS)

if(USE_KOREA_MAPS)
  add_definitions(-DUSE_KOREA_MAPS)
  set(FPDFAPI_KOREA_SOURCES
   core/src/fpdfapi/fpdf_cmaps/Korea1/Adobe-Korea1-UCS2_2.cpp
   core/src/fpdfapi/fpdf_cmaps/Korea1/cmaps_korea1.cpp
   core/src/fpdfapi/fpdf_cmaps/Korea1/KSC-EUC-H_0.cpp
   core/src/fpdfapi/fpdf_cmaps/Korea1/KSC-EUC-V_0.cpp
   core/src/fpdfapi/fpdf_cmaps/Korea1/KSCms-UHC-HW-H_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Korea1/KSCms-UHC-HW-V_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Korea1/KSCms-UHC-H_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Korea1/KSCms-UHC-V_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Korea1/KSCpc-EUC-H_0.cpp
   core/src/fpdfapi/fpdf_cmaps/Korea1/UniKS-UCS2-H_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Korea1/UniKS-UCS2-V_1.cpp
   core/src/fpdfapi/fpdf_cmaps/Korea1/UniKS-UTF16-H_0.cpp
  )
endif(USE_KOREA_MAPS)

if(USE_SYSTEM_FREETYPE)
  find_package(Freetype REQUIRED)
  include_directories(${FREETYPE_INCLUDE_DIRS})
  add_definitions(-DUSE_SYSTEM_FREETYPE)
  add_library(freetype OBJECT empty.c)
else(USE_SYSTEM_FREETYPE)
  add_subdirectory(third_party/freetype)
  include_directories(third_party/freetype/include)
endif(USE_SYSTEM_FREETYPE)

if(USE_SYSTEM_JPEG)
  find_package(JPEG REQUIRED)
  include_directories(${JPEG_INCLUDE_DIRS})
  add_definitions(-DUSE_SYSTEM_JPEG)
  add_library(jpeg OBJECT empty.c)
else(USE_SYSTEM_JPEG)
  add_subdirectory(third_party/libjpeg)
endif(USE_SYSTEM_JPEG)

if(USE_SYSTEM_ZLIB)
  find_package(ZLIB REQUIRED)
  include_directories(${ZLIB_INCLUDE_DIRS})
  add_definitions(-DUSE_SYSTEM_ZLIB)
  add_library(zlib OBJECT empty.c)
else(USE_SYSTEM_ZLIB)
  add_subdirectory(third_party/zlib_v128)
endif(USE_SYSTEM_ZLIB)

if(USE_SYSTEM_LCMS2)
  find_package(LCMS2 REQUIRED)
  include_directories(${LCMS2_INCLUDE_DIRS})
  add_definitions(-DUSE_SYSTEM_LCMS2)
  add_library(lcms2 OBJECT empty.c)
else(USE_SYSTEM_LCMS2)
  add_subdirectory(third_party/lcms2-2.6)
endif(USE_SYSTEM_LCMS2)

if(USE_SYSTEM_OPENJPEG)
  find_package(OpenJpeg REQUIRED)
  include_directories(${OPENJPEG_INCLUDE_DIR})
  add_definitions(-DUSE_SYSTEM_OPENJPEG)
  add_library(openjpeg OBJECT empty.c)
else(USE_SYSTEM_OPENJPEG)
  add_subdirectory(third_party/libopenjpeg20)
  add_definitions(-DOPJ_STATIC)
endif(USE_SYSTEM_OPENJPEG)

#Use own jbig2 in anytime
add_subdirectory(core/src/fxcodec/jbig2)

add_definitions(
  -D_FPDFSDK_LIB
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

######################## FDRM #############################################
set(FDRM_HEDAERS
  core/include/fdrm/fx_crypt.h
)

set(FDRM_SOURCES
  core/src/fdrm/crypto/fx_crypt.cpp
  core/src/fdrm/crypto/fx_crypt_aes.cpp
  core/src/fdrm/crypto/fx_crypt_sha.cpp
)

#add_library(fdrm STATIC ${FDRM_HEDAERS} ${FDRM_SOURCES})

######################## FPDFDOC ###########################################
set(FPDFDOC_HEDAERS
  core/include/fpdfdoc/fpdf_ap.h
  core/include/fpdfdoc/fpdf_doc.h
  core/include/fpdfdoc/fpdf_tagged.h
  core/include/fpdfdoc/fpdf_vt.h
  core/src/fpdfdoc/pdf_vt.h
  core/src/fpdfdoc/tagged_int.h  
)

set(FPDFDOC_SOURCES

  core/src/fpdfdoc/doc_action.cpp
  core/src/fpdfdoc/doc_annot.cpp
  core/src/fpdfdoc/doc_ap.cpp
  core/src/fpdfdoc/doc_basic.cpp
  core/src/fpdfdoc/doc_bookmark.cpp
  core/src/fpdfdoc/doc_form.cpp
  core/src/fpdfdoc/doc_formcontrol.cpp
  core/src/fpdfdoc/doc_formfield.cpp
  core/src/fpdfdoc/doc_link.cpp
  core/src/fpdfdoc/doc_metadata.cpp
  core/src/fpdfdoc/doc_ocg.cpp
  core/src/fpdfdoc/doc_tagged.cpp
  core/src/fpdfdoc/doc_utils.cpp
  core/src/fpdfdoc/doc_viewerPreferences.cpp
  core/src/fpdfdoc/doc_vt.cpp
  core/src/fpdfdoc/doc_vtmodule.cpp
)
#add_library(fpdfdoc STATIC ${FPDFDOC_HEDAERS} ${FPDFDOC_SOURCES})

######################## FPDFAPI ###########################################
set(FPDFAPI_HEDAERS
  core/include/fpdfapi/fpdfapi.h
  core/include/fpdfapi/fpdf_module.h
  core/include/fpdfapi/fpdf_objects.h
  core/include/fpdfapi/fpdf_page.h
  core/include/fpdfapi/fpdf_pageobj.h
  core/include/fpdfapi/fpdf_parser.h
  core/include/fpdfapi/fpdf_render.h
  core/include/fpdfapi/fpdf_resource.h
  core/include/fpdfapi/fpdf_serial.h
  core/src/fpdfapi/fpdf_cmaps/cmap_int.h
)

set(FPDFAPI_SOURCES
  core/src/fpdfapi/fpdf_basic_module.cpp
  core/src/fpdfapi/fpdf_cmaps/fpdf_cmaps.cpp
  core/src/fpdfapi/fpdf_edit/editint.h
  core/src/fpdfapi/fpdf_edit/fpdf_edit_content.cpp
  core/src/fpdfapi/fpdf_edit/fpdf_edit_create.cpp
  core/src/fpdfapi/fpdf_edit/fpdf_edit_doc.cpp
  core/src/fpdfapi/fpdf_edit/fpdf_edit_image.cpp
  core/src/fpdfapi/fpdf_font/common.h
  core/src/fpdfapi/fpdf_font/font_int.h
  core/src/fpdfapi/fpdf_font/fpdf_font.cpp
  core/src/fpdfapi/fpdf_font/fpdf_font_charset.cpp
  core/src/fpdfapi/fpdf_font/fpdf_font_cid.cpp
  core/src/fpdfapi/fpdf_font/ttgsubtable.cpp
  core/src/fpdfapi/fpdf_font/ttgsubtable.h
  core/src/fpdfapi/fpdf_page/fpdf_page.cpp
  core/src/fpdfapi/fpdf_page/fpdf_page_colors.cpp
  core/src/fpdfapi/fpdf_page/fpdf_page_doc.cpp
  core/src/fpdfapi/fpdf_page/fpdf_page_func.cpp
  core/src/fpdfapi/fpdf_page/fpdf_page_graph_state.cpp
  core/src/fpdfapi/fpdf_page/fpdf_page_image.cpp
  core/src/fpdfapi/fpdf_page/fpdf_page_parser.cpp
  core/src/fpdfapi/fpdf_page/fpdf_page_parser_old.cpp
  core/src/fpdfapi/fpdf_page/fpdf_page_path.cpp
  core/src/fpdfapi/fpdf_page/fpdf_page_pattern.cpp
  core/src/fpdfapi/fpdf_page/pageint.h
  core/src/fpdfapi/fpdf_parser/filters_int.h
  core/src/fpdfapi/fpdf_parser/fpdf_parser_decode.cpp
  core/src/fpdfapi/fpdf_parser/fpdf_parser_document.cpp
  core/src/fpdfapi/fpdf_parser/fpdf_parser_encrypt.cpp
  core/src/fpdfapi/fpdf_parser/fpdf_parser_fdf.cpp
  core/src/fpdfapi/fpdf_parser/fpdf_parser_filters.cpp
  core/src/fpdfapi/fpdf_parser/fpdf_parser_objects.cpp
  core/src/fpdfapi/fpdf_parser/fpdf_parser_parser.cpp
  core/src/fpdfapi/fpdf_parser/fpdf_parser_utility.cpp
  core/src/fpdfapi/fpdf_render/fpdf_render.cpp
  core/src/fpdfapi/fpdf_render/fpdf_render_cache.cpp
  core/src/fpdfapi/fpdf_render/fpdf_render_image.cpp
  core/src/fpdfapi/fpdf_render/fpdf_render_loadimage.cpp
  core/src/fpdfapi/fpdf_render/fpdf_render_pattern.cpp
  core/src/fpdfapi/fpdf_render/fpdf_render_text.cpp
  core/src/fpdfapi/fpdf_render/render_int.h
)
#add_library(fpdfapi STATIC ${FPDFAPI_HEDAERS} ${FPDFAPI_SOURCES})

######################## FPDFTEXT #############################################
set(FPDFTEXT_HEDAERS
  core/include/fpdftext/fpdf_text.h
  core/src/fpdftext/text_int.h
  core/src/fpdftext/txtproc.h
)

set(FPDFTEXT_SOURCES
  core/src/fpdftext/fpdf_text.cpp
  core/src/fpdftext/fpdf_text_int.cpp
  core/src/fpdftext/fpdf_text_search.cpp
  core/src/fpdftext/unicodenormalization.cpp
  core/src/fpdftext/unicodenormalizationdata.cpp
)

#add_library(fpdftext STATIC ${FPDFTEXT_HEDAERS} ${FPDFTEXT_SOURCES})

######################## FXCODEC #############################################
set(FXCODEC_HEDAERS
  core/include/fxcodec/fx_codec.h
  core/include/fxcodec/fx_codec_def.h
  core/include/fxcodec/fx_codec_provider.h
  core/src/fxcodec/codec/codec_int.h
)

set(FXCODEC_SOURCES
  core/src/fxcodec/codec/fx_codec.cpp
  core/src/fxcodec/codec/fx_codec_fax.cpp
  core/src/fxcodec/codec/fx_codec_flate.cpp
  core/src/fxcodec/codec/fx_codec_icc.cpp
  core/src/fxcodec/codec/fx_codec_jbig.cpp
  core/src/fxcodec/codec/fx_codec_jbig_enc.cpp
  core/src/fxcodec/codec/fx_codec_jpeg.cpp
  core/src/fxcodec/codec/fx_codec_jpx_opj.cpp
)

#add_library(fxcodec STATIC ${FXCODEC_HEDAERS} ${FXCODEC_SOURCES})

######################## FXCRT #############################################
set(FXCRT_HEDAERS
  core/include/fxcrt/fx_arb.h
  core/include/fxcrt/fx_basic.h
  core/include/fxcrt/fx_coordinates.h
  core/include/fxcrt/fx_ext.h
  core/include/fxcrt/fx_memory.h
  core/include/fxcrt/fx_stream.h
  core/include/fxcrt/fx_string.h
  core/include/fxcrt/fx_system.h
  core/include/fxcrt/fx_ucd.h
  core/include/fxcrt/fx_xml.h
  core/src/fxcrt/extension.h
  core/src/fxcrt/fxcrt_platforms.h
  core/src/fxcrt/fxcrt_posix.h
  #core/src/fxcrt/fxcrt_windows.h
  core/src/fxcrt/fx_arabic.h
  core/src/fxcrt/mem_int.h
  core/src/fxcrt/plex.h
  core/src/fxcrt/xml_int.h
)

set(FXCRT_SOURCES
  core/src/fxcrt/fxcrt_platforms.cpp        
  core/src/fxcrt/fxcrt_posix.cpp        
#  core/src/fxcrt/fxcrt_windows.cpp        
  core/src/fxcrt/fx_arabic.cpp        
  core/src/fxcrt/fx_basic_array.cpp
  core/src/fxcrt/fx_basic_bstring.cpp
  core/src/fxcrt/fx_basic_buffer.cpp
  core/src/fxcrt/fx_basic_coords.cpp
  core/src/fxcrt/fx_basic_gcc.cpp
  core/src/fxcrt/fx_basic_list.cpp
  core/src/fxcrt/fx_basic_maps.cpp
  core/src/fxcrt/fx_basic_memmgr.cpp
#  core/src/fxcrt/fx_basic_memmgr_mini.cpp
  core/src/fxcrt/fx_basic_plex.cpp
  core/src/fxcrt/fx_basic_utf.cpp
  core/src/fxcrt/fx_basic_util.cpp
  core/src/fxcrt/fx_basic_wstring.cpp
  core/src/fxcrt/fx_extension.cpp
  core/src/fxcrt/fx_ucddata.cpp
  core/src/fxcrt/fx_unicode.cpp
  core/src/fxcrt/fx_xml_composer.cpp
  core/src/fxcrt/fx_xml_parser.cpp
)

#add_library(fxcrt STATIC ${FXCRT_HEDAERS} ${FXCRT_SOURCES})

######################## FXGE #############################################
set(FXGE_HEDAERS
  core/include/fxge/fpf.h
  core/include/fxge/fx_dib.h
  core/include/fxge/fx_font.h
  core/include/fxge/fx_freetype.h
  core/include/fxge/fx_ge.h
#  core/include/fxge/fx_ge_apple.h
#  core/include/fxge/fx_ge_win32.h
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
  core/src/fxge/agg/include/fx_agg_driver.h
#   core/src/fxge/android/fpf_skiafont.h
#   core/src/fxge/android/fpf_skiafontmgr.h
#   core/src/fxge/android/fpf_skiamodule.h
#   core/src/fxge/android/fx_android_font.h
#   core/src/fxge/android/fx_fpf.h
#  core/src/fxge/apple/apple_int.h
  core/src/fxge/dib/dib_int.h
  core/src/fxge/ge/text_int.h
)

set(FXGE_SOURCES
  core/src/fxge/agg/src/fx_agg_driver.cpp
  third_party/agg23/agg_curves.cpp
  third_party/agg23/agg_path_storage.cpp
  third_party/agg23/agg_rasterizer_scanline_aa.cpp
  third_party/agg23/agg_vcgen_dash.cpp
  third_party/agg23/agg_vcgen_stroke.cpp
#   core/src/fxge/android/fpf_skiafont.cpp
#   core/src/fxge/android/fpf_skiafontmgr.cpp        
#   core/src/fxge/android/fpf_skiamodule.cpp        
#   core/src/fxge/android/fx_android_font.cpp
#   core/src/fxge/android/fx_android_imp.cpp
#  core/src/fxge/apple/fx_apple_platform.cpp
#  core/src/fxge/apple/fx_mac_imp.cpp
#  core/src/fxge/apple/fx_quartz_device.cpp
  core/src/fxge/dib/fx_dib_composite.cpp
  core/src/fxge/dib/fx_dib_convert.cpp
  core/src/fxge/dib/fx_dib_engine.cpp
  core/src/fxge/dib/fx_dib_main.cpp
  core/src/fxge/dib/fx_dib_transform.cpp
  core/src/fxge/fontdata/chromefontdata/FoxitDingbats.c
  core/src/fxge/fontdata/chromefontdata/FoxitFixed.c
  core/src/fxge/fontdata/chromefontdata/FoxitFixedBold.c
  core/src/fxge/fontdata/chromefontdata/FoxitFixedBoldItalic.c
  core/src/fxge/fontdata/chromefontdata/FoxitFixedItalic.c
  core/src/fxge/fontdata/chromefontdata/FoxitSans.c
  core/src/fxge/fontdata/chromefontdata/FoxitSansBold.c
  core/src/fxge/fontdata/chromefontdata/FoxitSansBoldItalic.c
  core/src/fxge/fontdata/chromefontdata/FoxitSansItalic.c
  core/src/fxge/fontdata/chromefontdata/FoxitSansMM.c
  core/src/fxge/fontdata/chromefontdata/FoxitSerif.c
  core/src/fxge/fontdata/chromefontdata/FoxitSerifBold.c
  core/src/fxge/fontdata/chromefontdata/FoxitSerifBoldItalic.c
  core/src/fxge/fontdata/chromefontdata/FoxitSerifItalic.c
  core/src/fxge/fontdata/chromefontdata/FoxitSerifMM.c
  core/src/fxge/fontdata/chromefontdata/FoxitSymbol.c
  core/src/fxge/freetype/fx_freetype.c
  core/src/fxge/ge/fx_ge.cpp
  core/src/fxge/ge/fx_ge_device.cpp
  core/src/fxge/ge/fx_ge_font.cpp
  core/src/fxge/ge/fx_ge_fontmap.cpp
  core/src/fxge/ge/fx_ge_linux.cpp
  core/src/fxge/ge/fx_ge_path.cpp
  core/src/fxge/ge/fx_ge_ps.cpp
  core/src/fxge/ge/fx_ge_text.cpp
)

#add_library(fxge STATIC ${FXGE_HEDAERS} ${FXGE_SOURCES})

######################## FXEDIT #############################################
set(FXEDIT_HEDAERS
  fpdfsdk/include/fxedit/fx_edit.h
  fpdfsdk/include/fxedit/fxet_edit.h
  fpdfsdk/include/fxedit/fxet_list.h
  fpdfsdk/include/fxedit/fxet_stub.h
)

set(FXEDIT_SOURCES
  fpdfsdk/src/fxedit/fxet_ap.cpp
  fpdfsdk/src/fxedit/fxet_edit.cpp
  fpdfsdk/src/fxedit/fxet_list.cpp
  fpdfsdk/src/fxedit/fxet_module.cpp
  fpdfsdk/src/fxedit/fxet_pageobjs.cpp
)

#add_library(fxedit STATIC ${FXEDIT_HEDAERS} ${FXEDIT_SOURCES})

######################## PDFWINDOW #############################################
set(PDFWINDOW_HEDAERS
  fpdfsdk/include/pdfwindow/IPDFWindow.h
  fpdfsdk/include/pdfwindow/PDFWindow.h
  fpdfsdk/include/pdfwindow/PWL_Button.h
  fpdfsdk/include/pdfwindow/PWL_Caret.h
  fpdfsdk/include/pdfwindow/PWL_ComboBox.h
  fpdfsdk/include/pdfwindow/PWL_Edit.h
  fpdfsdk/include/pdfwindow/PWL_EditCtrl.h
  fpdfsdk/include/pdfwindow/PWL_FontMap.h
  fpdfsdk/include/pdfwindow/PWL_Icon.h
  fpdfsdk/include/pdfwindow/PWL_IconList.h
  fpdfsdk/include/pdfwindow/PWL_Label.h
  fpdfsdk/include/pdfwindow/PWL_ListBox.h
  fpdfsdk/include/pdfwindow/PWL_ListCtrl.h
  fpdfsdk/include/pdfwindow/PWL_Note.h
  fpdfsdk/include/pdfwindow/PWL_ScrollBar.h
  fpdfsdk/include/pdfwindow/PWL_Signature.h
  fpdfsdk/include/pdfwindow/PWL_SpecialButton.h
  fpdfsdk/include/pdfwindow/PWL_Utils.h
  fpdfsdk/include/pdfwindow/PWL_Wnd.h
)

set(PDFWINDOW_SOURCES
  fpdfsdk/src/pdfwindow/PWL_Button.cpp
  fpdfsdk/src/pdfwindow/PWL_Caret.cpp
  fpdfsdk/src/pdfwindow/PWL_ComboBox.cpp
  fpdfsdk/src/pdfwindow/PWL_Edit.cpp
  fpdfsdk/src/pdfwindow/PWL_EditCtrl.cpp
  fpdfsdk/src/pdfwindow/PWL_FontMap.cpp
  fpdfsdk/src/pdfwindow/PWL_Icon.cpp
  fpdfsdk/src/pdfwindow/PWL_IconList.cpp
  fpdfsdk/src/pdfwindow/PWL_Label.cpp
  fpdfsdk/src/pdfwindow/PWL_ListBox.cpp
  fpdfsdk/src/pdfwindow/PWL_ListCtrl.cpp
  fpdfsdk/src/pdfwindow/PWL_Note.cpp
  fpdfsdk/src/pdfwindow/PWL_ScrollBar.cpp
  fpdfsdk/src/pdfwindow/PWL_Signature.cpp
  fpdfsdk/src/pdfwindow/PWL_SpecialButton.cpp
  fpdfsdk/src/pdfwindow/PWL_Utils.cpp
  fpdfsdk/src/pdfwindow/PWL_Wnd.cpp
)

#add_library(pdfwindow STATIC ${PDFWINDOW_HEDAERS} ${PDFWINDOW_SOURCES})

######################## FORMFILLER #############################################
set(FORMFILLER_HEDAERS
  fpdfsdk/include/formfiller/FFL_CBA_Fontmap.h
  fpdfsdk/include/formfiller/FFL_CheckBox.h
  fpdfsdk/include/formfiller/FFL_ComboBox.h
  fpdfsdk/include/formfiller/FFL_FormFiller.h
  fpdfsdk/include/formfiller/FFL_IFormFiller.h
  fpdfsdk/include/formfiller/FFL_ListBox.h
  fpdfsdk/include/formfiller/FFL_Notify.h
  fpdfsdk/include/formfiller/FFL_PushButton.h
  fpdfsdk/include/formfiller/FFL_RadioButton.h
  fpdfsdk/include/formfiller/FFL_TextField.h
  fpdfsdk/include/formfiller/FFL_Utils.h
  fpdfsdk/include/formfiller/FormFiller.h
)

set(FORMFILLER_SOURCES
  fpdfsdk/src/formfiller/FFL_CBA_Fontmap.cpp
  fpdfsdk/src/formfiller/FFL_CheckBox.cpp
  fpdfsdk/src/formfiller/FFL_ComboBox.cpp
  fpdfsdk/src/formfiller/FFL_FormFiller.cpp
  fpdfsdk/src/formfiller/FFL_IFormFiller.cpp
  fpdfsdk/src/formfiller/FFL_ListBox.cpp
  fpdfsdk/src/formfiller/FFL_Notify.cpp
  fpdfsdk/src/formfiller/FFL_PushButton.cpp
  fpdfsdk/src/formfiller/FFL_RadioButton.cpp
  fpdfsdk/src/formfiller/FFL_TextField.cpp
  fpdfsdk/src/formfiller/FFL_Utils.cpp
)

#add_library(formfiller STATIC ${FORMFILLER_HEDAERS} ${FORMFILLER_SOURCES})

######################### FPDFSDK #############################################
set(FPDFSDK_HEDAERS
  fpdfsdk/src/resource.h  
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
  fpdfsdk/include/fsdk_actionhandler.h
  fpdfsdk/include/fsdk_annothandler.h
  fpdfsdk/include/fsdk_baseannot.h
  fpdfsdk/include/fsdk_baseform.h
  fpdfsdk/src/fpdfdoc.cpp
  fpdfsdk/src/fpdfeditimg.cpp
  fpdfsdk/src/fpdfeditpage.cpp
  fpdfsdk/src/fpdfformfill.cpp
  fpdfsdk/src/fpdfppo.cpp
  fpdfsdk/src/fpdfsave.cpp
  fpdfsdk/src/fpdftext.cpp
  fpdfsdk/src/fpdfview.cpp
  fpdfsdk/src/fpdf_dataavail.cpp
  fpdfsdk/src/fpdf_ext.cpp
  fpdfsdk/src/fpdf_flatten.cpp
  fpdfsdk/src/fpdf_progressive.cpp
  fpdfsdk/src/fpdf_searchex.cpp
  fpdfsdk/src/fpdf_sysfontinfo.cpp
  fpdfsdk/src/fpdf_transformpage.cpp
  fpdfsdk/src/fsdk_actionhandler.cpp
  fpdfsdk/src/fsdk_annothandler.cpp
  fpdfsdk/src/fsdk_baseannot.cpp
  fpdfsdk/src/fsdk_baseform.cpp
  fpdfsdk/src/fsdk_mgr.cpp
  fpdfsdk/src/fsdk_rendercontext.cpp
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
)

if(USE_STATIC_LIBRARY)
    add_library(pdfium STATIC
        ${ALL_SOURCES}
	$<TARGET_OBJECTS:jpeg>
	$<TARGET_OBJECTS:zlib>
	$<TARGET_OBJECTS:lcms2>
	$<TARGET_OBJECTS:openjpeg>
	$<TARGET_OBJECTS:jbig2>
	$<TARGET_OBJECTS:freetype>
    )
else(USE_STATIC_LIBRARY)
    add_library(pdfium SHARED
        ${ALL_SOURCES}
	$<TARGET_OBJECTS:jpeg>
	$<TARGET_OBJECTS:zlib>
	$<TARGET_OBJECTS:lcms2>
	$<TARGET_OBJECTS:openjpeg>
	$<TARGET_OBJECTS:jbig2>
	$<TARGET_OBJECTS:freetype>
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
