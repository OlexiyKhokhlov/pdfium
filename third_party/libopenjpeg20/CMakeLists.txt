CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")

set(openjpeg_HEADERS
  openjpeg.h
)

set(openjpeg_SOURCES
  bio.c
  cio.c
  dwt.c
  event.c
  function_list.c
  image.c
  invert.c
  j2k.c
  mct.c
  mqc.c
  openjpeg.c
  opj_clock.c
  pi.c
  raw.c
  t1.c
  t1_generate_luts.c
  t2.c
  tcd.c
  tgt.c
)

add_library(openjpeg OBJECT ${openjpeg_HEADERS} ${openjpeg_SOURCES})
