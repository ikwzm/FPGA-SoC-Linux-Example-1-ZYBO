################################################################
# Check if script is running in correct Vivado version.
################################################################
array set available_vivado_version_list {"2014.2"   "ok"}
array set available_vivado_version_list {"2014.3"   "ok"}
array set available_vivado_version_list {"2014.3.1" "ok"}
array set available_vivado_version_list {"2014.4"   "ok"}
array set available_vivado_version_list {"2015.1"   "ok"}
array set available_vivado_version_list {"2015.2"   "ok"}
array set available_vivado_version_list {"2015.3"   "ok"}
array set available_vivado_version_list {"2015.4"   "ok"}
array set available_vivado_version_list {"2016.1"   "ok"}
array set available_vivado_version_list {"2016.2"   "ok"}
array set available_vivado_version_list {"2016.3"   "ok"}
array set available_vivado_version_list {"2016.4"   "ok"}
array set available_vivado_version_list {"2017.1"   "ok"}
array set available_vivado_version_list {"2017.2"   "ok"}
array set available_vivado_version_list {"2017.2.1" "ok"}
set available_vivado_version [array names available_vivado_version_list]
set current_vivado_version   [version -short]

if { [string first [lindex [array get available_vivado_version_list $current_vivado_version] 1] "ok"] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$available_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$available_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z010clg400-1


# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}


# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} ne "" && ${cur_design} eq ${design_name} } {

   # Checks if design is empty or not
   if { $list_cells ne "" } {
      set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
      set nRet 1
   } else {
      puts "INFO: Constructing design in IPI design <$design_name>..."
   }
} elseif { ${cur_design} ne "" && ${cur_design} ne ${design_name} } {

   if { $list_cells eq "" } {
      puts "INFO: You have an empty design <${cur_design}>. Will go ahead and create design..."
   } else {
      set errMsg "ERROR: Design <${cur_design}> is not empty! Please do not source this script on non-empty designs."
      set nRet 1
   }
} else {

   if { [get_files -quiet ${design_name}.bd] eq "" } {
      puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

      create_bd_design $design_name

      puts "INFO: Making design <$design_name> as current_bd_design."
      current_bd_design $design_name

   } else {
      set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
      set nRet 3
   }

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set LED [ create_bd_port -dir O -from 3 -to 0 LED ]

  # Create instance: LED4_AXI_0, and set properties
  set LED4_AXI_0 [ create_bd_cell -type ip -vlnv ikwzm:pipework:LED4_AXI:1.0 LED4_AXI_0 ]

  # Create instance: axi_interconnect_acp, and set properties
  set axi_interconnect_acp [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_acp ]
  set_property -dict [ list CONFIG.M00_HAS_DATA_FIFO {2} CONFIG.M00_HAS_REGSLICE {1} CONFIG.NUM_MI {1} CONFIG.NUM_SI {3} CONFIG.S00_HAS_REGSLICE {1} CONFIG.S01_HAS_REGSLICE {1} CONFIG.S02_HAS_REGSLICE {1}  ] $axi_interconnect_acp

  # Create instance: axi_interconnect_csr, and set properties
  set axi_interconnect_csr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_csr ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # 
  set import_board_preset [file join [file dirname [info script]] "ZYBO_zynq_def.xml"]

  # Create instance: processing_system7_0, and set properties
  if { [string equal "2014.2"  [version -short] ] == 1 } {
    set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.4 processing_system7_0 ]
    set_property -dict [ list CONFIG.PCW_IMPORT_BOARD_PRESET $import_board_preset CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_USE_S_AXI_ACP {1} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125.0} ] $processing_system7_0
  }
  if { [string match "2014.[34]*" [version -short] ] == 1 } {
    set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
    set_property -dict [ list CONFIG.PCW_IMPORT_BOARD_PRESET $import_board_preset CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_USE_S_AXI_ACP {1} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125.0} ] $processing_system7_0
  }
  if { [string match "2015.[1234]*" [version -short] ] == 1 } {
    set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
    set_property -dict [ list CONFIG.PCW_IMPORT_BOARD_PRESET $import_board_preset CONFIG.PCW_IRQ_F2P_INTR {1} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_USE_S_AXI_ACP {1} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125.0} ] $processing_system7_0
  }

  # Create instance: pump_axi3_to_axi3_0, and set properties
  set pump_axi3_to_axi3_0 [ create_bd_cell -type ip -vlnv ikwzm:pipework:pump_axi3_to_axi3_v1_0:1.0 pump_axi3_to_axi3_0 ]
  set_property -dict [ list CONFIG.BUF_DEPTH {8} CONFIG.C_ADDR_WIDTH {12} CONFIG.C_ID_WIDTH {12} CONFIG.I_AUSER_WIDTH {5} CONFIG.I_DATA_WIDTH {64} CONFIG.I_ID_WIDTH {1} CONFIG.I_MAX_XFER_SIZE {7} CONFIG.M_AUSER_WIDTH {5} CONFIG.M_AXI_ID {0} CONFIG.M_DATA_WIDTH {64} CONFIG.M_ID_WIDTH {1} CONFIG.O_AUSER_WIDTH {5} CONFIG.O_AXI_ID {1} CONFIG.O_DATA_WIDTH {64} CONFIG.O_ID_WIDTH {1} CONFIG.O_MAX_XFER_SIZE {7}  ] $pump_axi3_to_axi3_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins LED4_AXI_0/CSR] [get_bd_intf_pins axi_interconnect_csr/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI1 [get_bd_intf_pins axi_interconnect_acp/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_ACP]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_csr/M01_AXI] [get_bd_intf_pins pump_axi3_to_axi3_0/CSR]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins axi_interconnect_csr/S00_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]
  connect_bd_intf_net -intf_net pump_axi3_to_axi3_0_FETCH [get_bd_intf_pins axi_interconnect_acp/S01_AXI] [get_bd_intf_pins pump_axi3_to_axi3_0/FETCH]
  connect_bd_intf_net -intf_net pump_axi3_to_axi3_0_INTAKE [get_bd_intf_pins axi_interconnect_acp/S00_AXI] [get_bd_intf_pins pump_axi3_to_axi3_0/INTAKE]
  connect_bd_intf_net -intf_net pump_axi3_to_axi3_0_OUTLET [get_bd_intf_pins axi_interconnect_acp/S02_AXI] [get_bd_intf_pins pump_axi3_to_axi3_0/OUTLET]

  # Create port connections
  connect_bd_net -net LED4_AXI_0_LED [get_bd_ports LED] [get_bd_pins LED4_AXI_0/LED]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_interconnect_acp/ARESETN] [get_bd_pins axi_interconnect_acp/M00_ARESETN] [get_bd_pins axi_interconnect_acp/S00_ARESETN] [get_bd_pins axi_interconnect_acp/S01_ARESETN] [get_bd_pins axi_interconnect_acp/S02_ARESETN] [get_bd_pins axi_interconnect_csr/ARESETN] [get_bd_pins axi_interconnect_csr/M00_ARESETN] [get_bd_pins axi_interconnect_csr/M01_ARESETN] [get_bd_pins axi_interconnect_csr/S00_ARESETN] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins LED4_AXI_0/ARESETn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins pump_axi3_to_axi3_0/ARESETn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins LED4_AXI_0/ACLOCK] [get_bd_pins axi_interconnect_acp/ACLK] [get_bd_pins axi_interconnect_acp/M00_ACLK] [get_bd_pins axi_interconnect_acp/S00_ACLK] [get_bd_pins axi_interconnect_acp/S01_ACLK] [get_bd_pins axi_interconnect_acp/S02_ACLK] [get_bd_pins axi_interconnect_csr/ACLK] [get_bd_pins axi_interconnect_csr/M00_ACLK] [get_bd_pins axi_interconnect_csr/M01_ACLK] [get_bd_pins axi_interconnect_csr/S00_ACLK] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_ACP_ACLK] [get_bd_pins pump_axi3_to_axi3_0/C_CLK] [get_bd_pins pump_axi3_to_axi3_0/I_CLK] [get_bd_pins pump_axi3_to_axi3_0/M_CLK] [get_bd_pins pump_axi3_to_axi3_0/O_CLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net pump_axi3_to_axi3_0_IRQ [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins pump_axi3_to_axi3_0/IRQ]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs LED4_AXI_0/CSR/CSR] SEG_LED4_AXI_0_CSR
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs pump_axi3_to_axi3_0/C/reg0] SEG_pump_axi3_to_axi3_0_reg0
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces pump_axi3_to_axi3_0/I] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_DDR_LOWOCM] SEG_processing_system7_0_ACP_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces pump_axi3_to_axi3_0/M] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_DDR_LOWOCM] SEG_processing_system7_0_ACP_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces pump_axi3_to_axi3_0/O] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_DDR_LOWOCM] SEG_processing_system7_0_ACP_DDR_LOWOCM
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


