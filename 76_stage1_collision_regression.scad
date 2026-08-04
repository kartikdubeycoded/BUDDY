/* BUDDY FILE76 - STAGE1 COLLISION REGRESSION
Red means forbidden overlap. Diagnostic geometry only.
Tests distinguish protected AIRWAY from the surrounding propulsion DUCT: payload may not enter the duct envelope. */
include <55_stage1_print_parameters.scad>
use <57_equatorial_service_chassis.scad>
use <59_vane_cartridge_v2.scad>
use <70_mass_dummy_system.scad>
$fn=90;
TEST=0; // 0 overview, 1 payload vs duct, 2 payload outside cavity, 3 payload vs vane/control keepout
CONTROL_Z=-27;
CONTROL_RADIAL_IN=B1_DUCT_OD/2;
CONTROL_RADIAL_OUT=B1_DUCT_OD/2+18;
CONTROL_H=12;
module payload(){stage1_mass_dummies();}
module chassis(){service_chassis();}
module vane_hardware(){for(i=[0:3])rotate([0,0,90*i])translate([B1_DUCT_OD/2+9,0,CONTROL_Z])cartridge();}
// Conservative control keepout: annular downstream band reserved for vane frames/linkage.
module control_keepout(){translate([0,0,CONTROL_Z])difference(){cylinder(h=CONTROL_H,d=2*CONTROL_RADIAL_OUT,center=true);cylinder(h=CONTROL_H+1,d=2*CONTROL_RADIAL_IN,center=true);}}
if(TEST==0){%sphere(d=B1_CAVITY_D);%cylinder(h=70,d=B1_AIRWAY_D,center=true);%cylinder(h=70,d=B1_DUCT_OD,center=true);chassis();payload();vane_hardware();}
// Payload must remain outside the complete propulsion duct, not merely outside the open airway.
if(TEST==1)color("red")intersection(){payload();cylinder(h=72,d=B1_DUCT_OD,center=true);}
// Hardware envelopes must remain within the spherical cavity. Structural chassis/cage interfaces are tested separately.
if(TEST==2)color("red")difference(){payload();sphere(d=B1_CAVITY_D);}
// Payload must not enter conservative downstream control/vane service volume.
if(TEST==3)color("red")intersection(){payload();control_keepout();}
assert(TEST>=0&&TEST<=3);
echo("FILE76 collision regression TEST=",TEST," red geometry in tests 1-3 = failure");
