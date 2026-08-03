/*
================================================================
AIDRONE
FILE 19 / 24
SPLIT BATTERY CRADLE

PURPOSE
-------
Creates two opposed battery compartments around the Ø74 duct.

DESIGN GOALS
------------
- equal battery halves
- exact 180-degree opposition
- no intrusion into Ø70 airway
- adjustable Z position for CoG tuning
- battery retention
- expansion clearance
- wire-routing space
- shell collision checking

IMPORTANT
---------
Battery dimensions below are packaging envelopes only.
Do NOT manufacture the final cradle until the exact battery
cells, protection circuit, connector and wiring are selected.

GLOBAL DATUM
------------
Origin = vehicle geometric center.
================================================================
*/


include <00_master_parameters.scad>
include <02_materials_tolerances.scad>

$fn = 100;


// ============================================================
// 1. VEHICLE
// ============================================================

VEHICLE_D = 115.0;
VEHICLE_R = VEHICLE_D / 2;

SHELL_INNER_D = 111.0;
SHELL_INNER_R = SHELL_INNER_D / 2;


// ============================================================
// 2. DUCT
// ============================================================

DUCT_OD = 74.0;
DUCT_R = DUCT_OD / 2;

AIRWAY_D = 70.0;
AIRWAY_R = AIRWAY_D / 2;


// ============================================================
// 3. BATTERY Z POSITION
// ============================================================

/*
Positive Z moves batteries upward.

Mass solver indicated that the lower vane/actuator system
creates a negative-Z moment.

Start with +5 mm as a study position.

DO NOT freeze this value until real component masses exist.
*/

BATTERY_Z = 5.0;


// ============================================================
// 4. BATTERY HALF ENVELOPE
// ============================================================

/*
PROVISIONAL envelope per battery half.

Local orientation:

X = radial depth
Y = tangential width
Z = axial height
*/

BATTERY_DEPTH = 8.0;
BATTERY_WIDTH = 24.0;
BATTERY_HEIGHT = 30.0;


// ============================================================
// 5. BATTERY FIT CLEARANCE
// ============================================================

BATTERY_SIDE_CLEARANCE = 0.6;
BATTERY_AXIAL_CLEARANCE = 0.8;
BATTERY_RADIAL_CLEARANCE = 0.6;


// ============================================================
// 6. INTERNAL POCKET
// ============================================================

POCKET_DEPTH =
    BATTERY_DEPTH +
    BATTERY_RADIAL_CLEARANCE;

POCKET_WIDTH =
    BATTERY_WIDTH +
    2 * BATTERY_SIDE_CLEARANCE;

POCKET_HEIGHT =
    BATTERY_HEIGHT +
    2 * BATTERY_AXIAL_CLEARANCE;


// ============================================================
// 7. CRADLE WALL
// ============================================================

CRADLE_WALL = 1.6;


// ============================================================
// 8. OUTER CRADLE DIMENSIONS
// ============================================================

CRADLE_DEPTH =
    POCKET_DEPTH +
    CRADLE_WALL;

CRADLE_WIDTH =
    POCKET_WIDTH +
    2 * CRADLE_WALL;

CRADLE_HEIGHT =
    POCKET_HEIGHT +
    2 * CRADLE_WALL;


// ============================================================
// 9. RADIAL LOCATION
// ============================================================

/*
Cradles begin just outside the Ø74 duct.

A small structural stand-off prevents coincident surfaces.
*/

DUCT_STANDOFF = 0.5;

CRADLE_INNER_R =
    DUCT_R +
    DUCT_STANDOFF;

CRADLE_CENTER_R =
    CRADLE_INNER_R +
    CRADLE_DEPTH / 2;

CRADLE_MAX_R =
    CRADLE_INNER_R +
    CRADLE_DEPTH;


// ============================================================
// 10. BATTERY CENTER
// ============================================================

BATTERY_CENTER_R =
    CRADLE_INNER_R +
    CRADLE_WALL +
    POCKET_DEPTH / 2;


// ============================================================
// 11. ORIENTATION
// ============================================================

/*
Two halves at 90° and 270°.

This leaves +X/-X available for other hardware.

Change BATTERY_AXIS_ANGLE if packaging later demands it.
*/

BATTERY_AXIS_ANGLE = 90.0;


// ============================================================
// 12. RETENTION LIPS
// ============================================================

RETENTION_LIP_DEPTH = 1.2;
RETENTION_LIP_HEIGHT = 2.0;


// ============================================================
// 13. WIRE EXIT
// ============================================================

WIRE_EXIT_W = 5.0;
WIRE_EXIT_H = 4.0;


// ============================================================
// 14. COOLING WINDOWS
// ============================================================

COOLING_WINDOW_W = 12.0;
COOLING_WINDOW_H = 16.0;


// ============================================================
// 15. DISPLAY
// ============================================================

SHOW_CRADLES = true;
SHOW_BATTERY_ENVELOPES = true;

SHOW_DUCT = false;
SHOW_AIRWAY = false;

SHOW_OUTER_SPHERE = false;
SHOW_INNER_SHELL = false;


// ============================================================
// 16. MAIN
// ============================================================

battery_system();


// ============================================================
// 17. COMPLETE BATTERY SYSTEM
// ============================================================

module battery_system()
{
    if (SHOW_CRADLES)
    {
        battery_cradle_at_angle(
            BATTERY_AXIS_ANGLE
        );

        battery_cradle_at_angle(
            BATTERY_AXIS_ANGLE + 180
        );
    }


    if (SHOW_BATTERY_ENVELOPES)
    {
        %battery_envelope_at_angle(
            BATTERY_AXIS_ANGLE
        );

        %battery_envelope_at_angle(
            BATTERY_AXIS_ANGLE + 180
        );
    }


    if (SHOW_DUCT)
    {
        %duct_reference();
    }


    if (SHOW_AIRWAY)
    {
        %airway_reference();
    }


    if (SHOW_OUTER_SPHERE)
    {
        %sphere_reference(
            VEHICLE_D
        );
    }


    if (SHOW_INNER_SHELL)
    {
        %sphere_reference(
            SHELL_INNER_D
        );
    }
}


// ============================================================
// 18. SINGLE CRADLE
// ============================================================

module battery_cradle()
{
    difference()
    {
        cradle_outer_body();

        battery_pocket();

        cooling_window();

        wire_exit();
    }

    retention_lips();
}


// ============================================================
// 19. CRADLE OUTER BODY
// ============================================================

module cradle_outer_body()
{
    translate([
        CRADLE_CENTER_R,
        0,
        BATTERY_Z
    ])
    cube([
        CRADLE_DEPTH,
        CRADLE_WIDTH,
        CRADLE_HEIGHT
    ],
    center = true);
}


// ============================================================
// 20. BATTERY POCKET
// ============================================================

module battery_pocket()
{
    /*
    Pocket opens toward outer radial direction.

    Extend subtraction slightly outward so the battery can
    actually be inserted rather than becoming trapped inside
    a closed printed box.
    */

    translate([
        CRADLE_INNER_R +
        CRADLE_WALL +
        POCKET_DEPTH / 2 +
        0.2,

        0,

        BATTERY_Z
    ])
    cube([
        POCKET_DEPTH + 0.5,
        POCKET_WIDTH,
        POCKET_HEIGHT
    ],
    center = true);
}


// ============================================================
// 21. COOLING WINDOW
// ============================================================

module cooling_window()
{
    translate([
        CRADLE_MAX_R,

        0,

        BATTERY_Z
    ])
    cube([
        2 * CRADLE_WALL + 1,
        COOLING_WINDOW_W,
        COOLING_WINDOW_H
    ],
    center = true);
}


// ============================================================
// 22. WIRE EXIT
// ============================================================

module wire_exit()
{
    translate([
        CRADLE_CENTER_R,

        0,

        BATTERY_Z +
        CRADLE_HEIGHT / 2
    ])
    cube([
        CRADLE_DEPTH + 1,
        WIRE_EXIT_W,
        WIRE_EXIT_H
    ],
    center = true);
}


// ============================================================
// 23. RETENTION LIPS
// ============================================================

module retention_lips()
{
    for (side = [-1, 1])
    {
        translate([
            CRADLE_MAX_R -
            RETENTION_LIP_DEPTH / 2,

            side *
            (
                POCKET_WIDTH / 2 +
                RETENTION_LIP_DEPTH / 2
            ),

            BATTERY_Z
        ])
        cube([
            RETENTION_LIP_DEPTH,
            RETENTION_LIP_DEPTH,
            CRADLE_HEIGHT
        ],
        center = true);
    }
}


// ============================================================
// 24. PLACE CRADLE AROUND DUCT
// ============================================================

module battery_cradle_at_angle(
    angle
)
{
    rotate([
        0,
        0,
        angle
    ])
    battery_cradle();
}


// ============================================================
// 25. BATTERY ENVELOPE
// ============================================================

module battery_envelope()
{
    translate([
        BATTERY_CENTER_R,
        0,
        BATTERY_Z
    ])
    cube([
        BATTERY_DEPTH,
        BATTERY_WIDTH,
        BATTERY_HEIGHT
    ],
    center = true);
}


module battery_envelope_at_angle(
    angle
)
{
    rotate([
        0,
        0,
        angle
    ])
    battery_envelope();
}


// ============================================================
// 26. DUCT REFERENCE
// ============================================================

module duct_reference()
{
    difference()
    {
        cylinder(
            h = 70,
            d = DUCT_OD,
            center = true
        );

        cylinder(
            h = 70.2,
            d = AIRWAY_D,
            center = true
        );
    }
}


// ============================================================
// 27. AIRWAY REFERENCE
// ============================================================

module airway_reference()
{
    cylinder(
        h = 70,
        d = AIRWAY_D,
        center = true
    );
}


// ============================================================
// 28. SPHERE REFERENCE
// ============================================================

module sphere_reference(
    diameter
)
{
    sphere(
        d = diameter
    );
}


// ============================================================
// 29. SPHERE RADIUS AT Z
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
// 30. WORST AXIAL POSITION
// ============================================================

BATTERY_Z_TOP =
    BATTERY_Z +
    CRADLE_HEIGHT / 2;

BATTERY_Z_BOTTOM =
    BATTERY_Z -
    CRADLE_HEIGHT / 2;


BATTERY_WORST_Z =
    max(
        abs(BATTERY_Z_TOP),
        abs(BATTERY_Z_BOTTOM)
    );


// ============================================================
// 31. AVAILABLE SHELL RADIUS
// ============================================================

AVAILABLE_SHELL_R =
    sphere_radius_at_z(
        SHELL_INNER_R,
        BATTERY_WORST_Z
    );


// ============================================================
// 32. SHELL CLEARANCE
// ============================================================

BATTERY_SHELL_CLEARANCE =
    AVAILABLE_SHELL_R -
    CRADLE_MAX_R;


// ============================================================
// 33. DUCT CLEARANCE
// ============================================================

CRADLE_DUCT_CLEARANCE =
    CRADLE_INNER_R -
    DUCT_R;


// ============================================================
// 34. MASS MOMENT HELPER
// ============================================================

/*
Used to copy the battery position into mass-properties file.

With equal opposing halves:

Mx = 0
My = 0

Combined Z moment:

Mz = total_battery_mass * BATTERY_Z
*/

BATTERY_HALF_MASS_G = 28.0;

TOTAL_BATTERY_MASS_G =
    2 * BATTERY_HALF_MASS_G;


BATTERY_Z_FIRST_MOMENT =
    TOTAL_BATTERY_MASS_G *
    BATTERY_Z;


// ============================================================
// 35. VALIDATION
// ============================================================

assert(
    BATTERY_DEPTH > 0 &&
    BATTERY_WIDTH > 0 &&
    BATTERY_HEIGHT > 0,

    "FAIL: invalid battery envelope."
);


assert(
    CRADLE_DUCT_CLEARANCE >= 0.2,

    "FAIL: battery cradle too close to duct."
);


assert(
    CRADLE_MAX_R <
    VEHICLE_R,

    "FAIL: battery cradle exits 115 mm vehicle envelope."
);


assert(
    BATTERY_SHELL_CLEARANCE >= 0.2,

    "FAIL: battery cradle intersects inner crash shell."
);


assert(
    BATTERY_Z_TOP <
    VEHICLE_R,

    "FAIL: battery cradle exceeds north vehicle boundary."
);


assert(
    BATTERY_Z_BOTTOM >
    -VEHICLE_R,

    "FAIL: battery cradle exceeds south vehicle boundary."
);


// ============================================================
// 36. OUTPUT
// ============================================================

echo(
    "============================================"
);

echo(
    "AIDRONE FILE 19 — BATTERY CRADLE"
);

echo(
    "Battery half envelope =",
    BATTERY_DEPTH,
    BATTERY_WIDTH,
    BATTERY_HEIGHT
);

echo(
    "Battery Z =",
    BATTERY_Z
);

echo(
    "Battery center radius =",
    BATTERY_CENTER_R
);

echo(
    "Cradle inner radius =",
    CRADLE_INNER_R
);

echo(
    "Cradle maximum radius =",
    CRADLE_MAX_R
);

echo(
    "Cradle / duct clearance =",
    CRADLE_DUCT_CLEARANCE
);

echo(
    "Cradle top Z =",
    BATTERY_Z_TOP
);

echo(
    "Cradle bottom Z =",
    BATTERY_Z_BOTTOM
);

echo(
    "Worst |Z| =",
    BATTERY_WORST_Z
);

echo(
    "Available shell radius =",
    AVAILABLE_SHELL_R
);

echo(
    "Battery / shell clearance =",
    BATTERY_SHELL_CLEARANCE
);

echo(
    "Combined battery mass assumption =",
    TOTAL_BATTERY_MASS_G
);

echo(
    "Battery Z first moment =",
    BATTERY_Z_FIRST_MOMENT
);

echo(
    "============================================"
);