FPGA-SoC-Linux-Example-1-ZYBO
=============================

FPGA-SoC-Linux example(1) binary and project and test code for ZYBO

### Requirement

* Board: ZYBO
* OS:
   + ~~[FPGA-SoC-Linux](https://github.com/ikwzm/FPGA-SoC-Linux.git)~~
   + [FPGA-SoC-Debian12](https://github.com/ikwzm/FPGA-SoC-Debian12.git)
   + [FPGA-SoC-Debian13](https://github.com/ikwzm/FPGA-SoC-Debian13.git)

## Install

### Install python3-numpy

```console
shell# apt-get install python3-numpy
```

### Download FPGA-SoC-Linux-Example-1-ZYBO

```console
shell$ git clone https://github.com/ikwzm/FPGA-SoC-Linux-Example-1-ZYBO
shell$ cd FPGA-SoC-Linux-Example-1-ZYBO
```

### Install to FPGA and Device Tree

```console
shell# rake install
cp pump_axi4.bin /lib/firmware/pump_axi4.bin
dtbocfg.rb --install uio_irq_sample --dts uio_irq_sample.dts
<stdin>:22.13-27.20: Warning (unit_address_vs_reg): /fragment@1/__overlay__/pump-uio: node has a reg or ranges property, but no unit name
<stdin>:9.13-41.4: Warning (avoid_unnecessary_addr_size): /fragment@1: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" property
[ 1143.068664] fpga_manager fpga0: writing pump_axi4.bin to Xilinx Zynq FPGA Manager
[ 1143.232954] OF: overlay: WARNING: memory leak will occur if overlay removed, property: /axi/fpga-region0/firmware-name
[ 1143.299169] fclkcfg axi:fclk0: driver version : 1.9.0
[ 1143.314873] fclkcfg axi:fclk0: device name    : axi:fclk0
[ 1143.320385] fclkcfg axi:fclk0: clock  name    : fclk0
[ 1143.331002] fclkcfg axi:fclk0: clock  rate    : 100000000
[ 1143.336566] fclkcfg axi:fclk0: clock  enabled : 1
[ 1143.341299] fclkcfg axi:fclk0: driver installed.
[ 1143.366381] u-dma-buf udmabuf4: driver version = 5.3.0
[ 1143.371573] u-dma-buf udmabuf4: major number   = 243
[ 1143.380207] u-dma-buf udmabuf4: minor number   = 0
[ 1143.385210] u-dma-buf udmabuf4: phys address   = 0x1f100000
[ 1143.390816] u-dma-buf udmabuf4: buffer size    = 1048576
[ 1143.404653] u-dma-buf axi:pump-udmabuf4: driver installed.
[ 1143.417652] u-dma-buf udmabuf5: driver version = 5.3.0
[ 1143.422860] u-dma-buf udmabuf5: major number   = 243
[ 1143.427836] u-dma-buf udmabuf5: minor number   = 1
[ 1143.432672] u-dma-buf udmabuf5: phys address   = 0x1f200000
[ 1143.438253] u-dma-buf udmabuf5: buffer size    = 1048576
[ 1143.443609] u-dma-buf axi:pump-udmabuf5: driver installed.
```

## Run sample1 or sample2

### Compile sample1 or sample2

```console
shell# rake sample1 sample2
gcc -D_GNU_SOURCE -o sample1 sample1.c
gcc -D_GNU_SOURCE -o sample2 sample2.c
```

### Run sample1

```console
shell# ./sample1
elapsed_time = 5.758937 [msec]
elapsed_time = 5.755854 [msec]
elapsed_time = 5.756241 [msec]
elapsed_time = 5.749429 [msec]
elapsed_time = 5.755294 [msec]
elapsed_time = 5.751010 [msec]
elapsed_time = 5.704143 [msec]
elapsed_time = 5.737004 [msec]
elapsed_time = 5.763220 [msec]
elapsed_time = 5.777380 [msec]
```

### Run sample2

```console
shell$ ./sample2
elapsed_time = 5.778912 [msec]
elapsed_time = 5.769755 [msec]
elapsed_time = 5.779885 [msec]
elapsed_time = 5.759435 [msec]
elapsed_time = 5.758414 [msec]
elapsed_time = 5.772045 [msec]
elapsed_time = 5.766845 [msec]
elapsed_time = 5.764512 [msec]
elapsed_time = 5.713613 [msec]
elapsed_time = 5.776623 [msec]
```

## Run sample.py

```console
shell# python3 sample.py
elapsed_time:6.027[msec]
elapsed_time:5.909[msec]
elapsed_time:5.863[msec]
elapsed_time:5.837[msec]
elapsed_time:5.843[msec]
elapsed_time:5.87[msec]
elapsed_time:5.834[msec]
elapsed_time:5.863[msec]
elapsed_time:5.852[msec]
average_time:5.878[msec]
thougput    :178.404[MByte/sec]
udmabuf4 == udmabuf5 : OK
```

## Uninstall

```console
shell# rake uninstall
dtbocfg.rb --remove uio_irq_sample
[ 1155.739557] u-dma-buf axi:pump-udmabuf5: driver removed.
[ 1155.745975] u-dma-buf axi:pump-udmabuf4: driver removed.
[ 1155.755643] fclkcfg axi:fclk0: driver removed.
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
