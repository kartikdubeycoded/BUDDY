/*
FILE 1 - WIND TUNNEL CORE

Global origin: (0,0,0)

Airway diameter: 70 mm
Wall thickness: 2 mm
Outer diameter: 74 mm
Height: 70 mm
Z range: -35 to +35 mm

Board mounts:
0, 90, 180, 270 degrees

Male anti-rotation keys:
45, 135, 225, 315 degrees
*/

$fn = 100;


// ============================================================
// CORE DIMENSIONS
// ============================================================

airway_diameter = 70;
airway_radius = airway_diameter / 2;

wall_thickness = 2;

core_outer_radius = airway_radius + wall_thickness;
core_outer_diameter = core_outer_radius * 2;

core_height = 70;


// ============================================================
// BOARD MOUNT DIMENSIONS
// ============================================================

board_mount_count = 4;

board_mount_length = 4;
board_mount_width = 7;
board_mount_height = 3;

board_hole_diameter = 2.2;
board_hole_offset = 2;


// ============================================================
// KEY DIMENSIONS
// ============================================================

key_count = 4;

key_projection = 1.5;
key_width = 3;
key_height = 14;

key_angle_offset = 45;


// ============================================================
// BOOLEAN TOLERANCE
// ============================================================

eps = 0.05;


// ============================================================
// MAIN MODEL
// ============================================================

wind_tunnel_core();


// ============================================================
// COMPLETE CORE
// ============================================================

module wind_tunnel_core()
{
    difference()
    {
        union()
        {
            core_tube();
            board_mounts();
            anti_rotation_keys();
        }

        board_mount_holes();
    }
}


// ============================================================
// CENTERED HOLLOW CORE
// ============================================================

module core_tube()
{
    difference()
    {
        cylinder(
            h = core_height,
            r = core_outer_radius,
            center = true
        );

        cylinder(
            h = core_height + 0.2,
            r = airway_radius,
            center = true
        );
    }
}


// ============================================================
// FOUR EXTERNAL BOARD MOUNTS
// ============================================================

module board_mounts()
{
    for (i = [0 : board_mount_count - 1])
    {
        angle = i * 360 / board_mount_count;

        rotate([0, 0, angle])
        translate([
            core_outer_radius - eps,
            -board_mount_width / 2,
            -board_mount_height / 2
        ])
        cube([
            board_mount_length + eps,
            board_mount_width,
            board_mount_height
        ]);
    }
}


// ============================================================
// BOARD MOUNT HOLES
// ============================================================

module board_mount_holes()
{
    for (i = [0 : board_mount_count - 1])
    {
        angle = i * 360 / board_mount_count;

        rotate([0, 0, angle])
        translate([
            core_outer_radius + board_hole_offset,
            0,
            0
        ])
        cylinder(
            h = board_mount_height + 0.2,
            d = board_hole_diameter,
            center = true
        );
    }
}


// ============================================================
// FOUR MALE ANTI-ROTATION KEYS
// ============================================================

module anti_rotation_keys()
{
    for (i = [0 : key_count - 1])
    {
        angle = key_angle_offset + i * 360 / key_count;

        rotate([0, 0, angle])
        translate([
            core_outer_radius - eps,
            -key_width / 2,
            -key_height / 2
        ])
        cube([
            key_projection + eps,
            key_width,
            key_height
        ]);
    }
}


// ============================================================
// CONSOLE OUTPUT
// ============================================================

echo("FILE 1 - WIND TUNNEL CORE");
echo("Airway diameter =", airway_diameter);
echo("Core outer diameter =", core_outer_diameter);
echo("Core height =", core_height);
echo("Core Z minimum =", -core_height / 2);
echo("Core Z maximum =", core_height / 2);
echo("Maximum key radius =", core_outer_radius + key_projection);
echo("File 2 collar nominal ID = 74.2 mm");