#!/usr/bin/perl
# This program auto-generates Module Makefiles for the tosf projects
# P Walsh Jan 2016

sub buildMakeTargets {
   my $cut = shift @_;
   my $date = shift @_;
   my $whoami = shift @_;
   my $content;
   
   $content = "# Makefile to drive Perl modules \n"; 
   $content = $content . "# Date auto-generated: " . $date;
   $content = $content . "# By: " . $whoami . "\n";
   $content = $content . "# P Walsh Jan 2016 \n";
   $content = $content . "\n";
   $content = $content .  "# Targets \n";
   $content = $content . "#   bats --- make batch tester from tb.cew \n";
   $content = $content . "#   isobats --- make batch tester from tb.cew on CPU 0\n";
   $content = $content . "#   clean \n";
   $content = $content . "#   cover --- test coverage\n";
   $content = $content . "#   tidy --- indent code in .pl, .pm  and .cew files \n";
   $content = $content . "\n";
   $content = $content . "# directory where scripts are located and temp file\n";
   $content = $content . "SD=../../../../Tosf/Cew\n";
   $content = $content . "CUT=../../$cut\n";
   $content = $content . "MKF=../../Makefile\n";
   $content = $content . "\n";
   $content = $content . "# code beautifier \n";
   $content = $content . "INDENT=perltidy -i=3 \n";
   $content = $content . "\n";
   $content = $content . "bats: tb.pl translate\n";
   $content = $content . "\tperl tb.pl\n";
   $content = $content . "\n";
   $content = $content . "isobats: tb.pl translate\n";
   $content = $content . "\ttaskset 0x1 perl tb.pl \n";
   $content = $content . "\n";
   $content = $content . "translate: \n";
   $content = $content . "\t" . '@if [ -f $(MKF) ]; then ((cd ../../; $(MAKE) translate;) > /dev/null 2>&1)  fi' . "\n";
   $content = $content . "\n";
   $content = $content . "cover: tb.pl \n";
   $content = $content . "\t" . 'perl -MDevel::Cover tb.pl' . "\n";
   $content = $content . "\t" . '@cover -select $(CUT) -report text > $(CUT).cover' . "\n";
   $content = $content . "\t" . '@rm -r cover_db' .  "\n";
   $content = $content . "\n";
   $content = $content . "tb.pl: tb.cew \n";
   $content = $content . "\t" . '@rm -f $(SD)/tmp/tb.num' . "\n";
   $content = $content . "\t" . '@rm -f ./tb.pl' . "\n";
   $content = $content . "\t" . '@awk -f $(SD)/bin/addLineNums.awk tb.cew > $(SD)/tmp/tb.num' . "\n";
   $content = $content . "\t" . '@m4 -I $(SD)/bin $(SD)/tmp/tb.num  | $(INDENT) > tb.pl' . "\n";
   $content = $content . "\n";
   $content = $content . "tb.cew:\n";
   $content = $content . "\t" . '@cp $(SD)/Template/tb.cew .' . "\n";
   $content = $content . "\n";
   $content = $content . "clean:\n";
   $content = $content . "\t" . '@rm -f  $(SD)/tmp/* tb.pl $(CUT).cover *.cover $(CUT).tdy *.tdy *.ERR' . "\n";
   $content = $content . "\n";
   $content = $content . "tidy:\n";
   $content = $content . "\t" . '@$(INDENT) $(CUT) *.pl *.cew' . "\n";
   $content = $content . "\n";
}

sub makeMakefile{
   my $dir = shift @_;

   my @dirSegments = split('/', $dir);
   my $mod = $dirSegments[$#dirSegments] . ".pm";
   my $str = buildMakeTargets($mod, `date`, `whoami`);

   system("rm -f $dir/Makefile");
   open(FH, "> $dir/Makefile") || die "Cant open Makefile in $dir \n";
   print(FH $str);
   close(FH);
}

#=======================================================
makeMakefile('../Tosf/Demo/Verification/Lifo');
makeMakefile('../Tosf/Collection/Verification/Line');
makeMakefile('../Tosf/Collection/Verification/Queue');
makeMakefile('../Tosf/Collection/Verification/PQueue');
makeMakefile('../Tosf/Collection/Verification/STATUS');
makeMakefile('../Tosf/Record/Verification/Semaphore');
makeMakefile('../Tosf/Record/Verification/SVar');
makeMakefile('../Tosf/Record/Verification/Task');
makeMakefile('../Tosf/Record/Verification/Message');
makeMakefile('../Tosf/Table/Verification/QUEUE');
makeMakefile('../Tosf/Table/Verification/PQUEUE');
makeMakefile('../Tosf/Table/Verification/SEMAPHORE');
makeMakefile('../Tosf/Table/Verification/SVAR');
makeMakefile('../Tosf/Table/Verification/TASK');
makeMakefile('../Tosf/Table/Verification/MESSAGE');
makeMakefile('../Tosf/Widgit/Verification/Sensor');
makeMakefile('../Tosf/Widgit/Verification/Light');
makeMakefile('../Tosf/Executive/Verification/TIMER');
makeMakefile('../Tosf/Executive/Verification/DISPATCHER');
makeMakefile('../Tosf/Executive/Verification/SCHEDULER');
makeMakefile('../Tosf/Exception/Verification/Trap');
makeMakefile('../Tosf/Exception/Verification/Monitor');
makeMakefile('../Tosf/Fsm/Verification/To');
makeMakefile('../Tosf/Fsm/Verification/ATo');
#=======================================================
makeMakefile('../tlightApp/Fsm/Verification/CCON');
makeMakefile('../tlightApp/Fsm/Verification/CDISP');
makeMakefile('../tlightApp/Plant/Verification/MENU');
makeMakefile('../tlightApp/Plant/Verification/CCONTROL');
makeMakefile('../tlightApp/Plant/Verification/CLIGHTS');
#=======================================================
makeMakefile('../traceApp/Fsm/Verification/FOO');
makeMakefile('../traceApp/Fsm/Verification/BAR');
makeMakefile('../traceApp/Fsm/Verification/TOM');
makeMakefile('../traceApp/Fsm/Verification/JERRY');
makeMakefile('../traceApp/Fsm/Verification/PRODUCER');
makeMakefile('../traceApp/Fsm/Verification/CONSUMER');
makeMakefile('../traceApp/Plant/Verification/TRACE0');
makeMakefile('../traceApp/Plant/Verification/TRACE1');
makeMakefile('../traceApp/Plant/Verification/TRACE2');
makeMakefile('../traceApp/Plant/Verification/TRACE3');
#=======================================================
makeMakefile('../goldApp/Fsm/Verification/BPING');
makeMakefile('../goldApp/Fsm/Verification/GCLIENTCONTROL');
makeMakefile('../goldApp/Fsm/Verification/HOSTMANAGER');
makeMakefile('../goldApp/Fsm/Verification/TCLIENTCONTROL');
makeMakefile('../goldApp/Packet/Verification/Gold');
makeMakefile('../goldApp/Packet/Verification/Params');
makeMakefile('../goldApp/Plant/Verification/GCLIENTSETUP');
makeMakefile('../goldApp/Plant/Verification/HSETUP');
makeMakefile('../goldApp/Plant/Verification/LIGHTS');
makeMakefile('../goldApp/Plant/Verification/MENU');
makeMakefile('../goldApp/Plant/Verification/TCLIENTSETUP');
#=======================================================
makeMakefile('../miscApp/Fsm/Verification/CONN');
makeMakefile('../miscApp/Plant/Verification/MENU');
makeMakefile('../miscApp/Plant/Verification/LIGHTS');
makeMakefile('../miscApp/Plant/Verification/RTSETUP');
#=======================================================
