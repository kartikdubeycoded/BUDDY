/* BUDDY FILE60 - STAGE 1 PROTOTYPE ASSEMBLY
Single scene for the complete printable mechanical architecture.
F5 diagnostic assembly; individual source files remain printable part generators. */
include <55_stage1_print_parameters.scad>
use <56_segmented_crash_cage.scad>
use <57_equatorial_service_chassis.scad>
use <58_propulsion_cartridge.scad>
use <59_vane_cartridge_v2.scad>
use <39_camera_packaging_v3.scad>
$fn=100;
SHOW_CAGE=true;SHOW_CHASSIS=true;SHOW_PROPULSION=true;SHOW_VANES=true;SHOW_CAMERAS=false;SHOW_KEEP_OUTS=true;
if(SHOW_CAGE){hemisphere(1);hemisphere(-1);equator_clamp();}
if(SHOW_CHASSIS)service_chassis();
// File58 intentionally renders its top-level cartridge when opened alone; reproduce interfaces here to avoid top-level ambiguity.
if(SHOW_PROPULSION)propulsion_stage1();
if(SHOW_VANES)system();
if(SHOW_CAMERAS)camera_packaging_v3();
if(SHOW_KEEP_OUTS){%cylinder(h=70,d=B1_AIRWAY_D,center=true);%sphere(d=B1_OD);}
module propulsion_stage1(){difference(){cylinder(h=70,d=B1_DUCT_OD,center=true);cylinder(h=71,d=B1_AIRWAY_D,center=true);}for(z=[-12,12])translate([0,0,z])for(a=[0:90:270])rotate([0,0,a])translate([23,0,0])cube([28,2.2,2],center=true);for(z=[-6,6])%translate([0,0,z])cylinder(h=5,d=2*B1_ROTOR_NOMINAL_R,center=true);}
echo("FILE60 COMPLETE STAGE1 PROTOTYPE ASSEMBLY");
echo("Geometry is print-oriented but propulsion hardware remains envelope-only");
