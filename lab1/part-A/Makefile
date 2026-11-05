#   make          compile and run the simulation
#   make wave     run the simulation and open the waveform in GTKWave
#   make surfer   run the simulation and open the waveform in Surfer
#   make lint     check the design with Verilator
#   make clean    remove generated files
#   make help     show the available targets

DESIGN    := LEDdecoder
TB        := $(DESIGN)_tb

SRCS      := $(DESIGN).v
TB_SRCS   := $(TB).v
INCDIRS   := .

BUILD     := .
SIM       := $(BUILD)/$(TB).vvp

# Must match $dumpfile(...) in the testbench
VCD       := LEDdecoder_tb.vcd

IVERILOG  := iverilog
VVP       := vvp
GTKWAVE   := gtkwave
SURFER    := surfer
VERILATOR := verilator

# Surfer state file (signals, layout), loaded with --state-file if it exists.
SURFER_STATE ?= waveforms.surf.ron

IVFLAGS   := -g2005 -Wall $(addprefix -I,$(INCDIRS)) -s $(TB)

.PHONY: all sim wave surfer lint clean help

all: sim

$(BUILD):
	mkdir -p $@

$(SIM): $(SRCS) $(TB_SRCS) $(wildcard *.vh) | $(BUILD)
	$(IVERILOG) $(IVFLAGS) -o $@ $(SRCS) $(TB_SRCS)

sim: $(SIM)
	$(VVP) -n $(SIM)

$(VCD): $(SIM)
	$(VVP) -n $(SIM)

wave: $(VCD)
	$(GTKWAVE) $(VCD) &

surfer: $(VCD)
	$(SURFER) $(if $(wildcard $(SURFER_STATE)),-s $(SURFER_STATE)) $(VCD) &

lint:
	$(VERILATOR) --lint-only -Wall -Wno-UNUSEDPARAM -Wno-SYMRSVDWORD $(addprefix -I,$(INCDIRS)) --top-module $(DESIGN) $(SRCS)

clean:
	rm -f $(SIM) *.vcd

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
	@echo "  clean           remove $(SIM) and the .vcd files"
	@echo "  help            show this message"
	@echo ""
	@echo "Variables:"
	@echo "  SURFER_STATE    Surfer state file (current: $(SURFER_STATE))"
