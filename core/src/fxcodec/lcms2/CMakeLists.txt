CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")

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
  src/fx_cmsmd5.c
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
)

add_library(lcms2 STATIC ${lcms2_HEADERS} ${lcms2_SOURCES})
