CMAKE_MINIMUM_REQUIRED (VERSION 2.8.0)
enable_language(C)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")

set(libjpeg_HEADERS
  cderror.h
  cdjpeg.h
  jchuff.h
  jconfig.h
  jdct.h
  jdhuff.h
  jerror.h
  jinclude.h
  jmemsys.h
  jmorecfg.h
  jpegint.h
  jpeglib.h
  jversion.h
  makefile
  transupp.h
)

set(libjpeg_SOURCES
  fpdfapi_jcapimin.c
  fpdfapi_jcapistd.c
  fpdfapi_jccoefct.c
  fpdfapi_jccolor.c
  fpdfapi_jcdctmgr.c
  fpdfapi_jchuff.c
  fpdfapi_jcinit.c
  fpdfapi_jcmainct.c
  fpdfapi_jcmarker.c
  fpdfapi_jcmaster.c
  fpdfapi_jcomapi.c
  fpdfapi_jcparam.c
  fpdfapi_jcphuff.c
  fpdfapi_jcprepct.c
  fpdfapi_jcsample.c
  fpdfapi_jctrans.c
  fpdfapi_jdapimin.c
  fpdfapi_jdapistd.c
  fpdfapi_jdcoefct.c
  fpdfapi_jdcolor.c
  fpdfapi_jddctmgr.c
  fpdfapi_jdhuff.c
  fpdfapi_jdinput.c
  fpdfapi_jdmainct.c
  fpdfapi_jdmarker.c
  fpdfapi_jdmaster.c
  fpdfapi_jdmerge.c
  fpdfapi_jdphuff.c
  fpdfapi_jdpostct.c
  fpdfapi_jdsample.c
  fpdfapi_jdtrans.c
  fpdfapi_jerror.c
  fpdfapi_jfdctfst.c
  fpdfapi_jfdctint.c
  fpdfapi_jidctfst.c
  fpdfapi_jidctint.c
  fpdfapi_jidctred.c
  fpdfapi_jmemmgr.c
  fpdfapi_jmemnobs.c
  fpdfapi_jutils.c
)

add_library(jpeg OBJECT  ${libjpeg_SOURCES} )
