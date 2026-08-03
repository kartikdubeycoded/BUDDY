/*
================================================================
AIDRONE
FILE 02 / 24
MATERIALS + MANUFACTURING + TOLERANCE AUTHORITY

PURPOSE
-------
Single source of truth for prototype manufacturing rules.

This file generates NO vehicle geometry.

It defines:
- FDM process assumptions
- PLA prototype rules
- wall thickness rules
- minimum structural members
- sliding fits
- removable fits
- moving joints
- camera clearances
- wire-channel clearances
- screw clearances
- boss geometry
- heat-set insert placeholders
- edge radii
- print-orientation rules
- tolerance helper functions

IMPORTANT
---------
Printer-specific calibration overrides generic assumptions.

Before manufacturing flight hardware:
print calibration coupons and update the measured compensation
variables in this file.
================================================================
*/


$fn = 100;


// ============================================================
// 1. PROCESS
// ============================================================

PROCESS_FDM = 1;

MANUFACTURING_PROCESS =
    PROCESS_FDM;


// ============================================================
// 2. NOZZLE / LAYER
// ============================================================

NOZZLE_D = 0.40;

LAYER_HEIGHT =
    0.20;


// ============================================================
// 3. EXTRUSION WIDTH
// ============================================================

/*
Typical extrusion line may be slightly wider than nozzle.

This is a planning value.

Use slicer-calibrated value later.
*/

EXTRUSION_WIDTH =
    0.45;


// ============================================================
// 4. WALL CLASSES
// ============================================================

// 3 extrusion lines

WALL_LIGHT =
    3 * EXTRUSION_WIDTH;


// 4 extrusion lines

WALL_STANDARD =
    4 * EXTRUSION_WIDTH;


// 5 extrusion lines

WALL_STRUCTURAL =
    5 * EXTRUSION_WIDTH;


// 6 extrusion lines

WALL_HEAVY =
    6 * EXTRUSION_WIDTH;


// ============================================================
// 5. DUCT WALL
// ============================================================

/*
The aerodynamic duct retains the locked 2 mm nominal wall.

This is intentionally independent of exact extrusion count.
*/

DUCT_WALL_NOMINAL =
    2.00;


// ============================================================
// 6. CRASH-CAGE MEMBER
// ============================================================

/*
Structural solver starts at 2 mm.

Manufacturing rule prevents members smaller than this without
explicit engineering justification.
*/

MIN_CRASH_MEMBER =
    2.00;


PREFERRED_CRASH_MEMBER =
    2.40;


// ============================================================
// 7. ABSOLUTE PRINTABLE FEATURE
// ============================================================

/*
Do not use this for load-bearing members.

This only represents a small printable geometric feature.
*/

MIN_PRINT_FEATURE =
    0.80;


// ============================================================
// 8. CLEARANCE CLASSES
// ============================================================

/*
CLEARANCE DEFINITIONS

All values below are PER SIDE unless explicitly identified as
diametral.

Example:

74.0 mm male cylinder
0.20 mm sliding radial clearance

female bore:

74.0 + 2(0.20)
=
74.4 mm
*/


// ------------------------------------------------------------
// CLOSE STATIC ASSEMBLY
// ------------------------------------------------------------

CLEARANCE_CLOSE =
    0.10;


// ------------------------------------------------------------
// NORMAL REMOVABLE ASSEMBLY
// ------------------------------------------------------------

CLEARANCE_REMOVABLE =
    0.15;


// ------------------------------------------------------------
// SLIDING FIT
// ------------------------------------------------------------

CLEARANCE_SLIDING =
    0.20;


// ------------------------------------------------------------
// FREE MOVING JOINT
// ------------------------------------------------------------

CLEARANCE_MOVING =
    0.35;


// ------------------------------------------------------------
// ROUGH / SERVICE FIT
// ------------------------------------------------------------

CLEARANCE_SERVICE =
    0.40;


// ============================================================
// 9. CYLINDRICAL FIT FUNCTIONS
// ============================================================

function female_bore_for_male(
    male_diameter,
    radial_clearance
) =

    male_diameter +
    2 * radial_clearance;


function male_for_female_bore(
    female_diameter,
    radial_clearance
) =

    female_diameter -
    2 * radial_clearance;


// ============================================================
// 10. RECTANGULAR POCKET FUNCTIONS
// ============================================================

function pocket_dimension(
    part_dimension,
    side_clearance
) =

    part_dimension +
    2 * side_clearance;


// ============================================================
// 11. CURRENT CORE / COLLAR INTERFACE
// ============================================================

CORE_OD =
    74.0;


CORE_COLLAR_RADIAL_CLEARANCE =
    CLEARANCE_SLIDING;


COLLAR_BORE =

    female_bore_for_male(
        CORE_OD,
        CORE_COLLAR_RADIAL_CLEARANCE
    );


// Expected:
//
// 74 + 0.4 = 74.4 mm


// ============================================================
// 12. CAMERA FIT
// ============================================================

CAMERA_BODY_X =
    14.0;

CAMERA_BODY_Y =
    14.0;

CAMERA_BODY_Z =
    14.0;


// Camera should be removable without being loose.

CAMERA_SIDE_CLEARANCE =
    CLEARANCE_REMOVABLE;


CAMERA_POCKET_X =

    pocket_dimension(
        CAMERA_BODY_X,
        CAMERA_SIDE_CLEARANCE
    );


CAMERA_POCKET_Y =

    pocket_dimension(
        CAMERA_BODY_Y,
        CAMERA_SIDE_CLEARANCE
    );


CAMERA_POCKET_Z =

    pocket_dimension(
        CAMERA_BODY_Z,
        CAMERA_SIDE_CLEARANCE
    );


// Expected:
//
// 14.3 mm each axis


// ============================================================
// 13. KEY / KEYWAY FIT
// ============================================================

KEY_SIDE_CLEARANCE =
    CLEARANCE_SLIDING;


function keyway_width(
    key_width
) =

    key_width +
    2 * KEY_SIDE_CLEARANCE;


function keyway_depth(
    key_projection
) =

    key_projection +
    CLEARANCE_SLIDING;


// ============================================================
// 14. MOVING PIVOT FIT
// ============================================================

/*
For printed shaft rotating inside printed bore.

This is deliberately looser than the collar interface.
*/

PIVOT_RADIAL_CLEARANCE =
    CLEARANCE_MOVING;


function pivot_bore(
    shaft_diameter
) =

    shaft_diameter +
    2 * PIVOT_RADIAL_CLEARANCE;


// Example:
//
// 2 mm shaft:
//
// 2 + 0.7 = 2.7 mm printed bore
//
// This is a prototype starting point.
//
// A metal pin / bushing interface will use a different rule.


// ============================================================
// 15. METAL PIN CLEARANCE
// ============================================================

METAL_PIN_RADIAL_CLEARANCE =
    0.10;


function metal_pin_bore(
    pin_diameter
) =

    pin_diameter +
    2 * METAL_PIN_RADIAL_CLEARANCE;


// ============================================================
// 16. SCREW CLEARANCE
// ============================================================

/*
Nominal metric screw clearance holes.

These are prototype FDM dimensions, not ISO precision
machining tables.
*/


M1_6_NOMINAL =
    1.60;

M2_NOMINAL =
    2.00;

M2_5_NOMINAL =
    2.50;


M1_6_CLEARANCE_HOLE =
    1.90;

M2_CLEARANCE_HOLE =
    2.40;

M2_5_CLEARANCE_HOLE =
    2.90;


// ============================================================
// 17. SCREW EDGE DISTANCE
// ============================================================

/*
Minimum material from hole center to free edge.

Use larger values for impact-loaded joints.
*/

SCREW_EDGE_FACTOR =
    2.0;


function minimum_screw_edge_distance(
    screw_nominal_d
) =

    screw_nominal_d *
    SCREW_EDGE_FACTOR;


// ============================================================
// 18. PRINTED BOSS RULE
// ============================================================

BOSS_WALL_MIN =
    1.60;


function boss_outer_diameter(
    hole_diameter
) =

    hole_diameter +
    2 * BOSS_WALL_MIN;


// ============================================================
// 19. HEAT-SET INSERT PLACEHOLDERS
// ============================================================

/*
NO final insert dimensions are locked.

Actual insert OD, length and installation-hole diameter must be
taken from the selected insert manufacturer's drawing.
*/

INSERT_SELECTED =
    false;

INSERT_OD =
    0;

INSERT_LENGTH =
    0;

INSERT_HOLE_D =
    0;


// ============================================================
// 20. FILLET / EDGE RULES
// ============================================================

MIN_STRUCTURAL_FILLET =
    1.0;


PREFERRED_STRUCTURAL_FILLET =
    1.5;


// ============================================================
// 21. WIRE ROUTING
// ============================================================

WIRE_CHANNEL_SIDE_CLEARANCE =
    0.50;


function wire_channel_width(
    wire_bundle_width
) =

    wire_bundle_width +
    2 * WIRE_CHANNEL_SIDE_CLEARANCE;


// ============================================================
// 22. WIRE BEND RADIUS
// ============================================================

/*
Generic starting rule.

Actual coax, silicone wire and flex cables differ.
*/

WIRE_MIN_BEND_RADIUS_FACTOR =
    3.0;


function wire_min_bend_radius(
    cable_diameter
) =

    cable_diameter *
    WIRE_MIN_BEND_RADIUS_FACTOR;


// ============================================================
// 23. BATTERY FIT
// ============================================================

/*
LiPo cells should NOT be hard-clamped by brittle printed walls.

Allow clearance for:
- manufacturing variation
- protective tape
- swelling
- foam isolation
*/

BATTERY_SIDE_CLEARANCE =
    0.50;


function battery_pocket_dimension(
    battery_dimension
) =

    battery_dimension +
    2 * BATTERY_SIDE_CLEARANCE;


// ============================================================
// 24. BATTERY IMPACT PADDING
// ============================================================

BATTERY_MIN_PADDING =
    1.0;


// ============================================================
// 25. MOTOR MOUNT RULES
// ============================================================

MOTOR_SUPPORT_MIN_THICKNESS =
    2.40;


MOTOR_SUPPORT_PREFERRED_THICKNESS =
    3.00;


// ============================================================
// 26. ROTOR / DUCT MANUFACTURING CLEARANCE
// ============================================================

/*
This is NOT the final aerodynamic tip clearance.

It defines a manufacturing safety floor.

The propulsion solver currently studies:

70 mm duct
68 mm rotor
= 1 mm radial static clearance.

Do not reduce below this without rotor-runout testing.
*/

MIN_ROTOR_STATIC_RADIAL_CLEARANCE =
    1.00;


// ============================================================
// 27. VANE / SHELL MECHANICAL CLEARANCE
// ============================================================

VANE_SWEEP_MIN_CLEARANCE =
    1.00;


// ============================================================
// 28. CAMERA FOV STRUCTURAL CLEARANCE
// ============================================================

/*
Additional angular margin around nominal camera FOV.

Prevents cage members sitting exactly on theoretical FOV edge.
*/

CAMERA_FOV_MARGIN_DEG =
    3.0;


// ============================================================
// 29. PRINT ORIENTATION RULES
// ============================================================

/*
RULE P1
-------
Motor-support bending loads should preferably lie in XY printed
material directions rather than pulling layers apart.


RULE P2
-------
Vane pivots should not depend on a thin Z-layer neck.


RULE P3
-------
Crash cage joints must avoid pure layer-separation loading.


RULE P4
-------
Screw bosses should use generous root fillets.


RULE P5
-------
Battery retention must not use brittle snap features as the
only containment mechanism.


RULE P6
-------
Rotor containment region must not rely on decorative lattice.
*/


// ============================================================
// 30. CALIBRATION COMPENSATION
// ============================================================

/*
Set these after printing calibration coupons.

Example:

If printer consistently makes external XY features 0.10 mm
oversize, compensation can be introduced here.

Leave zero until measured.
*/

XY_EXTERNAL_COMPENSATION =
    0.00;


XY_INTERNAL_COMPENSATION =
    0.00;


Z_COMPENSATION =
    0.00;


// ============================================================
// 31. COMPENSATED HELPERS
// ============================================================

function compensated_external(
    dimension
) =

    dimension +
    XY_EXTERNAL_COMPENSATION;


function compensated_internal(
    dimension
) =

    dimension +
    XY_INTERNAL_COMPENSATION;


// ============================================================
// 32. VALIDATION
// ============================================================

assert(
    NOZZLE_D > 0,
    "Nozzle diameter must be positive."
);


assert(
    WALL_STANDARD >=
    3 * NOZZLE_D,

    "Standard wall unexpectedly thin."
);


assert(
    MIN_CRASH_MEMBER >=
    2.0,

    "Crash member below structural study minimum."
);


assert(
    CLEARANCE_MOVING >
    CLEARANCE_SLIDING,

    "Moving fit must be looser than sliding fit."
);


assert(
    CLEARANCE_SLIDING >
    CLEARANCE_CLOSE,

    "Sliding fit must be looser than close fit."
);


assert(
    COLLAR_BORE ==
    74.4,

    "Core/collar interface changed unexpectedly."
);


assert(
    MIN_ROTOR_STATIC_RADIAL_CLEARANCE >=
    1.0,

    "Rotor manufacturing clearance below current safety floor."
);


// ============================================================
// 33. OUTPUT
// ============================================================

echo(
    "============================================"
);

echo(
    "AIDRONE MATERIAL / TOLERANCE AUTHORITY"
);

echo(
    "Nozzle diameter =",
    NOZZLE_D
);

echo(
    "Layer height =",
    LAYER_HEIGHT
);

echo(
    "Light wall =",
    WALL_LIGHT
);

echo(
    "Standard wall =",
    WALL_STANDARD
);

echo(
    "Structural wall =",
    WALL_STRUCTURAL
);

echo(
    "Preferred crash member =",
    PREFERRED_CRASH_MEMBER
);

echo(
    "Sliding radial clearance =",
    CLEARANCE_SLIDING
);

echo(
    "Core OD =",
    CORE_OD
);

echo(
    "Collar bore =",
    COLLAR_BORE
);

echo(
    "Camera pocket X =",
    CAMERA_POCKET_X
);

echo(
    "Camera pocket Y =",
    CAMERA_POCKET_Y
);

echo(
    "Camera pocket Z =",
    CAMERA_POCKET_Z
);

echo(
    "M2 printed clearance hole =",
    M2_CLEARANCE_HOLE
);

echo(
    "Minimum motor support thickness =",
    MOTOR_SUPPORT_MIN_THICKNESS
);

echo(
    "Minimum rotor radial clearance =",
    MIN_ROTOR_STATIC_RADIAL_CLEARANCE
);

echo(
    "============================================"
);