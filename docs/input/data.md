# The `%data` command

With `%data` EXPO reads the basic crystallographic information:

- the unit cell parameters, if known; otherwise they can be determined by the
  [indexing](../indexing.md) (`%ntreor`, `%dicvol`, `%mcmaille`);
- the space group symbol, if known; otherwise it can be determined with the `findspace`
  directive (see [Space group determination](../space-group.md));
- the wavelength;
- the unit cell content;
- the experimental data: a powder pattern (counts) or a list of reflections.

The symmetry operators are derived from the space group symbol by a modified version of
the SYMM subroutine (Burzlaff & Hountas, 1982).

The experimental data are supplied in an external file. If a **reflection file** is
given instead of a powder pattern, the extraction step is skipped, and the reflections
are checked to find equivalent and systematically absent ones, which are excluded.

## Directives

Only the first four characters of the directive names are significant (e.g. `wave` for
`wavelength`, `space` for `spacegroup`).

### Crystal data and radiation

| Directive | Description |
|-----------|-------------|
| `cell a b c α β γ` | unit cell parameters (Å and degrees) |
| `spacegroup symbol` | space group symbol, as in *International Tables for Crystallography* |
| `content formula` | unit cell content (see [below](#unit-cell-content)) |
| `findspace` | determine the space group when the cell parameters are known (see [Space group determination](../space-group.md)) |
| `standard symbol` | standardize the space group |
| `shift sx sy sz` | origin shift components, integral multiples of 1/24 |
| `wavelength λ` | wavelength (Å). Data collected with more wavelengths are described as `λ1 λ2 [ratio2]`, `λ1 λ2 ratio2 λ3 [ratio3]`, …, where *ratio* is the intensity ratio of each component |
| `synchrotron` | the pattern was collected with synchrotron radiation |
| `neutron` | the pattern was collected with neutron radiation |
| `isotope El sf` | neutron scattering length *sf* for the element *El*; only with `neutron` |

### Powder pattern

| Directive | Description |
|-----------|-------------|
| `pattern file` | file of the powder pattern (see [Powder pattern files](#powder-pattern-files)) |
| `filetype type` | format of the pattern file when it cannot be deduced from the extension: `counts`, `xy`, `double`, `gsas` or `cif`. `double`: the first line contains the minimum 2θ, the 2θ step and the maximum 2θ, followed by intensities and standard deviations on separate lines |
| `range thmin thmax` | only the counts in the 2θ range *thmin*–*thmax* are used |
| `alpha2` | Kα~2~ stripping; only with `pattern` |
| `histogram n` | number of bars of the histogram used for the Kα~2~ stripping (3, 5 or 7; default 3); only with `alpha2` |
| `fwhm x` | parameter of the overlap condition: two reflections overlap if 2θ~1~ − 2θ~2~ < *x* × FWHM, where 2θ~*j*~ is the calculated position of reflection *j* and FWHM is the width of reflection 2 (default 0.1, range 0–1) |
| `equiportion` | divide the total intensity of a group of overlapping reflections equally among them (equal \|E\| values). With a reflection file, use it only with `ref2`, i.e. when the file contains the FWHM of the reflections |

### Peaks for the indexing

| Directive | Description |
|-----------|-------------|
| `search thmin thmax npeaks thre` | conditions of the peak search for the indexing (see [below](#peak-search-conditions)) |
| `extefile file` | external file of peak positions (*d* values, or 2θ values with `2-theta`) supplied to the indexing; the automatic peak search is skipped |
| `2-theta` | the peak positions in `extefile` are 2θ values |
| `norefine` | skip the refinement of the peak clusters in the peak search |
| `thcorr x` | Δ2θ used to correct the 2θ peak positions for the zero shift (Altomare *et al.*, 2000); default: the experimental 2θ step |

### Reflection files

| Directive | Description |
|-----------|-------------|
| `reflections file` | single-crystal-like reflection file: on each line *h k l*, \|*F*~obs~\|² and σ(\|*F*~obs~\|²). The default format is `(3i4,2f8.2)`; free format (fields separated by blanks) is also read |
| `ref2 file` | reflection file with *h k l*, FWHM and \|*F*~obs~\|² on each line, in free format |
| `fobserved` | the reflection file contains \|*F*~obs~\| instead of \|*F*~obs~\|²; only with `reflections` or `ref2` |

With `reflections` or `ref2`, the directive `pattern` and the directives related to it
(`range`, `alpha2`, …) must not be used, and the next command must be `%normal` or
`%continue`.

## Unit cell content

The unit cell content given with `content` must satisfy the following rules:

- elements are written with their IUPAC symbols, each optionally followed by a number
  (omitted when it is 1);
- upper- and lower-case letters are allowed. To avoid ambiguity, the second letter of a
  two-letter symbol should be lower case: `Sb` is one antimony atom, while `SB` is one
  sulfur and one boron atom; blanks can separate the symbols (`S B` is one sulfur and
  one boron atom);
- brackets `( )`, `[ ]` and `{ }` can be used.

Valid examples are:

```text
(C10H16N6S)4
(C10 H16 N6 S)4
S 4 C 40 N 24 H 64
[(C7H8N4O2)(C7H7NO)]8
```

The first three lines describe the same cell content.

X-ray scattering factors, atomic numbers and weights, and covalent and van der Waals
radii are stored for the elements up to Cf (*Z* = 98) in the file `AtomProperties.xen`;
neutron scattering lengths are available for the elements up to Pu (*Z* = 94).

## Powder pattern files

EXPO recognizes the format of the pattern file from its extension:

| Extension | Format |
|-----------|--------|
| `.xy` | free-format X,Y file: 2θ in the first column and intensity in the second; further columns are ignored. `#` marks comments and can be used to exclude data ranges. The wavelength can optionally be given in the first line |
| `.dat`, `.txt` | free-format file: minimum 2θ, 2θ step and maximum 2θ on the first line, followed by the counts in free format. Initial caption lines are allowed if they start with `#`, `!` or `>` |
| `.pow` | generic extension for `.xy` and `.dat` files |
| `.xye` | CCDC Mercury xye file |
| `.gda` | GSAS data file (STD, ESD, ALT, FXY and FXYE formats) |
| `.cif`, `.rtv` | CIF powder file |
| `.uxd` | Siemens data file |
| `.cpi` | Sietronics Sieray data file |
| `.xdd` | XDD data file |
| `.dbw` | DBWS data file |
| `.xda` | XDA data file |
| `.udf` | Philips UDF data file |
| `.xrdml` | PANalytical XRDML data file |

Other formats can be converted with external programs, e.g. PowDLL.

Example of an XY file:

```text
# An example of XY file
  4.700    4769.000
  4.714    4860.000
  4.729    4794.000
  4.743    4857.000
  ...
```

Example of a DAT file:

```text
# An example of DAT file
  7.00   0.020 100.00
     3017    2925    3056    2983    3008    2953    2875    2976    2886    2928
     2973    2831    2960    2821    2854    2900    2857    2798    2876    2798
     2819    2865    2830    2735    2771    2813    2806    2704    2823    2878
  ...
```

## Peak search conditions

`search thmin thmax npeaks thre` changes the conditions of the search of the peaks
supplied to the indexing:

- *thmin*, *thmax*: 2θ range of the search (default: the whole experimental range);
- *npeaks*: number of the most intense peaks to select, among those whose intensity
  percentage is larger than *thre*;
- *thre*: intensity percentage threshold (default 1.5).

Zero or negative values of *thmin*, *thmax* and *thre* are replaced by the defaults, and
the last values can be omitted. For example:

| Directive | Effect |
|-----------|--------|
| `search 5 80 25` | the 25 most intense peaks in the 2θ range 5–80° |
| `search 0 0 20` | the 20 most intense peaks in the whole pattern |
| `search 0 0 0 2.5` | all the peaks with intensity percentage larger than 2.5% |

## Examples

**Example 1.** The peak search is skipped, and a list of 2θ peak positions is supplied
to the indexing.

```text
%structure mes
%job MES - data from home diffractometer
%data
pattern mes.pow
wavelength 1.5406
2-theta
extefile mes.pea
%ntreor
%continue
```

where `mes.pea` contains one 2θ value per line:

```text
12.0014
13.6797
15.5003
16.0599
...
```

**Example 2.** Space group determination with neutron data.

```text
%structure cfcl
%job CFCL - data from neutron source
%data
pattern cfcl.pow
cell 10.168 14.964 5.100 90.000 90.000 90.000
content C 8 F 16 Cl 16
findspace
wavelength 1.595
neutron
%continue
```

**Example 3.** Minimal information when the cell parameters and the space group are
known.

```text
%structure crox
%job CROX - data from home diffractometer
%data
pattern crox.pow
cell 5.447 6.5576 12.1147 106.382 95.715 77.970
content Cr 8 O 21
wavelength 1.3922
spacegroup p -1
%continue
```

**Example 4.** Kα~2~ stripping with a 5-bar histogram.

```text
%structure dada
%job DADA - data from home diffractometer
%data
spacegroup p 21 21 21
cell 7.13115 9.9077 12.9256 90.0 90.0 90.0
content Si 12 Ti 4 K 8 O 40
wavelength 1.540562
pattern dada.dat
alpha2
histogram 5
%continue
```

**Example 5.** A reflection file with *h k l*, \|*F*~obs~\|² and σ(\|*F*~obs~\|²) is
supplied, and the extraction is skipped.

```text
%structure mes
%job MES - data from home diffractometer
%data
reflections mes.hkl
wavelength 1.5406
content C 24 N 4 O 20 S 4 H 52
cell 8.5884 9.9309 11.1046 90.000 93.754 90.000
spacegroup p 21/c
%normal
%continue
```

where `mes.hkl` is:

```text
>   H   K   L   Fobs**2  sigma(Fobs**2)
    1   0   0    0.01    0.01
    0   1   1    0.17    0.01
    1   1   0    0.29    0.01
    1   1  -1    0.41    0.01
    ...
```

**Example 6.** A reflection file with *h k l*, FWHM and \|*F*~obs~\|² is supplied, and
the extraction is skipped.

```text
%structure mes
%job MES - data from home diffractometer
%data
ref2 mes_ref2.hkl
wavelength 1.5406
content C 24 N 4 O 20 S 4 H 52
cell 8.5884 9.9309 11.1046 90.000 93.754 90.000
spacegroup p 21/c
%normal
%continue
```

where `mes_ref2.hkl` is:

```text
>   H   K   L     FWHM      Fobs**2
    1   0   0    0.1064    0.0108
    0   1   1    0.1065    0.1671
    1   1   0    0.1066    0.2948
    1   1  -1    0.1066    0.4085
    ...
```

## References

- Altomare, A., Giacovazzo, C., Guagliardi, A., Moliterni, A. G. G., Rizzi, R. &
  Werner, P.-E. (2000). *J. Appl. Cryst.* **33**, 1180–1186.
  [doi:10.1107/S0021889800006427](https://doi.org/10.1107/S0021889800006427)
- Burzlaff, H. & Hountas, A. (1982). *J. Appl. Cryst.* **15**, 464–467.
  [doi:10.1107/S0021889882012382](https://doi.org/10.1107/S0021889882012382)
