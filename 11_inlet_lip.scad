/*
================================================================
AIDRONE
FILE 11 / 24
PARAMETRIC INLET LIP + DUCT TRANSITION

GLOBAL DATUM
------------
Origin = vehicle geometric center
+Z     = inlet
-Z     = exhaust

PURPOSE
-------
Creates the upper aerodynamic inlet interface between:
- 115 mm spherical vehicle envelope
- 74 mm duct OD
- 70 mm protected airflow throat

This is a TESTABLE inlet contour, not a claim of final
aerodynamic optimization.

DESIGN RULES
------------
1. Minimum flow diameter remains >= 70 mm.
2. No electronics enter the airflow.
3. Lip remains inside 115 mm spherical envelope.
4. Lip joins the Ø74 duct concentrically.
5. Geometry is rotationally symmetric about Z.
6. All dimensions are parameterized.
7. Inlet contour can later be swept experimentally.
================================================================
*/


include <00_master_parameters.scad>
include <02_materials_tolerances.scad>


$fn = 100;


// ============================================================
// 1. LOCKED VEHICLE GEOMETRY
// ============================================================

VEHICLE_D = 115.0;

VEHICLE_R =
    VEHICLE_D / 2;


// ============================================================
// 2. DUCT INTERFACE
// ============================================================

THROAT_D = 70.0;

THROAT_R =
    THROAT_D / 2;


DUCT_OD_LOCAL = 74.0;

DUCT_R_LOCAL =
    DUCT_OD_LOCAL / 2;


// Existing duct terminates at Z=+35.

DUCT_TOP_Z = 35.0;


// ============================================================
// 3. INLET GEOMETRY
// ============================================================

/*
The inlet occupies the region immediately above the duct.

Current prototype:

Z = 35 mm
    duct interface

Z = 41 mm
    expanded inlet mouth

This remains far inside the sphere's +57.5 mm pole.
*/

INLET_HEIGHT = 6.0;

INLET_Z_BOTTOM =
    DUCT_TOP_Z;

INLET_Z_TOP =
    INLET_Z_BOTTOM +
    INLET_HEIGHT;


// ============================================================
// 4. MOUTH DIAMETER
// ============================================================

/*
A modest expansion is used.

The inlet mouth is NOT expanded anywhere near the full sphere.

Keeping the transition compact:
- reduces plastic
- preserves shell space
- limits abrupt flow expansion

This value remains tunable.
*/

MOUTH_FLOW_D = 76.0;

MOUTH_FLOW_R =
    MOUTH_FLOW_D / 2;


// ============================================================
// 5. STRUCTURAL LIP
// ============================================================

LIP_RADIAL_THICKNESS = 2.0;

MOUTH_OUTER_D =
    MOUTH_FLOW_D +
    2 * LIP_RADIAL_THICKNESS;

MOUTH_OUTER_R =
    MOUTH_OUTER_D / 2;


// ============================================================
// 6. EDGE ROUNDING APPROXIMATION
// ============================================================

/*
OpenSCAD does not provide a native variable-radius aerodynamic
surface.

Instead of pretending a sharp cone is an optimized inlet,
we generate a smooth surface of revolution from sampled
radial stations.

Contour function uses smoothstep:

    S(t) = 3t² - 2t³

This gives zero first derivative at both ends.

It therefore avoids a slope discontinuity at the throat and
mouth in the mathematical profile.

Final profile must later be optimized experimentally/CFD.
*/

PROFILE_STEPS = 24;


// ============================================================
// 7. PROFILE FUNCTIONS
// ============================================================

function clamp01(x) =
    min(
        1,
        max(
            0,
            x
        )
    );


function smoothstep(t) =

    let(
        u = clamp01(t)
    )

    3*u*u -
    2*u*u*u;


// Inner aerodynamic radius.

function inlet_inner_radius(t) =

    THROAT_R +

    (
        MOUTH_FLOW_R -
        THROAT_R
    )

    * smoothstep(t);


// Outer structural radius.

function inlet_outer_radius(t) =

    DUCT_R_LOCAL +

    (
        MOUTH_OUTER_R -
        DUCT_R_LOCAL
    )

    * smoothstep(t);


// Z position.

function inlet_z(t) =

    INLET_Z_BOTTOM +

    INLET_HEIGHT * t;


// ============================================================
// 8. 2D PROFILE POINT GENERATION
// ============================================================

inner_points = [

    for (
        i = [
            0 :
            PROFILE_STEPS
        ]
    )

    let(
        t =
            i /
            PROFILE_STEPS
    )

    [
        inlet_inner_radius(t),
        inlet_z(t)
    ]

];


outer_points = [

    for (
        i = [
            PROFILE_STEPS :
            -1 :
            0
        ]
    )

    let(
        t =
            i /
            PROFILE_STEPS
    )

    [
        inlet_outer_radius(t),
        inlet_z(t)
    ]

];


profile_points =
    concat(
        inner_points,
        outer_points
    );


// ============================================================
// 9. DISPLAY OPTIONS
// ============================================================

SHOW_INLET = true;

SHOW_AIRFLOW = false;

SHOW_VEHICLE_ENVELOPE = false;

SHOW_DUCT_REFERENCE = false;


// ============================================================
// 10. MAIN
// ============================================================

inlet_system();


// ============================================================
// 11. INLET SYSTEM
// ============================================================

module inlet_system()
{
    if (
        SHOW_INLET
    )
    {
        aerodynamic_inlet_lip();
    }


    if (
        SHOW_AIRFLOW
    )
    {
        %inlet_airflow_volume();
    }


    if (
        SHOW_VEHICLE_ENVELOPE
    )
    {
        %vehicle_envelope();
    }


    if (
        SHOW_DUCT_REFERENCE
    )
    {
        %duct_reference();
    }
}


// ============================================================
// 12. STRUCTURAL INLET
// ============================================================

module aerodynamic_inlet_lip()
{
    rotate_extrude(
        convexity = 10
    )
    polygon(
        points =
            profile_points
    );
}


// ============================================================
// 13. AIRFLOW DEBUG VOLUME
// ============================================================

module inlet_airflow_volume()
{
    airflow_profile = [

        [0, INLET_Z_BOTTOM],

        for (
            i = [
                0 :
                PROFILE_STEPS
            ]
        )

        let(
            t =
                i /
                PROFILE_STEPS
        )

        [
            inlet_inner_radius(t),
            inlet_z(t)
        ],

        [0, INLET_Z_TOP]
    ];


    rotate_extrude(
        convexity = 10
    )
    polygon(
        points =
            airflow_profile
    );
}


// ============================================================
// 14. VEHICLE ENVELOPE DEBUG
// ============================================================

module vehicle_envelope()
{
    sphere(
        d = VEHICLE_D
    );
}


// ============================================================
// 15. DUCT REFERENCE
// ============================================================

module duct_reference()
{
    translate([
        0,
        0,
        0
    ])
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
// 16. SPHERE AVAILABLE RADIUS
// ============================================================

function sphere_radius_at_z(z) =

    abs(z) <= VEHICLE_R

    ?

    sqrt(
        VEHICLE_R *
        VEHICLE_R
        -
        z * z
    )

    :

    0;


// ============================================================
// 17. SHELL INNER AVAILABLE RADIUS
// ============================================================

SHELL_INNER_R_LOCAL =
    55.5;


function shell_inner_radius_at_z(z) =

    abs(z) <=
    SHELL_INNER_R_LOCAL

    ?

    sqrt(
        SHELL_INNER_R_LOCAL *
        SHELL_INNER_R_LOCAL
        -
        z * z
    )

    :

    0;


// ============================================================
// 18. GEOMETRIC VALIDATION
// ============================================================

assert(
    THROAT_D == 70,

    "FAIL: inlet throat must remain 70 mm."
);


assert(
    DUCT_OD_LOCAL == 74,

    "FAIL: inlet must mate to 74 mm duct."
);


assert(
    MOUTH_FLOW_D >=
    THROAT_D,

    "FAIL: inlet mouth cannot be smaller than throat."
);


assert(
    INLET_Z_TOP <
    VEHICLE_R,

    "FAIL: inlet extends beyond vehicle north pole."
);


assert(
    MOUTH_OUTER_R <
    sphere_radius_at_z(
        INLET_Z_TOP
    ),

    "FAIL: inlet mouth exits 115 mm spherical envelope."
);


assert(
    inlet_inner_radius(0) ==
    THROAT_R,

    "FAIL: inlet does not match 70 mm throat."
);


assert(
    inlet_outer_radius(0) ==
    DUCT_R_LOCAL,

    "FAIL: inlet outer wall does not match 74 mm duct."
);


// ============================================================
// 19. FLOW AREA CALCULATIONS
// ============================================================

THROAT_AREA_MM2 =

    PI *
    THROAT_R *
    THROAT_R;


MOUTH_AREA_MM2 =

    PI *
    MOUTH_FLOW_R *
    MOUTH_FLOW_R;


AREA_RATIO =

    MOUTH_AREA_MM2 /
    THROAT_AREA_MM2;


// ============================================================
// 20. CONTRACTION RATIO
// ============================================================

CONTRACTION_RATIO =

    THROAT_AREA_MM2 /
    MOUTH_AREA_MM2;


// ============================================================
// 21. SPHERE CLEARANCE
// ============================================================

AVAILABLE_RADIUS_AT_MOUTH =

    sphere_radius_at_z(
        INLET_Z_TOP
    );


RADIAL_ENVELOPE_CLEARANCE =

    AVAILABLE_RADIUS_AT_MOUTH -
    MOUTH_OUTER_R;


// ============================================================
// 22. OUTPUT
// ============================================================

echo(
    "============================================"
);

echo(
    "AIDRONE FILE 11 — INLET LIP"
);

echo(
    "Throat diameter =",
    THROAT_D
);

echo(
    "Mouth flow diameter =",
    MOUTH_FLOW_D
);

echo(
    "Mouth outer diameter =",
    MOUTH_OUTER_D
);

echo(
    "Inlet bottom Z =",
    INLET_Z_BOTTOM
);

echo(
    "Inlet top Z =",
    INLET_Z_TOP
);

echo(
    "Inlet height =",
    INLET_HEIGHT
);

echo(
    "Throat area mm2 =",
    THROAT_AREA_MM2
);

echo(
    "Mouth area mm2 =",
    MOUTH_AREA_MM2
);

echo(
    "Mouth / throat area ratio =",
    AREA_RATIO
);

echo(
    "Throat / mouth contraction ratio =",
    CONTRACTION_RATIO
);

echo(
    "Sphere radius available at mouth =",
    AVAILABLE_RADIUS_AT_MOUTH
);

echo(
    "Radial vehicle-envelope clearance =",
    RADIAL_ENVELOPE_CLEARANCE
);

echo(
    "Profile samples =",
    PROFILE_STEPS
);

echo(
    "============================================"
);