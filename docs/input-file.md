# Preparing the input file

The EXPO input file (extension `.exp`) can be created with the EXPO graphical interface
or with any text editor. It contains:

- **commands**: lines beginning with the `%` character, each activating a step or a
  strategy of the solution process;
- **directives**: the lines that follow a command, providing its parameters and
  options. A directive always refers to the command that precedes it.

Each step of the solution process is associated with a command and its directives.
Default strategies are activated by the command alone; directives are used to supply
information or to choose non-default strategies.

## Required commands

The input file should contain at least two commands:

`%structure`
:   followed by a name (usually the name of the structure under investigation) that
    identifies the solution process.

`%data`
:   followed by the directives that give the minimum required information about the
    experimental powder diffraction data: the name of the data file, the wavelength and
    the type of radiation, when different from standard laboratory X-rays.

Further commands, with their directives, are added according to the tasks to perform:
mainly [indexing](indexing.md), [space group determination](space-group.md), structure solution by [Direct Methods](direct-methods/index.md) or by
[direct-space methods](direct-space/index.md), and other non-default strategies.

## Example

The following input file performs, with default strategies, indexing, space group
determination and structure solution by Direct Methods:

```text
%structure nbpo
%job nbpo powder data
%data
pattern nbpo.pow
wavelength 1.0001
synchrotron
%ntreor
%continue
```

| Line                  | Meaning                                                       |
|-----------------------|---------------------------------------------------------------|
| `%structure nbpo`     | name of the structure                                         |
| `%job ...`            | title line printed in the output file                         |
| `%data`               | start of the data section                                     |
| `pattern nbpo.pow`    | name of the powder diffraction data file                      |
| `wavelength 1.0001`   | wavelength (Å)                                                |
| `synchrotron`         | data collected with synchrotron radiation                     |
| `%ntreor`             | indexing of the powder pattern                                |
| `%continue`           | all the remaining steps of the structure solution process     |

More examples, with their step-by-step execution, are in the [Tutorials](tutorials.md).

## Syntax rules

- Commands are **case-insensitive** (`%data`, `%Data` and `%DATA` are equivalent) and
  can be **abbreviated** to their first letters, provided that at least three letters
  are given and the abbreviation is not ambiguous (e.g. `%cont` for `%continue`).
- Text written on the same line as a command, after the command name, is read as its
  first directive (e.g. `%structure nbpo`, `%fragment paracetamol.mol`).
- Lines beginning with `!`, `#` or `>` are **comments** and are ignored; text after a
  `!` on any line is ignored too.
- Blank lines are ignored.
- A directive placed before the first command, or an unknown command, stops the
  reading of the input file with an error message.
