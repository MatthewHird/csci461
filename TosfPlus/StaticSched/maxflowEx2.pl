#!/usr/bin/perl

# Cycle Executive Example 2 
# Peter Walsh csci 461 2020

# Graph for T1 = (10,1) T2 = (10,3)
# T3 = (20,3) T4 = (20,8)
# f = 10 H = 20
# 2 frames labeled F1 and F2
# 2 T1 jobs labeled J1-1 and J1-2
# 2 T2 jobs labeled J2-1and J2-2
# 1 T3 job labeled J3-1
# 1 T4 job labeled J4-1

use Graph::MaxFlow qw(max_flow);
my $g = new Graph;

# construct graph
$g->add_vertex("source");
$g->add_vertex("sink");
$g->add_vertex("J1-1");
$g->add_vertex("J1-2");
$g->add_vertex("J2-1");
$g->add_vertex("J2-2");
$g->add_vertex("J3-1");
$g->add_vertex("J4-1");

$g->add_weighted_edge("source", "J1-1", 1);
$g->add_weighted_edge("source", "J1-2", 1);
$g->add_weighted_edge("source", "J2-1", 3);
$g->add_weighted_edge("source", "J2-2", 3);
$g->add_weighted_edge("source", "J3-1", 2);
$g->add_weighted_edge("source", "J4-1", 8);


$g->add_weighted_edge("J1-1", "F1", 10);
$g->add_weighted_edge("J1-2", "F2", 10);
$g->add_weighted_edge("J2-1", "F1", 10);
$g->add_weighted_edge("J2-2", "F2", 10);

$g->add_weighted_edge("J3-1", "F1", 10);
$g->add_weighted_edge("J3-1", "F2", 10);

$g->add_weighted_edge("J4-1", "F1", 10);
$g->add_weighted_edge("J4-1", "F2", 10);

$g->add_weighted_edge("F1", "sink", 10);
$g->add_weighted_edge("F2", "sink", 10);

my $flow = max_flow($g, "source", "sink");
#print ("The graph is $g\n");
#print("Max flow  $flow \n");
print("Source to J1-1 weight ", $flow->get_edge_weight("source", "J1-1"), "\n");
print("Source to J1-2 weight ", $flow->get_edge_weight("source", "J1-2"), "\n");
print("Source to J2-1 weight ", $flow->get_edge_weight("source", "J2-1"), "\n");
print("Source to J2-2 weight ", $flow->get_edge_weight("source", "J2-2"), "\n \n");
print("Source to J3-1 weight ", $flow->get_edge_weight("source", "J3-1"), "\n");
print("Source to J4-1 weight ", $flow->get_edge_weight("source", "J4-1"), "\n \n");

print("J1-1 to F1 weight ", $flow->get_edge_weight("J1-1", "F1"), "\n");
print("J1-2 to F2 weight ", $flow->get_edge_weight("J1-2", "F2"), "\n");
print("J2-1 to F1 weight ", $flow->get_edge_weight("J2-1", "F1"), "\n");
print("J2-2 to F2 weight ", $flow->get_edge_weight("J2-2", "F2"), "\n");
print("J3-1 to F1 weight ", $flow->get_edge_weight("J3-1", "F1"), "\n");
print("J3-1 to F2 weight ", $flow->get_edge_weight("J3-1", "F2"), "\n");
print("J4-1 to F1 weight ", $flow->get_edge_weight("J4-1", "F1"), "\n");
print("J4-1 to F2 weight ", $flow->get_edge_weight("J4-1", "F2"), "\n");
