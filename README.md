# MD on Google Colab

## Building/Installing GROMACS 2021 with GPU support on Google Colab
* Build takes around 65 minutes
* Pre-build binary and tutorial is available [here&rarr;](https://www.scientificreporters.com/tool/gromacs-installation-with-gpu.html)
## Installing NAMD on Google Colab
Use [Python script](Google-Colab-NAMD-GPU-2020.py) (can be copied to Colab Notebook Cell) file to execute code to build gromacs on google colab's ubuntu environment with GPU RunTime turned on.
## Installing Desmond on Google Colab
* Copy desmond installer to google drive and install desmond on every colab instance start

### Useful options

* ```-nb gpu``` : to run with GPU
* ```-noappend``` : ?
* ```-cpi CHECKPOINT_FROM_DEFFNAME``` : ?
* ```-maxh HOURS_IN_INT``` : Numbers of hours to execute, terminate yourself before colab terminates it to avoid loss of data or file corruptions

## Plotting Graphs in R and Python

* Python - Python based Utility has been moved to [separate repository](https://github.com/TheBiomics/GMXvg) with executable files
  - Bulk XVG file plotting and value extraction
* R - Directly plot using R
