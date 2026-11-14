# Normalization of the integrated intensities

*Command: `%normal`*

The integrated intensities are normalized by the Wilson method (Wilson, 1942). A
statistical analysis of the intensities is carried out to:

- suggest the presence or absence of an inversion centre;
- detect pseudotranslational symmetry and its type (Cascarano *et al.*, 1988a, 1988b;
  Fan *et al.*, 1988), including deviations of displacive type from the ideal
  pseudotranslational symmetry;
- detect preferred orientation effects (Altomare *et al.*, 1994, 1996).

The information on pseudo-symmetry can be used as prior information in a new
extraction of the integrated intensities.

## Directives

The following directives of `%normal` activate non-default procedures:

| Directive | Description |
|-----------|-------------|
| `bfactor x` | isotropic temperature factor supplied by the user (the scale factor is then assumed equal to 1) |
| `nopreferred` | do not apply the preferred orientation correction, even if preferred orientation is detected |
| `yespseudo` | use the pseudotranslational symmetry information in a new extraction (see Example 1) |
| `nreflections n` | number of active reflections with the largest \|E\| (minimum \|E\| = 1.0). Default: 4 × number of independent atoms, + 50 if centrosymmetric, + 50 if triclinic, + 150, up to a maximum of 499. With `pseudotranslation`, all the \|E\| down to 1.0 are used |
| `nzro n` | number of the smallest \|E\| (maximum 0.3) used to compute the psi-zero triplets, which enter the figures of merit of the phasing. Default and maximum: one third of the strong reflections |
| `npla n` | number of candidate planes for the preferred orientation analysis (default 10, maximum 30), including equivalent planes, which are not considered |
| `plane h k l G` | preferred orientation direction supplied by the user; *G* is the correction factor |
| `pseudotranslation n(1,1) n(2,1) n(3,1) n(4,1) n(1,2) … n(4,3)` | pseudotranslational symmetry; see below |
| `thrp x` | threshold of the mean fractional scattering power above which the pseudotranslational symmetry information is used in a new extraction |

### Pseudotranslational symmetry

If the parameters of `pseudotranslation` are zero or omitted, EXPO computes the
statistics of the pseudotranslation effects and renormalizes the reflections assuming
the most probable pseudotranslation as prior information.

To supply a specific pseudotranslation corresponding to one of the classes of
[Table 1](#table-1-classes-of-pseudotranslational-symmetry), give only its class number
as *n*(1,1). A more complex pseudotranslation is specified by up to 3 sets of 4 values
*n*(*i*,*j*), such that

$$
n(1,j)\,h + n(2,j)\,k + n(3,j)\,l = n(4,j)\,m , \qquad j = 1, \dots, 3
$$

where *m* is an integer.

## Patterson map

*Command: `%patterson`*

The Patterson map can be computed using the normalized (or non-normalized) structure
factor moduli as coefficients. With the `inverse` directive, the positivity of the
electron density in direct space is exploited in the extraction: the Patterson map is
modified and inverted, giving a set of structure factor moduli to be used in a new
extraction (Altomare *et al.*, 1998).

The following directives of `%patterson` activate non-default procedures:

| Directive | Description |
|-----------|-------------|
| `e*f` (or `f*e`) | coefficients of the Patterson synthesis (default `e**2`) |
| `f**2` (or `f*f`) | coefficients of the Patterson synthesis (default `e**2`) |
| `inverse` | compute the \|F\| values from an inverted, suitably modified Patterson map, and use them as starting values in the Le Bail extraction (see Example 2) |
| `map`, `layx`, `layy`, `layz`, `peaks`, `limits`, `grid` | as the corresponding directives of [`%fourier`](fourier.md#directives) |
| `npat n` | number of cycles of successive inversions of the Patterson map (default 6 for X-ray data, 5 for neutron data) |

## Examples

**Example 1.** The pseudotranslational symmetry, if present, is used as prior
information in a new extraction.

```text
%structure agpz
%job AGPZ - data from home diffractometer
%data
pattern agpz.pow
cell 6.526 20.059 6.464 90.000 90.000 90.000
spacegroup p b c a
content Ag 8 N 16 C 24 H 24
wavelength 1.54056
%extraction
%normal
yespseudo
%continue
```

**Example 2.** The inversion of the Patterson map is used as prior information in a new
extraction.

```text
%structure lasi
%job lasi - Neutron data
%data
pattern lasi.pow
cell 5.4059 8.7934 14.2754 90.000 112.731 90.00
content La 8 Si 8 O 8
spacegroup p 21/c
wavelength 2.3400
neutron
%extraction
%normal
%patterson
inverse
%continue
```

## Table 1. Classes of pseudotranslational symmetry

Classes of reflections corresponding to the low-index pseudotranslational symmetries.

| Class | Condition | Class | Condition | Class | Condition | Class | Condition |
|---|---|---|---|---|---|---|---|
| 1 | `h+k+l = 1n` | 2 | `h = 2n` | 3 | `k = 2n` | 4 | `l = 2n` |
| 5 | `h+k+l = 2n` | 6 | `h+k = 2n` | 7 | `h+l = 2n` | 8 | `k+l = 2n` |
| 9 | `h = 3n` | 10 | `k = 3n` | 11 | `l = 3n` | 12 | `h+k = 3n` |
| 13 | `h+l = 3n` | 14 | `k+l = 3n` | 15 | `h+k+l = 3n` | 16 | `h+k+2l = 3n` |
| 17 | `h+2k+l = 3n` | 18 | `2h+k+l = 3n` | 19 | `h+2k = 3n` | 20 | `h+2l = 3n` |
| 21 | `k+2l = 3n` | 22 | `l = 4n` | 23 | `k = 4n` | 24 | `h = 4n` |
| 25 | `h+k = 4n` | 26 | `h+l = 4n` | 27 | `k+l = 4n` | 28 | `h+k+l = 4n` |
| 29 | `2h+2k+l = 4n` | 30 | `2h+k+2l = 4n` | 31 | `h+2k+2l = 4n` | 32 | `2h+k+l = 4n` |
| 33 | `h+2k+l = 4n` | 34 | `h+k+2l = 4n` | 35 | `h+2k = 4n` | 36 | `h+2l = 4n` |
| 37 | `k+2l = 4n` | 38 | `2h+k = 4n` | 39 | `2h+l = 4n` | 40 | `2k+l = 4n` |
| 41 | `3h+3k+l = 4n` | 42 | `3h+k+3l = 4n` | 43 | `h+3k+3l = 4n` | 44 | `h+2k+3l = 4n` |
| 45 | `h+3k+2l = 4n` | 46 | `3h+k+2l = 4n` | 47 | `h+3k = 4n` | 48 | `h+3l = 4n` |
| 49 | `k+3l = 4n` | 50 | `3k+2l = 6n` | 51 | `2k+3l = 6n` | 52 | `2h+3k = 6n` |
| 53 | `3h+2k = 6n` | 54 | `3h+2l = 6n` | 55 | `2h+3l = 6n` | 56 | `2h+2k+3l = 6n` |
| 57 | `3h+2k+3l = 6n` | 58 | `3h+3k+2l = 6n` | 59 | `4k+3l = 12n` | 60 | `4h+3l = 12n` |
| 61 | `4h+3k = 12n` | 62 | `3k+4l = 12n` | 63 | `3h+4k = 12n` | 64 | `3h+4l = 12n` |
| 65 | `h = 2n & k = 2n` | 66 | `h = 2n & l = 2n` | 67 | `k = 2n & l = 2n` | 68 | `h = 2n & k+l = 2n` |
| 69 | `k = 2n & h+l = 2n` | 70 | `l = 2n & h+k = 2n` | 71 | `h+k = 2n & h+l = 2n` | 72 | `h = 2n & k = 2n & l = 2n` |

## References

- Altomare, A., Cascarano, G., Giacovazzo, C., Guagliardi, A., Burla, M. C.,
  Polidori, G. & Camalli, M. (1994). *J. Appl. Cryst.* **27**, 435.
  [doi:10.1107/S002188989400021X](https://doi.org/10.1107/S002188989400021X)
- Altomare, A., Burla, M. C., Cascarano, G., Giacovazzo, C., Guagliardi, A.,
  Moliterni, A. G. G. & Polidori, G. (1996). *J. Appl. Cryst.* **29**, 341–345.
  [doi:10.1107/S0021889896000271](https://doi.org/10.1107/S0021889896000271)
- Altomare, A., Foadi, J., Giacovazzo, C., Moliterni, A. G. G., Burla, M. C. &
  Polidori, G. (1998). *J. Appl. Cryst.* **31**, 74–77.
  [doi:10.1107/S002188989700945X](https://doi.org/10.1107/S002188989700945X)
- Cascarano, G., Giacovazzo, C. & Luić, M. (1988a). *Acta Cryst.* A**44**, 176–183.
- Cascarano, G., Giacovazzo, C. & Luić, M. (1988b). *Acta Cryst.* A**44**, 183–189.
- Fan, H., Yao, J. & Qian, J. (1988). *Acta Cryst.* A**44**, 688–691.
  [doi:10.1107/S0108767388004131](https://doi.org/10.1107/S0108767388004131)
- Wilson, A. J. C. (1942). *Nature* **150**, 152.
  [doi:10.1038/150152a0](https://doi.org/10.1038/150152a0)
