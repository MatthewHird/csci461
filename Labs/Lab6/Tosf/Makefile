# Makefile to manage tosf
# P Walsh Aug 2017

# Targets
#   clean --- clean all modules
#   tidy --- indent code in all modules 
#   runtest --- run bats in all modules
#   cover --- run cover in all modules

MODULES=Collection/Verification/Line \
	Collection/Verification/Queue \
	Collection/Verification/PQueue \
	Collection/Verification/STATUS \
	Demo/Verification/Lifo \
	Record/Verification/Semaphore \
	Record/Verification/SVar \
	Record/Verification/Task \
	Table/Verification/TASK \
	Table/Verification/QUEUE \
	Table/Verification/PQUEUE \
	Table/Verification/SEMAPHORE \
	Table/Verification/SVAR \
	Executive/Verification/DISPATCHER \
	Executive/Verification/SCHEDULER \
	Executive/Verification/TIMER \
	Exception/Verification/Trap \
	Exception/Verification/Monitor \
	Fsm/Verification/To \
	Fsm \

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
		(cd $$m; $(MAKE) bats;) \
	done

cover:
	@for m in $(MODULES); do \
		(cd $$m; $(MAKE) cover;) \
	done

