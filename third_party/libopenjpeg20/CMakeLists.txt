CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)

if(WIN32)
  add_definitions(-D_WIN32 -DWIN32_LEAN_AND_MEAN)
else(WIN32)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -pthread")
endif(WIN32)

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
  jp2.c
)

add_library(internal_openjpeg OBJECT ${openjpeg_HEADERS} ${openjpeg_SOURCES})
