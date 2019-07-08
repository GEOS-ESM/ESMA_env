# Copy modules.NCCS to install/bin but needs special treatment as a 
# symlink
if (${GEOS_SITE} MATCHES NCCS)
   get_filename_component(NCCS_MODULEFILE modules.NCCS REALPATH)
   install(
      FILES ${NCCS_MODULEFILE}
      DESTINATION bin
      RENAME modules.NCCS
      )
endif ()

foreach (g5modulefile g5_modules g5_modules.sh)
   install (
      PROGRAMS ${g5modulefile}
      DESTINATION bin
      )
endforeach ()

