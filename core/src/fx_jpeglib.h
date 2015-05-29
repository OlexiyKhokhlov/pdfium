// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
 
// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

#ifndef CORE_SRC_FX_JPEGLIB_H_
#define CORE_SRC_FX_JPEGLIB_H_
#ifdef USE_SYSTEM_JPEG
    #include <jpeglib.h>
#else
    #include "./fxcodec/libjpeg/jpeglib.h"
#endif
#endif  // CORE_SRC_FX_JPEGLIB_H_
