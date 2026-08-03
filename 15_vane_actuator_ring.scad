/*
================================================================
AIDRONE
FILE 15 / 24
VANE ACTUATOR + LINKAGE RING

PURPOSE
-------
Mechanical control architecture for the four thrust-vectoring
vanes defined in 14_vane_system.scad.

Creates:
- external actuator carrier ring
- four symmetric actuator stations
- actuator keep-out pockets
- radial vane control horns
- linkage envelopes
- mechanical +/-25 degree stop geometry
- wiring channels
- shell clearance validation

IMPORTANT
---------
No specific servo is assumed.

ACTUATOR_* dimensions are packaging envelopes only.

Final design requires:
- actuator selection
- measured actuator torque
- linkage force analysis
- backlash testing
- vibration testing
================================================================
*/


include <00_master_parameters.scad>
include <02_materials_tolerances.scad>


$fn = 100;


// ============================================================
// 1. VEHICLE
// ============================================================

VEHICLE_D = 115;

VEHICLE_R =
    VEHICLE_D / 2;


SHELL_INNER_D = 111;

SHELL_INNER_R =
    SHELL_INNER_D / 2;


// ============================================================
// 2. DUCT
// ============================================================

DUCT_OD_LOCAL = 74;

DUCT_OUTER_R =
    DUCT_OD_LOCAL / 2;


DUCT_ID_LOCAL = 70;


// ============================================================
// 3. VANE DATUM
// ============================================================

VANE_COUNT = 4;

VANE_CENTER_Z = -27;

MAX_VANE_ANGLE = 25;


// ============================================================
// 4. ACTUATOR RING
// ============================================================

/*
Ring is positioned outside the duct.

Inner diameter uses the sliding-fit rule from the tolerance
authority.

74 mm duct + 0.20 mm clearance per side = 74.4 mm bore.
*/

RING_ID =
    female_bore_for_male(
        DUCT_OD_LOCAL,
        CLEARANCE_SLIDING
    );


RING_INNER_R =
    RING_ID / 2;


RING_RADIAL_WALL = 2.4;


RING_OD =
    RING_ID +
    2 * RING_RADIAL_WALL;


RING_OUTER_R =
    RING_OD / 2;


RING_HEIGHT = 8;


RING_Z =
    VANE_CENTER_Z;


// ============================================================
// 5. ACTUATOR ENVELOPE
// ============================================================

/*
Placeholder envelope.

This does NOT correspond to a selected commercial actuator.

The purpose is to reserve packaging volume.
*/

ACTUATOR_WIDTH = 8;

ACTUATOR_DEPTH = 5;

ACTUATOR_HEIGHT = 10;


// ============================================================
// 6. ACTUATOR RADIAL POSITION
// ============================================================

ACTUATOR_CENTER_R =

    RING_OUTER_R +

    ACTUATOR_DEPTH / 2;


// ============================================================
// 7. CONTROL HORN
// ============================================================

HORN_LENGTH = 5;

HORN_WIDTH = 2;

HORN_THICKNESS = 1.5;


// ============================================================
// 8. LINKAGE
// ============================================================

LINKAGE_D = 1.2;


// Packaging clearance around moving linkage.

LINKAGE_KEEP_OUT_D =
    LINKAGE_D +
    2 * CLEARANCE_MOVING;


// ============================================================
// 9. LINKAGE RADIAL DATUM
// ============================================================

VANE_PIVOT_RADIUS =

    7 +
    25 / 2;


HORN_CONNECTION_RADIUS =

    VANE_PIVOT_RADIUS +
    HORN_LENGTH;


// ============================================================
// 10. WIRING
// ============================================================

WIRE_BUNDLE_WIDTH = 2;

WIRE_BUNDLE_HEIGHT = 2;


WIRE_CHANNEL_W =
    wire_channel_width(
        WIRE_BUNDLE_WIDTH
    );


WIRE_CHANNEL_H =
    WIRE_BUNDLE_HEIGHT +
    1;


// ============================================================
// 11. MECHANICAL STOPS
// ============================================================

STOP_WIDTH = 2;

STOP_DEPTH = 2;

STOP_HEIGHT = 3;


// ============================================================
// 12. DISPLAY
// ============================================================

SHOW_RING = true;

SHOW_ACTUATOR_ENVELOPES = true;

SHOW_HORNS = true;

SHOW_LINKAGES = true;

SHOW_STOPS = true;

SHOW_DUCT = false;

SHOW_SPHERE = false;

SHOW_SHELL_INNER = false;


// ============================================================
// 13. MAIN
// ============================================================

actuator_system();


// ============================================================
// 14. COMPLETE SYSTEM
// ============================================================

module actuator_system()
{
    if (SHOW_RING)
    {
        actuator_ring();
    }


    for (
        station = [
            0 :
            VANE_COUNT - 1
        ]
    )
    {
        if (
            SHOW_ACTUATOR_ENVELOPES
        )
        {
            %actuator_envelope_at_station(
                station
            );
        }


        if (
            SHOW_HORNS
        )
        {
            control_horn_at_station(
                station
            );
        }


        if (
            SHOW_LINKAGES
        )
        {
            %linkage_at_station(
                station
            );
        }


        if (
            SHOW_STOPS
        )
        {
            mechanical_stops_at_station(
                station
            );
        }
    }


    if (
        SHOW_DUCT
    )
    {
        %duct_reference();
    }


    if (
        SHOW_SPHERE
    )
    {
        %sphere_reference();
    }


    if (
        SHOW_SHELL_INNER
    )
    {
        %shell_inner_reference();
    }
}


// ============================================================
// 15. ACTUATOR RING
// ============================================================

module actuator_ring()
{
    translate([
        0,
        0,
        RING_Z
    ])

    difference()
    {
        cylinder(
            h = RING_HEIGHT,
            d = RING_OD,
            center = true
        );


        cylinder(
            h = RING_HEIGHT + 0.2,
            d = RING_ID,
            center = true
        );


        wiring_channels();
    }
}


// ============================================================
// 16. WIRING CHANNELS
// ============================================================

module wiring_channels()
{
    for (
        station = [
            0 :
            VANE_COUNT - 1
        ]
    )
    {
        angle =
            station *
            360 /
            VANE_COUNT;


        rotate([
            0,
            0,
            angle
        ])

        translate([
            RING_INNER_R +
            RING_RADIAL_WALL / 2,

            0,

            0
        ])

        cube([
            RING_RADIAL_WALL + 1,

            WIRE_CHANNEL_W,

            WIRE_CHANNEL_H
        ],

        center = true);
    }
}


// ============================================================
// 17. ACTUATOR ENVELOPE
// ============================================================

module actuator_envelope_at_station(
    station
)
{
    angle =
        station *
        360 /
        VANE_COUNT;


    translate([
        0,
        0,
        RING_Z
    ])

    rotate([
        0,
        0,
        angle
    ])

    translate([
        ACTUATOR_CENTER_R,
        0,
        0
    ])

    cube([
        ACTUATOR_DEPTH,
        ACTUATOR_WIDTH,
        ACTUATOR_HEIGHT
    ],

    center = true);
}


// ============================================================
// 18. CONTROL HORN
// ============================================================

module control_horn_at_station(
    station
)
{
    angle =
        station *
        360 /
        VANE_COUNT;


    translate([
        0,
        0,
        VANE_CENTER_Z
    ])

    rotate([
        0,
        0,
        angle
    ])

    translate([
        VANE_PIVOT_RADIUS,
        0,
        0
    ])

    cube([
        HORN_LENGTH,
        HORN_WIDTH,
        HORN_THICKNESS
    ]);
}


// ============================================================
// 19. LINKAGE
// ============================================================

module linkage_at_station(
    station
)
{
    angle =
        station *
        360 /
        VANE_COUNT;


    /*
    Simplified straight linkage envelope.

    Final geometry depends on actuator output motion.
    */


    radial_start =
        HORN_CONNECTION_RADIUS;


    radial_end =
        ACTUATOR_CENTER_R;


    linkage_length =
        radial_end -
        radial_start;


    translate([
        0,
        0,
        VANE_CENTER_Z
    ])

    rotate([
        0,
        0,
        angle
    ])

    translate([
        radial_start +
        linkage_length / 2,

        0,

        0
    ])

    rotate([
        0,
        90,
        0
    ])

    cylinder(
        h = linkage_length,
        d = LINKAGE_KEEP_OUT_D,
        center = true
    );
}


// ============================================================
// 20. MECHANICAL STOPS
// ============================================================

module mechanical_stops_at_station(
    station
)
{
    angle =
        station *
        360 /
        VANE_COUNT;


    translate([
        0,
        0,
        VANE_CENTER_Z
    ])

    rotate([
        0,
        0,
        angle
    ])

    union()
    {
        rotate([
            MAX_VANE_ANGLE,
            0,
            0
        ])

        stop_block();


        rotate([
            -MAX_VANE_ANGLE,
            0,
            0
        ])

        stop_block();
    }
}


// ============================================================
// 21. STOP BLOCK
// ============================================================

module stop_block()
{
    translate([
        VANE_PIVOT_RADIUS +
        HORN_LENGTH,

        0,

        0
    ])

    cube([
        STOP_DEPTH,
        STOP_WIDTH,
        STOP_HEIGHT
    ],

    center = true);
}


// ============================================================
// 22. DUCT REFERENCE
// ============================================================

module duct_reference()
{
    difference()
    {
        cylinder(
            h = 70,
            d = 74,
            center = true
        );

        cylinder(
            h = 70.2,
            d = 70,
            center = true
        );
    }
}


// ============================================================
// 23. SPHERE REFERENCE
// ============================================================

module sphere_reference()
{
    sphere(
        d = VEHICLE_D
    );
}


// ============================================================
// 24. SHELL INNER REFERENCE
// ============================================================

module shell_inner_reference()
{
    sphere(
        d = SHELL_INNER_D
    );
}


// ============================================================
// 25. SPHERE RADIUS AT Z
// ============================================================

function sphere_radius_at_z(
    sphere_r,
    z
) =

    abs(z) <= sphere_r

    ?

    sqrt(
        sphere_r * sphere_r -
        z * z
    )

    :

    0;


// ============================================================
// 26. AVAILABLE SHELL SPACE
// ============================================================

AVAILABLE_SHELL_RADIUS =

    sphere_radius_at_z(
        SHELL_INNER_R,
        RING_Z
    );


// ============================================================
// 27. ACTUATOR MAXIMUM RADIUS
// ============================================================

ACTUATOR_MAX_RADIUS =

    ACTUATOR_CENTER_R +

    ACTUATOR_DEPTH / 2;


// ============================================================
// 28. SHELL CLEARANCE
// ============================================================

ACTUATOR_TO_SHELL_CLEARANCE =

    AVAILABLE_SHELL_RADIUS -

    ACTUATOR_MAX_RADIUS;


// ============================================================
// 29. RING CROSS SECTION
// ============================================================

RING_CROSS_SECTION_AREA =

    PI *

    (
        RING_OUTER_R *
        RING_OUTER_R

        -

        RING_INNER_R *
        RING_INNER_R
    );


// ============================================================
// 30. VALIDATION
// ============================================================

assert(
    VANE_COUNT == 4,

    "FAIL: actuator system requires fourfold symmetry."
);


assert(
    RING_ID >=
    74.4,

    "FAIL: actuator ring bore too small for duct sliding fit."
);


assert(
    RING_RADIAL_WALL >=
    MOTOR_SUPPORT_MIN_THICKNESS,

    "FAIL: actuator ring wall below structural manufacturing rule."
);


assert(
    ACTUATOR_TO_SHELL_CLEARANCE >=
    0.2,

    "FAIL: actuator envelope intersects inner crash shell."
);


assert(
    ACTUATOR_MAX_RADIUS <
    VEHICLE_R,

    "FAIL: actuator exits 115 mm vehicle envelope."
);


assert(
    MAX_VANE_ANGLE ==
    25,

    "FAIL: mechanical stop architecture no longer matches vane limit."
);


// ============================================================
// 31. OUTPUT
// ============================================================

echo(
    "============================================"
);

echo(
    "AIDRONE FILE 15 — VANE ACTUATOR RING"
);

echo(
    "Ring bore =",
    RING_ID
);

echo(
    "Ring OD =",
    RING_OD
);

echo(
    "Ring height =",
    RING_HEIGHT
);

echo(
    "Ring Z =",
    RING_Z
);

echo(
    "Actuator envelope =",
    ACTUATOR_WIDTH,
    ACTUATOR_DEPTH,
    ACTUATOR_HEIGHT
);

echo(
    "Actuator center radius =",
    ACTUATOR_CENTER_R
);

echo(
    "Actuator maximum radius =",
    ACTUATOR_MAX_RADIUS
);

echo(
    "Available shell radius at Z =",
    AVAILABLE_SHELL_RADIUS
);

echo(
    "Actuator/shell clearance =",
    ACTUATOR_TO_SHELL_CLEARANCE
);

echo(
    "Linkage keep-out diameter =",
    LINKAGE_KEEP_OUT_D
);

echo(
    "Mechanical vane limit = +/-",
    MAX_VANE_ANGLE
);

echo(
    "============================================"
);