CMAKE_MINIMUM_REQUIRED (VERSION 3.2)

if(WIN32)
  add_definitions(-D_WIN32 -DWIN32_LEAN_AND_MEAN)
else(WIN32)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -pthread -Wno-main -Wno-missing-braces -Wno-unused")
endif(WIN32)

set(lcms2_HEADERS
    include/lcms2.h
    include/lcms2_plugin.h
)

set(lcms2_SOURCES
  src/cmscam02.c
  src/cmscgats.c
  src/cmscnvrt.c
  src/cmserr.c
  src/cmsgamma.c
  src/cmsgmt.c
  src/cmshalf.c
  src/cmsintrp.c
  src/cmsio0.c
  src/cmsio1.c
  src/cmslut.c
  src/cmsmtrx.c
  src/cmsnamed.c
  src/cmsopt.c
  src/cmspack.c
  src/cmspcs.c
  src/cmsplugin.c
  src/cmsps2.c
  src/cmssamp.c
  src/cmssm.c
  src/cmstypes.c
  src/cmsvirt.c
  src/cmswtpnt.c
  src/cmsxform.c
  src/cmsmd5.c
)

add_library(internal_lcms2 OBJECT ${lcms2_HEADERS} ${lcms2_SOURCES})
