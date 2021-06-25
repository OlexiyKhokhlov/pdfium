CMAKE_MINIMUM_REQUIRED (VERSION 3.2)

if(WIN32)
  add_definitions(-D_WIN32)
else(WIN32)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
endif(WIN32)

set(jbig2_SOURCES
JBig2_ArithDecoder.cpp
JBig2_ArithDecoder.h
JBig2_ArithIntDecoder.cpp
JBig2_ArithIntDecoder.h
JBig2_BitStream.cpp
JBig2_BitStream.h
JBig2_Context.cpp
JBig2_Context.h
JBig2_Define.h
JBig2_GrdProc.cpp
JBig2_GrdProc.h
JBig2_GrrdProc.cpp
JBig2_GrrdProc.h
JBig2_GsidProc.cpp
JBig2_GsidProc.h
JBig2_HtrdProc.cpp
JBig2_HtrdProc.h
JBig2_HuffmanDecoder.cpp
JBig2_HuffmanDecoder.h
JBig2_HuffmanTable.cpp
JBig2_HuffmanTable.h
JBig2_HuffmanTable_Standard.cpp
JBig2_HuffmanTable_Standard.h
JBig2_Image.cpp
JBig2_Image.h
#JBig2_Image_unittest.cpp
JBig2_Page.h
JBig2_PatternDict.cpp
JBig2_PatternDict.h
JBig2_PddProc.cpp
JBig2_PddProc.h
JBig2_SddProc.cpp
JBig2_SddProc.h
JBig2_Segment.cpp
JBig2_Segment.h
JBig2_SymbolDict.cpp
JBig2_SymbolDict.h
JBig2_TrdProc.cpp
JBig2_TrdProc.h
)

add_library(internal_jbig2 OBJECT ${jbig2_SOURCES})
