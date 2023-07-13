#!/bin/tcsh -f
#------------------------------------------------------------------------
# name: parallel_build.csh
# purpose: This subroutine builds using install
#          for compilation parallelization.
#
#
# !REVISION HISTORY
# 15Mar2007  Stassi  Modified version of g5das_parallel_build.csh
# 22Mar2007  Kokron  Add support for discover
# 28Mar2007  Stassi  Attempt to find default group for job submittal
# 13Apr2007  Stassi  Change order in which LOG/info names get iterated
# 04May2007  Stassi  Hard-code NCPUS=4 for discover
# 10Aug2007  TO/JS   Added distclean option; reordered script
# 15Apr2008  Stassi  Added code to cd to src directory, if not already
#                    there. Rename ESMASRC variable to ESMADIR
# 16Apr2008  Stassi  Use only half of CPUs on palm; mpi needs more memory
# 30Mar2008  Stassi  Add runtime options: -h, -hdf, -q queue
# 13Apr2009  Stassi  Updated for pleiades
# 05Aug2009  Stassi  Added -debug and -tmpdir flags
# 19Aug2010  Stassi  Added -walltime flag
# 01Apr2011  Stassi  Added clean and realclean options
# 04Nov2014  MAT     Moved to sbatch on discover, added Haswell
#                    as an option, removed some older batch systems
# 07Jul2016  MAT     Added Broadwell at NAS. Removed Westmere. Made
#                    Broadwell default at NAS.
# 10Oct2017  MAT     Added Skylake at NAS. Added option to pass in
#                    account
# 08Jul2019  MAT     Changes for git-based GEOSadas
#------------------------------------------------------------------------

# NOTE: This is now called by a stub routine. For sanity's
#       sake, we fake its original name here so that the stub
#       will print the right name in usage output
set name = 'parallel_build.csh'
set scriptname = $name
set BUILD_LOG_DIR = BUILD_LOG_DIR

setenv ARCH `uname -s`
#--set time = (1000 "%Uu %Ss %E  %X+%Dk %Mk %I+%Oio %Fpf+%Ww")
set time = ( 1000 "%Uu %Ss %E" )
set NCPUs_min = 6

#=====================
# determine the site
#=====================
set node = `uname -n`
if ( ($node == dirac)   \
  || ($node =~ borg*)   \
  || ($node =~ warp*)   \
  || ($node =~ discover*)) then
   setenv SITE NCCS

else if (($node =~ pfe*)   \
      || ($node =~ tfe*)   \
      || ($node =~ r[0-9]*i[0-9]*n[0-9]*) \
      || ($node =~ r[0-9]*c[0-9]*t[0-9]*n[0-9]*)) then
   setenv SITE NAS

else
   setenv SITE UNKNOWN
   set NCPUs_min = 1
endif

# if batch, then skip over job submission
#----------------------------------------
if ($?Parallel_build_bypass_flag) then
   goto build
endif

# set defaults
#-------------
setenv esmadir     ""
setenv docmake     1
setenv usegnu      0
setenv notar       0
setenv ddb         0
setenv debug       0
setenv aggressive  0
setenv verbose     ""
setenv interactive 0
setenv do_wait     0
setenv proc        ""
setenv prompt      1
setenv queue       ""
setenv partition   ""
setenv account     ""
setenv tmpdir      ""
setenv walltime    ""
setenv cmake_build_type "Release"
setenv EXTRA_CMAKE_FLAGS ""

# Detect if on compute node already
# ---------------------------------
setenv oncompnode  0
if ($?PBS_JOBID || $?SLURM_JOBID) then
   set oncompnode = 1
endif

# check for runtime parameters
#-----------------------------
@ n = 0
while ($#argv)

   # usage information
   #------------------
   if ("$1" == "-help") goto usage
   if ("$1" == "-h"   ) goto usage

   # developer's debug
   #------------------
   if ("$1" == "-ddb") set ddb = 1

   # compile with debug
   #-------------------
   if (("$1" == "-debug") || ("$1" == "-db")) then
      setenv cmake_build_type "Debug"
      set debug = 1
   endif

   # compile with aggressive
   #------------------------
   if ("$1" == "-aggressive") then
      setenv cmake_build_type "Aggressive"
      set aggressive = 1
   endif

   # specify node type
   #------------------
   if ("$1" == "-rom")  set nodeTYPE = "Rome"
   if ("$1" == "-cas")  set nodeTYPE = "CascadeLake"
   if ("$1" == "-sky")  set nodeTYPE = "Skylake"
   if ("$1" == "-bro")  set nodeTYPE = "Broadwell"
   if ("$1" == "-has")  set nodeTYPE = "Haswell"
   if ("$1" == "-any")  set nodeTYPE = "Any node"

   # reset Fortran TMPDIR
   #---------------------
   if ("$1" == "-tmpdir") then
      shift; if (! $#argv) goto usage
      setenv tmpdir $1
   endif

   # set ESMADIR
   #------------
   if ("$1" == "-esmadir") then
      shift; if (! $#argv) goto usage
      setenv ESMADIR $1
   endif

   # set BUILDDIR
   #-------------
   if ("$1" == "-builddir") then
      shift; if (! $#argv) goto usage
      setenv BUILDDIR $1
   endif

   # set INSTALLDIR
   #---------------
   if ("$1" == "-installdir") then
      shift; if (! $#argv) goto usage
      setenv INSTALLDIR $1
   endif

   # set GMI_MECHANISM
   #------------------
   if ("$1" == "-gmi_mechanism") then
      shift; if (! $#argv) goto usage
      setenv GMI_MECHANISM $1
   endif

   # run job interactively
   #----------------------
   if ("$1" == "-i") set interactive = 1

   # set verbose flag
   #-----------------
   if ("$1" == "-verbose") set verbose = "VERBOSE=1"
   if ("$1" == "-v") set verbose = "VERBOSE=1"

   # run job interactively
   #----------------------
   if ("$1" == "-wait") set do_wait = 1

   # submit batch job to alternative queue/qos
   #------------------------------------------
   if ("$1" == "-q") then
      shift; if (! $#argv) goto usage
      if ($SITE == NCCS) then
         setenv queue "--qos=$1"
      else
         setenv queue "-q $1"
      endif
   endif

   # submit batch job to specified partition
   #----------------------------------------
   if ("$1" == "-partition") then
      shift; if (! $#argv) goto usage
      setenv partition "--partition=$1"
   endif

   # submit batch job to specified account
   #--------------------------------------
   if ("$1" == "-account") then
      shift; if (! $#argv) goto usage
      setenv account "$1"
   endif

   # set batch walltime
   #-------------------
   if ("$1" == "-walltime") then
      shift; if (! $#argv) goto usage
      setenv walltime $1

      set hr = `echo $walltime | cut -d: -f1`
      set ss = `echo $walltime | cut -d: -f3`
      if (("$hr" == "$walltime") || ("$ss" == "")) then
         echo ""
         echo walltime must be in hr:mm:ss format
         goto usage
      endif
   endif

   # set noprompt option
   #--------------------
   if (("$1" == "-np") || ("$1" == "-noprompt")) then
      setenv prompt 0
   endif

   # set nocmake option
   #--------------------
   if ("$1" == "-nocmake") then
      setenv docmake 0
   endif

   # set gnu option
   #---------------
   if ("$1" == "-gnu") then
      setenv usegnu 1
   endif

   # set no tar option
   #------------------
   if ("$1" == "-no-tar") then
      setenv notar 1
   endif

   # If a user passes in '-- ' then everything after that is passed
   # into EXTRA_CMAKE_FLAGS and we are done parsing arguments
   #--------------------------------------------------------------
   if ("$1" == "--") then
      shift
      setenv EXTRA_CMAKE_FLAGS "$*"
      set argv = ()
      break
   endif

   shift
end

# Only allow one of debug and aggressive
# --------------------------------------
if ( ($aggressive) && ($debug) ) then
   echo "ERROR. Only one of -debug and -aggressive is allowed"
   exit 1
endif

# default nodeTYPE
#-----------------
if (! $?nodeTYPE) then
   if ($SITE == NCCS) set nodeTYPE = "Any"
   if ($SITE == NAS)  set nodeTYPE = "Skylake"
endif

# at NCCS
#--------
if ($SITE == NCCS) then

   set nT = `echo $nodeTYPE| tr "[A-Z]" "[a-z]" | cut -c1-3 `
   if (($nT != sky) && ($nT != cas) && ($nT != any)) then
      echo "ERROR. Unknown node type at NCCS: $nodeTYPE"
      exit 1
   endif

   # For the any node, set the default to 40 cores as
   # this is the least number of cores you will get
   if ($nT == any) @ NCPUS_DFLT = 40
   if ($nT == sky) @ NCPUS_DFLT = 40
   if ($nT == cas) @ NCPUS_DFLT = 48

   if ($nT == sky) set proc = 'sky'
   if ($nT == cas) set proc = 'cas'
   if ($nT == cas) set proc = 'any'

   # If we are using GNU at NCCS, we can*only* use the cas queue
   # as OpenMPI is only built for Infiniband
   if ($usegnu) then
      echo "Using GNU at NCCS, setting queue to cas"
      set proc = 'cas'
      set slurm_constraint = "--constraint=$proc"
   else if ($nT == any) then
      set slurm_constraint = "--constraint=[sky|cas]"
   else
      set slurm_constraint = "--constraint=$proc"
   endif

   if ("$queue" == "") then
      set queue = '--qos=debug'
   endif

   if ("$partition" == "") then
      set partition = '--partition=compute'
   endif

endif

# at NAS
#-------
if ( $SITE == NAS ) then

   set nT = `echo $nodeTYPE | cut -c1-3 | tr "[A-Z]" "[a-z]"`
   if (($nT != has) && ($nT != bro) && ($nT != sky) && ($nT != cas) && ($nT != rom)) then
      echo "ERROR. Unknown node type at NAS: $nodeTYPE"
      exit 2
   endif

   if ($nT == rom) set nT = 'rom_ait'
   if ($nT == sky) set nT = 'sky_ele'
   if ($nT == cas) set nT = 'cas_ait'
   set proc = ":model=$nT"

   if ($nT == has)     @ NCPUS_DFLT = 24
   if ($nT == bro)     @ NCPUS_DFLT = 28
   if ($nT == sky_ele) @ NCPUS_DFLT = 40
   if ($nT == cas_ait) @ NCPUS_DFLT = 40
   if ($nT == rom_ait) @ NCPUS_DFLT = 128

   # TMPDIR needs to be reset
   #-------------------------
   if ($tmpdir == '') then
      set tmpdirDFLT = "/nobackup/$USER/scratch/"
      if ($prompt) then
         echo ""
         echo -n "Define TMPDIR location "
         echo    "where scratch files can be written during build."
         echo -n "TMPDIR [$tmpdirDFLT] "
         setenv tmpdir $<
         if ("$tmpdir" == "") setenv tmpdir $tmpdirDFLT
      else
         setenv tmpdir $tmpdirDFLT
      endif
   endif
   echo "TMPDIR: $tmpdir"

endif

if ($SITE == UNKNOWN) then
   echo ""
   if ($ARCH == Darwin) then
      @ NCPUS_DFLT = `sysctl -a | grep machdep.cpu.core_count | awk '{print $2}'`
   else
      @ NCPUS_DFLT = `cat /proc/cpuinfo  | grep processor | wc -l`
   endif
   echo "Unknown site. Detected $NCPUS_DFLT cores and setting interactive build"
   set interactive = 1
endif

# set Pbuild_build_directory
# --------------------------
if ($?BUILDDIR) then
   setenv Pbuild_build_directory   $ESMADIR/$BUILDDIR
else if ($debug) then
   setenv Pbuild_build_directory   $ESMADIR/build-Debug
else if ($aggressive) then
   setenv Pbuild_build_directory   $ESMADIR/build-Aggressive
else
   setenv Pbuild_build_directory   $ESMADIR/build
endif

# set Pbuild_install_directory
# ----------------------------
if ($?INSTALLDIR) then
   setenv Pbuild_install_directory $ESMADIR/$INSTALLDIR
else if ($debug) then
   setenv Pbuild_install_directory $ESMADIR/install-Debug
else if ($aggressive) then
   setenv Pbuild_install_directory $ESMADIR/install-Aggressive
else
   setenv Pbuild_install_directory $ESMADIR/install
endif

# developer's debug
#------------------
if ($ddb) then
   echo "ESMADIR = $ESMADIR"
   echo "debug = $debug"
   echo "aggressive = $aggressive"
   echo "verbose = $verbose"
   if ($?nodeTYPE) then
      echo "nodeTYPE = $nodeTYPE"
   endif
   if ($?GMI_MECHANISM) then
      echo "GMI_MECHANISM = $GMI_MECHANISM"
   endif
   echo "tmpdir = $tmpdir"
   echo "proc = $proc"
   echo "interactive = $interactive"
   echo "do_wait = $do_wait"
   echo "queue = $queue"
   if ($SITE == NCCS) then
      echo "partition = $partition"
   endif
   echo "account = $account"
   echo "walltime = $walltime"
   echo "prompt = $prompt"
   echo "nocmake = $docmake"
   echo "notar = $notar"
   echo "NCPUS_DFLT = $NCPUS_DFLT"
   echo "CMAKE_BUILD_TYPE = $cmake_build_type"
   echo "EXTRA_CMAKE_FLAGS = $EXTRA_CMAKE_FLAGS"
   echo "Build directory = $Pbuild_build_directory"
   echo "Install directory = $Pbuild_install_directory"
   exit
endif

# if user defines TMPDIR ...
#---------------------------
if ("$tmpdir" != "") then

   # ... mkdir if it does not exist
   #-------------------------------
   if (! -d $tmpdir) then
      echo "Making TMPDIR directory: $tmpdir"
      mkdir -p $tmpdir
      if ($status) then
         echo ">> Error << mkdir $tmpdir "
         exit 3
      endif
   endif

   # ... check that it is writeable
   #-------------------------------
   if (! -w $tmpdir) then
      echo ">> Error << TMPDIR is not writeable: $tmpdir"
      exit 4
   endif
   echo ""

endif

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                            JOB SUBMISSION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#========
# intro
#========
echo ""
echo "   ================"
echo "    PARALLEL BUILD "
echo "   ================"
echo ""

# set environment variables
#--------------------------
if ( -d ${ESMADIR}/@env ) then
   source $ESMADIR/@env/g5_modules
else if ( -d ${ESMADIR}/env@ ) then
   source $ESMADIR/env@/g5_modules
else if ( -d ${ESMADIR}/env ) then
   source $ESMADIR/env/g5_modules
endif
setenv Pbuild_source_directory  $ESMADIR

# Make the BUILD directory
# ------------------------
if (! -d $Pbuild_build_directory) then
   echo "Making build directory: $Pbuild_build_directory"
   mkdir -p $Pbuild_build_directory
   if ($status) then
      echo ">> Error << mkdir $Pbuild_build_directory "
      exit 5
   endif
endif

setenv Parallel_build_bypass_flag
set jobname = "parallel_build"

#===========================
# query for number of CPUs
#===========================
if ( ($SITE == NCCS) || ($SITE == NAS) ) then

   # use set number of CPUs on NCCS or NAS
   #--------------------------------------
   @ ncpus_val  = $NCPUS_DFLT
   @ numjobs_val  = $ncpus_val / 3  # save some CPUs for memory

   # use only even number of CPUs
   #-----------------------------
   @ check = ( $numjobs_val % 2 )
   if ($check == 1) then
      @ numjobs_val --
      echo "Rounding down to an even $numjobs_val CPUs."
   endif

   # Are we on a compute node?
   # -------------------------
   if ( (! $oncompnode) && $interactive) then
      # If we aren't don't use all the cores
      if ($numjobs_val > 6) @ numjobs_val = 6
   else
      # Just use 10 CPUs at most. GEOS doesn't support more
      # parallelism in the build
      if ($numjobs_val > 10) @ numjobs_val = 10
   endif
   echo ""
   echo -n "The build will proceed with $numjobs_val parallel processes on $ncpus_val CPUs"
   if ( (! $oncompnode) && $interactive) then
      echo " to not monopolize head node."
   else
      echo "."
   endif

else

   # how many?
   #----------
   echo ""
   echo -n "Parallel build using how many CPUs ($NCPUs_min minimum)? "
   echo -n "[$NCPUS_DFLT] "
   set ncpus_val = $<
   if ("$ncpus_val" == "") set ncpus_val = $NCPUS_DFLT
   echo ""

   # check for minimum number of CPUs
   #---------------------------------
   if ($ncpus_val < $NCPUs_min) then
      @ ncpus_val = $NCPUs_min
      echo "Defaulting to minimum $ncpus_val CPUs."
   endif

   # use only even number of CPUs
   #-----------------------------
   @ check = ( $ncpus_val / 2 ) * 2
   if ($check != $ncpus_val) then
      @ ncpus_val ++
      echo "Rounding up to an even $ncpus_val CPUs."
   endif

   # save some CPUs for memory
   #--------------------------
   @ numjobs_val = $ncpus_val - 2
   echo -n "The build will proceed with $numjobs_val parallel processes"
   echo    " on $ncpus_val CPUs."

endif

setenv ncpus   $ncpus_val
setenv numjobs $numjobs_val

#=================================================
# check for LOG and info files from previous build
#=================================================
setenv bldlogdir $Pbuild_build_directory/$BUILD_LOG_DIR
setenv cmakelog  $bldlogdir/CLOG
setenv buildlog  $bldlogdir/LOG
setenv buildinfo $bldlogdir/info
setenv cleanFLAG ""

ls $cmakelog $buildlog $buildinfo >& /dev/null
if ($status == 0) then
   if ($prompt) then
      echo ''
      echo 'Previous build detected - Do you want to clean?'
      echo '(c)     clean: Removes build and install directories, and rebuilds'
      echo '(n)  no clean'
      echo ''
      echo "  Note: if you have changed MAPL, we recommend doing a clean for safety's sake"
      echo ''
      echo -n 'Select (c,n) <<c>> '

      set do_clean = $<
      if ("$do_clean" != "n") then
         set do_clean = "c"
      endif
   else
      set do_clean = "c"
   endif

   if ("$do_clean" == "c") then
      setenv cleanFLAG clean
      echo  "Removing build and install directories and re-running CMake before rebuild"
   else
      echo "No clean before rebuild"
   endif
endif

#==============
# info for user
#==============
echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "LOG and info will be written to the $bldlogdir directory."
echo "Do the following to check the status/success of the build:"
echo ""
echo "  cd $bldlogdir"
echo ""
echo "Note: Check the latest version of LOG for the most recent build info."
echo ""
echo " The installation will be in $Pbuild_install_directory when complete."
echo ""

# build if interactive
#---------------------
if ($?PBS_JOBID || $?SLURM_JOBID) then
   goto build
endif

#=============
# submit job
#=============
set groupflag = ""
if ("$account" != "") then
   if ($SITE == NAS) then
      set groupflag = "-W group_list=$account"
   else if ($SITE == NCCS) then
      set groupflag = "--account=$account"
   endif
else if (-e `which getsponsor` && (! $interactive)) then
   set group = ""
   set sponsorinfo = `getsponsor`

   while ("$group" == "")
      @ n = 1
      while ($n < $#sponsorinfo)
         if ($sponsorinfo[$n] =~ g[0..9]*) then
            set group = $sponsorinfo[$n]
            #--break  # uncomment this line to make 1st entry the default
         endif
         @ n++
      end

      getsponsor
      if ("$group" != "") then
         echo -n "select group: [$group] "
      else
         echo -n "select group:  "
      endif
      if ($prompt) then
         set reponse = $<
         if ("$reponse" != "") set group = $reponse
      endif
   end

   set groupflag = "--account=$group"
endif

set waitflag = ""
if ($do_wait) then
   if ($SITE == NAS) then
      set waitflag = "-W block=true"
   else if ($SITE == NCCS) then
      set waitflag = "--wait"
   endif
endif

if ($interactive) then
   goto build
else if ( $SITE == NAS ) then
   if ("$walltime" == "") setenv walltime "1:30:00"
   set echo
   qsub  $groupflag $queue     \
        -N $jobname            \
        -l select=1:ncpus=${ncpus}:mpiprocs=${numjobs}$proc \
        -l walltime=$walltime  \
        -S /bin/csh            \
        -V -j oe -k oed        \
        $waitflag              \
        $0
   unset echo
   if ("$waitflag" == "") then
      sleep 1
      qstat -a | grep $USER
   endif
else if ( $SITE == NCCS ) then
   if ("$walltime" == "") setenv walltime "1:00:00"
   set echo
   sbatch $groupflag $partition $queue \
        $slurm_constraint      \
        --job-name=$jobname    \
        --output=$jobname.o%j  \
        --nodes=1              \
        --ntasks=${numjobs}    \
        --time=$walltime       \
        $waitflag              \
        $0
   unset echo
   if ("$waitflag" == "") then
      sleep 1
      # Add a longer format for the job name for scripting purposes
      squeue -a -o "%.10i %.12P %.10q %.30j %.8u %.8T %.10M %.9l %.6D %.6C %R" -u $USER
   endif
else
   echo $scriptname": batch procedures are not yet defined for node=$node at site=$SITE"
endif
exit



build:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                             BUILD SYSTEM
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if ( $cleanFLAG == "clean" ) then
   rm -rf $Pbuild_build_directory
   rm -rf $Pbuild_install_directory

   mkdir -p $Pbuild_build_directory
endif

chdir $Pbuild_build_directory

setenv ARCH `uname -s`

#=================================================
# create $BUILD_LOG_DIR, plus LOG and info files
#=================================================

# create build log directory
#---------------------------
if (! -d $bldlogdir) mkdir -p $bldlogdir

# increment LOG and info files if previous versions exist
#--------------------------------------------------------
ls $cmakelog $buildlog $buildinfo >& /dev/null
if ($status == 0) then
   @ next = 0
   foreach file ( $cmakelog $buildlog $buildinfo )
      @ num = 1
      while (-e ${file}.$num)
         @ num ++
      end
      if ($num > $next) @ next = $num
   end
   set buildinfo = $bldlogdir/info.$next
   set buildlog  = $bldlogdir/LOG.$next
   set cmakelog  = $bldlogdir/CLOG.$next
endif

# alias definitions
#------------------
alias echo2 "echo \!* |& tee    $buildinfo $buildlog"
alias echo1 "echo \!* |& tee -a $buildinfo"
alias date1 "date     |& tee -a $buildinfo"

# initialize files
#-----------------
echo "Writing LOG and info files to directory: $bldlogdir:t"
echo2 ""

#================
# set environment
#================
if ( -d ${ESMADIR}/@env ) then
   source $ESMADIR/@env/g5_modules
else if ( -d ${ESMADIR}/env@ ) then
   source $ESMADIR/env@/g5_modules
else if ( -d ${ESMADIR}/env ) then
   source $ESMADIR/env/g5_modules
endif

# write environment info to build log
#------------------------------------
if ("$tmpdir" != "") setenv TMPDIR $tmpdir
echo1 "======================================"
echo1 `uname -a`
echo1 "ESMADIR: $ESMADIR"
echo1 "BASEDIR: $BASEDIR"
echo1 "SITE: $SITE"
if ($?TMPDIR) then
   echo1 "TMPDIR = $TMPDIR"
endif
echo1 "cmake_build_type: $cmake_build_type"
if ("$verbose" != "") then
   echo1 "verbose: $verbose"
endif
if ("$queue" != "") then
   echo1 "queue: $queue"
endif
if ("$account" != "") then
   echo1 "account: $account"
endif

echo1 "======================================"
module list >>& $buildinfo
echo1 "======================================"

#===============
# build system
#===============
if ($usegnu) then
   setenv FORTRAN_COMPILER 'gfortran'
else
   setenv FORTRAN_COMPILER 'ifort'
endif

if ($notar) then
   setenv INSTALL_SOURCE_TARFILE "OFF"
else
   setenv INSTALL_SOURCE_TARFILE "ON"
endif

if ($?GMI_MECHANISM) then
   setenv GMI_MECHANISM_FLAG "-DGMI_MECHANISM=$GMI_MECHANISM"
else
   setenv GMI_MECHANISM_FLAG ""
endif

set cmd1 = "cmake $ESMADIR -DCMAKE_INSTALL_PREFIX=$Pbuild_install_directory -DBASEDIR=${BASEDIR}/${ARCH} -DCMAKE_Fortran_COMPILER=${FORTRAN_COMPILER} -DCMAKE_BUILD_TYPE=${cmake_build_type} -DINSTALL_SOURCE_TARFILE=${INSTALL_SOURCE_TARFILE} ${GMI_MECHANISM_FLAG} ${EXTRA_CMAKE_FLAGS}"
set cmd2 = "make --jobs=$numjobs install $verbose"
echo1 ""
echo1 ""
if ($docmake) then
echo1 "--------------------------------------"
echo1 $cmd1
$cmd1 |& tee -a $cmakelog
echo1 ""
endif
echo1 "--------------------------------------"
echo1 $cmd2
date1
echo1  "Parallel build: $numjobs JOBS on $ncpus CPUs ... "
set echo
$cmd2 |& tee -a $buildlog
set buildstatus = $status

echo1 "build complete; status = $buildstatus"
date1
echo1 "Your build is located in $Pbuild_build_directory"
echo1 ""
echo1 "Your installation is located in $Pbuild_install_directory"
echo1 "You can find setup scripts in $Pbuild_install_directory/bin"
echo1 "--------------------------------------"
time >> $buildinfo
echo1 ""

# check build results
#--------------------
chdir $bldlogdir
ls $buildlog >& /dev/null
set logstatus = $status

exit $buildstatus

usage:
cat <<EOF

usage: $scriptname:t [flagged options]

flagged options
   -np                  do not prompt for responses; use defaults
   -help (or -h)        echo usage information

   -develop             checkout with GEOSgcm_GridComp and GEOSgcm_App develop branches
   -debug (or -db)      compile with debug flags (-DCMAKE_BUILD_TYPE=Debug)
   -builddir dir        alternate CMake build directory (relative to $ESMADIR)
   -installdir dir      alternate CMake install directory (relative to $ESMADIR)
   -tmpdir dir          alternate Fortran TMPDIR location
   -esmadir dir         esmadir location
   -nocmake             do not run cmake (useful for scripting)
   -gnu                 build with gfortran
   -wait                wait when run as a batch job
   -no-tar              build with INSTALL_SOURCE_TARFILE=OFF (does not tar up source tarball, default is ON)

   -i                   run interactively rather than queuing job
   -q qos/queue         send batch job to qos/queue
   -partition partition send batch job to partition (in case SLURM queue not on default compute partition)
   -account account     send batch job to account
   -walltime hh:mm:ss   time to use as batch walltime at job submittal

   -rom                 compile on Rome nodes (only at NAS)
   -cas                 compile on Cascade Lake nodes
   -sky                 compile on Skylake nodes (default at NAS)
   -bro                 compile on Broadwell nodes (only at NAS)
   -has                 compile on Haswell nodes (only at NAS)
   -any                 compile on any node (only at NCCS with SLURM, default at NCCS)

extra cmake options

   To pass in additional CMake options not covered by the above flags,
   after all your flags, add -- and then the options. For example:

     $scriptname -debug -- -DSTRATCHEM_REDUCED_MECHANISM=ON -DUSE_CODATA_2018_CONSTANTS=ON

   and these options will be appended to the CMake command.

   NOTE: Once you use --, you cannot use any more flags. All options
   after -- will be passed to CMake and if not a valid CMake option,
   could cause the build to fail.

EOF
