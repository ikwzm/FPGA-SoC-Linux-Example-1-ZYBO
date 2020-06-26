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
shell$ git clone https://github.com/ikwzm/FPGA-SoC-Linux-Example-1-ZYBO
shell$ cd FPGA-SoC-Linux-Example-1-ZYBO
```

### Install to FPGA and Device Tree

```
shell# rake install
cp pump_axi4.bin /lib/firmware/pump_axi4.bin
dtbocfg.rb --install uio_irq_sample --dts uio_irq_sample.dts
<stdin>:22.13-27.20: Warning (unit_address_vs_reg): /fragment@1/__overlay__/pump-uio: node has a reg or ranges property, but no unit name
<stdin>:9.13-41.4: Warning (avoid_unnecessary_addr_size): /fragment@1: unnecessary #address-cells/#size-cells without "ranges" or child "reg" property
[  712.822208] fpga_manager fpga0: writing pump_axi4.bin to Xilinx Zynq FPGA Manager
[  712.867038] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /amba/fpga-region0/firmware-name
[  712.881097] fclkcfg amba:fclk0: driver installed.
[  712.885809] fclkcfg amba:fclk0: device name    : amba:fclk0
[  712.891989] fclkcfg amba:fclk0: clock  name    : fclk0
[  712.897132] fclkcfg amba:fclk0: clock  rate    : 100000000
[  712.902684] fclkcfg amba:fclk0: clock  enabled : 1
[  712.914833] u-dma-buf udmabuf4: driver version = 3.0.1
[  712.924993] u-dma-buf udmabuf4: major number   = 242
[  712.930088] u-dma-buf udmabuf4: minor number   = 0
[  712.934879] u-dma-buf udmabuf4: phys address   = 0x1f100000
[  712.940506] u-dma-buf udmabuf4: buffer size    = 1048576
[  712.945814] u-dma-buf udmabuf4: dma device     = amba:pump-udmabuf4
[  712.952119] u-dma-buf udmabuf4: dma coherent   = 1
[  712.956908] u-dma-buf amba:pump-udmabuf4: driver installed.
[  712.970810] u-dma-buf udmabuf5: driver version = 3.0.1
[  712.975963] u-dma-buf udmabuf5: major number   = 242
[  712.981042] u-dma-buf udmabuf5: minor number   = 1
[  712.985830] u-dma-buf udmabuf5: phys address   = 0x1f200000
[  712.991452] u-dma-buf udmabuf5: buffer size    = 1048576
[  712.996757] u-dma-buf udmabuf5: dma device     = amba:pump-udmabuf5
[  713.003061] u-dma-buf udmabuf5: dma coherent   = 1
[  713.007850] u-dma-buf amba:pump-udmabuf5: driver installed.
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
dtbocfg.rb --remove uio_irq_sample
[  779.549516] u-dma-buf amba:pump-udmabuf5: driver removed.
[  779.556223] u-dma-buf amba:pump-udmabuf4: driver removed.
[  779.565252] fclkcfg amba:fclk0: driver unloaded
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
