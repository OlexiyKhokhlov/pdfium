CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)

if(WIN32)
  add_definitions(-D_WIN32)
else(WIN32)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
endif(WIN32)

set(zlib_HEADERS
 include/fx_zlib.h
)

set(zlib_SOURCES
  src/fx_zlib_adler32.c
  src/fx_zlib_compress.c
  src/fx_zlib_crc32.c
  src/fx_zlib_deflate.c
  src/fx_zlib_gzclose.c
  src/fx_zlib_gzlib.c
  src/fx_zlib_gzread.c
  src/fx_zlib_gzwrite.c
  src/fx_zlib_infback.c
  src/fx_zlib_inffast.c
  src/fx_zlib_inflate.c
  src/fx_zlib_inftrees.c
  src/fx_zlib_trees.c
  src/fx_zlib_uncompr.c
  src/fx_zlib_zutil.c
)

add_library(zlib OBJECT ${zlib_HEADERS} ${zlib_SOURCES})
