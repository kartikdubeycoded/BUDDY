/*
================================================================
BUDDY / AIDRONE
FILE 13 / 24 - COUNTER-ROTATING ROTOR ENVELOPES

Safety geometry only. This does not define a manufacturable rotor.
The envelope includes runout, manufacturing and blade-deflection
allowances and is synchronized with File 12 stator positions.
================================================================
*/
include <00_master_parameters.scad>
include <02_materials_tolerances.scad>
$fn=100;

DUCT_ID_LOCAL=70.0;
DUCT_R_LOCAL=DUCT_ID_LOCAL/2;
ROTOR_NOMINAL_D=68.0;
ROTOR_NOMINAL_R=ROTOR_NOMINAL_D/2;
ROTOR_A_Z=12.0;
ROTOR_B_Z=-12.0;
ROTOR_NOMINAL_AXIAL_H=4.0;

SHAFT_RUNOUT_ALLOWANCE=0.10;
ROTOR_MANUFACTURING_ALLOWANCE=0.15;
BLADE_DYNAMIC_DEFLECTION_ALLOWANCE=0.20;
DUCT_DIMENSIONAL_ALLOWANCE=0.15;
TOTAL_DYNAMIC_RADIAL_ALLOWANCE=SHAFT_RUNOUT_ALLOWANCE+ROTOR_MANUFACTURING_ALLOWANCE+BLADE_DYNAMIC_DEFLECTION_ALLOWANCE+DUCT_DIMENSIONAL_ALLOWANCE;
NOMINAL_RADIAL_CLEARANCE=DUCT_R_LOCAL-ROTOR_NOMINAL_R;
REMAINING_RADIAL_CLEARANCE=NOMINAL_RADIAL_CLEARANCE-TOTAL_DYNAMIC_RADIAL_ALLOWANCE;
DYNAMIC_ROTOR_R=ROTOR_NOMINAL_R+TOTAL_DYNAMIC_RADIAL_ALLOWANCE;
DYNAMIC_ROTOR_D=2*DYNAMIC_ROTOR_R;

AXIAL_BLADE_DEFLECTION_ALLOWANCE=0.50;
DYNAMIC_ROTOR_H=ROTOR_NOMINAL_AXIAL_H+2*AXIAL_BLADE_DEFLECTION_ALLOWANCE;
HUB_ENVELOPE_D=18.0;
HUB_ENVELOPE_H=8.0;
ROTOR_A_DIRECTION=+1;
ROTOR_B_DIRECTION=-1;

// Synchronized with File 12.
STATOR_A_Z=6.0;
STATOR_B_Z=-6.0;
STATOR_H=5.0;
MIN_DYNAMIC_STATOR_CLEARANCE=1.0;

ROTOR_A_BOTTOM=ROTOR_A_Z-DYNAMIC_ROTOR_H/2;
ROTOR_A_TOP=ROTOR_A_Z+DYNAMIC_ROTOR_H/2;
ROTOR_B_BOTTOM=ROTOR_B_Z-DYNAMIC_ROTOR_H/2;
ROTOR_B_TOP=ROTOR_B_Z+DYNAMIC_ROTOR_H/2;
STATOR_A_TOP=STATOR_A_Z+STATOR_H/2;
STATOR_B_BOTTOM=STATOR_B_Z-STATOR_H/2;
ROTOR_A_STATOR_CLEARANCE=ROTOR_A_BOTTOM-STATOR_A_TOP;
ROTOR_B_STATOR_CLEARANCE=STATOR_B_BOTTOM-ROTOR_B_TOP;
INTER_ROTOR_GAP=ROTOR_A_BOTTOM-ROTOR_B_TOP;

FAILURE_RADIAL_MARGIN=1.0;
FAILURE_AXIAL_MARGIN=2.0;
FAILURE_ENVELOPE_D=DYNAMIC_ROTOR_D+2*FAILURE_RADIAL_MARGIN;
FAILURE_ENVELOPE_H=DYNAMIC_ROTOR_H+2*FAILURE_AXIAL_MARGIN;

SHOW_NOMINAL_ROTORS=true;
SHOW_DYNAMIC_ENVELOPES=false;
SHOW_FAILURE_ENVELOPES=false;
SHOW_HUB_ENVELOPES=false;
SHOW_DUCT_REFERENCE=false;
SHOW_INTERSTAGE_VOLUME=false;

rotor_envelope_system();

module rotor_envelope_system(){
    if(SHOW_NOMINAL_ROTORS){ %nominal_rotor(ROTOR_A_Z); %nominal_rotor(ROTOR_B_Z); }
    if(SHOW_DYNAMIC_ENVELOPES){ %dynamic_rotor(ROTOR_A_Z); %dynamic_rotor(ROTOR_B_Z); }
    if(SHOW_FAILURE_ENVELOPES){ %failure_envelope(ROTOR_A_Z); %failure_envelope(ROTOR_B_Z); }
    if(SHOW_HUB_ENVELOPES){ %hub_envelope(ROTOR_A_Z); %hub_envelope(ROTOR_B_Z); }
    if(SHOW_DUCT_REFERENCE) %duct_reference();
    if(SHOW_INTERSTAGE_VOLUME) %interstage_volume();
}
module nominal_rotor(z){ translate([0,0,z]) cylinder(h=ROTOR_NOMINAL_AXIAL_H,d=ROTOR_NOMINAL_D,center=true); }
module dynamic_rotor(z){ translate([0,0,z]) cylinder(h=DYNAMIC_ROTOR_H,d=DYNAMIC_ROTOR_D,center=true); }
module failure_envelope(z){ translate([0,0,z]) cylinder(h=FAILURE_ENVELOPE_H,d=FAILURE_ENVELOPE_D,center=true); }
module hub_envelope(z){ translate([0,0,z]) cylinder(h=HUB_ENVELOPE_H,d=HUB_ENVELOPE_D,center=true); }
module duct_reference(){ difference(){ cylinder(h=70,d=74,center=true); cylinder(h=70.2,d=70,center=true); } }
module interstage_volume(){ translate([0,0,(ROTOR_A_BOTTOM+ROTOR_B_TOP)/2]) cylinder(h=INTER_ROTOR_GAP,d=DUCT_ID_LOCAL,center=true); }

assert(ROTOR_NOMINAL_D<DUCT_ID_LOCAL,"FAIL: nominal rotor does not fit duct.");
assert(NOMINAL_RADIAL_CLEARANCE>=MIN_ROTOR_STATIC_RADIAL_CLEARANCE,"FAIL: nominal rotor tip clearance below design floor.");
assert(TOTAL_DYNAMIC_RADIAL_ALLOWANCE<NOMINAL_RADIAL_CLEARANCE,"FAIL: dynamic allowances consume entire rotor tip clearance.");
assert(REMAINING_RADIAL_CLEARANCE>0,"FAIL: no positive rotor-to-duct clearance remains.");
assert(DYNAMIC_ROTOR_D<DUCT_ID_LOCAL,"FAIL: dynamic rotor envelope intersects duct.");
assert(ROTOR_A_STATOR_CLEARANCE>=MIN_DYNAMIC_STATOR_CLEARANCE,"FAIL: Stage A dynamic rotor/stator clearance <1 mm.");
assert(ROTOR_B_STATOR_CLEARANCE>=MIN_DYNAMIC_STATOR_CLEARANCE,"FAIL: Stage B dynamic rotor/stator clearance <1 mm.");
assert(INTER_ROTOR_GAP>0,"FAIL: counter-rotating rotor envelopes intersect.");
assert(ROTOR_A_DIRECTION==-ROTOR_B_DIRECTION,"FAIL: rotor direction metadata is not counter-rotating.");

echo("============================================");
echo("BUDDY FILE 13 - ROTOR ENVELOPES");
echo("Nominal radial clearance mm =",NOMINAL_RADIAL_CLEARANCE);
echo("Total dynamic radial allowance mm =",TOTAL_DYNAMIC_RADIAL_ALLOWANCE);
echo("Remaining radial clearance mm =",REMAINING_RADIAL_CLEARANCE);
echo("Dynamic rotor diameter mm =",DYNAMIC_ROTOR_D);
echo("Dynamic rotor axial height mm =",DYNAMIC_ROTOR_H);
echo("Stage A dynamic stator clearance mm =",ROTOR_A_STATOR_CLEARANCE);
echo("Stage B dynamic stator clearance mm =",ROTOR_B_STATOR_CLEARANCE);
echo("Inter-rotor gap mm =",INTER_ROTOR_GAP);
echo("Failure envelope diameter mm =",FAILURE_ENVELOPE_D);
echo("============================================");
