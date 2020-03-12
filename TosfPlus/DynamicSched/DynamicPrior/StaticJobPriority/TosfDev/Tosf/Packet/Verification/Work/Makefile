# Makefile to drive Perl modules 
# Date auto-generated: Wed Apr 11 18:53:49 PDT 2018
# By: pwalsh

# P Walsh Jan 2016 

# Targets 
#   bats --- make batch tester from tb.cew 
#   clean 
#   cover --- test coverage
#   tidy --- indent code in .pl, .pm  and .cew files 

# directory where scripts are located and temp file
SD=../../../../Tosf/Cew
CUT=../../Generic.pm
MKF=../../Makefile

# code beautifier 
INDENT=perltidy -i=3 

bats: tb.pl translate
	perl tb.pl

translate: 
	@if [ -f $(MKF) ]; then ((cd ../../; $(MAKE) translate;) > /dev/null 2>&1)  fi

cover: tb.pl 
	perl -MDevel::Cover tb.pl
	@cover -select $(CUT) -report text > $(CUT).cover
	@rm -r cover_db

tb.pl: tb.cew 
	@rm -f $(SD)/tmp/tb.num
	@rm -f ./tb.pl
	@awk -f $(SD)/bin/addLineNums.awk tb.cew > $(SD)/tmp/tb.num
	@m4 -I $(SD)/bin $(SD)/tmp/tb.num  | $(INDENT) > tb.pl

tb.cew:
	@cp $(SD)/Template/tb.cew .

clean:
	@rm -f  $(SD)/tmp/* tb.pl $(CUT).cover *.cover $(CUT).tdy *.tdy *.ERR

tidy:
	@$(INDENT) $(CUT) *.pl *.cew

