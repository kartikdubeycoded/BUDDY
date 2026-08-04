/* BUDDY FILE75 - STAGE1 MASTER INSPECTION SCENE
One top-level file for the final local Stage1 CAD inspection round. */
include <55_stage1_print_parameters.scad>
use <56_segmented_crash_cage.scad>
use <57_equatorial_service_chassis.scad>
use <59_vane_cartridge_v2.scad>
use <70_mass_dummy_system.scad>
$fn=100;
VIEW=0; // 0 assembled, 1 cage, 2 chassis+dummies, 3 vane system, 4 keepouts
if(VIEW==0){hemisphere(1);hemisphere(-1);equator_clamp();service_chassis();for(i=[0:3])rotate([0,0,90*i])translate([B1_DUCT_OD/2+9,0,0])cartridge();stage1_mass_dummies();duct_visual();}
if(VIEW==1){hemisphere(1);hemisphere(-1);equator_clamp();}
if(VIEW==2){service_chassis();stage1_mass_dummies();}
if(VIEW==3){for(i=[0:3])rotate([0,0,90*i])translate([B1_DUCT_OD/2+9,0,0])cartridge();}
if(VIEW==4){%sphere(d=B1_OD);%cylinder(h=70,d=B1_AIRWAY_D,center=true);}
module duct_visual(){difference(){cylinder(h=70,d=B1_DUCT_OD,center=true);cylinder(h=71,d=B1_AIRWAY_D,center=true);}}
assert(B1_OD==115 && B1_CAVITY_D==111 && B1_AIRWAY_D==70);
echo("FILE75 BUDDY STAGE1 MASTER INSPECTION", "VIEW=",VIEW);
echo("Use F5 for views; F6 only after all dependency previews compile cleanly");
