/* BUDDY FILE90 - SYMMETRIC VENT / REINFORCEMENT PATTERN
Cutout tool for peripheral electronics cooling. Never cuts protected propulsion duct. */
include <55_stage1_print_parameters.scad>
$fn=72;
module vent_cutouts(){for(a=[45,135,225,315])rotate([0,0,a])translate([53,0,18])rotate([0,90,0])hull(){translate([0,-4,0])cylinder(h=5,d=3,center=true);translate([0,4,0])cylinder(h=5,d=3,center=true);}}
module reinforcement_ribs(){for(a=[0:45:315])rotate([0,0,a])translate([51,0,12])cube([6,1.6,18],center=true);}
%vent_cutouts();reinforcement_ribs();
echo("FILE90 symmetric peripheral ventilation/reinforcement concept; thermal and impact validation pending");
