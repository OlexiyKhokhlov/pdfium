CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")

set(jbig2_HEADERS
  JBig2_ArithDecoder.h
  JBig2_ArithIntDecoder.h
  JBig2_ArithQe.h
  JBig2_BitStream.h
  JBig2_Context.h
  JBig2_Define.h
  JBig2_GeneralDecoder.h
  JBig2_HuffmanDecoder.h
  JBig2_HuffmanTable.h
  JBig2_HuffmanTable_Standard.h
  JBig2_Image.h
  JBig2_List.h
  JBig2_Module.h
  JBig2_Object.h
  JBig2_Page.h
  JBig2_PatternDict.h
  JBig2_Segment.h
  JBig2_SymbolDict.h
)

set(jbig2_SOURCES
  JBig2_ArithIntDecoder.cpp
  JBig2_Context.cpp
  JBig2_GeneralDecoder.cpp
  JBig2_HuffmanDecoder.cpp
  JBig2_HuffmanTable.cpp
  JBig2_Image.cpp
  JBig2_Object.cpp
  JBig2_PatternDict.cpp
  JBig2_Segment.cpp
  JBig2_SymbolDict.cpp
)

add_library(jbig2 OBJECT ${jbig2_HEADERS} ${jbig2_SOURCES})
