
# Run as cmake -DPDFIUM_BUILD_DIR=`pwd` -P windows_deps.cmake

file(MAKE_DIRECTORY ${PDFIUM_BUILD_DIR}/deps)

message(STATUS "Downloading libjpeg-turbo-3.1.1-vc-x64.exe from https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.1/libjpeg-turbo-3.1.1-vc-x64.exe")
execute_process(
   COMMAND curl.exe --output ${PDFIUM_BUILD_DIR}/deps/libjpeg-turbo-3.1.1-vc-x64.exe  -vL https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.1/libjpeg-turbo-3.1.1-vc-x64.exe
   WORKING_DIRECTORY  "${PDFIUM_BUILD_DIR}/deps"
   RESULT_VARIABLE result
   OUTPUT_VARIABLE otput
   ERROR_VARIABLE error
   OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(STATUS "DOWNLOAD ${result} ${error}")

#message(STATUS "INSTALL CMD:  ${PDFIUM_BUILD_DIR}/deps/libjpeg-turbo-3.1.1-vc-x64.exe /S /D=${PDFIUM_BUILD_DIR}\\deps\\libjpeg-turbo")
message(STATUS "INSTALL CMD:  ${PDFIUM_BUILD_DIR}/deps/libjpeg-turbo-3.1.1-vc-x64.exe /S")
execute_process(
   COMMAND  ${PDFIUM_BUILD_DIR}/deps/libjpeg-turbo-3.1.1-vc-x64.exe /S
   RESULT_VARIABLE result
   OUTPUT_VARIABLE otput
   ERROR_VARIABLE error
   OUTPUT_STRIP_TRAILING_WHITESPACE
)

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
# Slightly reorganize freetype folder structure so cmake find_package can work with that
file(COPY "${PDFIUM_BUILD_DIR}/deps/freetype-windows-binaries-2.13.3/release static/vs2015-2022/win64/freetype.lib" DESTINATION "${PDFIUM_BUILD_DIR}/deps/freetype-windows-binaries-2.13.3/lib")

message(STATUS "Downloading  ZLib-1.3.1-Win-pc064.zip from https://media.githubusercontent.com/media/CristiFati/Prebuilt-Binaries/refs/heads/master/ZLib/v1/ZLib-1.3.1-Win-pc064.zip")
file(DOWNLOAD "https://media.githubusercontent.com/media/CristiFati/Prebuilt-Binaries/refs/heads/master/ZLib/v1/ZLib-1.3.1-Win-pc064.zip?download=true"
    "${PDFIUM_BUILD_DIR}/deps/ZLib-1.3.1-Win-pc064.zip"
    EXPECTED_HASH SHA256=080671339254a054c296cdbe1cb5df43e6f620c12a482458bec115079aeabe35
    STATUS download_status
    LOG download_log
    SHOW_PROGRESS
)
file(ARCHIVE_EXTRACT
    INPUT "${PDFIUM_BUILD_DIR}/deps/ZLib-1.3.1-Win-pc064.zip"
    DESTINATION "${PDFIUM_BUILD_DIR}/deps"
    VERBOSE
)

