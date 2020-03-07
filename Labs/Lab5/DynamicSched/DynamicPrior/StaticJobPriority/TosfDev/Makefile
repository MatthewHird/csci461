# Makefile to manage the complete tosf project
# P Walsh Jan 2018

# Targets
#   clean --- clean all modules
#   tidy --- indent code in all modules 
#   runtest --- run bats in all modules

MODULES=Tosf \
	goldApp\
	tlightApp\
	miscApp\
	traceApp\

clean:
	@for m in $(MODULES); do \
		#((cd $$m; $(MAKE) clean;) > /dev/null) \
		(cd $$m; $(MAKE) clean;) \
	done

tidy:
	@for m in $(MODULES); do \
		((cd $$m; $(MAKE) tidy;) > /dev/null 2>&1) \
	done


runtest:
	@for m in $(MODULES); do \
		(cd $$m; $(MAKE) runtest;) \
	done
