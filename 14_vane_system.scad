/*
================================================================
AIDRONE
FILE 14 / 24
FOUR-VANE THRUST VECTORING SYSTEM

PURPOSE
-------
Defines the preliminary four-vane control system downstream
of the propulsion stages.

Creates:
- 4 symmetric vanes
- pivot shafts
- hinge bosses
- configurable vane angles
- +/-25 degree travel limits
- complete swept-volume keep-outs
- duct-wall clearance checks
- shell-envelope checks

IMPORTANT
---------
This file establishes mechanical geometry.

It does NOT prove:
- aerodynamic effectiveness
- servo torque
- flutter resistance
- final vane airfoil
- final hinge hardware

GLOBAL DATUM
------------
Origin = vehicle geometric center
+Z     = inlet
-Z     = exhaust
================================================================
*/


include <00_master_parameters.scad>
include <02_materials_tolerances.scad>


$fn = 100;


// ============================================================
// 1. VEHICLE ENVELOPE
// ============================================================

VEHICLE_D = 115.0;

VEHICLE_R =
    VEHICLE_D / 2;


// ============================================================
// 2. DUCT
// ============================================================

DUCT_ID_LOCAL = 70.0;

DUCT_R_LOCAL =
    DUCT_ID_LOCAL / 2;

DUCT_OD_LOCAL = 74.0;


// ============================================================
// 3. VANE COUNT
// ============================================================

VANE_COUNT = 4;


// ============================================================
// 4. VANE POSITION
// ============================================================

/*
Propulsion rotors currently occupy Z +/-12 mm.

The vane system is placed downstream toward -Z.

Its center remains inside the 70 mm core.
*/

VANE_CENTER_Z = -27.0;


// ============================================================
// 5. VANE GEOMETRY
// ============================================================

/*
Radial span:

pivot near center
tip toward duct wall

Chord runs approximately along Z in neutral position.
*/

VANE_SPAN = 25.0;

VANE_CHORD = 15.0;

VANE_THICKNESS = 1.2;


// ============================================================
// 6. ROOT POSITION
// ============================================================

/*
Vane does not begin at absolute center.

Central gap protects:
- shaft/hub region
- wiring
- downstream wake core
*/

VANE_ROOT_RADIUS = 7.0;

VANE_TIP_RADIUS =
    VANE_ROOT_RADIUS +
    VANE_SPAN;


// ============================================================
// 7. DUCT TIP CLEARANCE
// ============================================================

VANE_STATIC_TIP_CLEARANCE =

    DUCT_R_LOCAL -
    VANE_TIP_RADIUS;


// ============================================================
// 8. PIVOT
// ============================================================

PIVOT_SHAFT_D = 2.0;

PIVOT_SHAFT_R =
    PIVOT_SHAFT_D / 2;


// Metal-pin bore rule from tolerance authority.

PIVOT_BORE_D =
    metal_pin_bore(
        PIVOT_SHAFT_D
    );


// ============================================================
// 9. PIVOT LOCATION
// ============================================================

/*
Pivot runs radially through the vane.

The vane rotates around its span axis.

This changes the plate incidence to the axial flow.
*/

PIVOT_RADIUS =

    VANE_ROOT_RADIUS +
    VANE_SPAN / 2;


// ============================================================
// 10. CONTROL LIMIT
// ============================================================

MAX_VANE_ANGLE = 25;


// ============================================================
// 11. CURRENT CONTROL COMMANDS
// ============================================================

/*
Each vane can be previewed independently.

Ordering viewed from +Z:

Vane 0 = +X
Vane 1 = +Y
Vane 2 = -X
Vane 3 = -Y
*/

VANE_0_ANGLE = 0;

VANE_1_ANGLE = 0;

VANE_2_ANGLE = 0;

VANE_3_ANGLE = 0;


VANE_ANGLES = [

    VANE_0_ANGLE,

    VANE_1_ANGLE,

    VANE_2_ANGLE,

    VANE_3_ANGLE

];


// ============================================================
// 12. HINGE BOSS
// ============================================================

HINGE_BOSS_OD =
    5.0;

HINGE_BOSS_LENGTH =
    4.0;


// ============================================================
// 13. VANE EDGE ROUNDING
// ============================================================

/*
Manufacturing/chipping radius only.

Not an aerodynamic airfoil claim.
*/

VANE_EDGE_RADIUS =
    0.6;


// ============================================================
// 14. SWEEP RESOLUTION
// ============================================================

SWEEP_STEP_DEG =
    5;


// ============================================================
// 15. SAFETY CLEARANCE
// ============================================================

SWEEP_CLEARANCE =
    VANE_SWEEP_MIN_CLEARANCE;


// ============================================================
// 16. DISPLAY
// ============================================================

SHOW_VANES = true;

SHOW_PIVOTS = true;

SHOW_HINGE_BOSSES = true;

SHOW_SWEEP_ENVELOPES = false;

SHOW_DUCT_REFERENCE = false;

SHOW_SPHERE_REFERENCE = false;


// ============================================================
// 17. MAIN
// ============================================================

vane_system();


// ============================================================
// 18. COMPLETE SYSTEM
// ============================================================

module vane_system()
{
    if (SHOW_VANES)
    {
        for (
            i = [
                0 :
                VANE_COUNT - 1
            ]
        )
        {
            vane_at_station(
                i,
                VANE_ANGLES[i]
            );
        }
    }


    if (SHOW_PIVOTS)
    {
        for (
            i = [
                0 :
                VANE_COUNT - 1
            ]
        )
        {
            pivot_at_station(
                i
            );
        }
    }


    if (SHOW_HINGE_BOSSES)
    {
        for (
            i = [
                0 :
                VANE_COUNT - 1
            ]
        )
        {
            hinge_boss_at_station(
                i
            );
        }
    }


    if (SHOW_SWEEP_ENVELOPES)
    {
        for (
            i = [
                0 :
                VANE_COUNT - 1
            ]
        )
        {
            %vane_sweep_envelope(
                i
            );
        }
    }


    if (SHOW_DUCT_REFERENCE)
    {
        %duct_reference();
    }


    if (SHOW_SPHERE_REFERENCE)
    {
        %sphere_reference();
    }
}


// ============================================================
// 19. SINGLE VANE
// ============================================================

module vane_body()
{
    /*
    Local coordinate system:

    X = radial/span direction
    Y = thickness
    Z = chord / flow direction

    Pivot axis = local X
    */

    translate([
        VANE_ROOT_RADIUS,
        -VANE_THICKNESS / 2,
        -VANE_CHORD / 2
    ])
    cube([
        VANE_SPAN,
        VANE_THICKNESS,
        VANE_CHORD
    ]);
}


// ============================================================
// 20. VANE WITH ROTATION
// ============================================================

module rotated_vane(
    angle_deg
)
{
    /*
    Move pivot axis to origin,
    rotate around radial X axis,
    move back.
    */

    translate([
        PIVOT_RADIUS,
        0,
        0
    ])

    rotate([
        angle_deg,
        0,
        0
    ])

    translate([
        -PIVOT_RADIUS,
        0,
        0
    ])

    vane_body();
}


// ============================================================
// 21. STATION PLACEMENT
// ============================================================

module vane_at_station(
    station,
    angle_deg
)
{
    station_angle =
        station *
        360 /
        VANE_COUNT;


    assert(
        abs(angle_deg) <=
        MAX_VANE_ANGLE,

        "FAIL: commanded vane angle exceeds +/-25 degrees."
    );


    translate([
        0,
        0,
        VANE_CENTER_Z
    ])

    rotate([
        0,
        0,
        station_angle
    ])

    rotated_vane(
        angle_deg
    );
}


// ============================================================
// 22. PIVOT SHAFT
// ============================================================

module pivot_shaft()
{
    /*
    Radial shaft along local X.
    */

    translate([
        PIVOT_RADIUS,
        0,
        0
    ])

    rotate([
        0,
        90,
        0
    ])

    cylinder(
        h =
            VANE_SPAN +
            6,

        d =
            PIVOT_SHAFT_D,

        center = true
    );
}


// ============================================================
// 23. PIVOT AT STATION
// ============================================================

module pivot_at_station(
    station
)
{
    station_angle =
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
        station_angle
    ])

    pivot_shaft();
}


// ============================================================
// 24. HINGE BOSS
// ============================================================

module hinge_boss()
{
    /*
    Boss sits near duct-side end of radial pivot.

    Final actuator linkage will attach outside this region.
    */

    translate([
        VANE_TIP_RADIUS,
        0,
        0
    ])

    rotate([
        0,
        90,
        0
    ])

    difference()
    {
        cylinder(
            h =
                HINGE_BOSS_LENGTH,

            d =
                HINGE_BOSS_OD,

            center = true
        );


        cylinder(
            h =
                HINGE_BOSS_LENGTH +
                0.2,

            d =
                PIVOT_BORE_D,

            center = true
        );
    }
}


// ============================================================
// 25. HINGE BOSS AT STATION
// ============================================================

module hinge_boss_at_station(
    station
)
{
    station_angle =
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
        station_angle
    ])

    hinge_boss();
}


// ============================================================
// 26. SWEEP ENVELOPE
// ============================================================

module vane_sweep_envelope(
    station
)
{
    /*
    Hull neighboring vane positions across full travel.

    This gives a conservative mechanical keep-out volume.
    */

    station_angle =
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
        station_angle
    ])

    for (
        angle = [
            -MAX_VANE_ANGLE :
            SWEEP_STEP_DEG :
            MAX_VANE_ANGLE -
            SWEEP_STEP_DEG
        ]
    )
    {
        hull()
        {
            rotated_vane(
                angle
            );

            rotated_vane(
                angle +
                SWEEP_STEP_DEG
            );
        }
    }
}


// ============================================================
// 27. DUCT REFERENCE
// ============================================================

module duct_reference()
{
    difference()
    {
        cylinder(
            h = 70,
            d = DUCT_OD_LOCAL,
            center = true
        );

        cylinder(
            h = 70.2,
            d = DUCT_ID_LOCAL,
            center = true
        );
    }
}


// ============================================================
// 28. SPHERE REFERENCE
// ============================================================

module sphere_reference()
{
    sphere(
        d = VEHICLE_D
    );
}


// ============================================================
// 29. SWEEP MATHEMATICS
// ============================================================

MAX_HALF_CHORD_SWEEP =

    (
        VANE_CHORD / 2
    )

    *
    sin(
        MAX_VANE_ANGLE
    );


MAX_FULL_CHORD_SWEEP =

    VANE_CHORD *

    sin(
        MAX_VANE_ANGLE
    );


// ============================================================
// 30. PROJECTED BLOCKAGE
// ============================================================

DUCT_AREA =

    PI *
    DUCT_R_LOCAL *
    DUCT_R_LOCAL;


SINGLE_VANE_PLANFORM_AREA =

    VANE_SPAN *
    VANE_CHORD;


TOTAL_VANE_PLANFORM_AREA =

    VANE_COUNT *
    SINGLE_VANE_PLANFORM_AREA;


MAX_PROJECTED_AREA =

    TOTAL_VANE_PLANFORM_AREA *

    sin(
        MAX_VANE_ANGLE
    );


MAX_PROJECTED_BLOCKAGE =

    MAX_PROJECTED_AREA /
    DUCT_AREA;


// ============================================================
// 31. AXIAL LIMITS
// ============================================================

VANE_NEUTRAL_Z_MIN =

    VANE_CENTER_Z -
    VANE_CHORD / 2;


VANE_NEUTRAL_Z_MAX =

    VANE_CENTER_Z +
    VANE_CHORD / 2;


VANE_SWEEP_Z_MIN =

    VANE_CENTER_Z -

    (
        VANE_CHORD / 2 *
        cos(MAX_VANE_ANGLE)
    )

    -

    (
        VANE_THICKNESS / 2 *
        sin(MAX_VANE_ANGLE)
    );


VANE_SWEEP_Z_MAX =

    VANE_CENTER_Z +

    (
        VANE_CHORD / 2 *
        cos(MAX_VANE_ANGLE)
    )

    +

    (
        VANE_THICKNESS / 2 *
        sin(MAX_VANE_ANGLE)
    );


// ============================================================
// 32. RADIAL SWEEP LIMIT
// ============================================================

/*
Rotation is about radial axis.

Therefore vane pitch does NOT substantially increase its
radial tip radius.

Boss is the dominant radial structure.
*/

MAX_MECHANICAL_RADIUS =

    VANE_TIP_RADIUS +

    HINGE_BOSS_LENGTH / 2;


// ============================================================
// 33. SPHERE AVAILABLE RADIUS
// ============================================================

function sphere_radius_at_z(
    z
) =

    abs(z) <=
    VEHICLE_R

    ?

    sqrt(
        VEHICLE_R *
        VEHICLE_R -
        z * z
    )

    :

    0;


// ============================================================
// 34. VALIDATION
// ============================================================

assert(
    VANE_COUNT == 4,

    "FAIL: thrust-vectoring system requires fourfold symmetry."
);


assert(
    VANE_TIP_RADIUS <
    DUCT_R_LOCAL,

    "FAIL: vane tip intersects duct wall."
);


assert(
    VANE_STATIC_TIP_CLEARANCE >=
    1.0,

    "FAIL: vane has less than 1 mm static duct clearance."
);


assert(
    MAX_VANE_ANGLE <=
    25,

    "FAIL: vane mechanical range exceeds design limit."
);


assert(
    MAX_PROJECTED_BLOCKAGE <
    0.20,

    "FAIL: vane blockage exceeds provisional 20 percent limit."
);


assert(
    VANE_SWEEP_Z_MIN >
    -35,

    "FAIL: vane swept volume exits lower duct boundary."
);


assert(
    VANE_SWEEP_Z_MAX <
    35,

    "FAIL: vane swept volume exits upper duct boundary."
);


assert(
    MAX_MECHANICAL_RADIUS <
    sphere_radius_at_z(
        VANE_CENTER_Z
    ),

    "FAIL: vane mechanism intersects 115 mm spherical envelope."
);


// ============================================================
// 35. OUTPUT
// ============================================================

echo(
    "============================================"
);

echo(
    "AIDRONE FILE 14 — VANE SYSTEM"
);

echo(
    "Vane count =",
    VANE_COUNT
);

echo(
    "Vane center Z =",
    VANE_CENTER_Z
);

echo(
    "Vane span =",
    VANE_SPAN
);

echo(
    "Vane chord =",
    VANE_CHORD
);

echo(
    "Vane thickness =",
    VANE_THICKNESS
);

echo(
    "Root radius =",
    VANE_ROOT_RADIUS
);

echo(
    "Tip radius =",
    VANE_TIP_RADIUS
);

echo(
    "Static tip clearance =",
    VANE_STATIC_TIP_CLEARANCE
);

echo(
    "Pivot shaft diameter =",
    PIVOT_SHAFT_D
);

echo(
    "Pivot bore diameter =",
    PIVOT_BORE_D
);

echo(
    "Maximum vane angle =",
    MAX_VANE_ANGLE
);

echo(
    "Full chord sweep at 25 deg =",
    MAX_FULL_CHORD_SWEEP
);

echo(
    "Maximum projected blockage ratio =",
    MAX_PROJECTED_BLOCKAGE
);

echo(
    "Swept Z minimum =",
    VANE_SWEEP_Z_MIN
);

echo(
    "Swept Z maximum =",
    VANE_SWEEP_Z_MAX
);

echo(
    "Maximum mechanism radius =",
    MAX_MECHANICAL_RADIUS
);

echo(
    "============================================"
);