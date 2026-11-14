# Preparing the input file

The EXPO input file (extension `.exp`) can be created with the EXPO graphical interface
(**File → New Project**) or with any text editor. It contains:

- **commands**: lines beginning with the `%` character, each activating a step or a
  strategy of the solution process;
- **directives**: the lines that follow a command, providing its parameters and
  options. A directive always refers to the command that precedes it.

Each step of the solution process is associated with a command and its directives.
Default strategies are activated by the command alone; directives are used to supply
information or to choose non-default strategies.

This section describes:

- the structure and syntax of the input file (this page);
- the [list of commands](commands.md), with the rules on their order;
- the [`%data` command](data.md), which supplies the experimental data and the basic
  crystallographic information;
- the [structure files](structure-files.md) that EXPO can import and export.

The directives of the other commands are described in the sections of the corresponding
steps: [Indexing](../indexing.md), [Space group determination](../space-group.md),
[Direct Methods](../direct-methods/index.md) and
[Direct Space Methods](../direct-space/index.md).

## Required commands

The input file should contain at least two commands:

`%structure`
:   followed by a name (usually the name of the structure under investigation) that
    identifies the solution process. The output file is named after it
    (`name.out`). If `%structure` is omitted, the name of the input file is used.

`%data`
:   followed by the directives that give the minimum required information about the
    experimental powder diffraction data: the name of the data file, the wavelength and
    the type of radiation, when different from standard laboratory X-rays (see
    [The `%data` command](data.md)).

Further commands, with their directives, are added according to the tasks to perform.

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

The minimal input for a complete run, from indexing to the solution by Direct Methods,
is shown in [Tutorial 1](../tutorials.md#tutorial-1-cimetidine-direct-methods-default-run);
the minimal input for a solution by direct-space methods in
[Tutorial 3](../tutorials.md#tutorial-3-paracetamol-direct-space-methods).

## Syntax rules

- Commands and directives are written in free format, start at any position on the
  line and are **case-insensitive** (`%data`, `%Data` and `%DATA` are equivalent).
  Tabs are treated as blanks.
- Commands can be **abbreviated** to their first letters, provided that at least three
  letters are given and the abbreviation is not ambiguous (e.g. `%cont` for
  `%continue`).
- Text written on the same line as a command, after the command name, is read as its
  first directive (e.g. `%structure nbpo`, `%fragment paracetamol.mol`).
- Lines beginning with `!`, `#` or `>` are **comments** and are ignored; text after a
  `!` on any line is ignored too.
- Blank lines are ignored.
- A directive placed before the first command, or an unknown command, stops the
  reading of the input file with an error message.
