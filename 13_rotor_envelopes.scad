/*
================================================================
AIDRONE
FILE 13 / 24
COUNTER-ROTATING ROTOR ENVELOPES + KEEP-OUTS

PURPOSE
-------
Defines geometric safety volumes for the two preliminary
counter-rotating rotor stages.

THIS FILE DOES NOT DESIGN PROPELLER BLADES.

It defines:
- nominal rotor swept volume
- dynamic radial margin
- axial blade envelope
- hub envelope
- inter-stage clearance
- duct-tip clearance
- stator clearance
- failure keep-out
- complete propulsion exclusion volume

GLOBAL DATUM
------------
Origin = vehicle geometric center
+Z     = inlet
-Z     = exhaust

Stage A = upper rotor
Stage B = lower rotor

Rotation direction is metadata only until actual rotor
geometry and motor hardware are selected.
================================================================
*/


include <00_master_parameters.scad>
include <02_materials_tolerances.scad>


$fn = 100;


// ============================================================
// 1. DUCT
// ============================================================

DUCT_ID_LOCAL = 70.0;

DUCT_R_LOCAL =
    DUCT_ID_LOCAL / 2;


// ============================================================
// 2. NOMINAL ROTOR ENVELOPE
// ============================================================

ROTOR_NOMINAL_D = 68.0;

ROTOR_NOMINAL_R =
    ROTOR_NOMINAL_D / 2;


// ============================================================
// 3. ROTOR AXIAL POSITIONS
// ============================================================

ROTOR_A_Z = 12.0;

ROTOR_B_Z = -12.0;


// ============================================================
// 4. NOMINAL BLADE AXIAL THICKNESS
// ============================================================

/*
This is an envelope, not actual blade thickness.

It allows room for:
- blade pitch
- blade flex
- hub geometry
- manufacturing variation
*/

ROTOR_NOMINAL_AXIAL_H = 4.0;


// ============================================================
// 5. DYNAMIC RADIAL MARGIN
// ============================================================

/*
The Ø68 rotor inside Ø70 duct gives:

    1.0 mm nominal radial clearance.

We explicitly reserve part of that clearance for dynamic
effects.

These values are provisional engineering allocations.
*/


SHAFT_RUNOUT_ALLOWANCE = 0.10;

ROTOR_MANUFACTURING_ALLOWANCE = 0.15;

BLADE_DYNAMIC_DEFLECTION_ALLOWANCE = 0.20;

DUCT_DIMENSIONAL_ALLOWANCE = 0.15;


TOTAL_DYNAMIC_RADIAL_ALLOWANCE =

    SHAFT_RUNOUT_ALLOWANCE +

    ROTOR_MANUFACTURING_ALLOWANCE +

    BLADE_DYNAMIC_DEFLECTION_ALLOWANCE +

    DUCT_DIMENSIONAL_ALLOWANCE;


// ============================================================
// 6. REMAINING TIP CLEARANCE
// ============================================================

NOMINAL_RADIAL_CLEARANCE =

    DUCT_R_LOCAL -
    ROTOR_NOMINAL_R;


REMAINING_RADIAL_CLEARANCE =

    NOMINAL_RADIAL_CLEARANCE -
    TOTAL_DYNAMIC_RADIAL_ALLOWANCE;


// ============================================================
// 7. DYNAMIC ROTOR ENVELOPE
// ============================================================

DYNAMIC_ROTOR_R =

    ROTOR_NOMINAL_R +
    TOTAL_DYNAMIC_RADIAL_ALLOWANCE;


DYNAMIC_ROTOR_D =

    2 *
    DYNAMIC_ROTOR_R;


// ============================================================
// 8. AXIAL DYNAMIC MARGIN
// ============================================================

AXIAL_BLADE_DEFLECTION_ALLOWANCE =
    0.50;


DYNAMIC_ROTOR_H =

    ROTOR_NOMINAL_AXIAL_H +

    2 *
    AXIAL_BLADE_DEFLECTION_ALLOWANCE;


// ============================================================
// 9. HUB ENVELOPE
// ============================================================

/*
Motor is not selected.

This is a provisional hub exclusion cylinder.
*/

HUB_ENVELOPE_D = 18.0;

HUB_ENVELOPE_H = 8.0;


// ============================================================
// 10. ROTOR DIRECTIONS
// ============================================================

/*
Metadata:

+1 = CCW viewed from +Z
-1 = CW viewed from +Z

Final directions depend on blade design and motor arrangement.
*/

ROTOR_A_DIRECTION = +1;

ROTOR_B_DIRECTION = -1;


// ============================================================
// 11. STATOR REFERENCES
// ============================================================

STATOR_A_Z = 8.0;

STATOR_B_Z = -8.0;

STATOR_H = 5.0;


// ============================================================
// 12. AXIAL CLEARANCE
// ============================================================

ROTOR_A_BOTTOM =

    ROTOR_A_Z -
    DYNAMIC_ROTOR_H / 2;


ROTOR_A_TOP =

    ROTOR_A_Z +
    DYNAMIC_ROTOR_H / 2;


ROTOR_B_BOTTOM =

    ROTOR_B_Z -
    DYNAMIC_ROTOR_H / 2;


ROTOR_B_TOP =

    ROTOR_B_Z +
    DYNAMIC_ROTOR_H / 2;


STATOR_A_TOP =

    STATOR_A_Z +
    STATOR_H / 2;


STATOR_B_BOTTOM =

    STATOR_B_Z -
    STATOR_H / 2;


ROTOR_A_STATOR_CLEARANCE =

    ROTOR_A_BOTTOM -
    STATOR_A_TOP;


ROTOR_B_STATOR_CLEARANCE =

    STATOR_B_BOTTOM -
    ROTOR_B_TOP;


// ============================================================
// 13. INTER-ROTOR AXIAL GAP
// ============================================================

INTER_ROTOR_GAP =

    ROTOR_A_BOTTOM -
    ROTOR_B_TOP;


// ============================================================
// 14. FAILURE CONTAINMENT KEEP-OUT
// ============================================================

/*
This is NOT proof of rotor containment.

It is a geometric exclusion zone around the rotor.

No electronics or batteries should occupy this radial/axial
region.

Final fragment containment requires physical testing.
*/

FAILURE_RADIAL_MARGIN =
    1.0;


FAILURE_AXIAL_MARGIN =
    2.0;


FAILURE_ENVELOPE_D =

    DYNAMIC_ROTOR_D +

    2 *
    FAILURE_RADIAL_MARGIN;


FAILURE_ENVELOPE_H =

    DYNAMIC_ROTOR_H +

    2 *
    FAILURE_AXIAL_MARGIN;


// ============================================================
// 15. DISPLAY OPTIONS
// ============================================================

SHOW_NOMINAL_ROTORS = true;

SHOW_DYNAMIC_ENVELOPES = false;

SHOW_FAILURE_ENVELOPES = false;

SHOW_HUB_ENVELOPES = false;

SHOW_DUCT_REFERENCE = false;

SHOW_INTERSTAGE_VOLUME = false;


// ============================================================
// 16. MAIN
// ============================================================

rotor_envelope_system();


// ============================================================
// 17. COMPLETE SYSTEM
// ============================================================

module rotor_envelope_system()
{
    if (
        SHOW_NOMINAL_ROTORS
    )
    {
        %nominal_rotor(
            ROTOR_A_Z
        );

        %nominal_rotor(
            ROTOR_B_Z
        );
    }


    if (
        SHOW_DYNAMIC_ENVELOPES
    )
    {
        %dynamic_rotor(
            ROTOR_A_Z
        );

        %dynamic_rotor(
            ROTOR_B_Z
        );
    }


    if (
        SHOW_FAILURE_ENVELOPES
    )
    {
        %failure_envelope(
            ROTOR_A_Z
        );

        %failure_envelope(
            ROTOR_B_Z
        );
    }


    if (
        SHOW_HUB_ENVELOPES
    )
    {
        %hub_envelope(
            ROTOR_A_Z
        );

        %hub_envelope(
            ROTOR_B_Z
        );
    }


    if (
        SHOW_DUCT_REFERENCE
    )
    {
        %duct_reference();
    }


    if (
        SHOW_INTERSTAGE_VOLUME
    )
    {
        %interstage_volume();
    }
}


// ============================================================
// 18. NOMINAL ROTOR
// ============================================================

module nominal_rotor(
    z_position
)
{
    translate([
        0,
        0,
        z_position
    ])
    cylinder(
        h =
            ROTOR_NOMINAL_AXIAL_H,

        d =
            ROTOR_NOMINAL_D,

        center = true
    );
}


// ============================================================
// 19. DYNAMIC ROTOR
// ============================================================

module dynamic_rotor(
    z_position
)
{
    translate([
        0,
        0,
        z_position
    ])
    cylinder(
        h =
            DYNAMIC_ROTOR_H,

        d =
            DYNAMIC_ROTOR_D,

        center = true
    );
}


// ============================================================
// 20. FAILURE ENVELOPE
// ============================================================

module failure_envelope(
    z_position
)
{
    translate([
        0,
        0,
        z_position
    ])
    cylinder(
        h =
            FAILURE_ENVELOPE_H,

        d =
            FAILURE_ENVELOPE_D,

        center = true
    );
}


// ============================================================
// 21. HUB ENVELOPE
// ============================================================

module hub_envelope(
    z_position
)
{
    translate([
        0,
        0,
        z_position
    ])
    cylinder(
        h =
            HUB_ENVELOPE_H,

        d =
            HUB_ENVELOPE_D,

        center = true
    );
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
// 23. INTERSTAGE VOLUME
// ============================================================

module interstage_volume()
{
    translate([
        0,
        0,
        (
            ROTOR_A_BOTTOM +
            ROTOR_B_TOP
        ) / 2
    ])
    cylinder(
        h =
            INTER_ROTOR_GAP,

        d =
            DUCT_ID_LOCAL,

        center = true
    );
}


// ============================================================
// 24. VALIDATION
// ============================================================

assert(
    ROTOR_NOMINAL_D <
    DUCT_ID_LOCAL,

    "FAIL: nominal rotor does not fit duct."
);


assert(
    NOMINAL_RADIAL_CLEARANCE >=
    MIN_ROTOR_STATIC_RADIAL_CLEARANCE,

    "FAIL: nominal rotor tip clearance below design floor."
);


assert(
    TOTAL_DYNAMIC_RADIAL_ALLOWANCE <
    NOMINAL_RADIAL_CLEARANCE,

    "FAIL: dynamic allowances consume entire rotor tip clearance."
);


assert(
    REMAINING_RADIAL_CLEARANCE >
    0,

    "FAIL: no positive rotor-to-duct clearance remains."
);


assert(
    DYNAMIC_ROTOR_D <
    DUCT_ID_LOCAL,

    "FAIL: dynamic rotor envelope intersects duct."
);


assert(
    ROTOR_A_STATOR_CLEARANCE >=
    1.0,

    "FAIL: Stage A dynamic rotor/stator clearance <1 mm."
);


assert(
    ROTOR_B_STATOR_CLEARANCE >=
    1.0,

    "FAIL: Stage B dynamic rotor/stator clearance <1 mm."
);


assert(
    INTER_ROTOR_GAP >
    0,

    "FAIL: counter-rotating rotor envelopes intersect."
);


assert(
    ROTOR_A_DIRECTION ==
    -ROTOR_B_DIRECTION,

    "FAIL: rotor direction metadata is not counter-rotating."
);


// ============================================================
// 25. OUTPUT
// ============================================================

echo(
    "============================================"
);

echo(
    "AIDRONE FILE 13 — ROTOR ENVELOPES"
);

echo(
    "Nominal rotor diameter =",
    ROTOR_NOMINAL_D
);

echo(
    "Nominal radial clearance =",
    NOMINAL_RADIAL_CLEARANCE
);

echo(
    "Shaft runout allowance =",
    SHAFT_RUNOUT_ALLOWANCE
);

echo(
    "Rotor manufacturing allowance =",
    ROTOR_MANUFACTURING_ALLOWANCE
);

echo(
    "Blade deflection allowance =",
    BLADE_DYNAMIC_DEFLECTION_ALLOWANCE
);

echo(
    "Duct dimensional allowance =",
    DUCT_DIMENSIONAL_ALLOWANCE
);

echo(
    "Total dynamic radial allowance =",
    TOTAL_DYNAMIC_RADIAL_ALLOWANCE
);

echo(
    "Dynamic rotor diameter =",
    DYNAMIC_ROTOR_D
);

echo(
    "Remaining radial clearance =",
    REMAINING_RADIAL_CLEARANCE
);

echo(
    "Dynamic rotor axial height =",
    DYNAMIC_ROTOR_H
);

echo(
    "Stage A stator clearance =",
    ROTOR_A_STATOR_CLEARANCE
);

echo(
    "Stage B stator clearance =",
    ROTOR_B_STATOR_CLEARANCE
);

echo(
    "Inter-rotor gap =",
    INTER_ROTOR_GAP
);

echo(
    "Failure envelope diameter =",
    FAILURE_ENVELOPE_D
);

echo(
    "============================================"
);