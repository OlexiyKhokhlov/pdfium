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
core/fxge/win32/cfx_psrenderer.cpp
core/fxge/win32/cfx_psrenderer.h
core/fxge/win32/cfx_windowsdib.h
core/fxge/win32/cpsoutput.cpp
core/fxge/win32/cpsoutput.h
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
core/ffpdfapi/cmaps/CNS1/Adobe-CNS1-UCS2_5.cpp
core/ffpdfapi/cmaps/CNS1/B5pc-H_0.cpp
core/ffpdfapi/cmaps/CNS1/B5pc-V_0.cpp
core/ffpdfapi/cmaps/CNS1/cmaps_cns1.cpp
core/ffpdfapi/cmaps/CNS1/cmaps_cns1.h
core/ffpdfapi/cmaps/CNS1/CNS-EUC-H_0.cpp
core/ffpdfapi/cmaps/CNS1/CNS-EUC-V_0.cpp
core/ffpdfapi/cmaps/CNS1/ETen-B5-H_0.cpp
core/ffpdfapi/cmaps/CNS1/ETen-B5-V_0.cpp
core/ffpdfapi/cmaps/CNS1/ETenms-B5-H_0.cpp
core/ffpdfapi/cmaps/CNS1/ETenms-B5-V_0.cpp
core/ffpdfapi/cmaps/CNS1/HKscs-B5-H_5.cpp
core/ffpdfapi/cmaps/CNS1/HKscs-B5-V_5.cpp
core/ffpdfapi/cmaps/CNS1/UniCNS-UCS2-H_3.cpp
core/ffpdfapi/cmaps/CNS1/UniCNS-UCS2-V_3.cpp
core/ffpdfapi/cmaps/CNS1/UniCNS-UTF16-H_0.cpp
)
endif(USE_CNS1_MAPS)

if(USE_GB1_MAPS)
  add_definitions(-DUSE_GB1_MAPS)
  set(FPDFAPI_GB1_SOURCES
core/ffpdfapi/cmaps/GB1/Adobe-GB1-UCS2_5.cpp
core/ffpdfapi/cmaps/GB1/cmaps_gb1.cpp
core/ffpdfapi/cmaps/GB1/cmaps_gb1.h
core/ffpdfapi/cmaps/GB1/GB-EUC-H_0.cpp
core/ffpdfapi/cmaps/GB1/GB-EUC-V_0.cpp
core/ffpdfapi/cmaps/GB1/GBK2K-H_5.cpp
core/ffpdfapi/cmaps/GB1/GBK2K-V_5.cpp
core/ffpdfapi/cmaps/GB1/GBK-EUC-H_2.cpp
core/ffpdfapi/cmaps/GB1/GBK-EUC-V_2.cpp
core/ffpdfapi/cmaps/GB1/GBKp-EUC-H_2.cpp
core/ffpdfapi/cmaps/GB1/GBKp-EUC-V_2.cpp
core/ffpdfapi/cmaps/GB1/GBpc-EUC-H_0.cpp
core/ffpdfapi/cmaps/GB1/GBpc-EUC-V_0.cpp
core/ffpdfapi/cmaps/GB1/UniGB-UCS2-H_4.cpp
core/ffpdfapi/cmaps/GB1/UniGB-UCS2-V_4.cpp )
endif(USE_GB1_MAPS)

if(USE_JAPAN1_MAPS)
  set(FPDFAPI_JAPAN1_SOURCES
core/ffpdfapi/cmaps/Japan1/83pv-RKSJ-H_1.cpp
core/ffpdfapi/cmaps/Japan1/90msp-RKSJ-H_2.cpp
core/ffpdfapi/cmaps/Japan1/90msp-RKSJ-V_2.cpp
core/ffpdfapi/cmaps/Japan1/90ms-RKSJ-H_2.cpp
core/ffpdfapi/cmaps/Japan1/90ms-RKSJ-V_2.cpp
core/ffpdfapi/cmaps/Japan1/90pv-RKSJ-H_1.cpp
core/ffpdfapi/cmaps/Japan1/Add-RKSJ-H_1.cpp
core/ffpdfapi/cmaps/Japan1/Add-RKSJ-V_1.cpp
core/ffpdfapi/cmaps/Japan1/Adobe-Japan1-UCS2_4.cpp
core/ffpdfapi/cmaps/Japan1/cmaps_japan1.cpp
core/ffpdfapi/cmaps/Japan1/cmaps_japan1.h
core/ffpdfapi/cmaps/Japan1/EUC-H_1.cpp
core/ffpdfapi/cmaps/Japan1/EUC-V_1.cpp
core/ffpdfapi/cmaps/Japan1/Ext-RKSJ-H_2.cpp
core/ffpdfapi/cmaps/Japan1/Ext-RKSJ-V_2.cpp
core/ffpdfapi/cmaps/Japan1/H_1.cpp
core/ffpdfapi/cmaps/Japan1/UniJIS-UCS2-H_4.cpp
core/ffpdfapi/cmaps/Japan1/UniJIS-UCS2-HW-H_4.cpp
core/ffpdfapi/cmaps/Japan1/UniJIS-UCS2-HW-V_4.cpp
core/ffpdfapi/cmaps/Japan1/UniJIS-UCS2-V_4.cpp
core/ffpdfapi/cmaps/Japan1/V_1.cpp  )
  add_definitions(-DUSE_JAPAN1_MAPS)
endif(USE_JAPAN1_MAPS)

if(USE_KOREA_MAPS)
  add_definitions(-DUSE_KOREA_MAPS)
  set(FPDFAPI_KOREA_SOURCES
core/ffpdfapi/cmaps/Korea1/Adobe-Korea1-UCS2_2.cpp
core/ffpdfapi/cmaps/Korea1/cmaps_korea1.cpp
core/ffpdfapi/cmaps/Korea1/cmaps_korea1.h
core/ffpdfapi/cmaps/Korea1/KSC-EUC-H_0.cpp
core/ffpdfapi/cmaps/Korea1/KSC-EUC-V_0.cpp
core/ffpdfapi/cmaps/Korea1/KSCms-UHC-H_1.cpp
core/ffpdfapi/cmaps/Korea1/KSCms-UHC-HW-H_1.cpp
core/ffpdfapi/cmaps/Korea1/KSCms-UHC-HW-V_1.cpp
core/ffpdfapi/cmaps/Korea1/KSCms-UHC-V_1.cpp
core/ffpdfapi/cmaps/Korea1/KSCpc-EUC-H_0.cpp
core/ffpdfapi/cmaps/Korea1/UniKS-UCS2-H_1.cpp
core/ffpdfapi/cmaps/Korea1/UniKS-UCS2-V_1.cpp
core/ffpdfapi/cmaps/Korea1/UniKS-UTF16-H_0.cpp
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
set(FPDFSDK_SOURCES
 fpdfsdk/cba_annotiterator.h
fpdfsdk/cfx_systemhandler.h
fpdfsdk/cpdfsdk_annot.h
fpdfsdk/cpdfsdk_annothandlermgr.h
fpdfsdk/cpdfsdk_annotiteration.h
fpdfsdk/cpdfsdk_baannot.h
fpdfsdk/cpdfsdk_baannothandler.h
fpdfsdk/cpdfsdk_datetime.h
fpdfsdk/cpdfsdk_formfillenvironment.h
fpdfsdk/cpdfsdk_interform.h
fpdfsdk/cpdfsdk_pageview.h
fpdfsdk/cpdfsdk_widget.h
fpdfsdk/cpdfsdk_widgethandler.h
# fpdfsdk/cpdfsdk_xfawidget.h
# fpdfsdk/cpdfsdk_xfawidgethandler.h
fpdfsdk/fpdfview_c_api_test.h
fpdfsdk/fsdk_actionhandler.h
fpdfsdk/fsdk_common.h
fpdfsdk/fsdk_define.h
fpdfsdk/fsdk_pauseadapter.h
fpdfsdk/ipdfsdk_annothandler.h
fpdfsdk/pdfsdk_fieldaction.h
fpdfsdk/cba_annotiterator.cpp
fpdfsdk/cfx_systemhandler.cpp
fpdfsdk/cpdfsdk_annot.cpp
fpdfsdk/cpdfsdk_annothandlermgr.cpp
fpdfsdk/cpdfsdk_annotiteration.cpp
fpdfsdk/cpdfsdk_baannot.cpp
fpdfsdk/cpdfsdk_baannothandler.cpp
fpdfsdk/cpdfsdk_datetime.cpp
fpdfsdk/cpdfsdk_formfillenvironment.cpp
fpdfsdk/cpdfsdk_interform.cpp
fpdfsdk/cpdfsdk_pageview.cpp
fpdfsdk/cpdfsdk_widget.cpp
fpdfsdk/cpdfsdk_widgethandler.cpp
# fpdfsdk/cpdfsdk_xfawidget.cpp
# fpdfsdk/cpdfsdk_xfawidgethandler.cpp
fpdfsdk/fpdf_dataavail.cpp
#fpdfsdk/fpdf_dataavail_embeddertest.cpp
fpdfsdk/fpdfdoc.cpp
# fpdfsdk/fpdfdoc_embeddertest.cpp
# fpdfsdk/fpdfdoc_unittest.cpp
# fpdfsdk/fpdfedit_embeddertest.cpp
fpdfsdk/fpdfeditimg.cpp
#fpdfsdk/fpdfeditimg_unittest.cpp
fpdfsdk/fpdfeditpage.cpp
fpdfsdk/fpdfeditpath.cpp
fpdfsdk/fpdfedittext.cpp
fpdfsdk/fpdf_ext.cpp
# fpdfsdk/fpdfext_embeddertest.cpp
fpdfsdk/fpdf_flatten.cpp
#fpdfsdk/fpdf_flatten_embeddertest.cpp
fpdfsdk/fpdfformfill.cpp
#fpdfsdk/fpdfformfill_embeddertest.cpp
fpdfsdk/fpdfppo.cpp
#fpdfsdk/fpdfppo_embeddertest.cpp
fpdfsdk/fpdf_progressive.cpp
fpdfsdk/fpdfsave.cpp
# fpdfsdk/fpdfsave_embeddertest.cpp
fpdfsdk/fpdf_searchex.cpp
fpdfsdk/fpdf_structtree.cpp
#fpdfsdk/fpdf_structtree_embeddertest.cpp
fpdfsdk/fpdf_sysfontinfo.cpp
fpdfsdk/fpdftext.cpp
#fpdfsdk/fpdftext_embeddertest.cpp
fpdfsdk/fpdf_transformpage.cpp
fpdfsdk/fpdfview.cpp
#fpdfsdk/fpdfview_embeddertest.cpp
#fpdfsdk/fpdfview_unittest.cpp
fpdfsdk/fsdk_actionhandler.cpp
#fpdfsdk/fsdk_baseform_embeddertest.cpp
fpdfsdk/fsdk_pauseadapter.cpp
fpdfsdk/pdfsdk_fieldaction.cpp
)

######################## FDRM #############################################
set(FDRM_SOURCES
core/fdrm/crypto/fx_crypt_aes.cpp
core/fdrm/crypto/fx_crypt.cpp
core/fdrm/crypto/fx_crypt.h
core/fdrm/crypto/fx_crypt_sha.cpp
#core/fdrm/crypt/fx_crypt_unittest.cpp
)

######################## FPDFDOC ###########################################
set(FPDFDOC_SOURCES
core/fpdfdoc/cline.cpp
core/fpdfdoc/cline.h
core/fpdfdoc/clines.cpp
core/fpdfdoc/clines.h
core/fpdfdoc/cpdf_aaction.cpp
core/fpdfdoc/cpdf_aaction.h
core/fpdfdoc/cpdf_action.cpp
core/fpdfdoc/cpdf_actionfields.cpp
core/fpdfdoc/cpdf_actionfields.h
core/fpdfdoc/cpdf_action.h
core/fpdfdoc/cpdf_annot.cpp
core/fpdfdoc/cpdf_annot.h
core/fpdfdoc/cpdf_annotlist.cpp
core/fpdfdoc/cpdf_annotlist.h
core/fpdfdoc/cpdf_apsettings.cpp
core/fpdfdoc/cpdf_apsettings.h
core/fpdfdoc/cpdf_bookmark.cpp
core/fpdfdoc/cpdf_bookmark.h
core/fpdfdoc/cpdf_bookmarktree.cpp
core/fpdfdoc/cpdf_bookmarktree.h
core/fpdfdoc/cpdf_defaultappearance.cpp
core/fpdfdoc/cpdf_defaultappearance.h
core/fpdfdoc/cpdf_dest.cpp
core/fpdfdoc/cpdf_dest.h
#core/fpdfdoc/cpdf_dest_unittest.cpp
core/fpdfdoc/cpdf_docjsactions.cpp
core/fpdfdoc/cpdf_docjsactions.h
core/fpdfdoc/cpdf_filespec.cpp
core/fpdfdoc/cpdf_filespec.h
#core/fpdfdoc/cpdf_filespec_unittest.cpp
core/fpdfdoc/cpdf_formcontrol.cpp
core/fpdfdoc/cpdf_formcontrol.h
core/fpdfdoc/cpdf_formfield.cpp
core/fpdfdoc/cpdf_formfield.h
#core/fpdfdoc/cpdf_formfield_unittest.cpp
core/fpdfdoc/cpdf_iconfit.cpp
core/fpdfdoc/cpdf_iconfit.h
core/fpdfdoc/cpdf_interform.cpp
core/fpdfdoc/cpdf_interform.h
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
core/fpdfdoc/cpdf_occontext.cpp
core/fpdfdoc/cpdf_occontext.h
core/fpdfdoc/cpdf_pagelabel.cpp
core/fpdfdoc/cpdf_pagelabel.h
core/fpdfdoc/cpdf_variabletext.cpp
core/fpdfdoc/cpdf_variabletext.h
core/fpdfdoc/cpdf_viewerpreferences.cpp
core/fpdfdoc/cpdf_viewerpreferences.h
core/fpdfdoc/cpvt_arraytemplate.h
core/fpdfdoc/cpvt_color.cpp
core/fpdfdoc/cpvt_color.h
core/fpdfdoc/cpvt_dash.h
core/fpdfdoc/cpvt_floatrect.h
core/fpdfdoc/cpvt_fontmap.cpp
core/fpdfdoc/cpvt_fontmap.h
core/fpdfdoc/cpvt_generateap.cpp
core/fpdfdoc/cpvt_generateap.h
core/fpdfdoc/cpvt_line.h
core/fpdfdoc/cpvt_lineinfo.h
core/fpdfdoc/cpvt_secprops.h
core/fpdfdoc/cpvt_section.h
core/fpdfdoc/cpvt_sectioninfo.cpp
core/fpdfdoc/cpvt_sectioninfo.h
core/fpdfdoc/cpvt_word.h
core/fpdfdoc/cpvt_wordinfo.cpp
core/fpdfdoc/cpvt_wordinfo.h
core/fpdfdoc/cpvt_wordplace.h
core/fpdfdoc/cpvt_wordprops.h
core/fpdfdoc/cpvt_wordrange.h
core/fpdfdoc/csection.cpp
core/fpdfdoc/csection.h
core/fpdfdoc/ctypeset.cpp
core/fpdfdoc/ctypeset.h
core/fpdfdoc/doc_tagged.cpp
core/fpdfdoc/fpdf_tagged.h
core/fpdfdoc/ipdf_formnotify.h
core/fpdfdoc/ipvt_fontmap.h
core/fpdfdoc/tagged_int.h)

######################## FPDFAPI ###########################################
set(FPDFAPI_SOURCES
core/fpdfapi/cmaps/fpdf_cmaps.cpp
core/fpdfapi/cmaps/cmap_int.h
core/fpdfapi/cpdf_modulemgr.cpp
core/fpdfapi/cpdf_modulemgr.h
core/fpdfapi/cpdf_pagerendercontext.cpp
core/fpdfapi/cpdf_pagerendercontext
core/fpdfapi/edit/cpdf_creator.h
core/fpdfapi/edit/cpdf_pagecontentgenerator.cpp
core/fpdfapi/edit/cpdf_pagecontentgenerator.h
# core/fpdfapi/edit/cpdf_pagecontentgenerator_unittest.cpp
core/fpdfapi/edit/editint.h
core/fpdfapi/edit/fpdf_edit_create.cpp
core/fpdfapi/font/cpdf_cidfont.cpp
core/fpdfapi/font/cpdf_cidfont.h
core/fpdfapi/font/cpdf_font.cpp
core/fpdfapi/font/cpdf_fontencoding.cpp
core/fpdfapi/font/cpdf_fontencoding.h
core/fpdfapi/font/cpdf_font.h
core/fpdfapi/font/cpdf_simplefont.cpp
core/fpdfapi/font/cpdf_simplefont.h
core/fpdfapi/font/cpdf_truetypefont.cpp
core/fpdfapi/font/cpdf_truetypefont.h
core/fpdfapi/font/cpdf_type1font.cpp
core/fpdfapi/font/cpdf_type1font.h
core/fpdfapi/font/cpdf_type3char.cpp
core/fpdfapi/font/cpdf_type3char.h
core/fpdfapi/font/cpdf_type3font.cpp
core/fpdfapi/font/cpdf_type3font.h
core/fpdfapi/font/font_int.h
core/fpdfapi/font/fpdf_font_cid.cpp
#core/fpdfapi/font/fpdf_font_cid_unittest.cpp
core/fpdfapi/font/fpdf_font.cpp
#core/fpdfapi/font/fpdf_font_unittest.cpp
core/fpdfapi/font/ttgsubtable.cpp
core/fpdfapi/font/ttgsubtable.h
core/fpdfapi/page/cpdf_allstates.cpp
core/fpdfapi/page/cpdf_allstates.h
core/fpdfapi/page/cpdf_clippath.cpp
core/fpdfapi/page/cpdf_clippath.h
core/fpdfapi/page/cpdf_color.cpp
core/fpdfapi/page/cpdf_color.h
core/fpdfapi/page/cpdf_colorspace.cpp
core/fpdfapi/page/cpdf_colorspace.h
core/fpdfapi/page/cpdf_colorstate.cpp
core/fpdfapi/page/cpdf_colorstate.h
core/fpdfapi/page/cpdf_contentmark.cpp
core/fpdfapi/page/cpdf_contentmark.h
core/fpdfapi/page/cpdf_contentmarkitem.cpp
core/fpdfapi/page/cpdf_contentmarkitem.h
core/fpdfapi/page/cpdf_contentparser.cpp
core/fpdfapi/page/cpdf_contentparser.h
core/fpdfapi/page/cpdf_countedobject.h
core/fpdfapi/page/cpdf_docpagedata.cpp
core/fpdfapi/page/cpdf_docpagedata.h
core/fpdfapi/page/cpdf_form.cpp
core/fpdfapi/page/cpdf_form.h
core/fpdfapi/page/cpdf_formobject.cpp
core/fpdfapi/page/cpdf_formobject.h
core/fpdfapi/page/cpdf_generalstate.cpp
core/fpdfapi/page/cpdf_generalstate.h
core/fpdfapi/page/cpdf_graphicstates.cpp
core/fpdfapi/page/cpdf_graphicstates.h
core/fpdfapi/page/cpdf_image.cpp
core/fpdfapi/page/cpdf_image.h
core/fpdfapi/page/cpdf_imageobject.cpp
core/fpdfapi/page/cpdf_imageobject.h
core/fpdfapi/page/cpdf_meshstream.cpp
core/fpdfapi/page/cpdf_meshstream.h
core/fpdfapi/page/cpdf_page.cpp
core/fpdfapi/page/cpdf_page.h
core/fpdfapi/page/cpdf_pagemodule.cpp
core/fpdfapi/page/cpdf_pagemodule.h
core/fpdfapi/page/cpdf_pageobject.cpp
core/fpdfapi/page/cpdf_pageobject.h
core/fpdfapi/page/cpdf_pageobjectholder.cpp
core/fpdfapi/page/cpdf_pageobjectholder.h
core/fpdfapi/page/cpdf_pageobjectlist.cpp
core/fpdfapi/page/cpdf_pageobjectlist.h
core/fpdfapi/page/cpdf_path.cpp
core/fpdfapi/page/cpdf_path.h
core/fpdfapi/page/cpdf_pathobject.cpp
core/fpdfapi/page/cpdf_pathobject.h
core/fpdfapi/page/cpdf_pattern.cpp
core/fpdfapi/page/cpdf_pattern.h
core/fpdfapi/page/cpdf_psengine.h
core/fpdfapi/page/cpdf_shadingobject.cpp
core/fpdfapi/page/cpdf_shadingobject.h
core/fpdfapi/page/cpdf_shadingpattern.cpp
core/fpdfapi/page/cpdf_shadingpattern.h
core/fpdfapi/page/cpdf_streamcontentparser.cpp
core/fpdfapi/page/cpdf_streamcontentparser.h
#core/fpdfapi/page/cpdf_streamcontentparser_unittest.cpp
core/fpdfapi/page/cpdf_streamparser.cpp
core/fpdfapi/page/cpdf_streamparser.h
#core/fpdfapi/page/cpdf_streamparser_unittest.cpp
core/fpdfapi/page/cpdf_textobject.cpp
core/fpdfapi/page/cpdf_textobject.h
core/fpdfapi/page/cpdf_textstate.cpp
core/fpdfapi/page/cpdf_textstate.h
core/fpdfapi/page/cpdf_tilingpattern.cpp
core/fpdfapi/page/cpdf_tilingpattern.h
core/fpdfapi/page/fpdf_page_colors.cpp
core/fpdfapi/page/fpdf_page_func.cpp
#core/fpdfapi/page/fpdf_page_func_embeddertest.cpp
core/fpdfapi/page/pageint.h
core/fpdfapi/parser/cfdf_document.cpp
core/fpdfapi/parser/cfdf_document.h
core/fpdfapi/parser/cpdf_array.cpp
core/fpdfapi/parser/cpdf_array.h
# core/fpdfapi/parser/cpdf_array_unittest.cpp
core/fpdfapi/parser/cpdf_boolean.cpp
core/fpdfapi/parser/cpdf_boolean.h
core/fpdfapi/parser/cpdf_crypto_handler.cpp
core/fpdfapi/parser/cpdf_crypto_handler.h
core/fpdfapi/parser/cpdf_data_avail.cpp
core/fpdfapi/parser/cpdf_data_avail.h
core/fpdfapi/parser/cpdf_dictionary.cpp
core/fpdfapi/parser/cpdf_dictionary.h
core/fpdfapi/parser/cpdf_document.cpp
core/fpdfapi/parser/cpdf_document.h
#core/fpdfapi/parser/cpdf_document_unittest.cpp
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
#core/fpdfapi/parser/cpdf_object_unittest.cpp
core/fpdfapi/parser/cpdf_parser.cpp
#core/fpdfapi/parser/cpdf_parser_embeddertest.cpp
core/fpdfapi/parser/cpdf_parser.h
#core/fpdfapi/parser/cpdf_parser_unittest.cpp
core/fpdfapi/parser/cpdf_reference.cpp
core/fpdfapi/parser/cpdf_reference.h
core/fpdfapi/parser/cpdf_security_handler.cpp
#core/fpdfapi/parser/cpdf_security_handler_embeddertest.cpp
core/fpdfapi/parser/cpdf_security_handler.h
core/fpdfapi/parser/cpdf_simple_parser.cpp
core/fpdfapi/parser/cpdf_simple_parser.h
#core/fpdfapi/parser/cpdf_simple_parser_unittest.cpp
core/fpdfapi/parser/cpdf_stream_acc.cpp
core/fpdfapi/parser/cpdf_stream_acc.h
core/fpdfapi/parser/cpdf_stream.cpp
core/fpdfapi/parser/cpdf_stream.h
core/fpdfapi/parser/cpdf_string.cpp
core/fpdfapi/parser/cpdf_string.h
core/fpdfapi/parser/cpdf_syntax_parser.cpp
core/fpdfapi/parser/cpdf_syntax_parser.h
#core/fpdfapi/parser/cpdf_syntax_parser_unittest.cpp
core/fpdfapi/parser/fpdf_parser_decode.cpp
#core/fpdfapi/parser/fpdf_parser_decode_embeddertest.cpp
core/fpdfapi/parser/fpdf_parser_decode.h
#core/fpdfapi/parser/fpdf_parser_decode_unittest.cpp
core/fpdfapi/parser/fpdf_parser_utility.cpp
core/fpdfapi/parser/fpdf_parser_utility.h
core/fpdfapi/render/cpdf_charposlist.cpp
core/fpdfapi/render/cpdf_charposlist.h
core/fpdfapi/render/cpdf_devicebuffer.cpp
core/fpdfapi/render/cpdf_devicebuffer.h
core/fpdfapi/render/cpdf_dibsource.cpp
core/fpdfapi/render/cpdf_dibsource.h
core/fpdfapi/render/cpdf_dibtransferfunc.cpp
core/fpdfapi/render/cpdf_dibtransferfunc.h
core/fpdfapi/render/cpdf_docrenderdata.cpp
core/fpdfapi/render/cpdf_docrenderdata.h
core/fpdfapi/render/cpdf_imagecacheentry.cpp
core/fpdfapi/render/cpdf_imagecacheentry.h
core/fpdfapi/render/cpdf_imageloader.cpp
core/fpdfapi/render/cpdf_imageloader.h
core/fpdfapi/render/cpdf_imagerenderer.cpp
core/fpdfapi/render/cpdf_imagerenderer.h
core/fpdfapi/render/cpdf_pagerendercache.cpp
core/fpdfapi/render/cpdf_pagerendercache.h
core/fpdfapi/render/cpdf_progressiverenderer.cpp
core/fpdfapi/render/cpdf_progressiverenderer.h
core/fpdfapi/render/cpdf_rendercontext.cpp
core/fpdfapi/render/cpdf_rendercontext.h
core/fpdfapi/render/cpdf_renderoptions.cpp
core/fpdfapi/render/cpdf_renderoptions.h
core/fpdfapi/render/cpdf_renderstatus.cpp
core/fpdfapi/render/cpdf_renderstatus.h
core/fpdfapi/render/cpdf_scaledrenderbuffer.cpp
core/fpdfapi/render/cpdf_scaledrenderbuffer.h
core/fpdfapi/render/cpdf_textrenderer.cpp
core/fpdfapi/render/cpdf_textrenderer.h
core/fpdfapi/render/cpdf_transferfunc.cpp
core/fpdfapi/render/cpdf_transferfunc.h
core/fpdfapi/render/cpdf_type3cache.cpp
core/fpdfapi/render/cpdf_type3cache.h
core/fpdfapi/render/cpdf_type3glyphs.cpp
core/fpdfapi/render/cpdf_type3glyphs.h
#core/fpdfapi/render/fpdf_render_loadimage_embeddertest.cpp
#core/fpdfapi/render/fpdf_render_pattern_embeddertest.cpp
)

######################## FPDFTEXT #############################################
set(FPDFTEXT_SOURCES
core/fpdftext/cpdf_linkextract.cpp
core/fpdftext/cpdf_linkextract.h
core/fpdftext/cpdf_textpage.cpp
core/fpdftext/cpdf_textpagefind.cpp
core/fpdftext/cpdf_textpagefind.h
core/fpdftext/cpdf_textpage.h
#core/fpdftext/fpdf_text_int_unittest.cpp
core/fpdftext/unicodenormalizationdata.cpp
core/fpdftext/unicodenormalizationdata.h
)

######################## FXCODEC #############################################
set(FXCODEC_SOURCES
core/fxcodec/fx_codec_def.h
core/fxcodec/fx_codec.h
core/fxcodec/JBig2_DocumentContext.h
core/fxcodec/codec/ccodec_basicmodule.h
# core/fxcodec/codec/ccodec_bmpmodule.cpp
# core/fxcodec/codec/ccodec_bmpmodule.h
core/fxcodec/codec/ccodec_faxmodule.h
core/fxcodec/codec/ccodec_flatemodule.h
#core/fxcodec/codec/ccodec_gifmodule.cpp
#core/fxcodec/codec/ccodec_gifmodule.h
core/fxcodec/codec/ccodec_iccmodule.h
core/fxcodec/codec/ccodec_jbig2module.h
core/fxcodec/codec/ccodec_jpegmodule.h
core/fxcodec/codec/ccodec_jpxmodule.h
#core/fxcodec/codec/ccodec_pngmodule.cpp
#core/fxcodec/codec/ccodec_pngmodule.h
#core/fxcodec/codec/ccodec_progressivedecoder.h
core/fxcodec/codec/ccodec_scanlinedecoder.h
#core/fxcodec/codec/ccodec_tiffmodule.cpp
#core/fxcodec/codec/ccodec_tiffmodule.h
core/fxcodec/codec/codec_int.h
#core/fxcodec/codec/fx_codec_a85_unittest.cpp
core/fxcodec/codec/fx_codec.cpp
#core/fxcodec/codec/fx_codec_embeddertest.cpp
core/fxcodec/codec/fx_codec_fax.cpp
core/fxcodec/codec/fx_codec_flate.cpp
core/fxcodec/codec/fx_codec_icc.cpp
core/fxcodec/codec/fx_codec_jbig.cpp
core/fxcodec/codec/fx_codec_jpeg.cpp
core/fxcodec/codec/fx_codec_jpx_opj.cpp
#core/fxcodec/codec/fx_codec_jpx_unittest.cpp
#core/fxcodec/codec/fx_codec_progress.cpp
#core/fxcodec/codec/fx_codec_rle_unittest.cpp
#core/fxcodec/codec/icodec_bmpmodule.h
#core/fxcodec/codec/icodec_gifmodule.h
#core/fxcodec/codec/icodec_pngmodule.h
#core/fxcodec/codec/icodec_tiffmodule.h
#core/fxcodec/lbmp/fx_bmp.cpp
#core/fxcodec/lbmp/fx_bmp.h
#core/fxcodec/lbmp/fx_bmp.cpp
#core/fxcodec/lbmp/fx_bmp.h
#core/fxcodec/lgif/fx_gif.cpp
#core/fxcodec/lgif/fx_gif.h
)

######################## FXCRT #############################################
set(FXCRT_SOURCES
core/fxcrt/cfx_maybe_owned.h
#core/fxcrt/cfx_maybe_owned_unittest.cpp
core/fxcrt/cfx_observable.h
#core/fxcrt/cfx_observable_unittest.cpp
core/fxcrt/cfx_retain_ptr.h
#core/fxcrt/cfx_retain_ptr_unittest.cpp
core/fxcrt/cfx_shared_copy_on_write.h
#core/fxcrt/cfx_shared_copy_on_write_unittest.cpp
core/fxcrt/cfx_string_c_template.h
core/fxcrt/cfx_string_data_template.h
core/fxcrt/cfx_string_pool_template.h
#core/fxcrt/cfx_string_pool_template_unittest.cpp
core/fxcrt/cfx_weak_ptr.h
#core/fxcrt/cfx_weak_ptr_unittest.cpp
core/fxcrt/extension.h
# core/fxcrt/fx_arabic.cpp
# core/fxcrt/fx_arabic.h
# core/fxcrt/fx_arb.h
core/fxcrt/fx_basic_array.cpp
core/fxcrt/fx_basic_bstring.cpp
#core/fxcrt/fx_basic_bstring_unittest.cpp
core/fxcrt/fx_basic_buffer.cpp
core/fxcrt/fx_basic_coords.cpp
core/fxcrt/fx_basic_gcc.cpp
#core/fxcrt/fx_basic_gcc_unittest.cpp
core/fxcrt/fx_basic.h
core/fxcrt/fx_basic_memmgr.cpp
#core/fxcrt/fx_basic_memmgr_unittest.cpp
core/fxcrt/fx_basic_utf.cpp
core/fxcrt/fx_basic_util.cpp
#core/fxcrt/fx_basic_util_unittest.cpp
core/fxcrt/fx_basic_wstring.cpp
#core/fxcrt/fx_basic_wstring_unittest.cpp
core/fxcrt/fx_bidi.cpp
core/fxcrt/fx_bidi.h
#core/fxcrt/fx_bidi_unittest.cpp
core/fxcrt/fx_coordinates.h
core/fxcrt/fxcrt_posix.cpp
core/fxcrt/fxcrt_posix.h
core/fxcrt/fxcrt_stream.cpp
core/fxcrt/fxcrt_windows.cpp
core/fxcrt/fxcrt_windows.h
core/fxcrt/fx_extension.cpp
#core/fxcrt/fx_extension_unittest.cpp
core/fxcrt/fx_ext.h
core/fxcrt/fx_memory.h
core/fxcrt/fx_safe_types.h
core/fxcrt/fx_stream.h
core/fxcrt/fx_string.h
core/fxcrt/fx_system.h
#core/fxcrt/fx_system_unittest.cpp
core/fxcrt/fx_ucddata.cpp
core/fxcrt/fx_ucd.h
core/fxcrt/fx_unicode.cpp
core/fxcrt/fx_xml_composer.cpp
core/fxcrt/fx_xml.h
core/fxcrt/fx_xml_parser.cpp
core/fxcrt/xml_int.h
)

######################## FXGE #############################################
set(FXGE_SOURCES
core/fxge/cfx_facecache.h
core/fxge/cfx_fontcache.h
core/fxge/cfx_fontmapper.h
core/fxge/cfx_fontmgr.h
core/fxge/cfx_fxgedevice.h
core/fxge/cfx_gemodule.h
core/fxge/cfx_graphstatedata.h
core/fxge/cfx_graphstate.h
core/fxge/cfx_pathdata.h
core/fxge/cfx_renderdevice.h
core/fxge/cfx_substfont.h
# core/fxge/cfx_unicodeencodingex.h
core/fxge/cfx_unicodeencoding.h
core/fxge/cfx_windowsdevice.h
core/fxge/fx_dib.h
core/fxge/fx_font.h
core/fxge/fx_freetype.h
core/fxge/ifx_renderdevicedriver.cpp
core/fxge/ifx_renderdevicedriver.h
core/fxge/ifx_systemfontinfo.h
core/fxge/agg/fx_agg_driver.cpp
core/fxge/agg/fx_agg_driver.h
core/fxge/dib/dib_int.h
core/fxge/dib/fx_dib_composite.cpp
core/fxge/dib/fx_dib_convert.cpp
core/fxge/dib/fx_dib_engine.cpp
# core/fxge/dib/fx_dib_engine_unittest.cpp
core/fxge/dib/fx_dib_main.cpp
core/fxge/dib/fx_dib_transform.cpp
core/fxge/fontdata/chromefontdata/chromefontdata.h
core/fxge/fontdata/chromefontdata/FoxitDingbats.cpp
core/fxge/fontdata/chromefontdata/FoxitFixedBold.cpp
core/fxge/fontdata/chromefontdata/FoxitFixedBoldItalic.cpp
core/fxge/fontdata/chromefontdata/FoxitFixed.cpp
core/fxge/fontdata/chromefontdata/FoxitFixedItalic.cpp
core/fxge/fontdata/chromefontdata/FoxitSansBold.cpp
core/fxge/fontdata/chromefontdata/FoxitSansBoldItalic.cpp
core/fxge/fontdata/chromefontdata/FoxitSans.cpp
core/fxge/fontdata/chromefontdata/FoxitSansItalic.cpp
core/fxge/fontdata/chromefontdata/FoxitSansMM.cpp
core/fxge/fontdata/chromefontdata/FoxitSerifBold.cpp
core/fxge/fontdata/chromefontdata/FoxitSerifBoldItalic.cpp
core/fxge/fontdata/chromefontdata/FoxitSerif.cpp
core/fxge/fontdata/chromefontdata/FoxitSerifItalic.cpp
core/fxge/fontdata/chromefontdata/FoxitSerifMM.cpp
core/fxge/fontdata/chromefontdata/FoxitSymbol.cpp
core/fxge/freetype/fx_freetype.cpp
core/fxge/ge/cfx_cliprgn.cpp
core/fxge/ge/cfx_cliprgn.h
core/fxge/ge/cfx_facecache.cpp
core/fxge/ge/cfx_folderfontinfo.cpp
core/fxge/ge/cfx_folderfontinfo.h
core/fxge/ge/cfx_fontcache.cpp
core/fxge/ge/cfx_font.cpp
core/fxge/ge/cfx_fontmapper.cpp
core/fxge/ge/cfx_fontmgr.cpp
core/fxge/ge/cfx_gemodule.cpp
core/fxge/ge/cfx_graphstate.cpp
core/fxge/ge/cfx_graphstatedata.cpp
core/fxge/ge/cfx_pathdata.cpp
core/fxge/ge/cfx_renderdevice.cpp
core/fxge/ge/cfx_substfont.cpp
core/fxge/ge/cfx_unicodeencoding.cpp
# core/fxge/ge/cfx_unicodeencodingex.cpp
core/fxge/ge/cttfontdesc.cpp
core/fxge/ge/cttfontdesc.h
core/fxge/ge/fx_ge_fontmap.cpp
core/fxge/ge/fx_ge_linux.cpp
core/fxge/ge/fx_ge_text.cpp
#core/fxge/ge/fx_ge_text_embeddertest.cpp
core/fxge/ge/fx_text_int.h
)

######################## FXEDIT #############################################
set(FXEDIT_SOURCES
fpdfsdk/fxedit/fx_edit.h
fpdfsdk/fxedit/fxet_ap.cpp
fpdfsdk/fxedit/fxet_edit.cpp
fpdfsdk/fxedit/fxet_edit.h
fpdfsdk/fxedit/fxet_list.cpp
fpdfsdk/fxedit/fxet_list.h
)

######################## PDFWINDOW #############################################
set(PDFWINDOW_SOURCES
fpdfsdk/pdfwindow/cpwl_color.cpp
fpdfsdk/pdfwindow/cpwl_color.h
fpdfsdk/pdfwindow/PWL_Button.cpp
fpdfsdk/pdfwindow/PWL_Button.h
fpdfsdk/pdfwindow/PWL_Caret.cpp
fpdfsdk/pdfwindow/PWL_Caret.h
fpdfsdk/pdfwindow/PWL_ComboBox.cpp
fpdfsdk/pdfwindow/PWL_ComboBox.h
fpdfsdk/pdfwindow/PWL_Edit.cpp
fpdfsdk/pdfwindow/PWL_EditCtrl.cpp
fpdfsdk/pdfwindow/PWL_EditCtrl.h
fpdfsdk/pdfwindow/PWL_Edit.h
fpdfsdk/pdfwindow/PWL_FontMap.cpp
fpdfsdk/pdfwindow/PWL_FontMap.h
fpdfsdk/pdfwindow/PWL_Icon.cpp
fpdfsdk/pdfwindow/PWL_Icon.h
fpdfsdk/pdfwindow/PWL_ListBox.cpp
fpdfsdk/pdfwindow/PWL_ListBox.h
fpdfsdk/pdfwindow/PWL_ScrollBar.cpp
fpdfsdk/pdfwindow/PWL_ScrollBar.h
fpdfsdk/pdfwindow/PWL_SpecialButton.cpp
fpdfsdk/pdfwindow/PWL_SpecialButton.h
fpdfsdk/pdfwindow/PWL_Utils.cpp
fpdfsdk/pdfwindow/PWL_Utils.h
fpdfsdk/pdfwindow/PWL_Wnd.cpp
fpdfsdk/pdfwindow/PWL_Wnd.h
)

######################## FORMFILLER #############################################
set(FORMFILLER_SOURCES
fpdfsdk/formfiller/cba_fontmap.cpp
fpdfsdk/formfiller/cba_fontmap.h
fpdfsdk/formfiller/cffl_checkbox.cpp
fpdfsdk/formfiller/cffl_checkbox.h
fpdfsdk/formfiller/cffl_combobox.cpp
fpdfsdk/formfiller/cffl_combobox.h
fpdfsdk/formfiller/cffl_formfiller.cpp
fpdfsdk/formfiller/cffl_formfiller.h
fpdfsdk/formfiller/cffl_interactiveformfiller.cpp
fpdfsdk/formfiller/cffl_interactiveformfiller.h
fpdfsdk/formfiller/cffl_listbox.cpp
fpdfsdk/formfiller/cffl_listbox.h
fpdfsdk/formfiller/cffl_pushbutton.cpp
fpdfsdk/formfiller/cffl_pushbutton.h
fpdfsdk/formfiller/cffl_radiobutton.cpp
fpdfsdk/formfiller/cffl_radiobutton.h
fpdfsdk/formfiller/cffl_textfield.cpp
fpdfsdk/formfiller/cffl_textfield.h
)

######################## JS #############################################
set(JS_STUB_SOURCES
fpdfsdk/javascript/ijs_event_context.h
fpdfsdk/javascript/ijs_runtime.h
fpdfsdk/javascript/JS_Runtime_Stub.cpp
)

######################## BIGINT #############################################
set(BIGINT_SOURCES
third_party/bigint/BigInteger.cc
third_party/bigint/BigInteger.hh
third_party/bigint/BigIntegerLibrary.hh
third_party/bigint/BigIntegerUtils.cc
third_party/bigint/BigIntegerUtils.hh
third_party/bigint/BigUnsigned.cc
third_party/bigint/BigUnsigned.hh
third_party/bigint/BigUnsignedInABase.cc
third_party/bigint/BigUnsignedInABase.hh
third_party/bigint/NumberlikeArray.hh
)

######################## AGG #############################################
set(AGG_SOURCES
third_party/agg23/agg_array.h
third_party/agg23/agg_basics.h
third_party/agg23/agg_clip_liang_barsky.h
third_party/agg23/agg_color_gray.h
third_party/agg23/agg_conv_adaptor_vcgen.h
third_party/agg23/agg_conv_dash.h
third_party/agg23/agg_conv_stroke.h
third_party/agg23/agg_curves.cpp
third_party/agg23/agg_curves.h
third_party/agg23/agg_math.h
third_party/agg23/agg_math_stroke.h
third_party/agg23/agg_path_storage.cpp
third_party/agg23/agg_path_storage.h
third_party/agg23/agg_pixfmt_gray.h
third_party/agg23/agg_rasterizer_scanline_aa.cpp
third_party/agg23/agg_rasterizer_scanline_aa.h
third_party/agg23/agg_renderer_base.h
third_party/agg23/agg_renderer_scanline.h
third_party/agg23/agg_rendering_buffer.h
third_party/agg23/agg_render_scanlines.h
third_party/agg23/agg_scanline_u.h
third_party/agg23/agg_shorten_path.h
third_party/agg23/agg_vcgen_dash.cpp
third_party/agg23/agg_vcgen_dash.h
third_party/agg23/agg_vcgen_stroke.cpp
third_party/agg23/agg_vcgen_stroke.h
third_party/agg23/agg_vertex_sequence.h
)

set(ALL_SOURCES
${FDRM_SOURCES}
${FPDFDOC_SOURCES}
${FPDFSDK_SOURCES}
${FPDFAPI_SOURCES} ${FPDFAPI_GB1_SOURCES} ${FPDFAPI_CNS1_SOURCES} ${FPDFAPI_JAPAN1_SOURCES} ${FPDFAPI_KOREA_SOURCES}
${FPDFTEXT_SOURCES}
${FXCODEC_SOURCES}
${FXCRT_SOURCES}
${FXGE_SOURCES}
${FXEDIT_SOURCES}
${PDFWINDOW_SOURCES}
${FORMFILLER_SOURCES}
 ${FPDFSDK_SOURCES}
 ${WINDOWS_SOURCES}
 ${JS_STUB_SOURCES}
 ${BIGINT_SOURCES}
${AGG_SOURCES}
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
