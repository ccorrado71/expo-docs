# Fourier map and structure model optimization

*Command: `%fourier`*

The sets of phases produced by the [tangent formula](phasing.md) are passed to the fast
Fourier transform routine written by Ten Eyck (1977) and modified by the MULTAN team
(Main, 1978; Main *et al.*, 1980).

In a default run only the phase set with the best CFOM is processed. When it does not
give a reasonable model, use the [ALLTRIALS](index.md#exploring-all-the-trials-alltrials)
strategy to explore all the stored phase sets.

The **E-map** is computed using the normalized experimental structure factor moduli as
coefficients and the phases given by Direct Methods. The map is then interpreted
chemically and the structure model is recovered: special positions are handled, peaks
very close to symmetry elements are moved onto them, the site symmetry is defined and
the crystallographic occupancy is evaluated.

To improve the model derived from the E-map, a Fourier recycling is applied, followed
by a default model optimization based on:

1. suitably weighted least squares (*w*LSQ) (Altomare *et al.*, 2006), applied
   automatically to inorganic compounds;
2. the resolution bias correction algorithm RBM (Altomare *et al.*, 2008a, 2008b, 2009,
   2010a, 2010b), the default for organic and metal-organic compounds.

At the end of the run, non-default optimization strategies can be applied if the model
is incomplete or rough (see
[Structure model optimization](index.md#structure-model-optimization)); the RBM
procedures are available from **Refine → Resolution Bias Modification (RBM)**.

## Electron density modification

The non-standard `edmo` directive improves the phasing and, consequently, the electron
density map. It is based on real-space techniques (Altomare *et al.*, 2002) originally
used for phase extension and refinement of proteins (Giacovazzo & Siliqi, 1997; Burla
*et al.*, 2000): an Electron Density Modification (EDM) procedure is combined with
Fourier map calculations, reducing the errors on the Direct Methods phases of the strong
reflections (|E| > 1.0) and extending the phases to the reflections with |E| > 0.8. The
model obtained from the E-map computed with all the phased reflections is then refined
automatically by the model optimization.

The procedure can be used with X-ray and neutron data; with neutron data, only for
structures without atoms with negative scattering length.

## Directives

The following directives of `%fourier` activate non-default procedures:

| Directive | Description |
|-----------|-------------|
| `edmo` | enable the Electron Density Modification (EDM) procedure, followed by the automatic model optimization. Apart from `set` and `recycle 0`, the other `%fourier` directives are not valid with EDM; `recycle 0` computes only the E-map, without model optimization |
| `fragment file` | known structural fragment to be completed; for each atom the file contains chemical element, fractional coordinates (*x*, *y*, *z*) and isotropic thermal factor |
| `fwhm D` | parameter of the overlap condition: two reflections overlap if \|2θ~1~ − 2θ~2~\| < *D* × FWHM. Default about 0.9 (it depends on the ratio between number of observations and number of refined parameters) |
| `grid x` | grid of the Fourier map (default computed by EXPO, about 1/3 Å) |
| `integration x n` | *x* is the integration radius for the peak search in the map (default 0.5); *n* = 1 for a Gaussian fitting of the Fourier peaks, *n* = 2 for the average peak density (default 2) |
| `layx`, `layy`, `layz` | print the Fourier map in sections of constant *x*, *y* or *z*; only with `map` |
| `level n` | values of the E-map larger than *n* are marked with `****` in the printed map, to help contouring (default 100). The map is scaled between about ±999 at the grid points, but printed between ±99. Only with `map` |
| `limits x1 x2 x3` | print the E-map from 0 to *x1* along *x*, 0 to *x2* along *y*, 0 to *x3* along *z*; only with `map` |
| `map` | print the E-map, in sections of constant *y* with *x* across the page and *z* down it, on a grid of about three points per ångström (at most 36 points, about 12 Å, across the page). Rarely used |
| `peaks n` | number of peaks to search in the E-map. Default: the number of peaks for which Σ *occ*(*i*) × *m* = 1.3 × *n*, where *occ*(*i*) is the site occupancy of the *i*-th peak, *m* the number of symmetry operators and *n* the number of non-hydrogen atoms in the cell |
| `radius El x` | radius *x* assigned to the element *El* to evaluate the connectivity |
| `recycle n` | stop the Fourier recycling after cycle *n*; with *n* = 0 only the E-map is computed |
| `set n` | serial number of the phase set used for the E-map. Without `set`, the set with the highest CFOM is used; if `%fourier` is given again, the set with the next highest CFOM is used |
| `sogf x` | percentage of the reflections with the largest \|F\| actively used in the Fourier recycling; the others get zero weight (default 100.0) |
| `sogi x` | percentage of the most intense groups of overlapping reflections actively used in the Fourier recycling (default 91.0) |
| `thre x` | positive threshold on \|E\| for the reflections used in the EDM procedure (default 0.8) |
| `thrm x` | fraction of the most intense Fourier map points used in the EDM procedure, 0 < *x* ≤ 1.0 (default 0.025) |

### Example

**Example 1.** Only the E-map is computed for phase set 7, while the full E-map
calculation and model optimization are carried out for phase set 10.

```text
%structure nbpo
%job nbpo
%data
pattern nbpo.pow
content Nb 20 O 120 P 28
wavelength 1.0001
cell 29.8661 8.7215 8.7860 90.000 91.769 90.000
spacegroup c 2/c
synchrotron
%extraction
%normal
%invariants
%phase
%fourier
set 7
recycle 0
%fourier
set 10
%continue
```

## POLPO: completion of polyhedral structures

*Command: `%polyhedra`*

The POLPO1 (Altomare *et al.*, 2000) and POLPO2 (Giacovazzo *et al.*, 2002) procedures
complete structures with polyhedral (tetrahedral or octahedral) coordination when the
cations have been located and the coordination is known *a priori*. Exploiting the
experimental information on the cation connectivity, they generate many models
compatible with the coordination by a Monte Carlo algorithm.

- **POLPO1** is suggested when all the cations are correctly positioned and labelled.
- **POLPO2** can also locate one or more missing cations and the surrounding anions.

Both procedures start from the cation positions, supplied in an external file by the
`%fragment` command (they can be selected from the EXPO Fourier map). `%polyhedra` must
follow `%extraction` and `%fragment`.

| Directive | Description |
|-----------|-------------|
| `octahedron n d tol1 tol2` | octahedral coordination around the cation *n* (order number in the fragment file); *d* is the expected cation–anion distance, *tol1* and *tol2* the tolerances on distances and angles |
| `tetrahedron n d tol1 tol2` | as `octahedron`, for a tetrahedral coordination |
| `missing n1 n2 El tetrahedron\|octahedron d tol1 tol2` | locate a missing cation of element *El* between the cations *n1* and *n2* (order numbers in the fragment file or in the list of Fourier peaks), with tetrahedral or octahedral coordination; *d* is the expected cation–anion distance, *tol1* and *tol2* the tolerances on distances and angles (default 0.3) |

**Example 1.** POLPO1 locates the light atoms around the chromium cations listed in
`crox_cr.fra`.

```text
%structure crox
%job CROX
%data
pattern crox.pow
content Cr 8 O 21
wavelength 1.39222
cell 5.447 6.5576 12.1147 106.382 95.715 77.970
spacegroup p -1
%extraction
%fragment crox_cr.fra
%polyhedra
octahedron 1 1.92 0.2 0.2
tetrahedron 2 1.75 0.2 0.2
tetrahedron 3 1.75 0.2 0.2
tetrahedron 4 1.75 0.2 0.2
%continue
```

The file `crox_cr.fra` contains element, fractional coordinates and isotropic thermal
factor of the four chromium cations:

```text
cr .859 .211 .068 1.500
cr .280 .234 .898 1.700
cr .358 .377 .258 2.100
cr .721 .799 .528 3.200
```

**Example 2.** POLPO2 locates two missing silicon cations and the oxygen anions of
their tetrahedra.

```text
%structure sapo
%job SAPO
%data
cell 21.9410 13.6912 7.1243 90.000 90.000 90.000
spacegroup p m m n
wavelength 1.54056
content Si 32 O 64 N 2 C 48
pattern sapo.pow
%extraction
%fragment sapo_si.fra
%polyhedra
tetrahedron 1 1.6 0.2 0.2
tetrahedron 2 1.6 0.2 0.2
missing 1 2 Si tetrahedron 1.6 0.2 0.2
missing 1 2 Si tetrahedron 1.6 0.2 0.2
%continue
```

The file `sapo_si.fra` contains element and fractional coordinates of the two located
silicon cations:

```text
Si 1.17900 0.13400 0.11500
Si 0.98700 0.14200 0.11900
```

!!! note "Procedures no longer available"
    The peak labelling procedure (`%changelabel`) and the combination of Direct Methods
    with simulated annealing (`%sdirect`), described in the EXPO2014 documentation, are
    not available in the current version of EXPO.

## References

- Altomare, A., Giacovazzo, C., Guagliardi, A., Moliterni, A. G. G. & Rizzi, R.
  (2000). *J. Appl. Cryst.* **33**, 1305–1310.
  [doi:10.1107/S0021889800010852](https://doi.org/10.1107/S0021889800010852)
- Altomare, A., Giacovazzo, C., Ianigro, M., Moliterni, A. G. G. & Rizzi, R. (2002).
  *J. Appl. Cryst.* **35**, 21–27.
  [doi:10.1107/S0021889801016739](https://doi.org/10.1107/S0021889801016739)
- Altomare, A., Cuocci, C., Giacovazzo, C., Moliterni, A. G. G. & Rizzi, R. (2006).
  *J. Appl. Cryst.* **39**, 558–562.
  [doi:10.1107/S0021889806017912](https://doi.org/10.1107/S0021889806017912)
- Altomare, A., Cuocci, C., Giacovazzo, C., Kamel, G. S., Moliterni, A. & Rizzi, R.
  (2008a). *Acta Cryst.* A**64**, 326–336.
  [doi:10.1107/S0108767308004303](https://doi.org/10.1107/S0108767308004303)
- Altomare, A., Cuocci, C., Giacovazzo, C., Moliterni, A. & Rizzi, R. (2008b).
  *J. Appl. Cryst.* **41**, 592–599.
  [doi:10.1107/S0021889808011527](https://doi.org/10.1107/S0021889808011527)
- Altomare, A., Cuocci, C., Giacovazzo, C., Moliterni, A. & Rizzi, R. (2009).
  *Acta Cryst.* A**65**, 183–189.
  [doi:10.1107/S0108767309003687](https://doi.org/10.1107/S0108767309003687)
- Altomare, A., Cuocci, C., Giacovazzo, C., Moliterni, A. & Rizzi, R. (2010a).
  *J. Appl. Cryst.* **43**, 798–804.
  [doi:10.1107/S0021889810015499](https://doi.org/10.1107/S0021889810015499)
- Altomare, A., Cuocci, C., Giacovazzo, C., Moliterni, A. & Rizzi, R. (2010b).
  *Z. Kristallogr.* **225**, 548–551.
  [doi:10.1524/zkri.2010.1352](https://doi.org/10.1524/zkri.2010.1352)
- Burla, M. C., Camalli, M., Carrozzini, B., Cascarano, G. L., Giacovazzo, C.,
  Polidori, G. & Spagna, R. (2000). *Acta Cryst.* A**56**, 451–457.
  [doi:10.1107/S0108767300006966](https://doi.org/10.1107/S0108767300006966)
- Giacovazzo, C., Altomare, A., Cuocci, C., Moliterni, A. G. G. & Rizzi, R. (2002).
  *J. Appl. Cryst.* **35**, 422–429.
  [doi:10.1107/S0021889802006556](https://doi.org/10.1107/S0021889802006556)
- Giacovazzo, C. & Siliqi, D. (1997). *Acta Cryst.* A**53**, 789–798.
  [doi:10.1107/S0108767397009653](https://doi.org/10.1107/S0108767397009653)
- Main, P. (1978). *Acta Cryst.* A**34**, 31–38.
  [doi:10.1107/S0567739478000066](https://doi.org/10.1107/S0567739478000066)
- Main, P., Fiske, S. J., Hull, S. E., Lessinger, L., Germain, G., Declercq, J. P. &
  Woolfson, M. M. (1980). *MULTAN80. A System of Computer Programs for the Automatic
  Solution of Crystal Structures from X-ray Diffraction Data.* University of York,
  England.
- Ten Eyck, L. F. (1977). *Acta Cryst.* A**33**, 486–492.
  [doi:10.1107/S0567739477001211](https://doi.org/10.1107/S0567739477001211)
