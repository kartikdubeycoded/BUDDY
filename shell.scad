/*
FILE 3 - OPEN MESH CRASH SHELL

Global origin: (0,0,0)

Outer diameter: 115 mm
Inner diameter: 111 mm
Wall thickness: 2 mm

Polar opening:
74.2 mm

Landing rings:
North and South

Mesh:
Symmetric staggered spherical perforations
*/

$fn = 100;


// ============================================================
// SHELL
// ============================================================

shell_od = 115;
shell_id = 111;

shell_outer_radius =
    shell_od / 2;

shell_inner_radius =
    shell_id / 2;


// ============================================================
// POLAR OPENING
// ============================================================

opening_diameter = 74.2;

opening_radius =
    opening_diameter / 2;


// ============================================================
// LANDING RINGS
// ============================================================

landing_width = 4;

landing_thickness = 2;

landing_outer_radius =
    opening_radius + landing_width;


// Position where opening meets inner sphere

landing_z =
    sqrt(
        shell_inner_radius *
        shell_inner_radius
        -
        opening_radius *
        opening_radius
    );


// ============================================================
// FASTENERS
// ============================================================

screw_count = 4;

screw_diameter = 1.8;

screw_radius =
    opening_radius +
    landing_width / 2;

screw_angle_offset = 45;


// ============================================================
// MESH
// ============================================================

latitude_bands = 7;

equator_segments = 20;


// Keep mesh away from polar mounts

maximum_latitude = 40;


// Mesh opening dimensions

mesh_width = 8;

mesh_height = 7;

mesh_depth = 4;


// ============================================================
// BOOLEAN TOLERANCE
// ============================================================

eps = 0.05;


// ============================================================
// MAIN
// ============================================================

open_mesh_shell();


// ============================================================
// COMPLETE SHELL
// ============================================================

module open_mesh_shell()
{
    difference()
    {
        union()
        {
            perforated_sphere();

            landing_rings();
        }

        polar_opening();

        screw_holes();
    }
}


// ============================================================
// PERFORATED SPHERE
// ============================================================

module perforated_sphere()
{
    difference()
    {
        hollow_sphere();

        mesh_cutouts();
    }
}


// ============================================================
// HOLLOW SPHERE
// ============================================================

module hollow_sphere()
{
    difference()
    {
        sphere(
            r = shell_outer_radius
        );

        sphere(
            r = shell_inner_radius
        );
    }
}


// ============================================================
// POLAR OPENING
// ============================================================

module polar_opening()
{
    cylinder(
        h = shell_od + 10,
        r = opening_radius,
        center = true
    );
}


// ============================================================
// LANDING RINGS
// ============================================================

module landing_rings()
{
    translate([
        0,
        0,
        landing_z - landing_thickness
    ])
    landing_ring();

    translate([
        0,
        0,
        -landing_z
    ])
    landing_ring();
}


module landing_ring()
{
    difference()
    {
        cylinder(
            h = landing_thickness,
            r = landing_outer_radius
        );

        translate([
            0,
            0,
            -eps
        ])
        cylinder(
            h = landing_thickness + 2 * eps,
            r = opening_radius
        );
    }
}


// ============================================================
// SCREW HOLES
// ============================================================

module screw_holes()
{
    for (i = [0 : screw_count - 1])
    {
        angle =
            screw_angle_offset +
            i * 360 / screw_count;

        rotate([0,0,angle])

        translate([
            screw_radius,
            0,
            landing_z -
            landing_thickness -
            eps
        ])

        cylinder(
            h = landing_thickness + 2 * eps,
            d = screw_diameter
        );


        rotate([0,0,angle])

        translate([
            screw_radius,
            0,
            -landing_z -
            eps
        ])

        cylinder(
            h = landing_thickness + 2 * eps,
            d = screw_diameter
        );
    }
}


// ============================================================
// SPHERICAL MESH
// ============================================================

module mesh_cutouts()
{
    for (
        band =
        [-latitude_bands :
        latitude_bands]
    )
    {
        latitude =
            band *
            maximum_latitude /
            latitude_bands;

        segments =
            max(
                8,
                round(
                    equator_segments *
                    cos(latitude)
                )
            );

        stagger =
            ((band + latitude_bands) % 2)
            *
            180 / segments;


        for (
            segment =
            [0 : segments - 1]
        )
        {
            longitude =
                segment *
                360 /
                segments +
                stagger;

            mesh_window(
                latitude,
                longitude
            );
        }
    }
}


// ============================================================
// POSITION MESH WINDOW
// ============================================================

module mesh_window(latitude, longitude)
{
    rotate([
        0,
        0,
        longitude
    ])

    rotate([
        0,
        -latitude,
        0
    ])

    translate([
        (shell_outer_radius +
         shell_inner_radius) / 2,
        0,
        0
    ])

    rotate([
        0,
        90,
        0
    ])

    cube([
        mesh_width,
        mesh_height,
        mesh_depth
    ],
    center = true);
}


// ============================================================
// OUTPUT
// ============================================================

echo("FILE 3 - OPEN MESH CRASH SHELL");

echo(
    "Shell OD =",
    shell_od
);

echo(
    "Shell ID =",
    shell_id
);

echo(
    "Wall thickness =",
    (shell_od - shell_id) / 2
);

echo(
    "Polar opening =",
    opening_diameter
);

echo(
    "Landing Z =",
    landing_z
);

echo(
    "Landing outer diameter =",
    landing_outer_radius * 2
);