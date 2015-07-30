CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")

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

add_library(zlib OBJECT ${zlib_HEADERS} ${zlib_SOURCES})
