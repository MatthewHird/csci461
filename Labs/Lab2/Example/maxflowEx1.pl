#!/usr/bin/perl

# Cycle Executive Example 1
# Peter Walsh csci 461 2020

# Graph for T1 = (4,1) T2 = (5,2) T3 = (20,5)
# f = 2 H = 20
# 10 frames labeled F1..F10
# 5 T1 jobs labeled J1-1..J1-5
# 4 T2 jobs labeled J2-1..J2-4
# 1 T3 job labeled J3-1

use Graph::MaxFlow qw(max_flow);
my $g = new Graph;

# construct graph
$g->add_vertex("source");
$g->add_vertex("sink");

$g->add_vertex("F1"); 
$g->add_vertex("F2"); 
$g->add_vertex("F3"); 
$g->add_vertex("F4");
$g->add_vertex("F5"); 
$g->add_vertex("F6"); 
$g->add_vertex("F7"); 
$g->add_vertex("F8");
$g->add_vertex("F9"); 
$g->add_vertex("F10");

$g->add_vertex("J1-1"); 
$g->add_vertex("J1-2");
$g->add_vertex("J1-3"); 
$g->add_vertex("J1-4");
$g->add_vertex("J1-5"); 

$g->add_vertex("J2-1"); 
$g->add_vertex("J2-2");
$g->add_vertex("J2-3"); 
$g->add_vertex("J2-4");

$g->add_vertex("J3-1");

$g->add_weighted_edge("source", "J1-1", 1);
$g->add_weighted_edge("source", "J1-2", 1);
$g->add_weighted_edge("source", "J1-3", 1);
$g->add_weighted_edge("source", "J1-4", 1);
$g->add_weighted_edge("source", "J1-5", 1);

$g->add_weighted_edge("source", "J2-1", 2);
$g->add_weighted_edge("source", "J2-2", 2);
$g->add_weighted_edge("source", "J2-3", 2);
$g->add_weighted_edge("source", "J2-4", 2);

$g->add_weighted_edge("source", "J3-1", 5);

$g->add_weighted_edge("J1-1", "F1", 2);
$g->add_weighted_edge("J1-1", "F2", 2);

$g->add_weighted_edge("J1-2", "F3", 2);
$g->add_weighted_edge("J1-2", "F4", 2);

$g->add_weighted_edge("J1-3", "F5", 2);
$g->add_weighted_edge("J1-3", "F6", 2);

$g->add_weighted_edge("J1-4", "F7", 2);
$g->add_weighted_edge("J1-4", "F8", 2);

$g->add_weighted_edge("J1-5", "F9", 2);
$g->add_weighted_edge("J1-5", "F10", 2);

$g->add_weighted_edge("J2-1", "F1", 2);
$g->add_weighted_edge("J2-1", "F2", 2);

$g->add_weighted_edge("J2-2", "F4", 2);
$g->add_weighted_edge("J2-2", "F5", 2);

$g->add_weighted_edge("J2-3", "F6", 2);
$g->add_weighted_edge("J2-3", "F7", 2);

$g->add_weighted_edge("J2-4", "F9", 2);
$g->add_weighted_edge("J2-4", "F10", 2);

$g->add_weighted_edge("J3-1", "F1", 2);
$g->add_weighted_edge("J3-1", "F2", 2);
$g->add_weighted_edge("J3-1", "F3", 2);
$g->add_weighted_edge("J3-1", "F4", 2);
$g->add_weighted_edge("J3-1", "F5", 2);
$g->add_weighted_edge("J3-1", "F6", 2);
$g->add_weighted_edge("J3-1", "F7", 2);
$g->add_weighted_edge("J3-1", "F8", 2);
$g->add_weighted_edge("J3-1", "F9", 2);
$g->add_weighted_edge("J3-1", "F10", 2);

$g->add_weighted_edge("F1", "sink", 2);
$g->add_weighted_edge("F2", "sink", 2);
$g->add_weighted_edge("F3", "sink", 2);
$g->add_weighted_edge("F4", "sink", 2);
$g->add_weighted_edge("F5", "sink", 2);
$g->add_weighted_edge("F6", "sink", 2);
$g->add_weighted_edge("F7", "sink", 2);
$g->add_weighted_edge("F8", "sink", 2);
$g->add_weighted_edge("F9", "sink", 2);
$g->add_weighted_edge("F10", "sink", 2);

my $flow = max_flow($g, "source", "sink");

print("Source to J1-1 weight ", $flow->get_edge_weight("source", "J1-1"), "\n");
print("Source to J1-2 weight ", $flow->get_edge_weight("source", "J1-2"), "\n");
print("Source to J1-3 weight ", $flow->get_edge_weight("source", "J1-3"), "\n");
print("Source to J1-4 weight ", $flow->get_edge_weight("source", "J1-4"), "\n");
print("Source to J1-5 weight ", $flow->get_edge_weight("source", "J1-5"), "\n");

print("Source to J2-1 weight ", $flow->get_edge_weight("source", "J2-1"), "\n");
print("Source to J2-2 weight ", $flow->get_edge_weight("source", "J2-2"), "\n");
print("Source to J2-3 weight ", $flow->get_edge_weight("source", "J2-3"), "\n");
print("Source to J2-4 weight ", $flow->get_edge_weight("source", "J2-4"), "\n");

print("Source to J3-1 weight ", $flow->get_edge_weight("source", "J3-1"), "\n");

print("J1-1 to F1 weight ", $flow->get_edge_weight("J1-1", "F1"), "\n");
print("J1-1 to F2 weight ", $flow->get_edge_weight("J1-1", "F2"), "\n");

print("J1-2 to F3 weight ", $flow->get_edge_weight("J1-2", "F3"), "\n");
print("J1-2 to F4 weight ", $flow->get_edge_weight("J1-2", "F4"), "\n");

print("J1-3 to F5 weight ", $flow->get_edge_weight("J1-3", "F5"), "\n");
print("J1-3 to F6 weight ", $flow->get_edge_weight("J1-3", "F6"), "\n");

print("J1-4 to F7 weight ", $flow->get_edge_weight("J1-4", "F7"), "\n");
print("J1-4 to F8 weight ", $flow->get_edge_weight("J1-4", "F8"), "\n");

print("J1-5 to F9 weight ", $flow->get_edge_weight("J1-5", "F9"), "\n");
print("J1-5 to F10 weight ", $flow->get_edge_weight("J1-5", "F10"), "\n");

print("J2-1 to F1 weight ", $flow->get_edge_weight("J2-1", "F1"), "\n");
print("J2-1 to F2 weight ", $flow->get_edge_weight("J2-1", "F2"), "\n");

print("J2-2 to F4 weight ", $flow->get_edge_weight("J2-2", "F4"), "\n");
print("J2-2 to F5 weight ", $flow->get_edge_weight("J2-2", "F5"), "\n");

print("J2-3 to F6 weight ", $flow->get_edge_weight("J2-3", "F6"), "\n");
print("J2-3 to F7 weight ", $flow->get_edge_weight("J2-3", "F7"), "\n");

print("J2-4 to F9 weight ", $flow->get_edge_weight("J2-4", "F9"), "\n");
print("J2-4 to F10 weight ", $flow->get_edge_weight("J2-4", "F10"), "\n");

print("J3-1 to F1 weight ", $flow->get_edge_weight("J3-1", "F1"), "\n");
print("J3-1 to F2 weight ", $flow->get_edge_weight("J3-1", "F2"), "\n");
print("J3-1 to F3 weight ", $flow->get_edge_weight("J3-1", "F3"), "\n");
print("J3-1 to F4 weight ", $flow->get_edge_weight("J3-1", "F4"), "\n");
print("J3-1 to F5 weight ", $flow->get_edge_weight("J3-1", "F5"), "\n");
print("J3-1 to F6 weight ", $flow->get_edge_weight("J3-1", "F6"), "\n");
print("J3-1 to F7 weight ", $flow->get_edge_weight("J3-1", "F7"), "\n");
print("J3-1 to F8 weight ", $flow->get_edge_weight("J3-1", "F8"), "\n");
print("J3-1 to F9 weight ", $flow->get_edge_weight("J3-1", "F9"), "\n");
print("J3-1 to F10 weight ", $flow->get_edge_weight("J3-1", "F10"), "\n");

print("F1 to sink weight ", $flow->get_edge_weight("F1", "sink"), "\n");
print("F2 to sink weight ", $flow->get_edge_weight("F2", "sink"), "\n");
print("F3 to sink weight ", $flow->get_edge_weight("F3", "sink"), "\n");
print("F4 to sink weight ", $flow->get_edge_weight("F4", "sink"), "\n");
print("F5 to sink weight ", $flow->get_edge_weight("F5", "sink"), "\n");
print("F6 to sink weight ", $flow->get_edge_weight("F6", "sink"), "\n");
print("F7 to sink weight ", $flow->get_edge_weight("F7", "sink"), "\n");
print("F8 to sink weight ", $flow->get_edge_weight("F8", "sink"), "\n");
print("F9 to sink weight ", $flow->get_edge_weight("F9", "sink"), "\n");
print("F10 to sink weight ", $flow->get_edge_weight("F10", "sink"), "\n");

