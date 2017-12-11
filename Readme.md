FPGA-SoC-Linux-Example-1-ZYBO
=============================

FPGA-SoC-Linux example(1) binary and project and test code for ZYBO

### Requirement

* Board: ZYBO
* OS: [FPGA-SoC-Linux](https://github.com/ikwzm/FPGA-SoC-Linux.git)

## Install

### Download FPGA-SoC-Linux-Example-1-ZYBO

```
shell$ git clone FPGA-SoC-Linux-Example-1-ZYBO
shell$ cd FPGA-SoC-Linux-Example-1-ZYBO
```

### Install to FPGA and Device Tree

```
shell$ rake install
```

## Run sample1 or sample2

### Compile sample1 or sample2

```
shell$ rake sample1 sample2
```

### Run sample1

```
shell$ ./sample1
```

### Run sample2

```
shell$ ./sample1
```

## Run sample.py

```
shell$ python3 sample.py
```

## Uninstall

```
shell$ rake uninstall
```


## Build Bitstream file

### Requirement

* Vivado 2016.1 or 2016.2 or 2016.2.1

### Download FPGA-SoC-Linux-Example-1-Base

```
shell$ pushd FPGA-SoC-Linux-Example-1-Base
shell$ git submodule init
shell$ git submodule update
shell$ popd
```

### Create Project

```
Vivado > Tools > Run Tcl Script > project/create_project.tcl
```

### Implementation

```
Vivado > Tools > Run Tcl Script > project/implementation.tcl
```

### Convert from Bitstream File to Binary File

```
shell$ tools/fpga-bit-to-bin.py --flip project/project.run/impl_1/design_1_wrapper.bit pump_axi4.bin
```
