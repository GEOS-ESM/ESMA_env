foreach (g5modulefile g5_modules g5_modules.sh)
   install (
      PROGRAMS ${g5modulefile}
      DESTINATION bin
      )
endforeach ()

foreach (conf_file BASEDIR.rc SITE.rc)
   configure_file(${conf_file}.in ${conf_file} @ONLY)
   install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${conf_file} DESTINATION etc)
endforeach ()
