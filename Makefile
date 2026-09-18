TOP       = top
SOURCES   = top.sv
TESTBENCH = top_tb.sv
PCF       = iceBlinkPico.pcf
BUILD     = build

.PHONY: all prog sim wave clean

all: $(BUILD)/$(TOP).bin

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/$(TOP).json: $(SOURCES) | $(BUILD)
	yosys -p "synth_ice40 -top $(TOP) -json $@" $(SOURCES)

$(BUILD)/$(TOP).asc: $(BUILD)/$(TOP).json $(PCF)
	nextpnr-ice40 --up5k --package sg48 --json $< --pcf $(PCF) --asc $@

$(BUILD)/$(TOP).bin: $(BUILD)/$(TOP).asc
	icepack $< $@

prog: $(BUILD)/$(TOP).bin
	dfu-util --device 1d50:6146 --alt 0 -D $< -R

sim: $(BUILD)/sim.out
	cd $(BUILD) && vvp sim.out

$(BUILD)/sim.out: $(TESTBENCH) $(SOURCES) | $(BUILD)
	iverilog -g2012 -o $@ $(TESTBENCH)

wave: sim
	gtkwave $(BUILD)/$(TOP).vcd &

clean:
	rm -rf $(BUILD)
