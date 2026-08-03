/*
================================================================
AIDRONE
FILE 12 / 24
MOTOR STATOR + STRUCTURAL THRUST TRANSFER

PURPOSE
-------
Creates the internal structural framework that transfers motor
thrust and torque into the Ø74 duct.

IMPORTANT
---------
Motor hardware is NOT selected.

Therefore:
- motor diameter is a configurable envelope
- bolt pattern is NOT invented
- final center hub is NOT locked
- final axial positions remain provisional

The geometry exists to establish:
- load paths
- airflow blockage
- structural arm dimensions
- rotor/stator clearance
- counter-rotating stage packaging

GLOBAL DATUM
------------
Origin = vehicle center
+Z = inlet
-Z = exhaust
================================================================
*/


include <00_master_parameters.scad>
include <02_materials_tolerances.scad>


$fn = 100;


// ============================================================
// 1. DUCT
// ============================================================

DUCT_ID = 70.0;

DUCT_R = DUCT_ID / 2;

DUCT_OD_LOCAL = 74.0;

DUCT_OUTER_R =
    DUCT_OD_LOCAL / 2;


// ============================================================
// 2. STATOR COUNT
// ============================================================

STATOR_ARM_COUNT = 4;


// ============================================================
// 3. MOTOR ENVELOPE
// ============================================================

/*
PROVISIONAL ONLY.

Replace after motor selection.

This is deliberately an envelope, not a mounting pattern.
*/

MOTOR_ENVELOPE_D = 18.0;

MOTOR_ENVELOPE_R =
    MOTOR_ENVELOPE_D / 2;


// ============================================================
// 4. CENTER HUB
// ============================================================

HUB_WALL = 2.0;

HUB_OD =
    MOTOR_ENVELOPE_D +
    2 * HUB_WALL;

HUB_R =
    HUB_OD / 2;

HUB_HEIGHT = 5.0;


// ============================================================
// 5. STATOR ARMS
// ============================================================

ARM_RADIAL_LENGTH =
    DUCT_R -
    HUB_R;

ARM_TANGENTIAL_WIDTH = 3.0;

ARM_AXIAL_THICKNESS = 3.0;


// ============================================================
// 6. STATOR STAGES
// ============================================================

STATOR_A_Z = 8.0;

STATOR_B_Z = -8.0;


// ============================================================
// 7. ROTOR STUDY POSITIONS
// ============================================================

ROTOR_A_Z = 12.0;

ROTOR_B_Z = -12.0;

ROTOR_ENVELOPE_D = 68.0;

ROTOR_ENVELOPE_H = 4.0;


// ============================================================
// 8. MINIMUM AXIAL CLEARANCE
// ============================================================

MIN_STATOR_ROTOR_AXIAL_CLEARANCE =
    1.0;


// ============================================================
// 9. DISPLAY
// ============================================================

SHOW_STAGE_A = true;

SHOW_STAGE_B = true;

SHOW_DUCT_REFERENCE = false;

SHOW_ROTORS = false;

SHOW_MOTOR_ENVELOPES = false;


// ============================================================
// 10. MAIN
// ============================================================

motor_stator_system();


// ============================================================
// 11. COMPLETE SYSTEM
// ============================================================

module motor_stator_system()
{
    if (SHOW_STAGE_A)
    {
        stator_stage(
            STATOR_A_Z
        );
    }

    if (SHOW_STAGE_B)
    {
        stator_stage(
            STATOR_B_Z
        );
    }

    if (SHOW_DUCT_REFERENCE)
    {
        %duct_reference();
    }

    if (SHOW_ROTORS)
    {
        %rotor_reference(
            ROTOR_A_Z
        );

        %rotor_reference(
            ROTOR_B_Z
        );
    }

    if (SHOW_MOTOR_ENVELOPES)
    {
        %motor_envelope(
            STATOR_A_Z
        );

        %motor_envelope(
            STATOR_B_Z
        );
    }
}


// ============================================================
// 12. SINGLE STATOR STAGE
// ============================================================

module stator_stage(
    z_position
)
{
    translate([
        0,
        0,
        z_position
    ])
    union()
    {
        center_hub();

        stator_arms();
    }
}


// ============================================================
// 13. CENTER HUB
// ============================================================

module center_hub()
{
    difference()
    {
        cylinder(
            h = HUB_HEIGHT,
            d = HUB_OD,
            center = true
        );

        /*
        Motor envelope subtraction.

        This is NOT the final motor fit.
        */

        cylinder(
            h = HUB_HEIGHT + 0.2,
            d = MOTOR_ENVELOPE_D,
            center = true
        );
    }
}


// ============================================================
// 14. FOUR STATOR ARMS
// ============================================================

module stator_arms()
{
    for (
        i = [
            0 :
            STATOR_ARM_COUNT - 1
        ]
    )
    {
        angle =
            i *
            360 /
            STATOR_ARM_COUNT;

        rotate([
            0,
            0,
            angle
        ])
        translate([
            HUB_R - 0.05,
            -ARM_TANGENTIAL_WIDTH / 2,
            -ARM_AXIAL_THICKNESS / 2
        ])
        cube([
            ARM_RADIAL_LENGTH + 0.10,
            ARM_TANGENTIAL_WIDTH,
            ARM_AXIAL_THICKNESS
        ]);
    }
}


// ============================================================
// 15. MOTOR ENVELOPE
// ============================================================

module motor_envelope(
    z_position
)
{
    translate([
        0,
        0,
        z_position
    ])
    cylinder(
        h = HUB_HEIGHT + 4,
        d = MOTOR_ENVELOPE_D,
        center = true
    );
}


// ============================================================
// 16. ROTOR REFERENCE
// ============================================================

module rotor_reference(
    z_position
)
{
    translate([
        0,
        0,
        z_position
    ])
    cylinder(
        h = ROTOR_ENVELOPE_H,
        d = ROTOR_ENVELOPE_D,
        center = true
    );
}


// ============================================================
// 17. DUCT REFERENCE
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
            d = DUCT_ID,
            center = true
        );
    }
}


// ============================================================
// 18. AIRFLOW BLOCKAGE
// ============================================================

DUCT_AREA =
    PI *
    DUCT_R *
    DUCT_R;


// Center hub frontal area.

HUB_FRONTAL_AREA =
    PI *
    HUB_R *
    HUB_R;


// Approximate exposed arm frontal area.
//
// Each arm spans hub edge -> duct wall.

SINGLE_ARM_FRONTAL_AREA =
    ARM_RADIAL_LENGTH *
    ARM_TANGENTIAL_WIDTH;


// Arms partially overlap hub at their roots,
// so this is deliberately conservative.

TOTAL_ARM_FRONTAL_AREA =
    STATOR_ARM_COUNT *
    SINGLE_ARM_FRONTAL_AREA;


TOTAL_STATOR_FRONTAL_AREA =
    HUB_FRONTAL_AREA +
    TOTAL_ARM_FRONTAL_AREA;


BLOCKAGE_RATIO =
    TOTAL_STATOR_FRONTAL_AREA /
    DUCT_AREA;


// ============================================================
// 19. OPEN FLOW AREA
// ============================================================

OPEN_FLOW_AREA =
    DUCT_AREA -
    TOTAL_STATOR_FRONTAL_AREA;


OPEN_FLOW_RATIO =
    OPEN_FLOW_AREA /
    DUCT_AREA;


// ============================================================
// 20. AXIAL CLEARANCE
// ============================================================

STATOR_A_TOP =
    STATOR_A_Z +
    HUB_HEIGHT / 2;


STATOR_B_BOTTOM =
    STATOR_B_Z -
    HUB_HEIGHT / 2;


ROTOR_A_BOTTOM =
    ROTOR_A_Z -
    ROTOR_ENVELOPE_H / 2;


ROTOR_B_TOP =
    ROTOR_B_Z +
    ROTOR_ENVELOPE_H / 2;


CLEARANCE_A =
    ROTOR_A_BOTTOM -
    STATOR_A_TOP;


CLEARANCE_B =
    STATOR_B_BOTTOM -
    ROTOR_B_TOP;


// ============================================================
// 21. VALIDATION
// ============================================================

assert(
    STATOR_ARM_COUNT == 4,

    "FAIL: stator architecture requires fourfold symmetry."
);


assert(
    MOTOR_ENVELOPE_D <
    DUCT_ID,

    "FAIL: motor envelope cannot fit inside duct."
);


assert(
    HUB_OD <
    DUCT_ID,

    "FAIL: hub exceeds duct."
);


assert(
    ARM_TANGENTIAL_WIDTH >=
    MOTOR_SUPPORT_MIN_THICKNESS,

    "FAIL: stator arm below structural minimum."
);


assert(
    ARM_AXIAL_THICKNESS >=
    MOTOR_SUPPORT_MIN_THICKNESS,

    "FAIL: stator arm axial thickness below structural minimum."
);


assert(
    CLEARANCE_A >=
    MIN_STATOR_ROTOR_AXIAL_CLEARANCE,

    "FAIL: upper rotor/stator axial clearance insufficient."
);


assert(
    CLEARANCE_B >=
    MIN_STATOR_ROTOR_AXIAL_CLEARANCE,

    "FAIL: lower rotor/stator axial clearance insufficient."
);


assert(
    BLOCKAGE_RATIO <
    0.35,

    "FAIL: preliminary stator blocks >=35% of duct area."
);


// ============================================================
// 22. ENGINEERING OUTPUT
// ============================================================

echo(
    "============================================"
);

echo(
    "AIDRONE FILE 12 — MOTOR STATOR"
);

echo(
    "Motor envelope diameter =",
    MOTOR_ENVELOPE_D
);

echo(
    "Hub OD =",
    HUB_OD
);

echo(
    "Hub height =",
    HUB_HEIGHT
);

echo(
    "Stator arm count =",
    STATOR_ARM_COUNT
);

echo(
    "Arm radial length =",
    ARM_RADIAL_LENGTH
);

echo(
    "Arm width =",
    ARM_TANGENTIAL_WIDTH
);

echo(
    "Arm axial thickness =",
    ARM_AXIAL_THICKNESS
);

echo(
    "Duct frontal area mm2 =",
    DUCT_AREA
);

echo(
    "Hub frontal area mm2 =",
    HUB_FRONTAL_AREA
);

echo(
    "Approx arm frontal area mm2 =",
    TOTAL_ARM_FRONTAL_AREA
);

echo(
    "Conservative blockage ratio =",
    BLOCKAGE_RATIO
);

echo(
    "Open flow ratio =",
    OPEN_FLOW_RATIO
);

echo(
    "Upper rotor/stator clearance =",
    CLEARANCE_A
);

echo(
    "Lower rotor/stator clearance =",
    CLEARANCE_B
);

echo(
    "============================================"
);