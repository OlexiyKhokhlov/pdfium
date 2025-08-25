
# Run as cmake -DPDFIUM_BUILD_DIR=`pwd` -P windows_deps.cmake

message(STATUS "Downloading v2.13.3.zip from https://github.com/ubawurinna/freetype-windows-binaries/archive/refs/tags/v2.13.3.zip")
file(DOWNLOAD "https://github.com/ubawurinna/freetype-windows-binaries/archive/refs/tags/v2.13.3.zip"
    "${PDFIUM_BUILD_DIR}/deps/freetype-v2.13.3.zip"
    EXPECTED_HASH SHA256=02048c9863fec1e28528c214a4953b729a144a3a6a05b95663b74b9be1d26de5
    STATUS download_status
    LOG download_log
    SHOW_PROGRESS
)
file(ARCHIVE_EXTRACT
    INPUT "${PDFIUM_BUILD_DIR}/deps/freetype-v2.13.3.zip"
    DESTINATION "${PDFIUM_BUILD_DIR}/deps"
    VERBOSE
)

message(STATUS "Downloading libjpeg-turbo-3.1.1-vc-x64.exe from https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.1/libjpeg-turbo-3.1.1-vc-x64.exe")
file(DOWNLOAD "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.1/libjpeg-turbo-3.1.1-vc-x64.exe"
    "${PDFIUM_BUILD_DIR}/deps/libjpeg-turbo-3.1.1-vc-x64.exe"
    EXPECTED_HASH SHA256=9cfb73cd587ba721f0b22113079b79cfe0a7cc13768375476a7d45b2f317e81a
)

execute_process(
  COMMAND  "${PDFIUM_BUILD_DIR}/deps/libjpeg-turbo-3.1.1-vc-x64.exe"
  WORKING_DIRECTORY  "${PDFIUM_BUILD_DIR}/deps"
  RESULT_VARIABLE result
  OUTPUT_VARIABLE output
  ERROR_VARIABLE output
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
