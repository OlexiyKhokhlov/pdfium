CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")

add_definitions(-DFT2_BUILD_LIBRARY)
include_directories(include)

set(freetype_HEADERS
  include/freetype.h  
  include/ft2build.h  
  include/ftmm.h  
  include/ftotval.h  
  include/ftoutln.h  
  include/tttables.h  
  include/internal/ftobjs.h  
  include/internal/ftstream.h  
  include/internal/tttypes.h  
  src/cff/cffobjs.h  
  src/cff/cfftypes.h  
)

set(freetype_SOURCES
  src/cff/cff.c  
  src/base/ftbase.c  
  src/base/ftbitmap.c  
  src/base/ftglyph.c  
  src/base/ftinit.c  
  src/base/ftlcdfil.c  
  src/base/ftmm.c  
  src/base/ftsystem.c  
  src/psaux/psaux.c  
  src/pshinter/pshinter.c  
  src/psnames/psmodule.c  
  src/raster/raster.c  
  src/sfnt/sfnt.c  
  src/smooth/smooth.c  
  src/truetype/truetype.c  
  src/type1/type1.c  
  src/cid/type1cid.c  
)

add_library(freetype OBJECT ${freetype_HEADERS} ${freetype_SOURCES})
