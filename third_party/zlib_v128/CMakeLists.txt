CMAKE_MINIMUM_REQUIRED (VERSION 3.2)

if(WIN32)
  add_definitions(-D_WIN32)
else(WIN32)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -Wno-shift-negative-value")
endif(WIN32)

set(zlib_HEADERS
 zlib.h
)

set(zlib_SOURCES
  adler32.c
  compress.c
  crc32.c
  deflate.c
  gzclose.c
  gzlib.c
  gzread.c
  gzwrite.c
  infback.c
  inffast.c
  inflate.c
  inftrees.c
  trees.c
  uncompr.c
  zutil.c
)

add_library(internal_zlib OBJECT ${zlib_HEADERS} ${zlib_SOURCES})
