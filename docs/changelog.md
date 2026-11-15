# Changelog

<!-- Copied from CHANGELOG.md of the EXPO repository by scripts/make_download_page.py: do not edit it by hand. -->

All notable changes to EXPO, for each released version.

## [2.3.13] - 2026-10-26

### Added
- Context menu on the pattern plot area (right click) with Reset Zoom, Autoscale, Legend, Selection Mode, Horizontal/Rectangle Zoom, Pan and Plot Style.
- "Clear Selection" in the peak list menu to deselect all selected peaks.
- H–Cl distance added to the bond distances table.

### Changed
- Indexing: the peak position tolerance is fixed at 0.02° for Cu wavelengths and scaled from the Cu value for other wavelengths.
- Windows installer now shows the license page, skips the Start menu page and no longer creates an Uninstall shortcut.
- Fewer GUI event-processing calls during long Fortran computations, reducing overhead.
- License updated to GPLv3.

### Fixed
- N-TREOR failed to index patterns collected at short wavelengths (e.g. synchrotron radiation), although the same d-values were indexed with Cu radiation.
- Crash when reading pdCIF files whose profile is given as d-spacings (`_pd_proc_d_spacing`); the 2θ step is now computed correctly.
- In no-GUI mode the default wavelength is used when none is given in the data file.
- Crash when updating the background with no background points.
- Background not respecting the selected number of coefficients.
- Wavelength input validation in the wavelengths widget.
- Crash when the MPI build is started without `mpirun`, and settings lock contention between MPI processes at startup.
- GNOME: missing running indicator on the taskbar icon, and launch from the dash failing with Intel Fortran (ifx/ifort) builds.
- Invalid color/light settings could be read from the configuration file.
- Memory leak in the crystal structure viewer.
- Linux packaging: RPATH errors during Qt deployment.
- Linux: installing with `install.sh` (`sudo cmake --install`) put the desktop entry and icons in `/root/.local/share`, so expo had no icon in the dock and was not recognized by the desktop portal; they are now installed in `/usr/local/share` (in `~/.local/share` for a non-root install, and inside the package for DEB builds).
- Linux: "Failed to register with host portal" warning at startup with recent Qt versions.

## [2.3.12] - 2026-06-27

### Added
- New project dialog (`NewProjectDialog`) to create expo input files interactively, without editing them by hand.
- Short contacts can now be displayed with 3 different colors depending on distance range (short / mid / long), making it easier to spot the most relevant contacts at a glance.
- Docker image to run expo without installing it locally, supporting both the headless/MPI workflow and the graphical (X11) interface.
- Use extended selection mode for info table views

### Fixed
- Various minor bug fixes, including an indexing issue affecting the reflection index shown in the status bar.

Back to the [download page](download.md).
