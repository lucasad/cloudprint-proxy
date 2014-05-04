project(cpproxy C)
cmake_minimum_required(VERSION 2.8)

list(APPEND CMAKE_MODULE_PATH 
    ${CMAKE_SOURCE_DIR}/cmake
)

find_package(Vala REQUIRED)
include(UseVala)

vala_precompile(VALA_C
    printer.vala
    printer_locator.vala
    privet.vala
    cpproxy.vala
PACKAGES
    avahi-gobject
    libsoup-2.4
    rest-0.7
OPTIONS
    --thread
)

find_package(PkgConfig)
pkg_check_modules(GLIB REQUIRED glib-2.0)
pkg_check_modules(AVAHI REQUIRED avahi-gobject)
pkg_check_modules(GTHREAD REQUIRED gthread-2.0)
pkg_check_modules(SOUP REQUIRED libsoup-2.4)
pkg_check_modules(REST REQUIRED rest-0.7)

add_definitions(${GLIB_CFLAGS} ${GLIB_CFLAGS_OTHER} ${AVAHI_CFLAGS} ${GTHREAD_CFLAGS} ${SOUP_CFLAGS} ${REST_CFLAGS})

link_libraries(${GLIB_LIBRARIES} ${AVAHI_LIBRARIES} ${GTHREAD_LIBRARIES} ${SOUP_LIBRARIES} ${REST_LIBRARIES})
link_directories(${GLIB_LIBRARY_DIRS} ${AVAHI_DIRS} ${GTHREAD_DIRS} ${SOUP_DIRS} ${REST_DIRS})

add_executable("cpproxy" ${VALA_C})
