# Warning! This is an automatically generated file!
#
cmake_minimum_required(VERSION 3.15 FATAL_ERROR)

project(roc_plus LANGUAGES C)

list(PREPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
find_package(SpicyPlugin REQUIRED)

# We'll let the SpicyPlugin package handle version requirements
# instead of using spicy_required_version

if(NOT CMAKE_BUILD_TYPE)
    # Default to the release build
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
endif(NOT CMAKE_BUILD_TYPE)

add_subdirectory(analyzer)