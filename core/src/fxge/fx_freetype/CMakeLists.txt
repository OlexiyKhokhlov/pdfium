CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")

set(freetype_HEADERS
  include/fxft_cffobjs.h
  include/fxft_cfftypes.h
  include/fxft_freetype.h
  include/fxft_ft2build.h
  include/fxft_ftmm.h
  include/fxft_ftobjs.h
  include/fxft_ftotval.h
  include/fxft_ftoutln.h
  include/fxft_ftstream.h
  include/fxft_tttables.h
  include/fxft_tttypes.h
)

set(freetype_SOURCES
  src/fxft_cff.c
  src/fxft_ftbase.c
  src/fxft_ftbitmap.c
  src/fxft_ftglyph.c
  src/fxft_ftinit.c
  src/fxft_ftlcdfil.c
  src/fxft_ftmm.c
  src/fxft_ftsystem.c
  src/fxft_psaux.c
  src/fxft_pshinter.c
  src/fxft_psmodule.c
  src/fxft_raster.c
  src/fxft_sfnt.c
  src/fxft_smooth.c
  src/fxft_truetype.c
  src/fxft_type1.c
  src/fxft_type1cid.c 
)

add_library(freetype STATIC ${freetype_HEADERS} ${freetype_SOURCES})
