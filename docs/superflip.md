---
search:
  exclude: true
---

# Structure solution by charge flipping (Superflip)

!!! warning "Draft"
    This page is being written and is not yet linked from the documentation.

**Charge flipping** is an iterative method for crystal structure solution based on the
direct modification of the electron density map. The algorithm alternates between real
and reciprocal space, modifying the electron density at each cycle to drive it towards
the correct structure.

A widely used and efficient implementation is the program
[Superflip](http://superflip.fzu.cz/) (Palatinus & Chapuis, 2007). EXPO integrates
Superflip, allowing structure solution from powder diffraction data by charge flipping:

1. EXPO computes the observed structure factors from the experimental pattern;
2. Superflip runs the charge flipping algorithm on them and produces an electron density
   map. Superflip is used with the **histogram matching** technique, which has proven
   effective for solving complex structures from powder data (Baerlocher *et al.*,
   2007);
3. the density map is interpreted and optimized by EXPO with its own tools.

If you solve a structure with this procedure, please cite the Superflip paper
(Palatinus & Chapuis, 2007) **in addition to** the EXPO reference.

## Using Superflip in EXPO

The simplest way is the `%sflip` command, which runs the charge flipping procedure with
the integrated Superflip program. The structure factors are obtained from the
[extraction of the integrated intensities](direct-methods/extraction.md) (`%extraction`);
if `%extraction` is not given, EXPO carries out a Le Bail decomposition of the pattern
before running Superflip.

Example of input file:

```text
%Structure ammonium
%Job ammonium
%Data
Cell 7.555 14.640 10.246 90 109.30 90
SpaceGroup p 21/a
Content (C9 H11 Cl N2 O2 S)4
Pattern pd_0014.xye
Wavelength 1.54056
%extraction
%sflip
```

If the default procedure does not give a satisfactory solution, use the `refine`
directive described below.

## Default behaviour and the `refine` directive

By default the whole Superflip calculation is repeated 20 times (Superflip keyword
`repeatmode`), and the 10 best densities are saved (keyword `bestdensities`), selected by
an overall symmetry agreement factor. All the saved densities are interpreted by EXPO,
but only the best one is optimized automatically.

To optimize more densities, use the `refine` directive after `%sflip`:

```text
refine [ndensities]
```

where *ndensities* is the number of saved densities to optimize. Without *ndensities*
all the saved densities are optimized; with 0 none is optimized. This is useful when the
default strategy fails, or to check whether other densities give a better solution.

```text
%Structure ammonium
%Job ammonium
%Data
Cell 7.555 14.640 10.246 90 109.30 90
SpaceGroup p 21/a
Content (C9 H11 Cl N2 O2 S)4
Pattern pd_0014.xye
Wavelength 1.54056
%extraction
%sflip
refine
```

## Graphical interface

The whole procedure can also be run from the graphical interface, with the
**Solve → Superflip** submenu:

**Run Superflip**
:   opens a dialog with the general settings of the procedure; the Superflip input file
    can be viewed and edited before running the calculation.

**Best Solutions**
:   lists the best density maps obtained by Superflip, and starts the optimization of one
    or more of them.

**Output**
:   shows the Superflip output file, with the details and results of the charge flipping
    calculation.

## References

- Baerlocher, Ch., McCusker, L. B. & Palatinus, L. (2007). *Z. Kristallogr.* **222**,
  47–53.
  [doi:10.1524/zkri.2007.222.2.47](https://doi.org/10.1524/zkri.2007.222.2.47)
- Palatinus, L. & Chapuis, G. (2007). *J. Appl. Cryst.* **40**, 786–790.
  [doi:10.1107/S0021889807029238](https://doi.org/10.1107/S0021889807029238)
