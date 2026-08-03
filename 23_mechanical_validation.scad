/*
================================================================
BUDDY / AIDRONE
FILE 23 - MECHANICAL VALIDATION HARNESS

Purpose: make geometric failures visible. This is a diagnostic file,
not a printable component and not a flight-safety certification.

VIEW_TEST:
 0 overview
 1 airway intrusion (RED result should be EMPTY)
 2 outside 115 mm vehicle envelope (RED result should be EMPTY)
 3 internal hardware outside 111 mm shell cavity (RED result should be EMPTY)
 4 vane full +/-25 deg swept envelope
 5 rotor dynamic envelopes + stators
 6 packaging inside shell cavity
================================================================
*/
$fn=100;
use <10_aero_duct.scad>
use <12_motor_stator.scad>
use <13_rotor_envelopes.scad>
use <14_vane_system.scad>
use <15_vane_actuator_ring.scad>
use <17_electronics_spine.scad>
use <19_battery_cradle.scad>
use <20_camera_ring.scad>
use <21_crash_shell.scad>

VEHICLE_OD=115;
SHELL_ID=111;
AIRWAY_D=70;
DUCT_H=70;
VIEW_TEST=0;

validation_view();

module internal_nonpropulsive_hardware(){
    union(){
        actuator_system();
        electronics_spine();
        battery_system();
        camera_ring();
    }
}

module all_contained_hardware(){
    union(){
        aidrone_aero_duct();
        motor_stator_system();
        vane_system();
        actuator_system();
        electronics_spine();
        battery_system();
        camera_ring();
    }
}

module airway_keepout(){ cylinder(h=DUCT_H+0.2,d=AIRWAY_D,center=true); }
module vehicle_envelope(){ sphere(d=VEHICLE_OD); }
module shell_cavity(){ sphere(d=SHELL_ID); }

module airway_intrusion_test(){
    color("red") intersection(){ internal_nonpropulsive_hardware(); airway_keepout(); }
}

module outside_vehicle_test(){
    color("red") difference(){ all_contained_hardware(); vehicle_envelope(); }
}

module inner_shell_violation_test(){
    color("red") difference(){ internal_nonpropulsive_hardware(); shell_cavity(); }
}

module vane_sweep_test(){
    %aidrone_aero_duct();
    %shell_cavity();
    for(i=[0:3]) vane_sweep_envelope(i);
}

module rotor_stator_test(){
    %aidrone_aero_duct();
    motor_stator_system();
    // File 13 renders nominal rotor references; its assertions verify the
    // synchronized dynamic radial/axial budgets when compiled directly.
    rotor_envelope_system();
}

module packaging_test(){
    %shell_cavity();
    %airway_keepout();
    internal_nonpropulsive_hardware();
}

module validation_view(){
    if(VIEW_TEST==0){
        %vehicle_envelope(); %shell_cavity(); %airway_keepout();
        all_contained_hardware();
    }
    else if(VIEW_TEST==1) airway_intrusion_test();
    else if(VIEW_TEST==2) outside_vehicle_test();
    else if(VIEW_TEST==3) inner_shell_violation_test();
    else if(VIEW_TEST==4) vane_sweep_test();
    else if(VIEW_TEST==5) rotor_stator_test();
    else if(VIEW_TEST==6) packaging_test();
    else assert(false,"FAIL: VIEW_TEST must be 0..6");
}

assert(VEHICLE_OD==115,"FAIL: validation vehicle OD mismatch");
assert(SHELL_ID==111,"FAIL: validation shell ID mismatch");
assert(AIRWAY_D==70,"FAIL: validation airway mismatch");

echo("============================================");
echo("BUDDY FILE 23 - MECHANICAL VALIDATION");
echo("VIEW_TEST =",VIEW_TEST);
echo("Tests 1-3: any visible red geometry is a collision/containment failure.");
echo("Test 4: inspect full vane swept volume against duct/shell references.");
echo("Test 5: rotor/stator diagnostic view; compile Files 12/13 for numeric asserts.");
echo("STATUS: geometry diagnostic only; NOT flight certification.");
echo("============================================");
