---
search:
  exclude: true
---

# Rietveld refinement: models and methods

!!! warning "Draft"
    This page is being written and is not yet linked from the documentation.

## Profile function

According to the Rietveld method (Rietveld, 1967, 1969), the intensity calculated at
the *i*-th point of the powder pattern (1 ≤ *i* ≤ *n*, where *n* is the number of
experimental points) is

$$
Y_i = b_i + S \sum_{k=1}^{m} I_k\, y_{ik}
\tag{1}
$$

where $b_i$ is the background, *S* is the scale factor of the phase, $y_{ik}$ is a
normalized profile function, $I_k$ is the intensity of the *k*-th Bragg reflection and
the sum runs over the *m* reflections contributing to point *i*. When more wavelengths
are present, typically Kα~1~ and Kα~2~, the sum also includes the reflections of the
second wavelength, with a fixed (not refined) intensity ratio. The second wavelength and
the ratio are given with the `wavelength` directive of [`%data`](input/data.md).

The intensity $I_k$ is

$$
I_k = M_k\, L_k\, |F_k|^2\, P_k
$$

where $M_k$ is the multiplicity, $L_k$ the Lorentz–polarization factor, $F_k$ the
structure factor and $P_k$ the preferred orientation correction.

When the sample is a mixture of $N_p$ phases, equation (1) becomes

$$
Y_i = b_i + \sum_{p=1}^{N_p} S_p \sum_{k=1}^{m} I_k^p\, y_{ik}^p
$$

where each phase contributes with its own scale factor $S_p$ and profile function
$y_{ik}^p$.

Three empirical profile functions are available.

### Pseudo-Voigt

$$
y(x) = \eta\, \frac{C_G^{1/2}}{\sqrt{\pi}\, H}\, e^{-C_G x^2}
     + (1 - \eta)\, \frac{C_L^{1/2}}{\pi H} \left( 1 + C_L x^2 \right)^{-1},
\qquad
x = \frac{2\theta_i - 2\theta_k}{H_k}
$$

where $\theta_i$ is the Bragg angle of the *i*-th point, $\theta_k$ the calculated Bragg
angle of the *k*-th reflection and $H_k$ the full width at half maximum (FWHM).
$C_G = 4 \ln 2$ and $C_L = 4$; $C_G^{1/2}/(\sqrt{\pi} H)$ and $C_L^{1/2}/(\pi H)$ are the
normalization factors of the Gaussian and Lorentzian functions, such that
$\int_{-\infty}^{\infty} y(x)\, dx = 1$.

This function is a simple approximation of the Voigt function, the convolution of a
Gaussian and a Lorentzian. The mixing parameter

$$
\eta = \eta_0 + \eta_1\, 2\theta + \eta_2\, (2\theta)^2 , \qquad 0 \le \eta \le 1
$$

is the fraction of the Gaussian component; $\eta_0$, $\eta_1$ and $\eta_2$ are refined.
The FWHM is described by the Caglioti formula (Caglioti *et al.*, 1958)

$$
H = \sqrt{U \tan^2\theta + V \tan\theta + W}
$$

where *U*, *V* and *W* are refined.

### Modified Thompson–Cox–Hastings pseudo-Voigt

In the pseudo-Voigt function of Thompson, Cox and Hastings (Thompson *et al.*, 1987) the
function is the same as above, but the mixing parameter η and the FWHM *H* are derived
from the FWHMs of the Lorentzian ($H_L$) and Gaussian ($H_G$) components by the series
expansions

$$
H = \left( \sum_{i=0}^{5} a_i\, H_G^{5-i}\, H_L^{i} \right)^{1/5} ,
\qquad
\eta = \sum_{i=1}^{3} b_i \left( \frac{H_L}{H} \right)^{i}
$$

with

$$
a_0 = 1, \; a_1 = 2.69269, \; a_2 = 2.42843, \; a_3 = 4.47163, \; a_4 = 0.07842, \; a_5 = 1
$$

$$
b_1 = 1.36603, \; b_2 = -0.47719, \; b_3 = 0.11116
$$

$H_G$ and $H_L$ are given by

$$
H_G = \sqrt{U \tan^2\theta + V \tan\theta + W + Z / \cos^2\theta} ,
\qquad
H_L = X / \cos\theta + Y \tan\theta
$$

The modification with respect to the original function is the broadening term *Z* in
the Gaussian component. The advantage of this formulation is its physical meaning: the
FWHM is separated into a Gaussian contribution, related to the instrumental broadening,
and a Lorentzian contribution, due to the sample. In particular, the refinable
parameters *X* and *Y* can be related to the crystallite size and to the microstrain,
respectively.

### Pearson VII (default)

$$
y(x) = \frac{\Gamma(\beta)}{\Gamma(\beta - 1/2)}\, \frac{C_P^{1/2}}{\sqrt{\pi}\, H}
       \left( 1 + C_P x^2 \right)^{-\beta} ,
\qquad
C_P = 4 \left( 2^{1/\beta} - 1 \right)
$$

where Γ is the gamma function and the first factor normalizes the function. The exponent
β depends on the Bragg angle,

$$
\beta = \beta_0 + \frac{\beta_1}{2\theta} + \frac{\beta_2}{(2\theta)^2}
$$

with $\beta_0$, $\beta_1$ and $\beta_2$ refined. Changing β, the profile varies
continuously from a Lorentzian (Cauchy) function (β = 1), through a modified Lorentzian
(β = 2), to a Gaussian (β → ∞). The FWHM is described by the Caglioti formula, as for
the pseudo-Voigt function.

## Peak asymmetry

The profile functions above are symmetric, while real peaks are asymmetric because of
instrumental effects. The asymmetry is corrected by multiplying the profile by the
semi-empirical function of Bérar & Baldinozzi (1993):

$$
A_{ik} = 1 + P_1(\theta_k)\, F_a(z) + P_2(\theta_k)\, F_b(z)
$$

where

$$
P_1(\theta_k) = \frac{A_0}{\tan\theta_k} + \frac{A_1}{\tan 2\theta_k} ,
\qquad
P_2(\theta_k) = \frac{B_0}{\tan\theta_k} + \frac{B_1}{\tan 2\theta_k}
$$

$$
F_a(z) = 2z\, e^{-z^2} ,
\qquad
F_b(z) = (8z^3 - 12z)\, e^{-z^2} ,
\qquad
z = \frac{\theta_i - \theta_k - S}{H_k}
$$

and $A_0$, $A_1$, $B_0$, $B_1$ are refined.

## Preferred orientation

The preferred orientation correction $P_k$ is computed with the March–Dollase function
(Dollase, 1986):

$$
P_k = \frac{1}{N} \sum_{i=1}^{N} \left( G^2 \cos^2\phi_k^i + \frac{1}{G} \sin^2\phi_k^i \right)^{-3/2}
$$

where $\phi_k$ is the angle between the reciprocal lattice vector $\mathbf{d}_k^*$ of
reflection *k* and the reciprocal lattice vector parallel to the preferred orientation
axis. The sum runs over the *N* symmetry-equivalent reflections, since the angle can be
different for each of them. *G* is refined.

## Line-shift corrections

The peak positions are affected by systematic errors due to zero shift, sample
displacement and sample transparency. In Bragg–Brentano geometry the shift due to the
sample displacement *s* is

$$
\Delta 2\theta_s = -\frac{2s \cos\theta}{R} = S \cos\theta
$$

where *R* is the goniometer radius and the shift is in radians; the refined parameter is
$S = -2s/R$. The transparency correction is

$$
\Delta 2\theta_t = \frac{1}{2\mu R} \sin 2\theta = T \sin 2\theta
$$

where μ is the linear absorption coefficient of the sample; the shift is in radians and
the refined parameter is $T = 1/(2\mu R)$. The observed Bragg angle is related to the
one calculated from the cell parameters by

$$
2\theta_{obs} = 2\theta_{calc} + \Delta 2\theta ,
\qquad
\Delta 2\theta = S \cos\theta + T \sin 2\theta + Z
$$

where the constant *Z* is the zero shift.

## Background

The background $b_i$ can be described by the following functions of the diffraction
angle $2\theta_i$.

**Polynomial**, with origin $2\theta_0$ and at most 12 refined coefficients $B_j$:

$$
b_i = \sum_{j=1}^{m} B_j \left( \frac{2\theta_i}{2\theta_0} - 1 \right)^{j-1}
$$

**Chebyshev polynomial**, with at most 36 refined coefficients:

$$
b_i = \sum_{j=1}^{m} B_j\, T_{j-1}(x) ,
\qquad
x = \frac{2 (2\theta_i - 2\theta_{min})}{2\theta_{max} - 2\theta_{min}} - 1
$$

where $T_j(x)$ are the Chebyshev polynomials, orthogonal on −1 ≤ *x* ≤ 1 and defined
by the recurrence

$$
T_0(x) = 1 , \qquad T_1(x) = x , \qquad T_{n+1}(x) = 2x\, T_n(x) - T_{n-1}(x)
$$

**Cosine Fourier series**, with at most 12 terms:

$$
b_i = \sum_{j=1}^{m} B_j \cos\left[ (j-1)\, 2\theta_i \right]
$$

A starting background is computed from points located in the regions of the pattern
without peaks, and the number of coefficients is chosen automatically as the one giving
the best fit of these points. Background points and number of coefficients can be
changed in the graphical interface. Cubic spline, Bézier spline and filter backgrounds
are also available.

## Least-squares procedure

The Rietveld refinement minimizes, by non-linear least squares, the differences between
observed and calculated profiles:

$$
\chi^2 = \sum_{i=1}^{N} w_i \left[ y_{i,obs} - y_{i,calc} \right]^2
$$

where $y_{i,obs}$ is the intensity measured at point *i*, $w_i$ its weight and
$y_{i,calc}$ the intensity calculated by equation (1). When the only source of error is
counting statistics, $w_i = 1/y_{i,obs}$.

$y_{i,calc}$ is a non-linear function of the unknown parameters $x_1, x_2, \dots, x_m$:

$$
y_{1,calc} = M_1(x_1, \dots, x_m), \quad
y_{2,calc} = M_2(x_1, \dots, x_m), \quad \dots, \quad
y_{N,calc} = M_N(x_1, \dots, x_m)
$$

Following chapter 3 of *The Rietveld Method* (Young, 1993), the problem can be written in
matrix form:

$$
\chi^2 = \left[ \mathbf{y} - \mathbf{M}(\mathbf{x}) \right]^T \mathbf{W} \left[ \mathbf{y} - \mathbf{M}(\mathbf{x}) \right]
$$

where $\mathbf{y}$ is the vector of the observations $y_{1,obs}, \dots, y_{N,obs}$ and
$\mathbf{W}$ the diagonal matrix of the weights $w_1, \dots, w_N$. For a linear model,
$\mathbf{M}(\mathbf{x}) = \mathbf{A}\mathbf{x} + \mathbf{b}$, the parameters $\mathbf{x}$
minimizing χ² are the solution of the normal equations

$$
\mathbf{A}^T \mathbf{W} \mathbf{A}\, \mathbf{x} = \mathbf{A}^T \mathbf{W} (\mathbf{y} - \mathbf{b})
$$

The Rietveld model is non-linear, but the same approach can be applied iteratively,
starting from a point $\mathbf{x}_0$ close enough to the minimum. The first derivative
of $\mathbf{M}(\mathbf{x})$ is the Jacobian matrix

$$
J(\mathbf{x})_{ij} = \frac{\partial M_i(\mathbf{x})}{\partial x_j} ,
\qquad 1 \le i \le N, \; 1 \le j \le m
$$

and expanding the model around $\mathbf{x}_0$ to first order:

$$
\mathbf{M}(\mathbf{x}) \approx \mathbf{M}(\mathbf{x}_0) + \mathbf{J}(\mathbf{x}_0)(\mathbf{x} - \mathbf{x}_0)
$$

At each iteration of the Gauss–Newton algorithm:

1. the search direction $\mathbf{d}$ is computed as the solution of the linear system
   $\mathbf{J}^T \mathbf{W} \mathbf{J}\, \mathbf{d} = \mathbf{J}^T \mathbf{W} \left[ \mathbf{y} - \mathbf{M}(\mathbf{x}_c) \right]$;
2. the current point is updated, $\mathbf{x}_c \leftarrow \mathbf{x}_c + \mathbf{d}$;
3. if convergence is not reached, the procedure returns to step 1.

To guarantee convergence for strongly non-linear problems, or when the starting point is
far from the minimum, EXPO uses the Gauss–Newton method with a line search: in step 2
the update is $\mathbf{x}_c \leftarrow \mathbf{x}_c + \alpha \mathbf{d}$, where the step
length α is chosen so that χ² decreases,
$\chi^2(\mathbf{x}_c + \alpha \mathbf{d}) < \chi^2(\mathbf{x}_c)$, by a backtracking
line search based on cubic interpolation (Dennis & Schnabel, 1983). The linear system of
step 1 is solved by Cholesky decomposition of the normal matrix
$\mathbf{J}^T \mathbf{W} \mathbf{J}$, and convergence is tested at each iteration on the
gradient,
$\mathbf{J}(\mathbf{x})^T \mathbf{W} \left[ \mathbf{y} - \mathbf{M}(\mathbf{x}) \right] \approx \mathbf{0}$,
and on the search direction, $\mathbf{d} \approx \mathbf{0}$.

## Quantitative phase analysis

The weight fractions of the phases of a mixture are computed from the refined scale
factors (Hill & Howard, 1987):

$$
W_i = \frac{S_i Z_i M_i V_i}{\sum_j S_j Z_j M_j V_j}
\tag{2}
$$

where $W_i$ is the weight fraction of phase *i*, $S_i$ its refined scale factor, $Z_i$
the number of formula units per cell, $M_i$ the mass of the formula unit and $V_i$ the
cell volume. The cell mass $Z_i M_i$ and volume $V_i$ are computed from the atomic
weights, the refined cell parameters and the site occupancies.

When the phases have very different linear absorption coefficients μ, microabsorption
affects the accuracy of the quantitative analysis. Following Brindley (1945), equation
(2) is corrected as (Taylor & Matulis, 1991)

$$
W_i = \frac{S_i Z_i M_i V_i / \tau_i}{\sum_j S_j Z_j M_j V_j / \tau_j}
$$

where $\tau_i$ is the *particle absorption factor* of phase *i*:

$$
\tau_i = \frac{1}{A_i} \int_0^{A_i} \exp\left[ -(\mu_i - \overline{\mu})\, x \right] dA_i
$$

$A_i$ is the particle volume of phase *i*, $\mu_i$ its linear absorption coefficient,
$\overline{\mu}$ the mean linear absorption coefficient of the mixture and *x* the path
length of the radiation in a particle of phase *i* of volume $dA_i$. Brindley solved this
expression numerically and tabulated the results (Table V of his paper) as a function of
$(\mu_i - \overline{\mu}) R_i$, where $R_i$ is the effective particle radius.

The correction requires $\overline{\mu}$ and $R_i$. $\overline{\mu}$ is easily computed
from an approximate composition of the sample, so $R_i$ is the only real unknown. It can
be estimated, for example, by SEM or by laser diffraction particle size analysis. The
model assumes spherical particles of identical size. The particle sizes, in micrometres,
are given in the graphical interface or with the `radius` directive of the `%crystal`
command. They refer to the particle (grain) size, not to the smaller size of the
crystalline domains forming the particles, which can be estimated by the Scherrer
equation.

The microabsorption must be within the range of applicability of the Brindley model.
Brindley classified powders by the value of μ*R*: fine (μ*R* < 0.01), medium
(0.01 < μ*R* < 0.1), coarse (0.1 < μ*R* < 1) and very coarse (μ*R* > 1). The correction
applies to medium powders, and may also work for coarse ones; for fine powders
absorption is negligible and no correction is needed. Microabsorption can therefore be
reduced by grinding the sample into the fine-powder range. When the Brindley model is
applied, the output file reports the particle absorption factor and the coarseness of
the powder for each phase.

## References

- Bérar, J.-F. & Baldinozzi, G. (1993). *J. Appl. Cryst.* **26**, 128–129.
  [doi:10.1107/S0021889892009725](https://doi.org/10.1107/S0021889892009725)
- Brindley, G. W. (1945). *Philos. Mag.* **36**, 347–369.
  [doi:10.1080/14786444508520918](https://doi.org/10.1080/14786444508520918)
- Caglioti, G., Paoletti, A. & Ricci, F. P. (1958). *Nucl. Instrum.* **3**, 223–228.
  [doi:10.1016/0369-643X(58)90029-X](https://doi.org/10.1016/0369-643X%2858%2990029-X)
- Dennis, J. E. & Schnabel, R. B. (1983). *Numerical Methods for Unconstrained
  Optimization and Nonlinear Equations.* Englewood Cliffs, NJ: Prentice Hall.
- Dollase, W. A. (1986). *J. Appl. Cryst.* **19**, 267–272.
  [doi:10.1107/S0021889886089458](https://doi.org/10.1107/S0021889886089458)
- Hill, R. J. & Howard, C. J. (1987). *J. Appl. Cryst.* **20**, 467–474.
  [doi:10.1107/S0021889887086199](https://doi.org/10.1107/S0021889887086199)
- Rietveld, H. M. (1967). *Acta Cryst.* **22**, 151–152.
  [doi:10.1107/S0365110X67000234](https://doi.org/10.1107/S0365110X67000234)
- Rietveld, H. M. (1969). *J. Appl. Cryst.* **2**, 65–71.
  [doi:10.1107/S0021889869006558](https://doi.org/10.1107/S0021889869006558)
- Taylor, J. C. & Matulis, C. E. (1991). *J. Appl. Cryst.* **24**, 14–17.
  [doi:10.1107/S002188989000841X](https://doi.org/10.1107/S002188989000841X)
- Thompson, P., Cox, D. E. & Hastings, J. B. (1987). *J. Appl. Cryst.* **20**, 79–83.
  [doi:10.1107/S0021889887087090](https://doi.org/10.1107/S0021889887087090)
- Young, R. A. (1993). *The Rietveld Method.* Oxford: IUCr/Oxford University Press.
