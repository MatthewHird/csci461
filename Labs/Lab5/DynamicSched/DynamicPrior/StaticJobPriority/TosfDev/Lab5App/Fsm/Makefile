# Makefile to drive fsm translation  
# By: pwalsh

# P Walsh Sept 2017 

# Targets 
#   translate   translate *.mmt to *.pm
#   tidy 

# directory where scripts are located and temp file
MM=../../Tosf/Mmt

MMTSRC = $(wildcard *.mmt)
MMTBNAME = $(basename $(MMTSRC))
MMTDEST = $(addsuffix .pm, $(MMTBNAME))

%pm: %mmt
	@rm -f ./$@
	@m4 -I $(MM)/bin $< | $(INDENT)  > $@

translate: $(MMTDEST) 

clean:
	@rm -f *.pm *.ERR

bats:
