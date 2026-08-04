/* BUDDY FILE58 - REPLACEABLE PROPULSION CARTRIDGE
Print-oriented structural interfaces around the protected duct. Motors/rotors are envelopes only.
No powered use until selected hardware and guarded bench validation. */
include <55_stage1_print_parameters.scad>
$fn=100; EXPLODE=0;
DUCT_H=70; COLLAR_H=4; COLLAR_OD=80; STATOR_Z=12;
module duct(){difference(){cylinder(h=DUCT_H,d=B1_DUCT_OD,center=true);cylinder(h=DUCT_H+1,d=B1_AIRWAY_D,center=true);}}
module collar(z){translate([0,0,z])difference(){cylinder(h=COLLAR_H,d=COLLAR_OD,center=true);cylinder(h=COLLAR_H+.2,d=B1_DUCT_OD+B1_FDM_SLIDE*2,center=true);for(a=[0:90:270])rotate([0,0,a])translate([COLLAR_OD/2-2,0,0])rotate([0,90,0])cylinder(h=5,d=B1_M2_CLEAR,center=true);}}
module stator(z){translate([0,0,z])union(){difference(){cylinder(h=2,d=B1_DUCT_OD,center=true);cylinder(h=2.2,d=18,center=true);}for(a=[0:90:270])rotate([0,0,a])translate([23,0,0])cube([28,2.2,2],center=true);}}
module rotor_envelope(z){%translate([0,0,z])cylinder(h=5,d=2*B1_ROTOR_NOMINAL_R,center=true);}
duct();collar(35+EXPLODE);collar(-35-EXPLODE);stator(STATOR_Z);stator(-STATOR_Z);rotor_envelope(6);rotor_envelope(-6);
assert(B1_ROTOR_NOMINAL_R<B1_AIRWAY_D/2);
echo("FILE58 propulsion cartridge static rotor radial gap =",B1_ROTOR_STATIC_RADIAL_GAP);
echo("Dynamic gap is NOT verified by this file");
