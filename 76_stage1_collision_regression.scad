/* BUDDY FILE76 - STAGE1 COLLISION REGRESSION
Red means forbidden overlap. Diagnostic geometry only. */
include <55_stage1_print_parameters.scad>
use <57_equatorial_service_chassis.scad>
use <59_vane_cartridge_v2.scad>
use <70_mass_dummy_system.scad>
$fn=90;
TEST=0; // 0 overview, 1 airway intrusion, 2 outside cavity, 3 vane keepout vs dummies
module hardware(){service_chassis();stage1_mass_dummies();}
module vanes(){for(i=[0:3])rotate([0,0,90*i])translate([B1_DUCT_OD/2+9,0,0])cartridge();}
if(TEST==0){%sphere(d=B1_CAVITY_D);%cylinder(h=70,d=B1_AIRWAY_D,center=true);hardware();vanes();}
if(TEST==1)color("red")intersection(){hardware();cylinder(h=72,d=B1_AIRWAY_D,center=true);}
if(TEST==2)color("red")difference(){union(){hardware();vanes();}sphere(d=B1_CAVITY_D);}
if(TEST==3)color("red")intersection(){stage1_mass_dummies();vanes();}
assert(TEST>=0&&TEST<=3);
echo("FILE76 collision regression TEST=",TEST," red geometry in tests 1-3 = failure");
