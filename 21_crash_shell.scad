/*
================================================================
AIDRONE
FILE 21 / 24
115 MM OPEN-MESH CRASH SHELL

PURPOSE
-------
Creates the external spherical protective structure.

FEATURES
--------
- Ø115 mm external envelope
- Ø111 mm nominal internal envelope
- 2 mm shell thickness
- Ø74.4 mm polar propulsion openings
- upper/lower duct landing interfaces
- latitude/longitude structural lattice
- four camera optical windows
- battery/service access zones
- vane/actuator keep-out region
- fully symmetric construction

IMPORTANT
---------
This geometry does NOT prove impact survival.

Final crashworthiness requires:
- material selection
- print orientation study
- FEA
- drop testing
- rotor containment testing

GLOBAL DATUM
------------
Origin = sphere center.
================================================================
*/


include <00_master_parameters.scad>
include <02_materials_tolerances.scad>

$fn = 100;


// ============================================================
// 1. SPHERE
// ============================================================

SHELL_OD = 115.0;
SHELL_OR = SHELL_OD / 2;

SHELL_ID = 111.0;
SHELL_IR = SHELL_ID / 2;

SHELL_THICKNESS =
    (SHELL_OD - SHELL_ID) / 2;


// ============================================================
// 2. PROPULSION OPENING
// ============================================================

DUCT_OD = 74.0;

DUCT_INTERFACE_CLEARANCE = 0.2;

POLAR_OPENING_D =
    DUCT_OD +
    2 * DUCT_INTERFACE_CLEARANCE;

POLAR_OPENING_R =
    POLAR_OPENING_D / 2;


// ============================================================
// 3. POLAR OPENING CUT HEIGHT
// ============================================================

POLAR_CUT_H = 30;


// ============================================================
// 4. DUCT LANDING RINGS
// ============================================================

LANDING_RING_ID =
    POLAR_OPENING_D;

LANDING_RING_RADIAL_WIDTH =
    2.5;

LANDING_RING_OD =
    LANDING_RING_ID +
    2 * LANDING_RING_RADIAL_WIDTH;

LANDING_RING_H =
    2.0;


// ============================================================
// 5. LANDING RING POSITION
// ============================================================

/*
The central duct ends at +/-35 mm.

Landing rings sit at those planes.
*/

DUCT_TOP_Z = 35.0;
DUCT_BOTTOM_Z = -35.0;


// ============================================================
// 6. LATTICE
// ============================================================

/*
Instead of subtracting arbitrary holes from a thin sphere,
the cage is generated from structural ribs.

This makes rib thickness explicit and predictable.
*/

RIB_DIAMETER = 2.4;


// ============================================================
// 7. LONGITUDE RIB COUNT
// ============================================================

LONGITUDE_COUNT = 8;


// ============================================================
// 8. LATITUDE POSITIONS
// ============================================================

/*
Avoid the polar duct openings.

Latitudes are mirrored around Z=0.
*/

LATITUDE_Z = [
    -28,
    -18,
    -9,
    0,
    9,
    18,
    28
];


// ============================================================
// 9. CAMERA WINDOWS
// ============================================================

CAMERA_COUNT = 4;

CAMERA_WINDOW_W = 18.0;
CAMERA_WINDOW_H = 18.0;

CAMERA_WINDOW_DEPTH = 12;

CAMERA_WINDOW_CENTER_R =
    SHELL_OR;


// ============================================================
// 10. CAMERA Z
// ============================================================

CAMERA_Z = 0;


// ============================================================
// 11. BATTERY SERVICE WINDOWS
// ============================================================

BATTERY_WINDOW_W = 28;
BATTERY_WINDOW_H = 34;
BATTERY_WINDOW_DEPTH = 12;

BATTERY_Z = 5;

BATTERY_AXIS_ANGLE = 90;


// ============================================================
// 12. ACTUATOR SERVICE BAND
// ============================================================

/*
Four actuator stations around Z=-27.

Open local access windows instead of removing the entire
lower hemisphere.
*/

ACTUATOR_Z = -27;

ACTUATOR_WINDOW_W = 12;
ACTUATOR_WINDOW_H = 14;
ACTUATOR_WINDOW_DEPTH = 12;


// ============================================================
// 13. SCREW INTERFACE
// ============================================================

SCREW_COUNT_PER_RING = 4;

SCREW_D = 2.0;

SCREW_CLEARANCE_D = 2.3;

SCREW_RADIUS =
    (
        LANDING_RING_ID / 2 +
        LANDING_RING_OD / 2
    ) / 2;


// ============================================================
// 14. DISPLAY
// ============================================================

SHOW_SHELL = true;

SHOW_DUCT_REFERENCE = false;
SHOW_CAMERA_WINDOWS = false;
SHOW_BATTERY_WINDOWS = false;
SHOW_ACTUATOR_WINDOWS = false;


// ============================================================
// 15. MAIN
// ============================================================

crash_shell_system();


// ============================================================
// 16. COMPLETE SYSTEM
// ============================================================

module crash_shell_system()
{
    if (SHOW_SHELL)
    {
        difference()
        {
            union()
            {
                spherical_lattice();

                upper_landing_ring();

                lower_landing_ring();
            }

            polar_openings();

            camera_windows();

            battery_service_windows();

            actuator_service_windows();

            landing_ring_screw_holes();
        }
    }


    if (SHOW_DUCT_REFERENCE)
    {
        %duct_reference();
    }


    if (SHOW_CAMERA_WINDOWS)
    {
        %camera_windows();
    }


    if (SHOW_BATTERY_WINDOWS)
    {
        %battery_service_windows();
    }


    if (SHOW_ACTUATOR_WINDOWS)
    {
        %actuator_service_windows();
    }
}


// ============================================================
// 17. SPHERICAL LATTICE
// ============================================================

module spherical_lattice()
{
    intersection()
    {
        spherical_shell_band();

        union()
        {
            longitude_ribs();

            latitude_ribs();

            equatorial_reinforcement();
        }
    }
}


// ============================================================
// 18. SPHERICAL SHELL BAND
// ============================================================

module spherical_shell_band()
{
    difference()
    {
        sphere(
            r = SHELL_OR
        );

        sphere(
            r = SHELL_IR
        );
    }
}


// ============================================================
// 19. LONGITUDE RIBS
// ============================================================

module longitude_ribs()
{
    for (
        i = [
            0 :
            LONGITUDE_COUNT - 1
        ]
    )
    {
        angle =
            i *
            180 /
            LONGITUDE_COUNT;

        rotate([
            0,
            0,
            angle
        ])
        longitude_rib();
    }
}


// ============================================================
// 20. SINGLE LONGITUDE RIB
// ============================================================

module longitude_rib()
{
    /*
    Thin slab passing through sphere center.

    Intersection with spherical band produces a curved
    meridian rib.
    */

    cube([
        2 * SHELL_OD,
        RIB_DIAMETER,
        2 * SHELL_OD
    ],
    center = true);
}


// ============================================================
// 21. LATITUDE RIBS
// ============================================================

module latitude_ribs()
{
    for (
        z_pos = LATITUDE_Z
    )
    {
        latitude_rib(
            z_pos
        );
    }
}


// ============================================================
// 22. SINGLE LATITUDE RIB
// ============================================================

module latitude_rib(
    z_pos
)
{
    local_radius =
        sqrt(
            SHELL_OR * SHELL_OR -
            z_pos * z_pos
        );


    translate([
        0,
        0,
        z_pos
    ])
    difference()
    {
        cylinder(
            h = RIB_DIAMETER,
            r =
                local_radius +
                RIB_DIAMETER,
            center = true
        );

        cylinder(
            h =
                RIB_DIAMETER +
                0.2,

            r =
                local_radius -
                RIB_DIAMETER,
            center = true
        );
    }
}


// ============================================================
// 23. EQUATORIAL REINFORCEMENT
// ============================================================

module equatorial_reinforcement()
{
    /*
    Slightly wider equatorial belt because:
    - cameras live here
    - battery structure is nearby
    - equator is the likely impact zone
    */

    EQUATOR_BAND_H = 3.2;

    difference()
    {
        cylinder(
            h = EQUATOR_BAND_H,
            r = SHELL_OR + 1,
            center = true
        );

        cylinder(
            h = EQUATOR_BAND_H + 0.2,
            r = SHELL_IR - 1,
            center = true
        );
    }
}


// ============================================================
// 24. POLAR OPENINGS
// ============================================================

module polar_openings()
{
    // Upper opening.

    translate([
        0,
        0,
        SHELL_OR -
        POLAR_CUT_H / 2
    ])
    cylinder(
        h = POLAR_CUT_H,
        d = POLAR_OPENING_D,
        center = true
    );


    // Lower opening.

    translate([
        0,
        0,
        -SHELL_OR +
        POLAR_CUT_H / 2
    ])
    cylinder(
        h = POLAR_CUT_H,
        d = POLAR_OPENING_D,
        center = true
    );
}


// ============================================================
// 25. UPPER LANDING RING
// ============================================================

module upper_landing_ring()
{
    translate([
        0,
        0,
        DUCT_TOP_Z
    ])
    landing_ring();
}


// ============================================================
// 26. LOWER LANDING RING
// ============================================================

module lower_landing_ring()
{
    translate([
        0,
        0,
        DUCT_BOTTOM_Z
    ])
    landing_ring();
}


// ============================================================
// 27. LANDING RING
// ============================================================

module landing_ring()
{
    difference()
    {
        cylinder(
            h = LANDING_RING_H,
            d = LANDING_RING_OD,
            center = true
        );

        cylinder(
            h = LANDING_RING_H + 0.2,
            d = LANDING_RING_ID,
            center = true
        );
    }
}


// ============================================================
// 28. CAMERA WINDOWS
// ============================================================

module camera_windows()
{
    for (
        i = [
            0 :
            CAMERA_COUNT - 1
        ]
    )
    {
        angle =
            i *
            360 /
            CAMERA_COUNT;


        rotate([
            0,
            0,
            angle
        ])

        translate([
            CAMERA_WINDOW_CENTER_R,
            0,
            CAMERA_Z
        ])

        cube([
            CAMERA_WINDOW_DEPTH,
            CAMERA_WINDOW_W,
            CAMERA_WINDOW_H
        ],
        center = true);
    }
}


// ============================================================
// 29. BATTERY SERVICE WINDOWS
// ============================================================

module battery_service_windows()
{
    for (
        angle = [
            BATTERY_AXIS_ANGLE,
            BATTERY_AXIS_ANGLE + 180
        ]
    )
    {
        rotate([
            0,
            0,
            angle
        ])

        translate([
            SHELL_OR,
            0,
            BATTERY_Z
        ])

        cube([
            BATTERY_WINDOW_DEPTH,
            BATTERY_WINDOW_W,
            BATTERY_WINDOW_H
        ],
        center = true);
    }
}


// ============================================================
// 30. ACTUATOR SERVICE WINDOWS
// ============================================================

module actuator_service_windows()
{
    for (
        i = [
            0 :
            3
        ]
    )
    {
        angle =
            i *
            90;


        rotate([
            0,
            0,
            angle
        ])

        translate([
            SHELL_OR,
            0,
            ACTUATOR_Z
        ])

        cube([
            ACTUATOR_WINDOW_DEPTH,
            ACTUATOR_WINDOW_W,
            ACTUATOR_WINDOW_H
        ],
        center = true);
    }
}


// ============================================================
// 31. LANDING RING SCREW HOLES
// ============================================================

module landing_ring_screw_holes()
{
    for (
        z_pos = [
            DUCT_TOP_Z,
            DUCT_BOTTOM_Z
        ]
    )
    {
        for (
            i = [
                0 :
                SCREW_COUNT_PER_RING - 1
            ]
        )
        {
            angle =
                i *
                360 /
                SCREW_COUNT_PER_RING;


            rotate([
                0,
                0,
                angle
            ])

            translate([
                SCREW_RADIUS,
                0,
                z_pos
            ])

            cylinder(
                h =
                    LANDING_RING_H +
                    1,

                d =
                    SCREW_CLEARANCE_D,

                center = true
            );
        }
    }
}


// ============================================================
// 32. DUCT REFERENCE
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
// 33. SPHERE RADIUS FUNCTION
// ============================================================

function sphere_radius_at_z(
    radius,
    z
) =
    abs(z) <= radius

    ?

    sqrt(
        radius * radius -
        z * z
    )

    :

    0;


// ============================================================
// 34. POLAR GEOMETRY CHECK
// ============================================================

OPENING_INTERSECTION_Z =

    sqrt(
        SHELL_OR * SHELL_OR -
        POLAR_OPENING_R *
        POLAR_OPENING_R
    );


// ============================================================
// 35. LANDING RING RADIAL CHECK
// ============================================================

AVAILABLE_OUTER_RADIUS_AT_DUCT_TOP =

    sphere_radius_at_z(
        SHELL_OR,
        DUCT_TOP_Z
    );


AVAILABLE_INNER_RADIUS_AT_DUCT_TOP =

    sphere_radius_at_z(
        SHELL_IR,
        DUCT_TOP_Z
    );


// ============================================================
// 36. LATTICE ANGULAR SPACING
// ============================================================

LONGITUDE_SPACING_DEG =

    180 /
    LONGITUDE_COUNT;


// ============================================================
// 37. APPROXIMATE OPENNESS INDICATOR
// ============================================================

/*
This is NOT exact removed mass.

It is merely a design indicator based on rib pitch.

Exact plastic fraction must be calculated from exported mesh
volume.
*/

EQUATOR_CIRCUMFERENCE =

    2 *
    PI *
    SHELL_OR;


APPROX_LONGITUDE_RIB_FRACTION =

    (
        LONGITUDE_COUNT *
        RIB_DIAMETER
    )
    /
    EQUATOR_CIRCUMFERENCE;


// ============================================================
// 38. VALIDATION
// ============================================================

assert(
    SHELL_OD == 115,

    "FAIL: crash shell OD must remain 115 mm."
);


assert(
    SHELL_ID == 111,

    "FAIL: crash shell ID must remain 111 mm."
);


assert(
    SHELL_THICKNESS == 2,

    "FAIL: nominal shell thickness must remain 2 mm."
);


assert(
    POLAR_OPENING_D >=
    74.4,

    "FAIL: polar opening too small for duct interface."
);


assert(
    LANDING_RING_ID >=
    POLAR_OPENING_D,

    "FAIL: landing ring bore smaller than polar opening."
);


assert(
    LANDING_RING_OD / 2 <
    AVAILABLE_OUTER_RADIUS_AT_DUCT_TOP,

    "FAIL: landing ring exits spherical envelope."
);


assert(
    RIB_DIAMETER >=
    2.0,

    "FAIL: lattice ribs below provisional impact thickness."
);


assert(
    LONGITUDE_COUNT % 4 == 0,

    "FAIL: longitude lattice should preserve fourfold symmetry."
);


// ============================================================
// 39. OUTPUT
// ============================================================

echo(
    "============================================"
);

echo(
    "AIDRONE FILE 21 — CRASH SHELL"
);

echo(
    "Shell OD =",
    SHELL_OD
);

echo(
    "Shell ID =",
    SHELL_ID
);

echo(
    "Nominal thickness =",
    SHELL_THICKNESS
);

echo(
    "Polar opening =",
    POLAR_OPENING_D
);

echo(
    "Polar opening meets sphere at |Z| =",
    OPENING_INTERSECTION_Z
);

echo(
    "Landing ring ID =",
    LANDING_RING_ID
);

echo(
    "Landing ring OD =",
    LANDING_RING_OD
);

echo(
    "Landing ring Z = +/-",
    DUCT_TOP_Z
);

echo(
    "Available sphere radius at landing ring =",
    AVAILABLE_OUTER_RADIUS_AT_DUCT_TOP
);

echo(
    "Longitude rib count =",
    LONGITUDE_COUNT
);

echo(
    "Longitude spacing =",
    LONGITUDE_SPACING_DEG
);

echo(
    "Latitude count =",
    len(LATITUDE_Z)
);

echo(
    "Rib diameter =",
    RIB_DIAMETER
);

echo(
    "Approx longitude coverage indicator =",
    APPROX_LONGITUDE_RIB_FRACTION
);

echo(
    "============================================"
);