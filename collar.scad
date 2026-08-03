/*
FILE 2 - ELECTRONICS AND CAMERA COLLAR

Global origin: (0,0,0)

File 1 core OD: 74.0 mm
Collar ID: 74.2 mm
Diametral clearance: 0.2 mm

Height: 25 mm
Z range: -12.5 to +12.5 mm

Camera stations:
0, 90, 180, 270 degrees

Camera cavity:
14.2 x 14.2 x 15 mm

Female keyways:
45, 135, 225, 315 degrees
*/

$fn = 100;


// ============================================================
// BASIC DIMENSIONS
// ============================================================

core_od = 74;
collar_id = 74.2;

collar_inner_radius = collar_id / 2;

collar_wall = 2;

collar_outer_radius =
    collar_inner_radius + collar_wall;

collar_height = 25;


// ============================================================
// CAMERA DIMENSIONS
// ============================================================

camera_count = 4;

camera_width = 14.2;
camera_height = 14.2;
camera_depth = 15;

camera_wall = 1.2;
camera_back_wall = 1.0;


// Housing dimensions

camera_outer_width =
    camera_width + 2 * camera_wall;

camera_outer_height =
    camera_height + 2 * camera_wall;

camera_outer_depth =
    camera_depth + camera_back_wall;


// ============================================================
// FILE 1 KEY DIMENSIONS
// ============================================================

key_count = 4;

key_angle_offset = 45;

file1_key_width = 3;
file1_key_projection = 1.5;
file1_key_height = 14;


// Female keyway clearance

key_clearance = 0.2;

keyway_width =
    file1_key_width + 2 * key_clearance;

keyway_depth =
    file1_key_projection + key_clearance;

keyway_height =
    file1_key_height + 2 * key_clearance;


// ============================================================
// BATTERY SUPPORTS
// ============================================================

battery_angle_1 = 45;
battery_angle_2 = 225;

battery_arc_angle = 32;

battery_depth = 4;

battery_height = 16;

battery_wall = 1.2;


// ============================================================
// BOOLEAN TOLERANCE
// ============================================================

eps = 0.05;


// ============================================================
// MAIN MODEL
// ============================================================

electronics_camera_collar();


// ============================================================
// COMPLETE COLLAR
// ============================================================

module electronics_camera_collar()
{
    difference()
    {
        union()
        {
            collar_ring();

            camera_housings();

            battery_supports();
        }

        female_keyways();

        camera_pockets();

        battery_cavities();
    }
}


// ============================================================
// MAIN COLLAR
// ============================================================

module collar_ring()
{
    difference()
    {
        cylinder(
            h = collar_height,
            r = collar_outer_radius,
            center = true
        );

        cylinder(
            h = collar_height + 0.2,
            r = collar_inner_radius,
            center = true
        );
    }
}


// ============================================================
// CAMERA HOUSINGS
// ============================================================

module camera_housings()
{
    for (i = [0 : camera_count - 1])
    {
        angle =
            i * 360 / camera_count;

        rotate([0,0,angle])

        translate([
            collar_outer_radius - eps,
            -camera_outer_width / 2,
            -camera_outer_height / 2
        ])

        cube([
            camera_outer_depth + eps,
            camera_outer_width,
            camera_outer_height
        ]);
    }
}


// ============================================================
// CAMERA POCKETS
// ============================================================

module camera_pockets()
{
    for (i = [0 : camera_count - 1])
    {
        angle =
            i * 360 / camera_count;

        rotate([0,0,angle])

        translate([
            collar_outer_radius +
            camera_back_wall,

            -camera_width / 2,

            -camera_height / 2
        ])

        cube([
            camera_depth + eps,
            camera_width,
            camera_height
        ]);
    }
}


// ============================================================
// FEMALE KEYWAYS
// ============================================================

module female_keyways()
{
    for (i = [0 : key_count - 1])
    {
        angle =
            key_angle_offset +
            i * 360 / key_count;

        rotate([0,0,angle])

        translate([
            collar_inner_radius - eps,
            -keyway_width / 2,
            -keyway_height / 2
        ])

        cube([
            keyway_depth + eps,
            keyway_width,
            keyway_height
        ]);
    }
}


// ============================================================
// BATTERY SUPPORTS
// ============================================================

module battery_supports()
{
    battery_support(battery_angle_1);

    battery_support(battery_angle_2);
}


module battery_support(angle_position)
{
    rotate([
        0,
        0,
        angle_position -
        battery_arc_angle / 2
    ])

    rotate_extrude(
        angle = battery_arc_angle
    )

    translate([
        collar_outer_radius - eps,
        -battery_height / 2 -
        battery_wall
    ])

    square([
        battery_depth +
        battery_wall +
        eps,

        battery_height +
        2 * battery_wall
    ]);
}


// ============================================================
// BATTERY CAVITIES
// ============================================================

module battery_cavities()
{
    battery_cavity(battery_angle_1);

    battery_cavity(battery_angle_2);
}


module battery_cavity(angle_position)
{
    rotate([
        0,
        0,
        angle_position -
        battery_arc_angle / 2
    ])

    rotate_extrude(
        angle = battery_arc_angle
    )

    translate([
        collar_outer_radius,
        -battery_height / 2
    ])

    square([
        battery_depth,
        battery_height
    ]);
}


// ============================================================
// OUTPUT
// ============================================================

echo("FILE 2 - ELECTRONICS CAMERA COLLAR");

echo(
    "Collar ID =",
    collar_id
);

echo(
    "Collar OD =",
    collar_outer_radius * 2
);

echo(
    "Height =",
    collar_height
);

echo(
    "Core/collar diametral clearance =",
    collar_id - core_od
);

echo(
    "Camera pocket width =",
    camera_width
);

echo(
    "Camera pocket height =",
    camera_height
);

echo(
    "Camera pocket depth =",
    camera_depth
);