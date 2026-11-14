# Examples

The following examples show the solution of challenging structures by direct-space
methods. They are the supplementary material of the paper:

> Cuocci, C., Corriero, N., Dell'Aera, M., Falcicchio, A., Rizzi, R. & Altomare, A.
> (2022). Direct space approach in action: challenging structure solution of
> microcrystalline materials using the EXPO software. *Comput. Mater. Sci.* **210**,
> 111465. [doi:10.1016/j.commatsci.2022.111465](https://doi.org/10.1016/j.commatsci.2022.111465)

All the files can be [downloaded here](https://cnrbox.cnr.it/owncloud/index.php/s/IHEdvnHhrba5vio/download)
(zip archive). The folder names below refer to the content of the archive.

The directives used in the input files are described in
[Directives and restraints](directives.md).

## Example 1: diltiazem hydrochloride

CSD reference code
[CEYHUJ01](https://www.ccdc.cam.ac.uk/structures/Search?Ccdcid=CEYHUJ01). The powder
pattern `pd_0029.xy` is publicly available from the
[powder diffraction data collection](http://spider.science.strath.ac.uk/powderdata/Data.htm)
of the University of Strathclyde.

### Test 1: open ring

Folder `Example 1 – diltiazem hydrochloride/test1`:

| File | Content |
|------|---------|
| `diltia.exp` | input file; the starting model has the ring opened at the C4–C5 bond |
| `diltiazem_nw_break.mol` | starting model |
| `pd_0029.xy` | powder diffraction data |

```text
%Structure diltia
%Job CSD refcode: CEYHUJ01
%Data
Cell   42.190  9.075  6.037  90  90  90
SpaceGroup p 21 21 21
Pattern    pd_0029.xy
Wavelength 1.54056
%fragment diltiazem_nw_break.mol
%fragment atoms Cl
deletehydro
%sannel
nrun 100
niter 5000
```

### Test 2: open ring with a restraint

Folder `Example 1 – diltiazem hydrochloride/test2`: same files as test 1, with a
restraint on the C4–C5 bond to close the ring.

```text
%Structure diltia
%Job CSD refcode: CEYHUJ01
%Data
Cell 42.190 9.075 6.037 90 90 90
SpaceGroup p 21 21 21
Pattern pd_0029.xy
Wavelength 1.54056
%fragment diltiazem_nw_break.mol
%frag atoms Cl
deletehydro
%sannel
nrun 100
niter 1000
rest C4 C5
```

### Test 3: scan of conformers

Folder `Example 1 – diltiazem hydrochloride/test3/conformer_test`: the structure solution
is repeated for 100 conformers generated with [RDKit](https://www.rdkit.org/docs/).

| File | Content |
|------|---------|
| `scanconformers` | bash script that writes an input file for each conformer, runs the structure solution and collects the results |
| `diltia_templ` | template of the input file used by `scanconformers` |
| `molecules.txt` | list of the conformers to test |
| `diltia1.mol`, `diltia2.mol`, … | conformers in MOL format |

The conformers were generated with the Python script `rdk_confgen.py`, in the folder
`test3/conformer_generation` (a modified version of
[rdk_confgen](https://github.com/iwatobipen/rdk_confgen)). With RDKit and
[Open Babel](https://openbabel.org/) installed, run:

```bash
python3 rdk_confgen.py --input diltia_nw.mol --numconf 100
obabel gen_confs.sdf -O diltia1.mol -m
```

Open Babel splits the multi-molecule SDF file written by `rdk_confgen.py` into the
single files `diltia1.mol`, `diltia2.mol`, …

The script `scanconformers` is:

```bash
#!/bin/bash
filein=molecules.txt
template=diltia_templ
rm results.dat summary.dat *.expo *.bin *_best*.cif
c=`wc -l $filein | awk '{print $1}'`
for i in `seq 1 $c`;
do
a=`cat $filein | head -$i | tail -1`
file=${a%.*}
echo $file $template
sed "s%STRNAME%$file%" $template > "$file.exp"
#expo "$file.exp" "$file.out" --nogui
mpirun -np 20 -oversubscribe $HOME/expo/expo_mpi "$file.exp" "$file.out"
echo "============================================================" >> results.dat
echo "$file.out" >> results.dat
grep @@  "$file.out" | cut -c3-  >> results.dat
grep @@best  "$file.out" | cut -c3-  >> summary.dat
done
```

Make it executable (`chmod +x scanconformers`) and run it (`./scanconformers`). Before
running, adapt the `mpirun` line to the path of your EXPO executable and to the number of
cores to use (see [Parallel execution](parallel.md)); to use the serial version, replace
it with the commented `expo … --nogui` line.

The lines of the output files marked with `@@` are collected in `results.dat` and
`summary.dat`: at the end, `results.dat` contains a report to quickly identify the most
reasonable structure. For each conformer the script also produces:

- the output file (`.out`), with general information on the procedure;
- the CIF files of the solutions found;
- the project file (`.expo`), to inspect the models: load it with
  **File → Load Project**, select **Solve → Simulated Annealing** and click
  **Solutions**.

## Example 2: tetracycline hydrochloride

CSD reference code
[XAYCAB](https://www.ccdc.cam.ac.uk/structures/Search?Ccdcid=XAYCAB). Folder
`Example 2 – tetracycline hydrochloride`: the structure solution is repeated for 300
conformers generated with RDKit.

| File | Content |
|------|---------|
| `scanconformers` | bash script that writes an input file for each conformer, runs the structure solution and collects the results |
| `aldx_templ` | template of the input file used by `scanconformers` |
| `molecules.txt` | list of the conformers to test |
| `aldx1.mol`, `aldx2.mol`, … | conformers in MOL format, generated with `rdk_confgen.py` |
| `aldx.dat` | powder diffraction data |

The files are used as in [Example 1, test 3](#test-3-scan-of-conformers).

## Example 3: selexipag form I

CSD reference code
[VOHVIA](https://www.ccdc.cam.ac.uk/structures/Search?Ccdcid=VOHVIA). Folder
`Example 3 – selexipag`:

| File | Content |
|------|---------|
| `selexipag.exp` | input file |
| `selexipag_mopac.mol` | starting model, optimized with MOPAC |
| `VOHVIA.cif` | CIF file with the powder diffraction data |

Two molecules are imported (*Z*′ = 2), and the resolution is limited to 2.5 Å:

```text
%structure selexipag
%job CSD refcode: VOHVIA
%data
pattern VOHVIA.cif
synchrotron
cell 37.96347 6.110426 22.47454 90 98.3273 90
space P21/c
%fragment selexipag_mopac.mol
%fragment selexipag_mopac.mol
deletehydro
%sannel
nrun 100
niter 2000
resm 2.5
```

## Example 4: ALPO-M

CSD reference code
[RAMXUZ](https://www.ccdc.cam.ac.uk/structures/Search?Ccdcid=RAMXUZ). Folder
`Example 4 – ALPO-M`:

| File | Content |
|------|---------|
| `alpo.exp` | input file |
| `alpo.xy` | synchrotron powder diffraction data |

The model is built from two PO~4~ tetrahedra, isolated Al and O atoms and two
ethanolamine molecules from SMILES strings. The dynamical occupancy correction is
applied to all atoms except those of the organic molecules and the oxygen atoms O10 and
O11, and the preferred orientation along [0 1 0] is refined:

```text
%structure alpo
%job AlPO-M L.B. McCusker - SLS data - (CSD refcode: RAMXUZ)
%data
pattern alpo.xy
cell 9.7493 29.1668 9.3528 90. 90. 90.
space p b c a
wave 0.9187
synchrotron
%frag tetra P O
%frag tetra P O
%frag atoms Al2O
%frag smiles C(CO)N
%frag smiles C(CO)N
deletehydro
%sannel
nrun 100
niter 3000
doc
nodoc C* N* O10 O11
po 0 1 0
```

## Example 5: calcium glycinate trihydrate

CSD reference code
[ZINXAX](https://www.ccdc.cam.ac.uk/structures/Search?Ccdcid=ZINXAX). Folder
`Example 5 – calcium glycinate trihydrate`:

| File | Content |
|------|---------|
| `cagly.exp` | input file |
| `sk3493Isup2.rtv` | powder diffraction data |

Two glycinate ions are built from SMILES strings, and one displacement parameter is
refined for each molecule (`refinetf` is a synonym of `optimadp`):

```text
%job calcium glycinate trihydrate (CSD refcode: ZINXAX)
%structure cagly
%data
pattern sk3493Isup2.rtv
cell 9.6572 9.6878 5.7627 90.588 76.997 97.467
space P-1
wave 1.540560
%frag smiles C(C(=O)[O-])N
%frag smiles C(C(=O)[O-])N
%frag atoms CaO3
deletehydro
%sannel
nrun 100
niter 20000
refinetf molecules
```

## Example 6: LaTi~2~Al~9~O~19~

ICSD 262089. Folder `Example 6 – LaTi2Al9O19`:

| File | Content |
|------|---------|
| `LaTi.exp` | input file |
| `hw5019Isup2.rtv` | powder diffraction data |

The model of this inorganic compound is built only from polyhedra and an isolated La
atom, with the dynamical occupancy correction:

```text
%job La Ti2 Al9 O19 (ICSD 262089)
%structure LaTi
%data
pattern hw5019Isup2.rtv
cell 22.59355 10.99919 9.72968 90 98.5634 90
space C2/c
wave 1.54059
%fragment atoms La
%fragment octa Ti O
%fragment octa Ti O
%fragment tetra Al O
%fragment tetra Al O
%fragment octa Al O
%fragment octa Al O
%fragment octa Al O
%fragment octa Al O
%fragment octa Al O
%fragment octa Al O
%fragment octa Al O
%fragment octa Al O
%sannel
nrun 100
doc
```
