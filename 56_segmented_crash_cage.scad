/* BUDDY FILE 56 - SEGMENTED CRASH CAGE
Stage-1 printable cage concept: two hemispherical rib cages + equatorial joint.
Impact/rotor containment remains unverified. */
include <55_stage1_print_parameters.scad>
$fn=120; PART=0; // 0 assembly, 1 upper, 2 lower, 3 equator clamp
module shell_skin(){difference(){sphere(d=B1_OD);sphere(d=B1_CAVITY_D);}}
module rib_cage(){union(){
 for(a=[0:30:150]) rotate([0,0,a]) intersection(){shell_skin();cube([B1_MIN_RIB,B1_OD+2,B1_OD+2],center=true);}
 for(z=[-42,-30,-18,18,30,42]){rr=sqrt(B1_SHELL_R*B1_SHELL_R-z*z);translate([0,0,z])rotate_extrude()translate([rr-B1_MIN_RIB/2,0])circle(d=B1_MIN_RIB);}
}}
module polar_clear(){for(s=[-1,1])translate([0,0,s*45])cylinder(h=30,d=B1_POLAR_OPENING_D,center=true);}
module hemisphere(sign=1){difference(){rib_cage();polar_clear();translate([0,0,-sign*B1_OD/2])cube([B1_OD+4,B1_OD+4,B1_OD],center=true);}}
module equator_clamp(){difference(){cylinder(h=6,d=B1_OD,center=true);cylinder(h=6.2,d=B1_OD-2*B1_WALL,center=true);for(a=[0:90:270])rotate([0,0,a])translate([B1_OD/2-1,0,0])rotate([0,90,0])cylinder(h=5,d=B1_M2_CLEAR,center=true);}}
if(PART==0){hemisphere(1);hemisphere(-1);equator_clamp();} else if(PART==1)hemisphere(1); else if(PART==2)hemisphere(-1); else equator_clamp();
echo("FILE56 segmented crash cage PART=",PART);
