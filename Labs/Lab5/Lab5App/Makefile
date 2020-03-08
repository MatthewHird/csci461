# Makefile to manage traceApp
# P Walsh Aug 2017

# Targets
#   interactive
#   iso --- run on CPU 0
#   clean --- clean all modules
#   tidy --- indent code in all modules 
#   runtest --- run bats in all modules
#   cover --- run cover in all modules

MODULES=Fsm/Verification/FOO \
	Fsm \


#.SILENT:

interactive: main.pl translate
	-@(./main.pl)

save: main.pl translate
	-@(rm -f OUTFILE)
	-@(./main.pl < INFILE > OUTFILE)

nice: main.pl translate
	-@(nice -n -10 ./main.pl)


iso: main.pl translate
	taskset 0x1 perl main.pl

rt: main.pl translate
	(taskset -c 1,5 ./main.pl)

translate:
	-@((cd ./Fsm; $(MAKE) translate;) > /dev/null 2>&1 || true)

clean:
	-@for m in $(MODULES); do \
		#((cd $$m; $(MAKE) clean;) > /dev/null 2>&1 || true ) \
		(cd $$m; $(MAKE) clean;) \
	done

tidy:
	-@for m in $(MODULES); do \
		((cd $$m; $(MAKE) tidy;)  > /dev/null 2>&1 || true) \
	done


runtest:
	-@((cd ./Fsm; $(MAKE) translate;) > /dev/null 2>&1 || true)
	-@for m in $(MODULES); do \
		(cd $$m; $(MAKE) bats;) \
	done

cover:
	-@for m in $(MODULES); do \
		(cd $$m; $(MAKE) cover;) \
	done
