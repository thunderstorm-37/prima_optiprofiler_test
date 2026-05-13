# prima_optiprofiler_test

This directory contains the report, codes and results of tests of PRIMA and OptiProfiler.
 The tests are conducted in MATLAB R2026a.
## Directory Structure

```text
prima_optiprofiler_test/
├── .gitignore
├── README.md
├── ZhuHuatao.tex
├── ZhuHuatao.bbl
├── ZhuHuatao.pdf
├── ZhuHuatao.synctex.gz
├── reference.bib
├── codes/
│   ├── optiprofiler_prima/
│   │   ├── test1.m
│   │   └── test2.m
│   └── prima_rosenbrock/
│       ├── prima_rosenbrock.m
│       └── prima_rosenbrock_results.mat
└── results/
    ├── optiprofiler_example/
    │   ├── solver1_solver2_fminsearch_u_2_5_noisy_0.001_mixed_gaussian/
    │   ├── solver1_solver2_u_1_2_plain/
    │   ├── solver1_solver2_u_3_4_noisy_0.001_mixed_gaussian/
    │   ├── solver_1_solver_2_solver_3_u_1_2_plain/
    │   └── summary.pdf
    ├── optiprofiler_prima/
    │   ├── prima_double_prima_quadruple_ubln_2_20_0_10_noisy/
    │   ├── prima_double_prima_quadruple_ubln_2_20_0_10_plain/
    │   ├── prima_double_prima_single_ubln_2_20_0_10_noisy/
    │   ├── prima_double_prima_single_ubln_2_20_0_10_plain/
    │   └── summary.pdf
    └── prima_rosenbrock_results/
        └── prima_rosenbrock_results.mat
```

## Contents

- `ZhuHuatao.pdf`: The report of the tests.
- `ZhuHuatao.tex`: The LaTeX source of the report.
- `reference.bib`: BibTeX reference file.
- `codes/`: MATLAB scripts used to run experiments.
- `results/`: Generated OptiProfiler profiles, summaries, logs, and saved MATLAB data.

To compile the report, you can run the following command in the terminal:
```bash
latexmk -xelatex ZhuHuatao.tex
```

## Experimental Procedure

The configuration process for PRIMA and OptiProfiler is described in `ZhuHuatao.pdf`.

### Rosenbrock Function Test

Change the directory to `path/to/prima_optiprofiler_test/codes/prima_rosenbrock/`, and run 
```matlab
prima_rosenbrock(n)
```
in MATLAB command window, where $n$ is the dimension of the problem that you want to test. The results will be saved in `prima_rosenbrock_results.mat`.

### OptiProfiler Example Test

Change the directory to `path/to/prima_optiprofiler_test/codes/optiprofiler_prima/`, and run 
```matlab
example1; example2; example3; example4;
```
in MATLAB command window. The generated profiles, summaries and logs will be saved in `./out`.

### OptiProfiler PRIMA Test

Change the directory to `path/to/prima_optiprofiler_test/codes/optiprofiler_prima/`. Run 
```matlab
test1;
```
to compare the performance of PRIMA with double precision and PRIMA with single precision. Run 
```matlab
test2;
``` 
to compare the performance of PRIMA with double precision and PRIMA with quadruple precision. The generated profiles, summaries and logs will be saved in `./out`.
