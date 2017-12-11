FPGA-SoC-Linux-Example-1-ZYBO
=============================

FPGA-SoC-Linux example(1) binary and project and test code for ZYBO

### Requirement

* Board: ZYBO
* OS: [FPGA-SoC-Linux](https://github.com/ikwzm/FPGA-SoC-Linux.git)

## Install

### Install python3-numpy

```
shell# apt-get install python3-numpy
```

### Download FPGA-SoC-Linux-Example-1-ZYBO

```
shell$ git clone FPGA-SoC-Linux-Example-1-ZYBO
shell$ cd FPGA-SoC-Linux-Example-1-ZYBO
```

### Install to FPGA and Device Tree

```
shell# rake install
dtbocfg.rb --install uio_irq_sample --dts uio_irq_sample.dts
/config/device-tree/overlays/uio_irq_sample/dtbo: Warning (unit_a[  212.745565] fpga_manager fpga0: writing pump_axi4.bin to Xilinx Zynq FPGA Manager
ddress_vs_reg): Node /fragment@0 has a unit name, but no reg property
[  212.795237] udmabuf amba:fpga-region0:pump-udmabuf4: driver probe start.
[  212.808126] udmabuf udmabuf4: driver installed
[  212.814428] udmabuf udmabuf4: major number   = 245
[  212.819143] udmabuf udmabuf4: minor number   = 0
[  212.825395] udmabuf udmabuf4: phys address   = 0x1f100000
[  212.831566] udmabuf udmabuf4: buffer size    = 1048576
[  212.836627] udmabuf amba:fpga-region0:pump-udmabuf4: driver installed.
[  212.845412] udmabuf amba:fpga-region0:pump-udmabuf5: driver probe start.
[  212.859166] udmabuf udmabuf5: driver installed
[  212.864621] udmabuf udmabuf5: major number   = 245
[  212.869332] udmabuf udmabuf5: minor number   = 1
[  212.875630] udmabuf udmabuf5: phys address   = 0x1f200000
[  212.881889] udmabuf udmabuf5: buffer size    = 1048576
[  212.886945] udmabuf amba:fpga-region0:pump-udmabuf5: driver installed.
```

## Run sample1 or sample2

### Compile sample1 or sample2

```
shell# rake sample1 sample2
```

### Run sample1

```
shell# ./sample1
time = 0.005702 sec
time = 0.005685 sec
time = 0.005668 sec
time = 0.005681 sec
time = 0.005690 sec
time = 0.005677 sec
time = 0.005698 sec
time = 0.005707 sec
time = 0.005662 sec
time = 0.005692 sec
```

### Run sample2

```
shell$ ./sample2
time = 0.005713 sec
time = 0.005694 sec
time = 0.005688 sec
time = 0.005720 sec
time = 0.005708 sec
time = 0.005687 sec
time = 0.005693 sec
time = 0.005701 sec
time = 0.005723 sec
time = 0.005718 sec
```

## Run sample.py

```
shell# python3 sample.py
elapsed_time:5.912[msec]
elapsed_time:5.847[msec]
elapsed_time:5.833[msec]
elapsed_time:5.839[msec]
elapsed_time:5.826[msec]
elapsed_time:5.841[msec]
elapsed_time:5.832[msec]
elapsed_time:5.842[msec]
elapsed_time:5.84[msec]
average_time:5.846[msec]
thougput    :179.374[MByte/sec]
udmabuf4 == udmabuf5 : OK
```

## Uninstall

```
shell# rake uninstall
dtbocfg.rb --remove uio_irq_sample
[  476.886343] udmabuf udmabuf5: driver uninstalled
[  476.891485] udmabuf amba:fpga-region0:pump-udmabuf5: driver unloaded
[  476.899289] udmabuf udmabuf4: driver uninstalled
[  476.904421] udmabuf amba:fpga-region0:pump-udmabuf4: driver unloaded
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
