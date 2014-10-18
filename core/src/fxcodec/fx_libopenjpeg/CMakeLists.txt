CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")

set(openjpeg_HEADERS
  include/fx_openjpeg.h
)

set(openjpeg_SOURCES
  src/fx_bio.c
  src/fx_cio.c
  src/fx_dwt.c
  src/fx_event.c
  src/fx_function_list.c
  src/fx_image.c
  src/fx_invert.c
  src/fx_j2k.c
  src/fx_j2k_lib.c
  src/fx_jpt.c
  src/fx_mct.c
  src/fx_mqc.c
  src/fx_openjpeg.c
  src/fx_openjpeg_jp2.c
  src/fx_opj_clock.c
  src/fx_pi.c
  src/fx_raw.c
  src/fx_t1.c
  src/fx_t1_generate_luts.c
  src/fx_t2.c
  src/fx_tcd.c
  src/fx_tgt.c
)

add_library(openjpeg STATIC ${openjpeg_HEADERS} ${openjpeg_SOURCES})
