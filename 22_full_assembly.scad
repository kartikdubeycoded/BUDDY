/*
================================================================
BUDDY / AIDRONE
FILE 22 / 24 - FULL VEHICLE ASSEMBLY

Integration authority for the current CAD generation.
Global origin = center of the 115 mm vehicle sphere.

NOTE
----
The legacy core.scad, collar.scad and shell.scad are deliberately
NOT loaded here. Their newer authoritative replacements are:
  core  -> 10_aero_duct.scad
  collar packaging -> 17/19/20
  shell -> 21_crash_shell.scad
================================================================
*/

$fn = 100;

use <10_aero_duct.scad>
use <11_inlet_lip.scad>
use <12_motor_stator.scad>
use <13_rotor_envelopes.scad>
use <14_vane_system.scad>
use <15_vane_actuator_ring.scad>
use <17_electronics_spine.scad>
use <19_battery_cradle.scad>
use <20_camera_ring.scad>
use <21_crash_shell.scad>

VEHICLE_OD = 115;
VEHICLE_R = VEHICLE_OD / 2;
SHELL_ID = 111;
SHELL_IR = SHELL_ID / 2;
DUCT_OD = 74;
DUCT_ID = 70;
DUCT_HEIGHT = 70;

// 0 complete, 1 exploded, 2 structure, 3 propulsion,
// 4 electronics, 5 packaging, 6 keep-outs.
VIEW_MODE = 0;

SHOW_DUCT = true;
SHOW_INLET = true;
SHOW_MOTOR_STATOR = true;
SHOW_ROTOR_ENVELOPES = true;
SHOW_VANES = true;
SHOW_ACTUATORS = true;
SHOW_ELECTRONICS = true;
SHOW_BATTERIES = true;
SHOW_CAMERAS = true;
SHOW_CRASH_SHELL = true;

SHOW_GLOBAL_AXES = false;
SHOW_VEHICLE_ENVELOPE = false;
SHOW_AIRWAY_KEEP_OUT = false;
SHOW_SHELL_INNER_ENVELOPE = false;
SHOW_COG_DATUM = false;

vehicle_assembly();

module vehicle_assembly() {
    if (VIEW_MODE == 0) complete_assembly();
    else if (VIEW_MODE == 1) exploded_assembly();
    else if (VIEW_MODE == 2) structure_view();
    else if (VIEW_MODE == 3) propulsion_view();
    else if (VIEW_MODE == 4) electronics_view();
    else if (VIEW_MODE == 5) packaging_view();
    else if (VIEW_MODE == 6) keepout_view();
    else assert(false, "FAIL: VIEW_MODE must be 0..6.");
    debug_geometry();
}

module complete_assembly() {
    if (SHOW_DUCT) aidrone_aero_duct();
    if (SHOW_INLET) inlet_system();
    if (SHOW_MOTOR_STATOR) motor_stator_system();
    if (SHOW_ROTOR_ENVELOPES) rotor_envelope_system();
    if (SHOW_VANES) vane_system();
    if (SHOW_ACTUATORS) actuator_system();
    if (SHOW_ELECTRONICS) electronics_spine();
    if (SHOW_BATTERIES) battery_system();
    if (SHOW_CAMERAS) camera_ring();
    if (SHOW_CRASH_SHELL) crash_shell_system();
}

module exploded_assembly() {
    if (SHOW_DUCT) aidrone_aero_duct();
    if (SHOW_INLET) translate([0,0,90]) inlet_system();
    if (SHOW_MOTOR_STATOR) translate([0,0,90]) motor_stator_system();
    if (SHOW_ROTOR_ENVELOPES) translate([0,0,90]) rotor_envelope_system();
    if (SHOW_VANES) translate([0,0,-90]) vane_system();
    if (SHOW_ACTUATORS) translate([0,0,-120]) actuator_system();
    if (SHOW_ELECTRONICS) translate([100,0,0]) electronics_spine();
    if (SHOW_BATTERIES) translate([0,100,0]) battery_system();
    if (SHOW_CAMERAS) translate([-100,0,0]) camera_ring();
    if (SHOW_CRASH_SHELL) translate([0,0,150]) crash_shell_system();
}

module structure_view() {
    aidrone_aero_duct();
    crash_shell_system();
}

module propulsion_view() {
    aidrone_aero_duct();
    inlet_system();
    motor_stator_system();
    rotor_envelope_system();
    vane_system();
    actuator_system();
}

module electronics_view() {
    aidrone_aero_duct();
    electronics_spine();
    battery_system();
    camera_ring();
}

module packaging_view() {
    %sphere(d=VEHICLE_OD);
    %sphere(d=SHELL_ID);
    aidrone_aero_duct();
    actuator_system();
    electronics_spine();
    battery_system();
    camera_ring();
    vane_system();
}

module keepout_view() {
    %cylinder(h=DUCT_HEIGHT+20, d=DUCT_ID, center=true);
    %sphere(d=VEHICLE_OD);
    %sphere(d=SHELL_ID);
    aidrone_aero_duct();
    actuator_system();
    electronics_spine();
    battery_system();
    camera_ring();
    vane_system();
}

module debug_geometry() {
    if (SHOW_GLOBAL_AXES) global_axes();
    if (SHOW_VEHICLE_ENVELOPE) %sphere(d=VEHICLE_OD);
    if (SHOW_SHELL_INNER_ENVELOPE) %sphere(d=SHELL_ID);
    if (SHOW_AIRWAY_KEEP_OUT) %cylinder(h=DUCT_HEIGHT+20,d=DUCT_ID,center=true);
    if (SHOW_COG_DATUM) sphere(d=3);
}

module global_axes() {
    axis_l=80; axis_d=0.6;
    rotate([0,90,0]) cylinder(h=axis_l,d=axis_d,center=true);
    rotate([90,0,0]) cylinder(h=axis_l,d=axis_d,center=true);
    cylinder(h=axis_l,d=axis_d,center=true);
}

// Diagnostic: result should be EMPTY.
module airway_collision_test() {
    intersection() {
        union() {
            actuator_system();
            electronics_spine();
            battery_system();
            camera_ring();
        }
        cylinder(h=DUCT_HEIGHT+10,d=DUCT_ID,center=true);
    }
}

// Diagnostic: result should be EMPTY.
module outside_vehicle_test() {
    difference() {
        union() {
            aidrone_aero_duct();
            actuator_system();
            electronics_spine();
            battery_system();
            camera_ring();
            vane_system();
        }
        sphere(d=VEHICLE_OD);
    }
}

// Diagnostic: result should be EMPTY for internal hardware.
module inner_shell_violation_test() {
    difference() {
        union() {
            actuator_system();
            electronics_spine();
            battery_system();
            camera_ring();
            vane_system();
        }
        sphere(d=SHELL_ID);
    }
}

assert(VEHICLE_OD == 115, "FAIL: vehicle OD changed.");
assert(SHELL_ID == 111, "FAIL: shell ID changed.");
assert(DUCT_OD == 74, "FAIL: duct OD changed.");
assert(DUCT_ID == 70, "FAIL: airway diameter changed.");

echo("============================================");
echo("BUDDY FILE 22 - FULL ASSEMBLY");
echo("Vehicle OD =", VEHICLE_OD);
echo("Shell ID =", SHELL_ID);
echo("Duct OD =", DUCT_OD);
echo("Airway diameter =", DUCT_ID);
echo("View mode =", VIEW_MODE);
echo("Legacy core/collar/shell loaded = NO");
echo("============================================");
