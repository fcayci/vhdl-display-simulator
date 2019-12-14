# author: Furkan Cayci, 2018
# description:
#   add ghdl to your PATH for simulation

CC = ghdl
ARCHNAME = tb_display
STOPTIME = 100ms

VHDL_SOURCES = $(wildcard rtl/*.vhd)
TBS = $(wildcard tb/tb_*.vhd)
TB = tb/$(ARCHNAME).vhd
WORKDIR = debug
CFLAGS = --ieee=synopsys

.PHONY: all
all: check analyze
	@echo ">>> completed..."

.PHONY: check
check:
	@echo ">>> check syntax on all designs..."
	@$(CC) -s $(CFLAGS) $(VHDL_SOURCES) $(TBS)

.PHONY: analyze
analyze:
	@echo ">>> analyzing designs..."
	@mkdir -p $(WORKDIR)
	@$(CC) -a --workdir=$(WORKDIR) $(CFLAGS) $(VHDL_SOURCES) $(TBS)

.PHONY: simulate
simulate: clean analyze
	@echo ">>> creating rgb file for:" $(TB)
	@$(CC) --elab-run --workdir=$(WORKDIR) $(CFLAGS) \
		-o $(WORKDIR)/$(ARCHNAME).bin $(ARCHNAME) \
		--stop-time=$(STOPTIME)

.PHONY: clean
clean:
	@echo ">>> cleaning design..."
	@ghdl --remove --workdir=$(WORKDIR)
	@rm -f $(WORKDIR)/*
	@rm -rf $(WORKDIR)
	@echo ">>> done..."