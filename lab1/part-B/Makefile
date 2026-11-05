#   make          compile and run the simulation
#   make wave     run the simulation and open the waveform in GTKWave
#   make surfer   run the simulation and open the waveform in Surfer
#   make lint     check the design with Verilator
#   make fsm      compile and run the MessageFSM testbench
#   make fsm-wave    same, and open the waveform in GTKWave
#   make fsm-surfer  same, and open the waveform in Surfer
#   make clean    remove generated files
#   make help     show the available targets

DESIGN    := FourDigitLEDdriver
TB        := $(DESIGN)_tb

# Vivado
XILINX_VIVADO ?= $(patsubst %/bin/vivado,%,$(shell command -v vivado 2>/dev/null))
ifeq ($(strip $(XILINX_VIVADO)),)
$(error Vivado not found: add it to PATH or set XILINX_VIVADO)
endif
XILINX_SRC := $(XILINX_VIVADO)/data/verilog/src

# Xilinx simulation models for the MMCM primitive. glbl.v is the global
# set/reset module that every unisim model refers to.
XILINX_SRCS := $(XILINX_SRC)/unisims/MMCME2_BASE.v \
               $(XILINX_SRC)/unisims/MMCME2_ADV.v \
               $(XILINX_SRC)/glbl.v

SRCS      := $(DESIGN).v LEDdecoder.v
TB_SRCS   := $(TB).v
INCDIRS   := .

BUILD     := .
SIM       := $(BUILD)/$(TB).vvp

# Must match $dumpfile(...) in the testbench
VCD       := $(TB).vcd

# MessageFSM unit testbench. It needs neither the MMCM models nor glbl.
FSM_TB    := MessageFSM_tb
FSM_SRCS  := MessageFSM.v
FSM_TB_SRCS := $(FSM_TB).sv
FSM_SIM   := $(BUILD)/$(FSM_TB).vvp

# Must match $dumpfile(...) in MessageFSM_tb.sv
FSM_VCD   := $(FSM_TB).vcd

IVERILOG  := iverilog
VVP       := vvp
GTKWAVE   := gtkwave
SURFER    := surfer
VERILATOR := verilator

# Surfer state file (signals, layout), loaded with --state-file if it exists.
SURFER_STATE ?= waveforms.surf.ron

# -Ttyp silences the "Choosing typ expression" warnings of the MMCM model.
# glbl must be a second top-level module next to the testbench.
IVFLAGS   := -g2005 -Wall -Ttyp $(addprefix -I,$(INCDIRS)) -s $(TB) -s glbl
FSM_IVFLAGS := -g2012 -Wall $(addprefix -I,$(INCDIRS)) -s $(FSM_TB)

.PHONY: all sim wave surfer lint fsm fsm-wave fsm-surfer clean help

all: sim

$(BUILD):
	mkdir -p $@

$(SIM): $(SRCS) $(TB_SRCS) $(wildcard *.vh) | $(BUILD)
	$(IVERILOG) $(IVFLAGS) -o $@ $(SRCS) $(XILINX_SRCS) $(TB_SRCS)

sim: $(SIM)
	$(VVP) -n $(SIM)

$(VCD): $(SIM)
	$(VVP) -n $(SIM)

wave: $(VCD)
	$(GTKWAVE) $(VCD) &

surfer: $(VCD)
	$(SURFER) $(if $(wildcard $(SURFER_STATE)),-s $(SURFER_STATE)) $(VCD) &

# Verilator cannot parse the Xilinx MMCM model, so lint uses the black-box
# stub in lint/. PINCONNECTEMPTY is off because unused MMCM outputs are
# deliberately left unconnected.
lint:
	$(VERILATOR) --lint-only -Wall -Wno-UNUSEDPARAM -Wno-SYMRSVDWORD -Wno-PINCONNECTEMPTY $(addprefix -I,$(INCDIRS)) -y lint --top-module $(DESIGN) $(SRCS)

$(FSM_SIM): $(FSM_SRCS) $(FSM_TB_SRCS) $(wildcard *.vh) | $(BUILD)
	$(IVERILOG) $(FSM_IVFLAGS) -o $@ $(FSM_SRCS) $(FSM_TB_SRCS)

fsm: $(FSM_SIM)
	$(VVP) -n $(FSM_SIM)

$(FSM_VCD): $(FSM_SIM)
	$(VVP) -n $(FSM_SIM)

fsm-wave: $(FSM_VCD)
	$(GTKWAVE) $(FSM_VCD) &

fsm-surfer: $(FSM_VCD)
	$(SURFER) $(FSM_VCD) &

clean:
	rm -f $(SIM) $(FSM_SIM) *.vcd

help:
	@echo "ECE333 Lab 1 - $(DESIGN)"
	@echo ""
	@echo "Usage: make [target] [VAR=value]"
	@echo ""
	@echo "Targets:"
	@echo "  all             same as sim (default)"
	@echo "  sim             compile with iverilog and run the simulation"
	@echo "  wave            run the simulation and open $(VCD) in GTKWave"
	@echo "  surfer          run the simulation and open $(VCD) in Surfer"
	@echo "                  (loads $(SURFER_STATE) if it exists)"
	@echo "  lint            check the design with Verilator"
	@echo "  fsm             compile and run the $(FSM_TB) testbench"
	@echo "  fsm-wave        run $(FSM_TB) and open $(FSM_VCD) in GTKWave"
	@echo "  fsm-surfer      run $(FSM_TB) and open $(FSM_VCD) in Surfer"
	@echo "  clean           remove $(SIM), $(FSM_SIM) and the .vcd files"
	@echo "  help            show this message"
	@echo ""
	@echo "Variables:"
	@echo "  SURFER_STATE    Surfer state file (current: $(SURFER_STATE))"
	@echo "  XILINX_VIVADO   Vivado install dir (current: $(XILINX_VIVADO))"
