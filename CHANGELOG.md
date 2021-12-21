# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
### Fixed
### Removed
### Added

## [3.10.0] - 2021-Dec-21

### Changed

- Moved the default walltime at NAS to 1:30:00 due to observed slowness

## [3.9.0] - 2021-Dec-20

### Changed

- Updated the Rome code in `build.csh` to not use SLES15

## [3.8.0] - 2021-Dec-16

### Changed

- Update to Intel 2021.3
  - Note: This is non-zero-diff for GEOSgcm vs Intel 2021.2

## [3.7.0] - 2021-Dec-06

### Added

- Add `build.csh` option `-no-tar` to turn off source tarfile generation (aka run CMake with `-DINSTALL_SOURCE_TARFILE=OFF`)

## [3.6.0] - 2021-Nov-03

### Changes

- Per NAS advice, use MPT 2.25 on TOSS nodes

## [3.5.1] - 2021-Nov-03

### Fixed

- Added Rome compute nodes (and tfe) to `build.csh`

## [3.5.0] - 2021-Oct-26

### Changed

- Update to Baselibs 6.2.8

## [3.4.1] - 2021-Oct-15

### Fixed

- When running on Cascade Lake nodes at NCCS, pass in `--ntasks-per-node=45`. Note that this script will never actually run `make -j48` and indeed only asks SLURM for 10 tasks, but this will suppress a loud warning.

### Added

- Add CMake option to install source tarfile by default in `build.csh`

## [3.4.0] - 2021-Oct-01

### Changed

- Update license to Apache
- Cascade Lake at NCCS Support
  - Update to Intel 2021.2 compiler and MPI
  - Update to Baselibs 6.2.7
  - Add cas to `build.csh`

### Added

- Added Changelog enforcer

## [3.3.1] - 2021-Aug-27

### Added

- Add `-rom` option to build script

## [3.3.0] - 2021-Jun-08

### Changed

- Update to Baselibs 6.2.4 (for GFE CMake Namespace)
  - NOTE: This should be used in conjunction with ESMA_cmake v3.5.0

## [3.2.2] - 2021-May-26

### Changed

- Updates for different mepo styles

## [3.2.1] - 2021-Apr-16

### Added

- Add `XTRAMODS2LOAD` to `g5_modules`

## [3.2.0] - 2021-Apr-05

### Changed

- Move to ESMF 8.1.0 (Baselibs 6.1.0)

## [3.1.4] - 2021-Apr-02

### Added

- Add option for non-hydrostatic build

## [3.1.3] - 2021-Jan-05

### Changed

- Update to Baselibs 6.0.27
  - This release updates to Baselibs 6.0.27 which is a minor update to the current 6.0.22. The differences were mainly in the build system, though an important update is the yaFyaml for some work being done in MAPL.

## [3.1.2] - 2020-Dec-10

### Added

- Add hidden aggressive `CMAKE_BUILD_TYPE`

## [3.1.1] - 2020-Nov-23

### Removed

- As we remove support for manage_externals, remove the reference in `build.csh`. No change to actual scripting.

## [3.1.0] - 2020-Nov-17

### Changed

- Update to Intel 19.1.3 and Baselibs 6.0.22
  - This release updates from Intel 19.1.2 to 19.1.3. This is zero-diff in all testing save for MOM6 (which was tested by @yvikhlya said is not wrong, just different).

## [3.0.1] - 2020-Oct-14

### Changed

- Reduce number of make jobs with `build.csh`

## [3.0.0] - 2020-Sep-23

### Changed

- This is a major release of ESMA_env. Note that with these changes ***SLES 11 Support at NCCS is Removed***

   #### Changes

   * ESMA Baselibs 6.0.16
   * Use a new Python Stack: GEOSpyD/Min4.8.3_py2.7
   * Update compilers and MPI stacks
     * NCCS
       * Intel Fortran 19.1.2
       * Intel MPI 19.1.2
     * NAS
       * Intel Fortran 2020.2.254 (aka 19.1.2)
       * MPT 2.17 (same as before)
     * GMAO Desktop
       * Intel Fortran 19.1.2
       * Open MPI 4.0.4
   * Remove the `NCCS/` directory as it was out-of-date
   * Add `-gnu` flag to `build.csh` for easier building with GCC at NAS
   
   #### Baselibs Changes

   The change to Baselibs 6.0.16 from 6.0.13 involves the following:
   
   | Library   | 6.0.13 | 6.0.16 |
   |-----------|--------|--------|
   | cURL      | 7.70.0 | 7.72.0 |
   | NCO       | 4.9.1  | 4.9.3  |
   | pFUnit    | 4.1.8  | 4.1.12 |
   | gFTL      | 1.2.5  | 1.2.7  |
   | fArgParse | 0.9.5  | 1.0.1  |
   | pFlogger  | 1.4.2  | 1.4.5  |
   | yaFyaml   | 0.3.3  | 0.4.1  |

## [2.1.6] - 2020-Jun-25

### Added

- This release adds a new file, `BUILD_MODULES.rc`, which will contain the environment modules/Lua modules used during building (if environment/Lua modules are found).

## [2.1.5] - 2020-May-27

### Changed

- Update to Baselibs 6.0.13
  - This update moves ESMA_env to use Baselibs 6.0.13. Testing has been zero-diff.

   Changes in this Baselibs include:

   #### Updates

   * ESMF 8.0.1
   * gFTL-shared v1.0.7
   * pFUnit v4.1.7
   * pFlogger v1.4.2
   * fArgParse v0.9.5
   * yaFyaml v0.3.3

   #### Fixed
   
   * Fixes for GCC 10
     * Added patch for netcdf issue with GCC 10
     * Added flag for HDF4 when using GCC 10
     * Need to pass in extra flags to ESMF when using GCC 10
   * Fix for detection for `--enable-dap` with netcdf


## [2.1.4] - 2020-May-18

### Added

- Add `g5_modules.zsh`

## [2.1.3] - 2020-May-04

### Changed

- Update to Baselibs 6.0.12

## [2.1.2] - 2020-Apr-27

### Fixed

- Fix for bug at NAS

### Added

- Add `-nocmake` option for scripting

## [2.1.1] - 2020-Apr-20

### Changed

- Update to Baselibs 6.0.11

## [2.1.0] - 2020-Apr-15

### Changed

- Release of MAPL 2.1 Compatible Environment
  - This release mainly moves to use Baselibs 6.0.10 which has new and update libraries needed for MAPL 2.1. The differences between 6.0.4 and 6.0.10 are:

  | Library     | 6.0.4  | 6.0.10 |
  |-------------|--------|--------|
  | cURL        | 7.67.0 | 7.69.1 |
  | HDF4        | 4.2.14 | 4.2.15 |
  | pFUnit      | 4.1.5  | 4.1.7  |
  | gFTL        | 1.2.2  | 1.2.5  |
  | gFTL-shared | 1.0.2  | 1.0.5  |
  | fArgParse   | 0.9.2  | 0.9.3  |
  | pFlogger    |        | 1.3.5  |
  | yaFyaml     |        | 0.3.1  |

  - Also, NAS installed 18.0.5 so this matches what is used at NCCS.

## [2.0.4] - 2020-Mar-11

### Fixed

- Fix usage statement

## [2.0.3] - 2020-Feb-26

### Added

- Add Skylake Build capability at NCCS

## [2.0.2] - 2020-Feb-26

### Changed

- Use Intel MPI 19.1 on SLES 12

## [2.0.1] - 2020-Feb-21

### Changed

- Combined SLES11 + SLES12 `g5_modules`

## [2.0.0] - 2020-Feb-10

### Changed

- Release of MAPL 2.0 Compatible Environment
  - This release of ESMA_env is the version compatible with MAPL 2.0. Changes include:
    - Use ESMA-Baselibs 6.0.4
    - Move to GEOSpyD 2019.10 as Python stack
    - NCCS
      - Move to Intel 18.0.5
      - Move to Intel MPI 18.0.5
    - NAS
      - Move to Intel 2019.3.199
        - NAS does not have Intel MPI 18.0.5 installed
    - GMAO Desktops
      - Move to Intel 18.0.5
      - Move to Open MPI 4.0.0

## [1.4.1] - 2020-Jan-07

### Changed

- Use Ops build of Baselibs 5.1.7 at NCCS

## [1.4.0] - 2019-Sep-26

## Added

- Add ability to specify directories and fix queues

## [1.3.3] - 2019-Sep-10

## Fixed

- Source GEOSenv after SIVO-PyD
  - This is a small change due to the structure of MOM6. The libcurl in SIVO-PyD was interfering with git's ability to do a submodule clone in MOM6 (no support for https). But, if GEOSenv is loaded after SIVO-PyD, it seems to fix this issue by letting git's libcurl (built by Bhat) to win and that seems to work.

## [1.3.2] - 2019-Aug-13

### Fixed

- Detect CPU count on macOS correctly
  - The `build.csh` script was assuming `/proc/cpuinfo` existed on all systems. macOS does not have it.

## [1.3.1] - 2019-Jul-25

### Changed

- Enable additional parallelism in build script

## [1.3.0] - 2019-Jul-24

### Changed

- Revert Python back to SIVO-PyD

## [1.2.2] - 2019-Jul-23

### Changed

- Change location of SI Team modulefiles on NCCS

## [1.2.1] - 2019-Jul-23

### Changed

- At build time, the ESMA_env will now create two files `CMAKE_RELEASE.rc` and `GIT_VERSION.rc` that will have information on what versions of CMake and Git built this install.

## [1.2.0] - 2019-Jul-18

### Changed

- To not duplicate massive amounts of code across major GEOS-ESM fixtures, we move the bulk of `parallel_build.csh` to this repo in
  the name `build.csh`. This is called by a small stub in fixtures.

### Added

- Also move `SITE.rc.in` and `BASEDIR.rc.in` from fixture to here.

## [1.1.2] - 2019-Jul-08

### Changed

- This moves installation of `g5_modules` etc. from the fixture to this repo

## [1.1.1] - 2019-Jul-05

### Fixed

- This was a bad copy-and-paste. Correct the basedir to point to the one for MPT

## [1.1.0] - 2019-Jul-05

### Added

- Due to the sheer number of `g5_modules` references in GEOS, for now restore this script

## [1.0.0] - 2019-Jul-03

### Added

- Initial release for GEOS
