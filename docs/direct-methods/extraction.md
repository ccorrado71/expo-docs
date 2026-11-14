# Extraction of the integrated intensities

*Command: `%extraction`*

The extraction step decomposes the measured powder pattern to obtain the integrated
intensity of each reflection (Altomare *et al.*, 1995); the experimental structure
factor moduli are derived from these intensities. EXPO uses the Le Bail algorithm
(Le Bail *et al.*, 1988), combined with a least-squares procedure that minimizes

$$
\sum_i w_i \,(y_{oi} - y_{ci})^2 , \qquad w_i = \frac{1}{y_{oi}}
$$

where the sum runs over all the data points, $y_{oi}$ and $y_{ci}$ are the observed and
calculated intensities at the $i$-th step, and

$$
y_{ci} = s \sum_{\mathbf{h}} LP_{\mathbf{h}}\, m_{\mathbf{h}}\, |F_{\mathbf{h}}|^2\,
P(2\theta_i - 2\theta_{\mathbf{h}})\, A(2\theta_i - 2\theta_{\mathbf{h}}) + y_{bi}
$$

The sum over $\mathbf{h}$ includes the Bragg reflections close to the $i$-th step, and:

| Symbol | Meaning |
|--------|---------|
| $s$ | scale factor |
| $LP_{\mathbf{h}}$ | Lorentz–polarization factor |
| $m_{\mathbf{h}}$ | reflection multiplicity |
| $F_{\mathbf{h}}$ | structure factor |
| $P$ | profile function |
| $A$ | asymmetry function |
| $y_{bi}$ | background intensity at the $i$-th step |

The background is estimated automatically and described by the polynomial (Young, 1993)

$$
y_{bi} = \sum_{m=0} bkg_m \left[ \frac{2\theta_i}{2\theta_M} - 1 \right]^m
$$

where the degree $m$ is chosen automatically as the one giving the best fit of the
background interpolation points.

A standard reference peak is selected automatically from the pattern; its fitting gives
the starting values of the variables refined by least squares. The pattern is then
divided automatically into intervals, and the parameters refined in each interval are
used in the final full-pattern fitting.

## Profile functions

The following profile functions are available:

| Function | Expression |
|----------|------------|
| Pearson VII (default) | $\dfrac{\Gamma(\beta_{\mathbf{h}})}{\Gamma(\beta_{\mathbf{h}} - 0.5)} \left(\dfrac{C_2}{\pi}\right)^{1/2} \dfrac{2}{H_{\mathbf{h}}} \left(1 + 4 C_2 X_{i\mathbf{h}}^2\right)^{-\beta_{\mathbf{h}}}$ |
| Gaussian | $\dfrac{C_0^{1/2}}{\sqrt{\pi}\, H_{\mathbf{h}}} \exp\left(-C_0 X_{i\mathbf{h}}^2\right)$ |
| Lorentzian | $\dfrac{C_1^{1/2}}{\pi H_{\mathbf{h}}} \left(1 + C_1 X_{i\mathbf{h}}^2\right)^{-1}$ |
| Pseudo-Voigt | $\eta\, \dfrac{C_1^{1/2}}{\pi H_{\mathbf{h}}} \left(1 + C_1 X_{i\mathbf{h}}^2\right)^{-1} + (1-\eta)\, \dfrac{C_0^{1/2}}{\sqrt{\pi}\, H_{\mathbf{h}}} \exp\left(-C_0 X_{i\mathbf{h}}^2\right)$ |

where

$$
C_0 = 4 \ln 2 , \qquad C_1 = 4 , \qquad C_2 = 2^{1/\beta_{\mathbf{h}}} - 1 , \qquad
X_{i\mathbf{h}} = \frac{2\theta_i - 2\theta_{\mathbf{h}}}{H_{\mathbf{h}}}
$$

$$
H_{\mathbf{h}} = \left[ w + v \tan\theta_{\mathbf{h}} + u \tan^2\theta_{\mathbf{h}} \right]^{1/2} ,
\qquad
H'_{\mathbf{h}} = Z \tan\theta_{\mathbf{h}} + T / \cos\theta_{\mathbf{h}}
$$

$$
\eta = \eta_0 + \eta_1 \tan\theta_{\mathbf{h}} + \eta_2 \tan^2\theta_{\mathbf{h}} ,
\qquad
\beta_{\mathbf{h}} = \beta_0 + \frac{\beta_1}{2\theta_{\mathbf{h}}} + \frac{\beta_2}{(2\theta_{\mathbf{h}})^2}
$$

The asymmetry function is, for the Pearson VII function,

$$
A(i, \mathbf{h}) = \frac{a\, (2\theta_i - 2\theta_{\mathbf{h}})^3}
{\left[ H_{\mathbf{h}}^2 / C_3 + (2\theta_i - 2\theta_{\mathbf{h}})^2 \right]^{3/2}} + 1
$$

and, for the other functions,

$$
A(i, \mathbf{h}) = 1 - \frac{a\, \mathrm{sign}(2\theta_i - 2\theta_{\mathbf{h}})\,
(2\theta_i - 2\theta_{\mathbf{h}})^2}{\tan\theta_{\mathbf{h}}}
$$

Peak shape, asymmetry, cell and background parameters are all refined.

## Directives

The following directives of `%extraction` activate non-default procedures:

| Directive | Description |
|-----------|-------------|
| `all` | choose the profile function (Pearson VII, Gaussian, Lorentzian or pseudo-Voigt) giving the best fit in each interval |
| `first` | choose the profile function giving the best fit of the first interval |
| `standard` | choose the profile function giving the best fit of the standard peak |
| `gaussian` | use the Gaussian function |
| `lorentzian` | use the Lorentzian function |
| `pvoigt` | use the pseudo-Voigt function |
| `interval n` | number of intervals into which the pattern is divided (maximum 8); give it only to change the automatic division |
| `ncycle n` | number of least-squares cycles for each interval (default 22, maximum 100) |
| `nosingle` | skip the preliminary fitting of the standard peak; the first interval is fitted instead |
| `lowb` | lower the background by a constant equal to the minimum observed count |
| `noba` | do not refine the background coefficients |
| `polynomial k` | fixed degree *k* (maximum 10) of the background polynomial in each interval, instead of the degree chosen automatically |
| `smoothing` | estimate the background by the smoothing procedure of Brückner (2000); the background coefficients are not refined |
| `nocell` | do not refine the cell parameters |
| `random p` | activate the random procedure (Altomare *et al.*, 2001) to improve the extracted structure factor moduli; *p* is the coefficient of the overlap condition (default 0.5) |
| `frecycle file.hkl` | start the Le Bail algorithm from the squared moduli in `file.hkl` (*h k l F²*), obtained from a previous EXPO run or any other source |
| `damping x` | damping factor of the least squares (default 0.1); small values are recommended |
| `width x` | factor that, multiplied by the FWHM of each peak, gives the total peak width (instead of the automatic value) |
| `zeroprofile x` | 2θ zero shift supplied by the user, used to correct the observed 2θ positions; its automatic calculation is skipped |
| `slow` | stop after the main calculations and wait for the user before going on (graphical interface only) |
| `verbose` | more detailed output: R~p~, R~wp~ and the refined variables are printed for each interval |

## Examples

**Example 1.** A pseudo-Voigt function is used, the background in each interval is a
constant, and the graphical window is suppressed.

```text
%nowindow
%structure mes
%job MES - data from home diffractometer
%data
pattern mes.pow
cell 8.588 9.931 11.105 90.0 93.754 90.0
content C 24 N 4 O 20 S 4 H 52
spacegroup p 21/c
wavelength 1.5406
%extraction
pvoigt
polynomial 0
%continue
```

**Example 2.** The starting values of the integrated intensities are read from the
file `yono.hkl`, and the number of least-squares cycles is set to 40.

```text
%structure yono
%job YONO - Synchrotron data
%data
pattern yono.pow
cell 9.385 16.394 3.627 90.000 101.067 90.000
content Y 8 O 26 N 2 H 18
spacegroup p 21
wavelength 1.2323
synchrotron
%extraction
frecycle yono.hkl
ncycle 40
%continue
```

**Example 3.** The preliminary fitting of the standard peak is skipped and a starting
2θ zero shift is supplied (it is then refined).

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
nosingle
zeroprofile 0.02
%continue
```

## References

- Altomare, A., Burla, M. C., Cascarano, G., Giacovazzo, C., Guagliardi, A.,
  Moliterni, A. G. G. & Polidori, G. (1995). *J. Appl. Cryst.* **28**, 842–846.
  [doi:10.1107/S0021889895005619](https://doi.org/10.1107/S0021889895005619)
- Altomare, A., Giacovazzo, C., Moliterni, A. G. G. & Rizzi, R. (2001).
  *J. Appl. Cryst.* **34**, 704–709.
  [doi:10.1107/S0021889801012729](https://doi.org/10.1107/S0021889801012729)
- Brückner, S. (2000). *J. Appl. Cryst.* **33**, 977–979.
  [doi:10.1107/S0021889800003617](https://doi.org/10.1107/S0021889800003617)
- Le Bail, A., Duroy, H. & Fourquet, J. L. (1988). *Mater. Res. Bull.* **23**, 447–452.
  [doi:10.1016/0025-5408(88)90019-0](https://doi.org/10.1016/0025-5408%2888%2990019-0)
- Young, R. A. (1993). *The Rietveld Method.* Oxford: IUCr/Oxford University Press.
