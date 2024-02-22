# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
### Fixed
### Removed
### Added

## [4.26.0] - 2024-02-22

### Changed

- Move to Baselibs 7.18.1
  - HDF5 1.14.3
  - curl 8.6.0
  - zlib 1.3.1

## [4.25.1] - 2024-01-24

### Fixed

- Fix incorrect Open MPI module at NCCS SLES15

## [4.25.0] - 2024-01-22

### Changed

- Moved to Baselibs 7.17.1
  - Fix for NAG and ESMF 8.6.0
- Update `g5_modules` to use GCC 11.4 as the backing C compiler on SLES 15 at NCCS
  - This was done as it was discovered that xgboost was not building on SLES15 with Intel when using GCC 12. Until xgboost can be
    updated to a newer version, this is the workaround.

## [4.24.0] - 2023-12-01

### Changed

- Moved to Baselibs 7.17.0
  - GFE v1.12.0
    - gFTL v1.11.0
    - gFTL-shared v1.7.0
    - fArgParse v1.6.0
    - pFUnit v4.8.0
    - yaFyaml v1.2.0
    - pFlogger v1.11.0

## [4.23.0] - 2023-11-30

### Changed

- Moved to Baselibs 7.16.0
  - ESMF v8.6.0
  - NCO 5.1.9
  - CDO 2.3.0
- Move to Open MPI 4.1.6 with Intel on SLES 15 at NCCS.

## [4.22.0] - 2023-11-21

### Changed

- Move back to Open MPI 4.1.5 with Intel on SLES 15 on NCCS. This avoids a bug between GEOS' Intel debugging flags and MPI_Init with Open MPI 5.0.0 (see https://github.com/open-mpi/ompi/issues/12113)

## [4.21.0] - 2023-11-20

### Changed

- Move to Open MPI 5.0.0 on SLES15 at NCCS
- Moved to Baselibs 7.15.1
  - zlib 1.3
  - curl 8.4.0
  - HDF4 4.2.16-2
  - HDF5 1.10.11
  - nco 5.1.8
  - CDO 2.2.2
  - udunits2 2.2.28
  - fortran\_udunits2 v1.0.0-rc.2 (GMAO-SI-Team fork)

### Added

- `g5_modules` now exports `UDUNITS2_XML_PATH`

## [4.20.6] - 2023-10-30

### Fixed

- Fixed issue with clean option

## [4.20.5] - 2023-10-26

### Fixed

- Fix issue with passing in build and install dirs

## [4.20.4] - 2023-10-25

### Fixed

- Fixed breakage of debug, aggressive and many many other options

## [4.20.3] - 2023-10-24

### Fixed

- Fixed issue with OS versioning when inside SLURM (has to be detected differently)

## [4.20.2] - 2023-10-23

### Fixed

- Append `-SLES12` or `-SLES15` on the build and install directories at NCCS when using `build.csh` to make it clear to users

## [4.20.1] - 2023-10-23

### Fixed

- Fixed `build.csh` for using Milan at NCCS

## [4.20.0] - 2023-10-14

### Added

- Added support for Milan at NCCS
  - Uses Open MPI 4.1.5 on SCU17 rather than Intel MPI due to issues with Intel MPI

## [4.19.0] - 2023-07-27

### Changed

- Moved to Baselibs 7.14.0
  - ESMF v8.5.0
  - GFE v1.11.0
    - gFTL-shared v1.6.1
    - pFUnit v4.7.3
  - curl 8.2.1
  - NCO 5.1.7
  - CDO 2.2.1

## [4.18.0] - 2023-07-13

### Changed

- Removed Haswell as build node option at NCCS (no longer available)
- Added an "any" option for the build node at NCCS which will submit to any available node type
  - At NCCS with GNU, Cascade Lake is forced as Open MPI is built only for Infiniband

## [4.17.0] - 2023-05-25

### Changed

- Moved to Baselibs 7.13.0
  - esmf v8.5.0b22
  - curl 8.1.1
  - HDF5 1.10.10
  - netCDF-C 4.9.2
  - netCDF-Fortran 4.6.1
  - CDO 2.2.0

## [4.16.1] - 2023-05-24

### Fixed

- Fixed issue with tmpdir at NAS

## [4.16.0] - 2023-05-18

### Changed

- Updated to use MPT 2.28 at NAS per their recommendation for running on new TOSS4 nodes
  - This is done through the `mpi-hpt/mpt` module which resolves to `mpi-hpe/mpt.2.28_25Apr23_rhel87`

## [4.15.0] - 2023-04-19

### Changed

- Moved to Baselibs 7.12.0
  - GFE v1.10.0
  - curl 8.0.1
  - NCO 5.1.5

## [4.14.0] - 2023-03-29

### Removed

- Removed the `-hydrostatic` and `non-hydrostatic` options from `build.csh` as they are no longer needed as GEOS now
  builds both by default

## [4.13.0] - 2023-03-17

### Added

- Add `-wait` option for waiting for batch jobs

## [4.12.0] - 2023-03-08

### Changed

- Moved to Baselibs 7.11.0
  - ESMF v8.5.0b18

## [4.11.0] - 2023-03-03

### Changed

- Moved to Baselibs 7.10.0
  - GFE v1.9.0
  - curl v7.88.1

## [4.10.0] - 2023-01-26

### Changed

- Moved to Baselibs 7.9.0
  - ESMF v8.5.0b13
    - NOTE: This is a non-zero-diff change for GEOSgcm to precision changes in grid generation.

## [4.9.0] - 2023-01-26

### Changed

- Moved to Baselibs 7.8.0
  - curl 7.87.0
  - NCO 5.1.4
  - CDO 2.1.1
    - NOTE: CDO now requires C++17 so this means if you are building with Intel C++ (Classic), you should use GCC 11.1 or higher as the backing GCC compiler [per the Intel docs](https://www.intel.com/content/www/us/en/develop/documentation/cpp-compiler-developer-guide-and-reference/top/compiler-reference/compiler-options/language-options/std-qstd.html)
- Move to use GCC 11 at NCCS and NAS as needed above
- Moved to use GitHub Actions for label enforcement

## [4.8.0] - 2022-11-29

### Changed

- Moved to Baselibs 7.7.0
  - Updated
    - GFE v1.8.0
      - fArgParse v1.4.1
      - pFUnit v4.6.1

## [4.7.0] - 2022-11-09

### Changed

- Moved to Baselibs 7.6.0
  - Updated
    - ESMF v8.4.0
    - zlib 1.2.13
    - curl 7.86.0
    - netCDF-C 4.9.0
    - netCDF-Fortran 4.6.0
    - NCO 5.1.1
    - CDO 2.1.0

## [4.6.0] - 2022-11-02

### Added

- Add ability to pass in arbitrary CMake options to `build.csh`

## [4.5.0] - 2022-10-25

### Added

- Added `-gmi_mechanism` option to `build.csh` for use with multiple GMI mechanism

## [4.4.0] - 2022-08-26

### Added

- Add support for TOSS4 at NAS in `g5_modules`

## [4.3.0] - 2022-08-19

### Changed

- Update to Intel 2022.1

## [4.2.0] - 2022-07-01

### Changed

- Moved to Baselibs 7.5.0
  - Updated
    - GFE v1.4.0

## [4.1.0] - 2022-06-15

### Changed

- Moved to Baselibs 7.3.1
  - Added
    - xgboost v1.6.0
  - Updated
    - ESMF v8.3.0
    - GFE v1.3.1
    - HDF5 1.10.9
    - curl 7.83.1
    - HDF5 1.10.9
    - NCO 5.0.7
    - CDO 2.0.5
- Added Arm64 section to `g5_modules`

### Added

- Added `.editorconfig` file

## [4.0.0] - 2022-04-21

### Changed

- Update to Baselibs v7.0.0
  - NOTE: This is a major tick because the yaFyaml in Baselibs 7 is incompatible with code that used yaFyaml in Baselibs 6. This is
    MAPL for GEOS. Upcoming code changes will require the use of these new yaFyaml interfaces

## [3.13.0] - 2022-03-17

### Changed

- Change `build.csh` to only have `clean` or `no clean` options. The `clean` option now always does a full remove-build-and-install
  followed by a cmake.

## [3.12.0] - 2022-03-09

### Changed

- Update to Baselibs 6.2.13
- Move to have both Python2 and Python3 loaded at the same time

## [3.11.0] - 2022-01-24

### Removed

- Removed support for SLES 12 and SLES 15 at NAS

### Changed

- Changed dates in CHANGELOG to conform to ISO 8601

## [3.10.0] - 2021-12-21

### Changed

- Moved the default walltime at NAS to 1:30:00 due to observed slowness

## [3.9.0] - 2021-12-20

### Changed

- Updated the Rome code in `build.csh` to not use SLES15

## [3.8.0] - 2021-12-16

### Changed

- Update to Intel 2021.3
  - Note: This is non-zero-diff for GEOSgcm vs Intel 2021.2

## [3.7.0] - 2021-12-06

### Added

- Add `build.csh` option `-no-tar` to turn off source tarfile generation (aka run CMake with `-DINSTALL_SOURCE_TARFILE=OFF`)

## [3.6.0] - 2021-11-03

### Changes

- Per NAS advice, use MPT 2.25 on TOSS nodes

## [3.5.1] - 2021-11-03

### Fixed

- Added Rome compute nodes (and tfe) to `build.csh`

## [3.5.0] - 2021-10-26

### Changed

- Update to Baselibs 6.2.8

## [3.4.1] - 2021-10-15

### Fixed

- When running on Cascade Lake nodes at NCCS, pass in `--ntasks-per-node=45`. Note that this script will never actually run `make -j48` and indeed only asks SLURM for 10 tasks, but this will suppress a loud warning.

### Added

- Add CMake option to install source tarfile by default in `build.csh`

## [3.4.0] - 2021-10-01

### Changed

- Update license to Apache
- Cascade Lake at NCCS Support
  - Update to Intel 2021.2 compiler and MPI
  - Update to Baselibs 6.2.7
  - Add cas to `build.csh`

### Added

- Added Changelog enforcer

## [3.3.1] - 2021-08-27

### Added

- Add `-rom` option to build script

## [3.3.0] - 2021-06-08

### Changed

- Update to Baselibs 6.2.4 (for GFE CMake Namespace)
  - NOTE: This should be used in conjunction with ESMA_cmake v3.5.0

## [3.2.2] - 2021-05-26

### Changed

- Updates for different mepo styles

## [3.2.1] - 2021-04-16

### Added

- Add `XTRAMODS2LOAD` to `g5_modules`

## [3.2.0] - 2021-04-05

### Changed

- Move to ESMF 8.1.0 (Baselibs 6.1.0)

## [3.1.4] - 2021-04-02

### Added

- Add option for non-hydrostatic build

## [3.1.3] - 2021-01-05

### Changed

- Update to Baselibs 6.0.27
  - This release updates to Baselibs 6.0.27 which is a minor update to the current 6.0.22. The differences were mainly in the build system, though an important update is the yaFyaml for some work being done in MAPL.

## [3.1.2] - 2020-12-10

### Added

- Add hidden aggressive `CMAKE_BUILD_TYPE`

## [3.1.1] - 2020-11-23

### Removed

- As we remove support for manage_externals, remove the reference in `build.csh`. No change to actual scripting.

## [3.1.0] - 2020-11-17

### Changed

- Update to Intel 19.1.3 and Baselibs 6.0.22
  - This release updates from Intel 19.1.2 to 19.1.3. This is zero-diff in all testing save for MOM6 (which was tested by @yvikhlya said is not wrong, just different).

## [3.0.1] - 2020-10-14

### Changed

- Reduce number of make jobs with `build.csh`

## [3.0.0] - 2020-09-23

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

## [2.1.6] - 2020-06-25

### Added

- This release adds a new file, `BUILD_MODULES.rc`, which will contain the environment modules/Lua modules used during building (if environment/Lua modules are found).

## [2.1.5] - 2020-05-27

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


## [2.1.4] - 2020-05-18

### Added

- Add `g5_modules.zsh`

## [2.1.3] - 2020-05-04

### Changed

- Update to Baselibs 6.0.12

## [2.1.2] - 2020-04-27

### Fixed

- Fix for bug at NAS

### Added

- Add `-nocmake` option for scripting

## [2.1.1] - 2020-04-20

### Changed

- Update to Baselibs 6.0.11

## [2.1.0] - 2020-04-15

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

## [2.0.4] - 2020-03-11

### Fixed

- Fix usage statement

## [2.0.3] - 2020-02-26

### Added

- Add Skylake Build capability at NCCS

## [2.0.2] - 2020-02-26

### Changed

- Use Intel MPI 19.1 on SLES 12

## [2.0.1] - 2020-02-21

### Changed

- Combined SLES11 + SLES12 `g5_modules`

## [2.0.0] - 2020-02-10

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

## [1.4.1] - 2020-01-07

### Changed

- Use Ops build of Baselibs 5.1.7 at NCCS

## [1.4.0] - 2019-Sep-26

## Added

- Add ability to specify directories and fix queues

## [1.3.3] - 2019-Sep-10

## Fixed

- Source GEOSenv after SIVO-PyD
  - This is a small change due to the structure of MOM6. The libcurl in SIVO-PyD was interfering with git's ability to do a submodule clone in MOM6 (no support for https). But, if GEOSenv is loaded after SIVO-PyD, it seems to fix this issue by letting git's libcurl (built by Bhat) to win and that seems to work.

## [1.3.2] - 2019-08-13

### Fixed

- Detect CPU count on macOS correctly
  - The `build.csh` script was assuming `/proc/cpuinfo` existed on all systems. macOS does not have it.

## [1.3.1] - 2019-07-25

### Changed

- Enable additional parallelism in build script

## [1.3.0] - 2019-07-24

### Changed

- Revert Python back to SIVO-PyD

## [1.2.2] - 2019-07-23

### Changed

- Change location of SI Team modulefiles on NCCS

## [1.2.1] - 2019-07-23

### Changed

- At build time, the ESMA_env will now create two files `CMAKE_RELEASE.rc` and `GIT_VERSION.rc` that will have information on what versions of CMake and Git built this install.

## [1.2.0] - 2019-07-18

### Changed

- To not duplicate massive amounts of code across major GEOS-ESM fixtures, we move the bulk of `parallel_build.csh` to this repo in
  the name `build.csh`. This is called by a small stub in fixtures.

### Added

- Also move `SITE.rc.in` and `BASEDIR.rc.in` from fixture to here.

## [1.1.2] - 2019-07-08

### Changed

- This moves installation of `g5_modules` etc. from the fixture to this repo

## [1.1.1] - 2019-07-05

### Fixed

- This was a bad copy-and-paste. Correct the basedir to point to the one for MPT

## [1.1.0] - 2019-07-05

### Added

- Due to the sheer number of `g5_modules` references in GEOS, for now restore this script

## [1.0.0] - 2019-07-03

### Added

- Initial release for GEOS
