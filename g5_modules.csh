#!/bin/csh
#
# It is a mimic of g5_module.bash
# from AI,  but now it is not needed
#
#=================================================================
set script_dir = `dirname $0`
set g5ModDir = `cd "$script_dir" && pwd`
set g5modules = "$g5ModDir/g5_modules"

if ( ! -e "$g5modules" ) then
   echo "Error. Cannot find $g5modules"
   exit 1
endif

# Basedir
setenv BASEDIR `csh $g5modules basedir`

# UDUNITS2_XML_PATH
set arch = `uname -s`
setenv UDUNITS2_XML_PATH "$BASEDIR/$arch/share/udunits/udunits2.xml"

# Modules
source $MODULESHOME/init/csh
module purge

# This is for non-standard module paths
foreach usemod ( `csh $g5modules usemodules` )
    module use -a $usemod
end

foreach mymod ( `csh $g5modules modules` )
    module load $mymod
end

ml

echo "g5modules = $g5modules"
echo "MODULESHOME = $MODULESHOME"
echo "BASEDIR= $BASEDIR"
