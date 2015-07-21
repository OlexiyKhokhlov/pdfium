CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)

if(WIN32)
  add_definitions(-D_WIN32 -DWIN32_LEAN_AND_MEAN)
else(WIN32)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -pthread")
endif(WIN32)

set(lcms2_HEADERS
)

set(lcms2_SOURCES
  src/fx_cmscam02.c
  src/fx_cmscgats.c
  src/fx_cmscnvrt.c
  src/fx_cmserr.c
  src/fx_cmsgamma.c
  src/fx_cmsgmt.c
  src/fx_cmshalf.c
  src/fx_cmsintrp.c
  src/fx_cmsio0.c
  src/fx_cmsio1.c
  src/fx_cmslut.c
  src/fx_cmsmtrx.c
  src/fx_cmsnamed.c
  src/fx_cmsopt.c
  src/fx_cmspack.c
  src/fx_cmspcs.c
  src/fx_cmsplugin.c
  src/fx_cmsps2.c
  src/fx_cmssamp.c
  src/fx_cmssm.c
  src/fx_cmstypes.c
  src/fx_cmsvirt.c
  src/fx_cmswtpnt.c
  src/fx_cmsxform.c
#  src/fx_cmsmd5.c
)

add_library(lcms2 OBJECT ${lcms2_HEADERS} ${lcms2_SOURCES})
