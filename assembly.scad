/*
============================================================
COMPLETE SPHERICAL DRONE - ENGINEERING ASSEMBLY VIEW
============================================================

This file VISUALIZES the complete architecture.

Structural files:
    core.scad
    collar.scad
    shell.scad

Reference hardware shown here:
    - central motor
    - rotor disk
    - flight board
    - four cameras
    - two battery packs
    - four bottom steering vanes

Reference hardware is NOT intended for STL export yet.
============================================================
*/

$fn = 100;


// ============================================================
// IMPORT STRUCTURAL COMPONENTS
// ============================================================

use <core.scad>
use <collar.scad>
use <shell.scad>


// ============================================================
// VIEW CONTROLS
// ============================================================

show_core = true;
show_collar = true;
show_shell = true;

show_motor = true;
show_rotor = true;
show_board = true;
show_cameras = true;
show_batteries = true;
show_vanes = true;


// ============================================================
// MASTER ASSEMBLY
// ============================================================

complete_drone();


module complete_drone()
{
    // --------------------------------------------------------
    // REAL STRUCTURAL PARTS
    // --------------------------------------------------------

    if (show_shell)
        color([0.75,0.75,0.75,0.45])
            open_mesh_shell();

    if (show_core)
        color([0.25,0.45,0.85])
            wind_tunnel_core();

    if (show_collar)
        color([0.20,0.20,0.20])
            electronics_camera_collar();


    // --------------------------------------------------------
    // REFERENCE HARDWARE
    // --------------------------------------------------------

    if (show_motor)
        reference_motor();

    if (show_rotor)
        reference_rotor();

    if (show_board)
        reference_flight_board();

    if (show_cameras)
        reference_cameras();

    if (show_batteries)
        reference_batteries();

    if (show_vanes)
        reference_vanes();
}


// ============================================================
// MOTOR
// ============================================================

module reference_motor()
{
    /*
        CONCEPTUAL MOTOR ONLY.

        Replace these dimensions after actual motor selection.
    */

    motor_diameter = 22;
    motor_height = 12;

    color([0.15,0.15,0.15])

    translate([
        0,
        0,
        15
    ])

    cylinder(
        h = motor_height,
        d = motor_diameter,
        center = true
    );


    // Motor shaft

    color([0.65,0.65,0.65])

    translate([
        0,
        0,
        24
    ])

    cylinder(
        h = 8,
        d = 3,
        center = true
    );
}


// ============================================================
// ROTOR / PROPELLER REFERENCE
// ============================================================

module reference_rotor()
{
    /*
        Conceptual rotor.

        Diameter deliberately kept inside 70 mm duct.

        Actual propeller geometry must be selected later.
    */

    rotor_diameter = 64;
    blade_width = 8;
    blade_thickness = 1.5;

    rotor_z = 28;


    color([0.8,0.25,0.20])

    translate([
        0,
        0,
        rotor_z
    ])

    union()
    {
        // Blade 1

        cube([
            rotor_diameter,
            blade_width,
            blade_thickness
        ],
        center = true);


        // Blade 2

        rotate([0,0,90])

        cube([
            rotor_diameter,
            blade_width,
            blade_thickness
        ],
        center = true);


        // Hub

        cylinder(
            h = blade_thickness + 2,
            d = 10,
            center = true
        );
    }
}


// ============================================================
// FLIGHT CONTROLLER BOARD
// ============================================================

module reference_flight_board()
{
    /*
        Conceptual 30 x 30 mm electronics board.

        IMPORTANT:
        This is shown for packaging understanding.

        Final board location/mount architecture requires
        actual PCB dimensions.
    */

    board_x = 30;
    board_y = 30;
    board_z = 2;


    color([0.10,0.55,0.20])

    translate([
        0,
        0,
        0
    ])

    cube([
        board_x,
        board_y,
        board_z
    ],
    center = true);
}


// ============================================================
// FOUR CAMERAS
// ============================================================

module reference_cameras()
{
    camera_size = 14;
    camera_depth = 14;

    camera_radius = 47;


    for (i = [0:3])
    {
        angle = i * 90;


        rotate([
            0,
            0,
            angle
        ])

        translate([
            camera_radius,
            0,
            0
        ])

        color([0.10,0.10,0.10])

        cube([
            camera_depth,
            camera_size,
            camera_size
        ],
        center = true);


        // Lens reference

        rotate([
            0,
            0,
            angle
        ])

        translate([
            camera_radius +
            camera_depth / 2 +
            1,

            0,
            0
        ])

        rotate([
            0,
            90,
            0
        ])

        color([0.15,0.25,0.35])

        cylinder(
            h = 3,
            d = 6,
            center = true
        );
    }
}


// ============================================================
// TWO SYMMETRIC BATTERY PACKS
// ============================================================

module reference_batteries()
{
    /*
        CONCEPTUAL battery envelopes.

        NOT final LiPo dimensions.
    */

    battery_length = 24;
    battery_width = 8;
    battery_height = 14;

    battery_radius = 44;


    // Battery A

    rotate([0,0,45])

    translate([
        battery_radius,
        0,
        0
    ])

    color([0.65,0.35,0.15])

    cube([
        battery_width,
        battery_length,
        battery_height
    ],
    center = true);


    // Battery B

    rotate([0,0,225])

    translate([
        battery_radius,
        0,
        0
    ])

    color([0.65,0.35,0.15])

    cube([
        battery_width,
        battery_length,
        battery_height
    ],
    center = true);
}


// ============================================================
// FOUR STEERING VANES
// ============================================================

module reference_vanes()
{
    /*
        Conceptual thrust-vectoring vanes.

        These sit near the lower outlet.

        Actual pivot/servo architecture still requires
        mechanical design.
    */

    vane_length = 18;
    vane_width = 12;
    vane_thickness = 1.2;

    vane_radius = 17;

    vane_z = -29;


    for (i = [0:3])
    {
        angle = i * 90;


        rotate([
            0,
            0,
            angle
        ])

        translate([
            vane_radius,
            0,
            vane_z
        ])

        color([0.85,0.65,0.15])

        cube([
            vane_length,
            vane_thickness,
            vane_width
        ],
        center = true);
    }
}