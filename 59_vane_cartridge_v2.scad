/* BUDDY FILE59 - VANE CARTRIDGE V2
Four removable downstream control-vane cartridges. Mechanical hard stops included.
Aerodynamic authority remains unverified. */
include <55_stage1_print_parameters.scad>
$fn=80; VANE_Z=-27; VANE_SPAN=27; VANE_CHORD=13; VANE_T=1.2; SHAFT_D=2; FRAME_W=6; ANGLE=0;
module vane(){rotate([0,ANGLE,0])cube([VANE_CHORD,VANE_SPAN,VANE_T],center=true);}
module cartridge(){difference(){union(){translate([0,-VANE_SPAN/2-2,0])cube([VANE_CHORD+5,4,FRAME_W],center=true);translate([0,VANE_SPAN/2+2,0])cube([VANE_CHORD+5,4,FRAME_W],center=true);}for(y=[-VANE_SPAN/2-2,VANE_SPAN/2+2])translate([0,y,0])rotate([90,0,0])cylinder(h=6,d=SHAFT_D+B1_FDM_SLIDE,center=true);}vane();hard_stops();}
module hard_stops(){for(s=[-1,1])translate([s*(VANE_CHORD/2+2),0,0])cube([2,VANE_SPAN+2,2],center=true);}
module system(){for(a=[0:90:270])rotate([0,0,a])translate([0,0,VANE_Z])cartridge();}
system();
assert(VANE_SPAN< B1_AIRWAY_D);
assert(abs(ANGLE)<=25,"commanded vane angle exceeds Stage1 limit");
echo("FILE59 replaceable vane cartridge angle=",ANGLE);
