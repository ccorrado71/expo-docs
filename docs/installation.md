# Installation

## Hardware and software environment

EXPO uses [Qt 6](https://www.qt.io/) for the graphical user interface and OpenGL for
three-dimensional molecular visualization. It runs on the most widely used operating
systems: Windows, macOS and several Linux distributions.

All installation packages are available from the
[Download](download.md) page.
In the file names below, `xx.yy.zz` stands for the version number of the release.

## Windows

The 64-bit version of EXPO has been tested on Windows 10 and 11.

1. Download the installer `expo2-xx.yy.zz-win64.exe`.
2. Double-click the downloaded file and follow the on-screen instructions.
   By default, EXPO is installed in `C:\Program Files\Expo2`.
3. Launch EXPO from the **Expo2** icon on the desktop or in the Start menu.

To uninstall EXPO, use **Settings → Apps → Installed apps**.

## macOS

1. **Download the DMG file** `expo-xx.yy.zz-arm64.dmg`.
   The DMG was prepared on macOS Monterey and also works on later versions.
2. **Open the DMG**: double-click the downloaded file (usually in your *Downloads* folder).
   A window showing the application icon appears.
3. **Drag and drop** the EXPO icon onto the *Applications* folder shortcut in the same
   window. This copies the application into your *Applications* directory.
4. **Eject the DMG**: right-click the mounted EXPO volume on the desktop and select
   *Eject*, or drag it to the Trash.
5. **Launch EXPO**: open *Finder → Applications* and double-click EXPO.

!!! warning "First launch"
    On the first launch macOS may block EXPO because it comes from an unidentified
    developer.

    - **macOS 14 (Sonoma) and earlier**: right-click (or Control-click) the EXPO icon,
      select *Open* and confirm.
    - **macOS 15 (Sequoia) and later**: try to open EXPO once, then go to
      *System Settings → Privacy & Security*, scroll down and click *Open Anyway*.

    After this one-time confirmation EXPO opens normally.

## Linux

On Linux, EXPO can be installed from a pre-built Debian package (`.deb`), compiled from
source (`.tar.gz`), or run from a Docker image.

### Option A – Debian package (.deb)

Pre-built `.deb` packages are the easiest way to install EXPO on Debian, Ubuntu and
their derivatives. Packages are built for specific Ubuntu releases, and the release
codename is part of the file name, e.g. `expo-xx.yy.zz-noble_amd64.deb` for Ubuntu 24.04.
Choose the package that matches your distribution.

Install the package with `apt`, which also installs all the required runtime
dependencies (Qt 6, Open Babel, Open MPI, FFTW, gfortran runtime):

```bash
sudo apt update
sudo apt install ./expo-xx.yy.zz-<codename>_amd64.deb
```

??? note "Installing with dpkg instead"
    If you prefer `dpkg`, install the package and then let `apt` fix any missing
    dependency:

    ```bash
    sudo dpkg -i expo-xx.yy.zz-<codename>_amd64.deb
    sudo apt-get install -f
    ```

The package installs EXPO system-wide under `/usr`; the executable is `/usr/bin/expo`
and is already on your `PATH`. Launch EXPO from the applications menu or by typing:

```bash
expo
```

To remove EXPO:

```bash
sudo apt remove expo
```

!!! note
    A native `.rpm` package is not available at this time. On Fedora, RHEL, CentOS
    and Rocky Linux, install EXPO from source (Option B) or use the Docker image
    (Option C).

### Option B – Compiling from source (.tar.gz)

Building from source gives full control over the compiler and optimization flags.
EXPO uses [CMake](https://cmake.org/) (version 3.20 or later) as its build system.

#### Build requirements

- CMake ≥ 3.20
- a C++17 compiler
- a Fortran compiler: GNU Fortran (`gfortran`) or Intel Fortran (`ifx`, `ifort`)
- Qt 6 (Widgets, OpenGL, OpenGLWidgets, PrintSupport, Network)
- Open Babel, Open MPI and FFTW libraries

On **Debian / Ubuntu**:

```bash
sudo apt-get update
sudo apt-get install cmake build-essential pkg-config gfortran \
    qt6-base-dev libopenbabel-dev libopenmpi-dev libfftw3-dev
```

On **Fedora**:

```bash
sudo dnf group install "Development Tools"
sudo dnf install cmake gcc-c++ gcc-gfortran pkgconfig \
    qt6-qtbase-devel openbabel-devel openmpi-devel fftw-devel
```

After installing `openmpi-devel` on Fedora, load the MPI module before building:

```bash
module load mpi/openmpi-x86_64
```

On **RHEL / CentOS / Rocky Linux** (enable the EPEL and CRB repositories first):

```bash
sudo dnf install epel-release
sudo dnf config-manager --set-enabled crb   # RHEL 9 / Rocky 9
sudo dnf group install "Development Tools"
sudo dnf install cmake gcc-c++ gcc-gfortran pkgconfig \
    qt6-qtbase-devel openbabel-devel openmpi-devel fftw-devel
```

#### Fortran compiler and parallel version

The Fortran compiler is chosen at configuration time. If its name starts with `mpi`
(e.g. `mpifort`, `mpiifort`), EXPO is built with **MPI support** for the parallel
execution of the direct-space structure solution; otherwise a serial version is built.

| Compiler   | Description                                       | MPI |
|------------|---------------------------------------------------|-----|
| `mpifort`  | Open MPI wrapper (usually around `gfortran`)      | yes |
| `mpiifort` | Intel MPI wrapper for the Intel Fortran compiler  | yes |
| `gfortran` | GNU Fortran                                       | no  |
| `ifx`      | Intel oneAPI Fortran compiler                     | no  |
| `ifort`    | Intel Fortran Compiler Classic (discontinued by Intel, use `ifx`) | no |

The Intel compilers can be downloaded from the
[Intel oneAPI website](https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html).

#### Quick install with install.sh

Download the source archive `expo2-xx.yy.zz-Source.tar.gz`, extract it and run the
installation script:

```bash
tar xzf expo2-xx.yy.zz-Source.tar.gz
cd expo2-xx.yy.zz-Source
./install.sh
```

The script:

1. configures the build with CMake (Release mode);
2. compiles using all available CPU cores;
3. installs EXPO to `/opt/expo-xx.yy.zz` (it asks for your password for the
   `sudo cmake --install` step).

By default `install.sh` uses `mpifort`. To use a different Fortran compiler, pass it as
the first argument:

```bash
./install.sh gfortran     # GNU Fortran (serial)
./install.sh ifx          # Intel oneAPI (serial)
./install.sh mpiifort     # Intel MPI wrapper
```

At the end, add the EXPO directory to your `PATH`:

```bash
export PATH=/opt/expo-xx.yy.zz/bin:$PATH
```

To make this permanent, append the line to your `~/.bashrc` or `~/.profile`.

#### Manual build with CMake

For full control, run the CMake commands yourself:

```bash
# 1. Extract and enter the source directory
tar xzf expo2-xx.yy.zz-Source.tar.gz
cd expo2-xx.yy.zz-Source

# 2. Configure (choose your Fortran compiler)
cmake -B build -S . -DCMAKE_Fortran_COMPILER=mpifort -DCMAKE_BUILD_TYPE=Release

# 3. Build using all CPU cores
cmake --build build -j$(nproc)

# 4. Install (requires root privileges)
sudo cmake --install build
```

You can replace `-j$(nproc)` with a specific number of parallel jobs (e.g. `-j4`).

By default EXPO is installed to `/opt/expo-xx.yy.zz`. To install it elsewhere, add
`-DCMAKE_INSTALL_PREFIX` at configuration time:

```bash
cmake -B build -S . -DCMAKE_Fortran_COMPILER=mpifort -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/your/custom/path
cmake --build build -j$(nproc)
sudo cmake --install build     # sudo is not needed for a directory you own
```

### Option C – Docker image

A pre-built Docker image is distributed as a `.tar.gz` archive
(`expo-xx.yy.zz-docker.tar.gz`). It is the simplest way to run EXPO on any Linux
distribution without installing dependencies. It only requires
[Docker](https://docs.docker.com/engine/install/) on the host.

**1. Load the image**

```bash
docker load -i expo-xx.yy.zz-docker.tar.gz
```

The image is registered as `expo:xx.yy.zz`. Verify with:

```bash
docker images expo
```

**2. Run EXPO with the graphical interface (X11 forwarding)**

```bash
docker run --rm -it --ipc=host \
    -e PUID="$(id -u)" -e PGID="$(id -g)" \
    -e DISPLAY="$DISPLAY" \
    -e QT_QPA_PLATFORM=xcb \
    -e QT_XCB_GL_INTEGRATION=xcb_egl \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$XAUTHORITY:/home/expo/.Xauthority:ro" \
    -v "$PWD:/work" \
    expo:xx.yy.zz expo
```

- `PUID`/`PGID` make EXPO run inside the container with the same user and group IDs
  as the host user, so files created in `/work` (the current directory, mounted in the
  container) belong to you and not to `root`.
- If the `XAUTHORITY` variable is not set on your system, use
  `-v "$HOME/.Xauthority:/home/expo/.Xauthority:ro"` instead.
- If the host has no GPU or OpenGL driver available to the container, add
  `-e LIBGL_ALWAYS_SOFTWARE=1` to enable software OpenGL rendering.

**3. Run EXPO without graphics, in parallel with mpirun**

```bash
docker run --rm \
    -e PUID="$(id -u)" -e PGID="$(id -g)" \
    -v "$PWD:/work" \
    expo:xx.yy.zz mpirun -np <NUM_TASKS> expo <FILE.exp>
```

!!! note
    The Docker image does not include Wine, so the external indexing programs
    DICVOL and McMaille (see [Third-party software](#third-party-software)) are not
    available inside the container.

## Third-party software

On Linux and macOS, running **DICVOL** or **McMaille** during the indexing procedure
requires [Wine](https://gitlab.winehq.org/wine/wine/-/wikis/Download). EXPO looks for
the `wine` executable in the `PATH` (on macOS also in the usual Wine installation
folders). Neither Wine nor these programs are needed on Windows.

## Command-line usage

The EXPO executable is called `expo`. Besides launching it from its icon, you can start
it from a terminal, optionally passing an input file and an output file:

```bash
expo merca.exp merca.out
```

This runs EXPO with the input file `merca.exp` and writes the output to `merca.out`.
The output file can be omitted:

```bash
expo merca.exp
```

or EXPO can be started with no arguments:

```bash
expo
```

EXPO can also open at startup a crystal structure file (e.g. `*.cif`) or a powder
diffraction data file (e.g. `*.xy`, `*.dat`):

```bash
expo paracetamol_best1.cif
expo merca.xy
```

### Options

| Option      | Description                                                          |
|-------------|----------------------------------------------------------------------|
| `--help`    | Shows a short help message with the available options                |
| `--version` | Prints the version of EXPO                                           |
| `--nogui`   | Runs EXPO without the graphical interface (e.g. `expo merca.exp --nogui`) |
| `--auto`    | Runs EXPO with the graphical interface in automatic mode: the program starts, runs and exits without user interaction |

If EXPO was built with MPI support, the direct-space structure solution can run in
parallel with `mpirun`, as described in [Parallel execution](direct-space/parallel.md).

## Running the examples

Three test structures (`cime`, `merca` and `paracetamol`) are distributed with EXPO.
To open one of them, select **File → Load Examples**.

The first time this command is used, EXPO copies the examples into the folder
`share/expo/examples` of your home directory (e.g. `~/share/expo/examples` on
Linux and macOS, `C:\Users\<username>\share\expo\examples` on Windows), so that
they can be run without modifying the original files.

Then click the ![Next](images/next.png){ height="20" } icon on the toolbar to perform
the steps of the structure solution. The three examples are described step by step in
the [Tutorials](tutorials.md).
