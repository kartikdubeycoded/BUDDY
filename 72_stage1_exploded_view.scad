/* BUDDY FILE72 - STAGE1 EXPLODED VIEW
Assembly-order visualization for the inert prototype. */
use <56_segmented_crash_cage.scad>
use <57_equatorial_service_chassis.scad>
use <59_vane_cartridge_v2.scad>
use <70_mass_dummy_system.scad>
include <55_stage1_print_parameters.scad>
$fn=80;
EXP=28;
translate([0,0,EXP])hemisphere(1);
translate([0,0,-EXP])hemisphere(-1);
equator_clamp();
service_chassis();
for(i=[0:3])rotate([0,0,90*i])translate([B1_DUCT_OD/2+9,0,0])cartridge();
stage1_mass_dummies();
%cylinder(h=70,d=B1_AIRWAY_D,center=true);
echo("FILE72 exploded Stage1 mechanical assembly / service visualization");
