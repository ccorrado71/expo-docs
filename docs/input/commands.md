# Commands

EXPO recognizes the following commands. Their directives, usually needed only to
activate non-default procedures, are described in the pages linked in the table.

## General commands

| Command | Description |
|---------|-------------|
| `%structure name` | name of the structure. The output file is `name.out`; if the command is omitted, the name of the input file is used |
| `%job caption` | caption printed in the output file |
| `%window` | the graphical window is used (default) |
| `%nowindow` | the graphical window is suppressed |
| `%automatic` | the procedures run with default values, without waiting for user interaction (e.g. in the [simulated annealing](../direct-space/directives.md)) |
| `%initialize` | initializes the program; the structure name is set from the input file if `%structure` does not follow |
| `%data` | experimental data and basic crystallographic information; see [The `%data` command](data.md) |
| `%continue` | runs with default settings all the remaining steps, from the last given command to the end. After `%data` it is equivalent to `%extraction`, `%normal`, `%invariants`, `%phase`, `%fourier`; with the `reflections` or `ref2` directives of `%data`, to `%normal`, `%invariants`, `%phase`, `%fourier` |
| `%fragment file.ext` | imports a structure model (`ext` = `cif`, `mol`, …) or generates a predefined fragment; see [`%fragment`](../direct-space/directives.md#the-fragment-command) |
| `%export file.ext` | exports data or results; see [`%export`](#the-export-command) |
| `%end` | end of the input file |

## Indexing

| Command | Description |
|---------|-------------|
| `%ntreor` | indexing by N-TREOR09; see [Indexing](../indexing.md) |
| `%dicvol` | indexing by DICVOL14 |
| `%mcmaille` | indexing by McMaille |

## Structure solution by Direct Methods

| Command | Description |
|---------|-------------|
| `%extraction` | [extraction of the integrated intensities](../direct-methods/extraction.md) |
| `%normal` | [normalization of the integrated intensities](../direct-methods/normalization.md) |
| `%patterson` | [Patterson map](../direct-methods/normalization.md#patterson-map) calculation |
| `%invariants` | [estimate of the structure invariants](../direct-methods/invariants.md) |
| `%phase` | [phasing by the tangent formula](../direct-methods/phasing.md) |
| `%fourier` | [Fourier map calculation and structure model optimization](../direct-methods/fourier.md) |
| `%alltrials` | the [ALLTRIALS](../direct-methods/index.md#exploring-all-the-trials-alltrials) procedure |
| `%random` | the [RAMM](../direct-methods/index.md#the-ramm-procedure) procedure |
| `%polyhedra` | completion of polyhedral structures by [POLPO1 and POLPO2](../direct-methods/fourier.md#polpo-completion-of-polyhedral-structures) |

## Structure solution by direct-space methods

| Command | Description |
|---------|-------------|
| `%sanneal` (or `%sannel`) | structure solution by [direct-space methods](../direct-space/index.md) |

## Refinement

| Command | Description |
|---------|-------------|
| `%rietveld` | [Rietveld refinement](../rietveld.md) of the structure model |

## Order of the commands

Commands must satisfy the following conditions:

- `%data` must be present;
- `%ntreor`, `%dicvol` and `%mcmaille` must follow `%data`;
- `%extraction` must follow `%data`;
- `%normal` must follow `%extraction`;
- `%invariants` must follow `%normal`;
- `%phase` must follow `%invariants`;
- `%fourier` must follow `%phase`;
- `%patterson` must follow `%normal`;
- `%sanneal` must follow `%data`;
- `%polyhedra` must follow `%extraction` and `%fragment`;
- `%rietveld` requires a structure model (e.g. from `%fragment` or from a structure
  solution).

## The `%export` command

`%export file.ext` writes a file at the point of the run where the command is given.
The type of file is chosen by the extension:

| Extension | Content |
|-----------|---------|
| `hkl` | reflections: *h k l*, *F*~obs~² and σ, in SHELX format |
| `fc` | reflections: *h k l*, *F*~obs~, *F*~calc~ and phase |
| `xy` | powder pattern profile |
| `bk` | background |
| `cif`, `xyz`, … | structure model, in the format given by the extension |

**Example 1.** Reflections and structure model are exported after the solution by
Direct Methods.

```text
%structure cime
%job structure cime
%data
pattern cime.dat
content S 4 C 40 N 24 H 64
wavelength 1.52904
cell 10.6986 18.8181 6.8246 90.000 111.284 90.000
spacegroup p 21/a
synchrotron
%continue
%export cime.hkl
%export cime.cif
```

**Example 2.** Reflections and structure model are exported after the solution by
direct-space methods.

```text
%structure paracetamol
%job paracetamol
%data
cell 7.100 9.380 11.708 90.0 97.42 90.0
spacegroup p 21/n
content C 32 O 8 N 4 H 36
pattern paracetamol.xy
wavelength 1.54056
%fragment paracetamol.mol
%sanneal
%export paracetamol.hkl
%export paracetamol.cif
```
