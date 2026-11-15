# EXPO Documentation

User documentation for **EXPO**, the software for crystal structure solution from powder
diffraction data developed at the [Institute of Crystallography (IC-CNR), Bari](https://www.ic.cnr.it/).

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](LICENSE)

📖 Online documentation: <https://ccorrado71.github.io/expo-docs/>

The site is built with [MkDocs](https://www.mkdocs.org/) and the
[Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme, and is deployed
automatically to GitHub Pages on every push to `main`. A PDF version of the manual can be
generated with `pandoc`.

## Repository structure

```
docs/                 Markdown sources of the documentation
docs/images/          images and icons
docs/javascripts/     MathJax configuration
mkdocs.yml            MkDocs configuration (site navigation, theme, extensions)
requirements.txt      Python dependencies for building the site
make_pdf.sh           script that generates the PDF manual
scripts/              make_download_page.py: download page and updates.json
.github/workflows/    GitHub Actions workflow for GitHub Pages deployment
```

## Building locally

```bash
pip install -r requirements.txt
mkdocs serve          # live preview at http://127.0.0.1:8000
mkdocs build          # static site in site/
```

## PDF manual

Requires `pandoc` and `xelatex` (package `texlive-xetex`):

```bash
bash make_pdf.sh      # generates expo_manual.pdf
```

When adding a new page, add it both to the `nav` section of `mkdocs.yml` and to the
`PAGES` list in `make_pdf.sh`.

## Releasing a new EXPO version

The EXPO packages are distributed through public links on cnrbox. The script
`scripts/make_download_page.py` creates the links and generates:

- `docs/download.md`, the download page;
- `docs/updates.json`, read by EXPO (**Help → Check for Updates**) to notify users of
  a new version. It is published at
  <https://ccorrado71.github.io/expo-docs/updates.json>: this URL is compiled into
  EXPO and must not change.

Steps:

1. copy the new packages to `~/cnrbox/software/expo_packages` and wait for the ownCloud
   client to upload them;
2. run `python3 scripts/make_download_page.py` (credentials in `~/.netrc`, see the
   script header);
3. regenerate the PDF manual and copy it into EXPO:
   `bash make_pdf.sh ~/expo2/share/expo/docs/expo_manual.pdf`;
4. commit and push `docs/download.md` and `docs/updates.json`.

## Citing EXPO

Altomare, A., Cuocci, C., Giacovazzo, C., Moliterni, A., Rizzi, R., Corriero, N. and Falcicchio, A.,
*'EXPO2013: a kit of tools for phasing crystal structures from powder data'* (2013).
*J. Appl. Cryst.* **46**, 1231–1235. <https://doi.org/10.1107/S0021889813013113>

## License

The documentation is distributed under the
[Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSE) license.
This license applies to the documentation only, not to the EXPO software.

## Contact

Institute of Crystallography – CNR, Bari — Corrado Cuocci ([corrado.cuocci@cnr.it](mailto:corrado.cuocci@cnr.it))
