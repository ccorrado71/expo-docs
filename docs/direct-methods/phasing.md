# Phasing by the tangent formula

*Command: `%phase`*

In EXPO the most reliable one-phase structure seminvariants (s.s.) are treated as known
phases. Besides triplets, the most reliable negative quartets and two-phase s.s. can be
actively used. Each relationship is used with its own weight: the concentration
parameter of the first representation for quartets and two-phase s.s., and C or G for
triplets (see [Structure invariants](invariants.md)).

## Convergence and divergence

The convergence procedure (Germain *et al.*, 1970) defines an optimal starting set of
phases, to be expanded by the tangent formula or by other algorithms.

With the P10 formula (the default), a special convergence process chooses the starting
set according to (Giacovazzo, 1979; Burla *et al.*, 1987)

$$
\langle \alpha_{\mathbf{h}} \rangle = \sum_j \left[ G_j\, D_1(G_j) \right]
D_1\!\left( \langle \alpha_{\mathbf{h}-\mathbf{k}} \rangle \right),
\qquad
D_1(G_j) = \frac{I_1(G_j)}{I_0(G_j)}
$$

where $I_1$ and $I_0$ are the modified Bessel functions of order one and zero, and the
sum is over all the relationships involving the reflection $\mathbf{h}$. With the P3
formula the default is

$$
\langle \alpha_{\mathbf{h}} \rangle = \sum_j \left[ C_j\, D_1(C_j) \right]
$$

Once the starting set is defined, a good pathway for the phase expansion is determined
by a divergence procedure: starting from the reflections of the starting set, each new
reflection is linked to the preceding ones with the highest value of
$\langle \alpha \rangle$.

## Phase extension and refinement

The starting set usually consists of the origin (and enantiomorph) fixing reflections,
a few one-phase s.s. and other phases obtained:

1. by magic integer permutation (White & Woolfson, 1975; Main, 1978): the **default**;
2. by a random approach (Baggio *et al.*, 1978; Burla *et al.*, 1992), activated by the
   `random` directive. In this case a large number of trials (depending on the
   available computer time) can be requested.

The directives `symbols`, `specials` and `maxtrials` change the default values.

Phases are expanded and refined by a tangent formula using triplets, negative quartets,
psi-zero triplets and the most reliable two-phase s.s. In the weighting scheme the
experimental distributions of the α parameters are forced to match the theoretical
ones (Burla *et al.*, 1987).

For each phase set several figures of merit are computed, using all the invariants and
seminvariants estimated by the representation method, and combined into a highly
selective **combined figure of merit (CFOM)** (Cascarano *et al.*, 1987, 1992). All the
figures of merit, CFOM included, are expected to be 1.0 for correct solutions;
**CFOM larger than 0.5 is encouraging**. If pseudotranslational symmetry is present,
CFOM > 0.3 may characterize the correct solution.

## Directives

The following directives of `%phase` activate non-default procedures:

| Directive | Description |
|-----------|-------------|
| `enantiomorph n` | code of the reflection fixing the enantiomorph (by default chosen by EXPO) |
| `list n` | print the divergence map for the *n* reflections at its top (default: not printed) |
| `maxtrials n` | maximum number of trials with the random approach (default 100); only with `random` (see Example 1) |
| `minfom x n` | stop as soon as a solution with CFOM > *x* is found (default 1.00); *n* is the maximum number of phase sets with the largest CFOM to retain (default 20) (see Example 1) |
| `noreject` | retain equivalent sets of phases |
| `origin n(i) phi(i)` | codes and phases of the reflections fixing the origin (up to 3; by default chosen by EXPO) |
| `permute n(i)` | codes of the reflections to permute, included in the number of symbols (maximum 12) |
| `phase n(i) phi(i) wt(i)` | codes, phases and weights of reflections with known phase (maximum 200); repeat the directive on more lines if needed |
| `random n` | use random starting sets; *n* is the number of random phases (default: half of the strong reflections, *nstrong*; maximum *nstrong* − 4, minimum *nstrong*/4). The default seed of the random generator is 67543. Not compatible with `symbols` (see Example 1) |
| `specials n` | number of reflections with restricted phase to permute, included in the number of symbols (maximum 12) |
| `symbols n` | number of permuted phases (maximum 12). Default 5, or 7 when no element heavier than Cl is present. Not compatible with `random` |
| `table` | print the table of α values at the beginning of the phasing |
| `trial n` | print the final phases of trial *n* |
| `yneg` | actively use negative triplets in the phasing (by default they are not used) |

## Example

**Example 1.** A random approach is used, and the best 100 sets of phases out of 250
trials are retained.

```text
%structure nizr
%job nizr structure
%data
pattern nizr.pow
cell 12.388 8.9269 8.8449 90.0 90.550 90.0
content Zr 8 P 12 O 48 Ni 4
spacegroup p 21/n
wavelength 1.0302
synchrotron
%extraction
%normal
%invariants
%phase
random
maxtrials 250
minfom 1.0 100
%continue
```

## References

- Baggio, R., Woolfson, M. M., Declercq, J. P. & Germain, G. (1978). *Acta Cryst.*
  A**34**, 883–892.
  [doi:10.1107/S0567739478001837](https://doi.org/10.1107/S0567739478001837)
- Burla, M. C., Cascarano, G., Giacovazzo, C., Nunzi, A. & Polidori, G. (1987).
  *Acta Cryst.* A**43**, 370–374.
- Burla, M. C., Cascarano, G. & Giacovazzo, C. (1992). *Acta Cryst.* A**48**, 906–912.
  [doi:10.1107/S010876739200518X](https://doi.org/10.1107/S010876739200518X)
- Cascarano, G., Giacovazzo, C. & Viterbo, D. (1987). *Acta Cryst.* A**43**, 22–29.
  [doi:10.1107/S0108767387099963](https://doi.org/10.1107/S0108767387099963)
- Cascarano, G., Giacovazzo, C. & Guagliardi, A. (1992). *Acta Cryst.* A**48**,
  859–865.
  [doi:10.1107/S0108767392004240](https://doi.org/10.1107/S0108767392004240)
- Germain, G., Main, P. & Woolfson, M. M. (1970). *Acta Cryst.* B**26**, 274–285.
  [doi:10.1107/S056774087000225X](https://doi.org/10.1107/S056774087000225X)
- Giacovazzo, C. (1979). *Acta Cryst.* A**35**, 757–764.
  [doi:10.1107/S0567739479001741](https://doi.org/10.1107/S0567739479001741)
- Main, P. (1978). *Acta Cryst.* A**34**, 31–38.
  [doi:10.1107/S0567739478000066](https://doi.org/10.1107/S0567739478000066)
- White, P. S. & Woolfson, M. M. (1975). *Acta Cryst.* A**31**, 53–56.
  [doi:10.1107/S0567739475000095](https://doi.org/10.1107/S0567739475000095)
