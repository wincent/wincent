cmake_minimum_required(VERSION 3.0)

project(mac2linux)

add_executable(mac2linux mac2linux.c)

target_compile_options(mac2linux PRIVATE -Wall -Wextra)

install(TARGETS mac2linux RUNTIME DESTINATION bin)
