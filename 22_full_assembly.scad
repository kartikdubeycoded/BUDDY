/*
================================================================
AIDRONE
FILE 22 / 24
FULL VEHICLE ASSEMBLY

PURPOSE
-------
Integrates the complete 115 mm spherical drone architecture
around one global coordinate system.

GLOBAL DATUM
------------
X = lateral
Y = lateral
Z = propulsion axis

Origin = geometric center of 115 mm sphere.

IMPORTANT
---------
This file should NOT redefine subsystem geometry.

Subsystem dimensions belong in their respective files.

This file is for:
- integration
- packaging
- visual inspection
- exploded views
- keep-out inspection
- collision debugging

OpenSCAD 2021 compatible.
================================================================
*/


$fn = 100;


// ============================================================
// 1. IMPORT SUBSYSTEM MODULES
// ============================================================

/*
Adjust filenames below if your actual filenames differ.

"use" is intentional.

It imports module definitions WITHOUT executing the standalone
top-level preview command inside each subsystem file.
*/


use <core.scad>

// Earlier propulsion files.
// Rename these paths to match your actual project filenames.

use <10_inlet_system.scad>
use <11_motor_stator_system.scad>
use <12_rotor_system.scad>
use <13_flow_stator.scad>
use <14_vane_system.scad>

// Files created recently.

use <15_vane_actuator_ring.scad>
use <17_electronics_spine.scad>
use <19_battery_cradle.scad>
use <20_camera_ring.scad>
use <21_crash_shell.scad>


// ============================================================
// 2. VEHICLE MASTER ENVELOPE
// ============================================================

VEHICLE_OD = 115;

VEHICLE_R =
    VEHICLE_OD / 2;


SHELL_ID = 111;

SHELL_IR =
    SHELL_ID / 2;


// ============================================================
// 3. DUCT
// ============================================================

DUCT_OD = 74;

DUCT_ID = 70;

DUCT_HEIGHT = 70;


// ============================================================
// 4. VIEW MODE
// ============================================================

/*
0 = complete assembly
1 = exploded assembly
2 = structure only
3 = propulsion only
4 = electronics only
5 = transparent packaging inspection
6 = keep-out inspection
*/

VIEW_MODE = 0;


// ============================================================
// 5. SUBSYSTEM VISIBILITY
// ============================================================

SHOW_CORE = true;

SHOW_INLET = true;

SHOW_MOTOR_STATOR = true;

SHOW_ROTORS = true;

SHOW_FLOW_STATOR = true;

SHOW_VANES = true;

SHOW_ACTUATORS = true;

SHOW_ELECTRONICS = true;

SHOW_BATTERIES = true;

SHOW_CAMERAS = true;

SHOW_CRASH_SHELL = true;


// ============================================================
// 6. DEBUG VISIBILITY
// ============================================================

SHOW_GLOBAL_AXES = false;

SHOW_VEHICLE_ENVELOPE = false;

SHOW_AIRWAY_KEEP_OUT = false;

SHOW_SHELL_INNER_ENVELOPE = false;

SHOW_COG_DATUM = false;


// ============================================================
// 7. EXPLODED VIEW DISTANCES
// ============================================================

EXPLODE_CORE_Z = 0;

EXPLODE_PROPULSION_Z = 90;

EXPLODE_VANES_Z = -90;

EXPLODE_ACTUATORS_Z = -120;

EXPLODE_ELECTRONICS_X = 100;

EXPLODE_BATTERY_Y = 100;

EXPLODE_CAMERA_X = -100;

EXPLODE_SHELL_Z = 150;


// ============================================================
// 8. MAIN
// ============================================================

vehicle_assembly();


// ============================================================
// 9. VIEW CONTROLLER
// ============================================================

module vehicle_assembly()
{
    if (VIEW_MODE == 0)
    {
        complete_assembly();
    }


    if (VIEW_MODE == 1)
    {
        exploded_assembly();
    }


    if (VIEW_MODE == 2)
    {
        structure_view();
    }


    if (VIEW_MODE == 3)
    {
        propulsion_view();
    }


    if (VIEW_MODE == 4)
    {
        electronics_view();
    }


    if (VIEW_MODE == 5)
    {
        packaging_view();
    }


    if (VIEW_MODE == 6)
    {
        keepout_view();
    }


    debug_geometry();
}


// ============================================================
// 10. COMPLETE ASSEMBLY
// ============================================================

module complete_assembly()
{
    if (SHOW_CORE)
    {
        wind_tunnel_core();
    }


    if (SHOW_INLET)
    {
        inlet_system();
    }


    if (SHOW_MOTOR_STATOR)
    {
        motor_stator_system();
    }


    if (SHOW_ROTORS)
    {
        rotor_system();
    }


    if (SHOW_FLOW_STATOR)
    {
        flow_stator_system();
    }


    if (SHOW_VANES)
    {
        vane_system();
    }


    if (SHOW_ACTUATORS)
    {
        actuator_system();
    }


    if (SHOW_ELECTRONICS)
    {
        electronics_spine();
    }


    if (SHOW_BATTERIES)
    {
        battery_system();
    }


    if (SHOW_CAMERAS)
    {
        camera_ring();
    }


    if (SHOW_CRASH_SHELL)
    {
        crash_shell_system();
    }
}


// ============================================================
// 11. EXPLODED ASSEMBLY
// ============================================================

module exploded_assembly()
{
    if (SHOW_CORE)
    {
        translate([
            0,
            0,
            EXPLODE_CORE_Z
        ])
        wind_tunnel_core();
    }


    if (SHOW_INLET)
    {
        translate([
            0,
            0,
            EXPLODE_PROPULSION_Z
        ])
        inlet_system();
    }


    if (SHOW_MOTOR_STATOR)
    {
        translate([
            0,
            0,
            EXPLODE_PROPULSION_Z
        ])
        motor_stator_system();
    }


    if (SHOW_ROTORS)
    {
        translate([
            0,
            0,
            EXPLODE_PROPULSION_Z
        ])
        rotor_system();
    }


    if (SHOW_FLOW_STATOR)
    {
        translate([
            0,
            0,
            EXPLODE_PROPULSION_Z
        ])
        flow_stator_system();
    }


    if (SHOW_VANES)
    {
        translate([
            0,
            0,
            EXPLODE_VANES_Z
        ])
        vane_system();
    }


    if (SHOW_ACTUATORS)
    {
        translate([
            0,
            0,
            EXPLODE_ACTUATORS_Z
        ])
        actuator_system();
    }


    if (SHOW_ELECTRONICS)
    {
        translate([
            EXPLODE_ELECTRONICS_X,
            0,
            0
        ])
        electronics_spine();
    }


    if (SHOW_BATTERIES)
    {
        translate([
            0,
            EXPLODE_BATTERY_Y,
            0
        ])
        battery_system();
    }


    if (SHOW_CAMERAS)
    {
        translate([
            EXPLODE_CAMERA_X,
            0,
            0
        ])
        camera_ring();
    }


    if (SHOW_CRASH_SHELL)
    {
        translate([
            0,
            0,
            EXPLODE_SHELL_Z
        ])
        crash_shell_system();
    }
}


// ============================================================
// 12. STRUCTURE VIEW
// ============================================================

module structure_view()
{
    wind_tunnel_core();

    crash_shell_system();
}


// ============================================================
// 13. PROPULSION VIEW
// ============================================================

module propulsion_view()
{
    wind_tunnel_core();

    inlet_system();

    motor_stator_system();

    rotor_system();

    flow_stator_system();

    vane_system();

    actuator_system();
}


// ============================================================
// 14. ELECTRONICS VIEW
// ============================================================

module electronics_view()
{
    wind_tunnel_core();

    electronics_spine();

    battery_system();

    camera_ring();
}


// ============================================================
// 15. PACKAGING VIEW
// ============================================================

module packaging_view()
{
    /*
    Transparent shell references are shown with %.

    Internal subsystems remain normal solids.
    */

    %sphere(
        d = VEHICLE_OD
    );


    %sphere(
        d = SHELL_ID
    );


    wind_tunnel_core();

    actuator_system();

    electronics_spine();

    battery_system();

    camera_ring();

    vane_system();
}


// ============================================================
// 16. KEEP-OUT VIEW
// ============================================================

module keepout_view()
{
    /*
    Shows the major protected volumes.

    Red-looking transparent geometry in OpenSCAD preview
    indicates reference/keep-out regions.
    */


    // 70 mm propulsion airway.

    %cylinder(
        h = DUCT_HEIGHT + 20,
        d = DUCT_ID,
        center = true
    );


    // Vehicle external envelope.

    %sphere(
        d = VEHICLE_OD
    );


    // Internal shell boundary.

    %sphere(
        d = SHELL_ID
    );


    wind_tunnel_core();

    actuator_system();

    electronics_spine();

    battery_system();

    camera_ring();

    vane_system();
}


// ============================================================
// 17. DEBUG GEOMETRY
// ============================================================

module debug_geometry()
{
    if (SHOW_GLOBAL_AXES)
    {
        global_axes();
    }


    if (SHOW_VEHICLE_ENVELOPE)
    {
        %sphere(
            d = VEHICLE_OD
        );
    }


    if (SHOW_SHELL_INNER_ENVELOPE)
    {
        %sphere(
            d = SHELL_ID
        );
    }


    if (SHOW_AIRWAY_KEEP_OUT)
    {
        %cylinder(
            h = DUCT_HEIGHT + 20,
            d = DUCT_ID,
            center = true
        );
    }


    if (SHOW_COG_DATUM)
    {
        cog_datum();
    }
}


// ============================================================
// 18. GLOBAL AXES
// ============================================================

module global_axes()
{
    AXIS_LENGTH = 80;

    AXIS_D = 0.6;


    // X

    rotate([
        0,
        90,
        0
    ])
    cylinder(
        h = AXIS_LENGTH,
        d = AXIS_D,
        center = true
    );


    // Y

    rotate([
        90,
        0,
        0
    ])
    cylinder(
        h = AXIS_LENGTH,
        d = AXIS_D,
        center = true
    );


    // Z

    cylinder(
        h = AXIS_LENGTH,
        d = AXIS_D,
        center = true
    );
}


// ============================================================
// 19. COG DATUM
// ============================================================

module cog_datum()
{
    sphere(
        d = 3
    );
}


// ============================================================
// 20. AIRWAY COLLISION TEST
// ============================================================

/*
This module can be manually enabled to inspect whether any
external subsystem has entered the Ø70 propulsion airway.

OpenSCAD intersection() displays ONLY overlapping geometry.
*/

module airway_collision_test()
{
    intersection()
    {
        union()
        {
            actuator_system();

            electronics_spine();

            battery_system();

            camera_ring();
        }


        cylinder(
            h = DUCT_HEIGHT + 10,
            d = DUCT_ID,
            center = true
        );
    }
}


// ============================================================
// 21. VEHICLE ENVELOPE VIOLATION TEST
// ============================================================

/*
Shows material lying OUTSIDE the Ø115 sphere.

Use manually when debugging packaging.
*/

module outside_vehicle_test()
{
    difference()
    {
        union()
        {
            wind_tunnel_core();

            actuator_system();

            electronics_spine();

            battery_system();

            camera_ring();

            vane_system();
        }


        sphere(
            d = VEHICLE_OD
        );
    }
}


// ============================================================
// 22. INNER-SHELL COLLISION TEST
// ============================================================

/*
The internal hardware should generally remain inside the
Ø111 inner shell boundary.

This test shows anything extending beyond it.
*/

module inner_shell_violation_test()
{
    difference()
    {
        union()
        {
            actuator_system();

            electronics_spine();

            battery_system();

            camera_ring();

            vane_system();
        }


        sphere(
            d = SHELL_ID
        );
    }
}


// ============================================================
// 23. CORE EXTERNAL ENVELOPE
// ============================================================

module core_envelope_reference()
{
    %cylinder(
        h = DUCT_HEIGHT,
        d = DUCT_OD,
        center = true
    );
}


// ============================================================
// 24. ASSEMBLY DATUM VALIDATION
// ============================================================

assert(
    VEHICLE_OD == 115,

    "FAIL: master vehicle diameter changed."
);


assert(
    SHELL_ID == 111,

    "FAIL: inner crash-shell diameter changed."
);


assert(
    DUCT_OD == 74,

    "FAIL: propulsion duct OD changed."
);


assert(
    DUCT_ID == 70,

    "FAIL: propulsion airway diameter changed."
);


// ============================================================
// 25. OUTPUT
// ============================================================

echo(
    "============================================"
);

echo(
    "AIDRONE FILE 22 — FULL ASSEMBLY"
);

echo(
    "Vehicle OD =",
    VEHICLE_OD
);

echo(
    "Shell inner diameter =",
    SHELL_ID
);

echo(
    "Duct OD =",
    DUCT_OD
);

echo(
    "Airway diameter =",
    DUCT_ID
);

echo(
    "View mode =",
    VIEW_MODE
);

echo(
    "Global datum = (0,0,0)"
);

echo(
    "============================================"
);