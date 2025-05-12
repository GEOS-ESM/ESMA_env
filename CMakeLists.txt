foreach (g5modulefile g5_modules g5_modules.sh)
   install (
      PROGRAMS ${g5modulefile}
      DESTINATION bin
      )
endforeach ()

find_package(EnvModules QUIET)
if (EnvModules_FOUND)
   env_module_list(ENVIRONMENT_MODULES)
else ()
   set (ENVIRONMENT_MODULES "No environment modules were found")
endif ()
set(ENVIRONMENT_MODULES "${ENVIRONMENT_MODULES}" CACHE INTERNAL "List of environment modules")

foreach (conf_file BASEDIR.rc SITE.rc CMAKE_VERSION.rc GIT_VERSION.rc BUILD_MODULES.rc)
   configure_file(${conf_file}.in ${conf_file} @ONLY)
   install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${conf_file} DESTINATION etc)
endforeach ()
