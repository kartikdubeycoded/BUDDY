"""
================================================================
AIDRONE
FILE 05 / 24
CONTROL AUTHORITY + THRUST VECTORING SOLVER

PURPOSE
-------
First-order physics model for the four-vane thrust-vectoring
system located downstream of the 70 mm propulsion duct.

Calculates:

- exhaust-flow estimates
- dynamic pressure
- vane force
- lateral force
- control torque
- angular acceleration
- response-time estimates
- vane blockage
- sweep requirements
- sensitivity versus vane angle

IMPORTANT
---------
This is NOT CFD.

Flat-plate aerodynamic coefficients and flow uniformity are
approximations.

Final vane dimensions require:
1. CFD or better aerodynamic modelling
2. bench thrust testing
3. actuator testing
4. complete measured inertia tensor

Units are SI internally.
================================================================
"""

import math


# ==============================================================
# 1. CONSTANTS
# ==============================================================

G = 9.80665

AIR_DENSITY = 1.225


# ==============================================================
# 2. VEHICLE
# ==============================================================

DESIGN_MASS_G = 200.0

DESIGN_MASS_KG = (
    DESIGN_MASS_G / 1000.0
)

VEHICLE_RADIUS_MM = 57.5


# ==============================================================
# 3. PROPULSION DUCT
# ==============================================================

DUCT_DIAMETER_MM = 70.0

DUCT_RADIUS_M = (
    DUCT_DIAMETER_MM /
    2000.0
)

DUCT_AREA_M2 = (
    math.pi *
    DUCT_RADIUS_M**2
)


# ==============================================================
# 4. THRUST CONDITIONS
# ==============================================================

HOVER_THRUST_N = (
    DESIGN_MASS_KG *
    G
)

CONTROL_THRUST_RATIO = 1.5

CONTROL_THRUST_N = (
    HOVER_THRUST_N *
    CONTROL_THRUST_RATIO
)

MAX_THRUST_RATIO = 2.0

MAX_THRUST_N = (
    HOVER_THRUST_N *
    MAX_THRUST_RATIO
)


# ==============================================================
# 5. VANE ARCHITECTURE
# ==============================================================

VANE_COUNT = 4

MAX_VANE_ANGLE_DEG = 25.0


# --------------------------------------------------------------
# PRELIMINARY VANE ENVELOPE
# --------------------------------------------------------------
#
# These dimensions are NOT locked.
#
# The solver determines whether this starting geometry is
# remotely adequate.
#

VANE_SPAN_MM = 25.0

VANE_CHORD_MM = 15.0

VANE_THICKNESS_MM = 1.2


VANE_SPAN_M = (
    VANE_SPAN_MM /
    1000.0
)

VANE_CHORD_M = (
    VANE_CHORD_MM /
    1000.0
)


VANE_AREA_M2 = (
    VANE_SPAN_M *
    VANE_CHORD_M
)


TOTAL_VANE_AREA_M2 = (
    VANE_AREA_M2 *
    VANE_COUNT
)


# ==============================================================
# 6. VANE LOCATION
# ==============================================================

"""
Distance between vehicle center and approximate vane
aerodynamic center.

This is a preliminary moment arm.

Final value comes from CAD.
"""

VANE_MOMENT_ARM_MM = 28.0

VANE_MOMENT_ARM_M = (
    VANE_MOMENT_ARM_MM /
    1000.0
)


# ==============================================================
# 7. INERTIA MODEL
# ==============================================================

"""
Temporary inertia approximation.

A complete value will later be imported from
03_mass_properties.py.

For initial feasibility, approximate the 200 g vehicle as a
solid sphere.

Solid sphere:

    I = 2/5 m r^2

This is NOT the final vehicle inertia.
"""


VEHICLE_RADIUS_M = (
    VEHICLE_RADIUS_MM /
    1000.0
)


I_APPROX_KGM2 = (
    (2.0 / 5.0) *
    DESIGN_MASS_KG *
    VEHICLE_RADIUS_M**2
)


# ==============================================================
# 8. MOMENTUM THEORY
# ==============================================================

def induced_velocity(thrust_n):

    return math.sqrt(
        thrust_n /
        (
            2.0 *
            AIR_DENSITY *
            DUCT_AREA_M2
        )
    )


# ==============================================================
# 9. WAKE VELOCITY
# ==============================================================

"""
For ideal actuator-disk hover:

far-wake velocity ~= 2 * induced velocity.

The vane may not actually experience the complete ideal
far-wake velocity depending on its axial location.

Therefore we introduce WAKE_VELOCITY_FACTOR.

1.0 means:
    vane velocity = ideal far wake

Lower values represent losses / incomplete acceleration /
nonuniform flow.
"""

WAKE_VELOCITY_FACTOR = 0.75


def vane_flow_velocity(thrust_n):

    vi = induced_velocity(
        thrust_n
    )

    ideal_far_wake = (
        2.0 * vi
    )

    return (
        ideal_far_wake *
        WAKE_VELOCITY_FACTOR
    )


# ==============================================================
# 10. DYNAMIC PRESSURE
# ==============================================================

def dynamic_pressure(flow_velocity):

    return (
        0.5 *
        AIR_DENSITY *
        flow_velocity**2
    )


# ==============================================================
# 11. FLAT-PLATE NORMAL FORCE MODEL
# ==============================================================

"""
Approximate normal-force coefficient:

    Cn ~= 2 sin(alpha) cos(alpha)

Equivalent:

    Cn ~= sin(2 alpha)

This is deliberately simple.

It should NOT be considered accurate at large angles,
separated flow, duct-wall interaction or rotor wake swirl.
"""


def normal_force_coefficient(
    angle_deg
):

    angle_rad = math.radians(
        angle_deg
    )

    return (
        2.0 *
        math.sin(angle_rad) *
        math.cos(angle_rad)
    )


# ==============================================================
# 12. SINGLE-VANE FORCE
# ==============================================================

def single_vane_force(
    thrust_n,
    angle_deg
):

    velocity = (
        vane_flow_velocity(
            thrust_n
        )
    )

    q = dynamic_pressure(
        velocity
    )

    cn = (
        normal_force_coefficient(
            angle_deg
        )
    )

    return (
        q *
        VANE_AREA_M2 *
        cn
    )


# ==============================================================
# 13. CONTROL PAIR FORCE
# ==============================================================

"""
For pitch or roll:

Use an opposing vane pair.

This simplified model assumes two vanes contribute useful
control force.

Actual vane mixing will later be determined by the flight
controller.
"""


ACTIVE_VANES_PER_AXIS = 2


def control_pair_force(
    thrust_n,
    angle_deg
):

    return (
        ACTIVE_VANES_PER_AXIS *
        single_vane_force(
            thrust_n,
            angle_deg
        )
    )


# ==============================================================
# 14. CONTROL TORQUE
# ==============================================================

def control_torque(
    thrust_n,
    angle_deg
):

    force = (
        control_pair_force(
            thrust_n,
            angle_deg
        )
    )

    return (
        force *
        VANE_MOMENT_ARM_M
    )


# ==============================================================
# 15. ANGULAR ACCELERATION
# ==============================================================

def angular_acceleration(
    thrust_n,
    angle_deg,
    inertia_kgm2
):

    torque = (
        control_torque(
            thrust_n,
            angle_deg
        )
    )

    return (
        torque /
        inertia_kgm2
    )


# ==============================================================
# 16. SIMPLE ROTATION TIME
# ==============================================================

"""
For constant angular acceleration starting from rest:

    theta = 0.5 alpha t^2

therefore:

    t = sqrt(2 theta / alpha)

This does NOT model braking.

It is only a rough indication of available authority.
"""


def approximate_rotation_time(
    target_angle_deg,
    angular_accel
):

    if angular_accel <= 0:
        return math.inf

    theta_rad = math.radians(
        target_angle_deg
    )

    return math.sqrt(
        2.0 *
        theta_rad /
        angular_accel
    )


# ==============================================================
# 17. VANE BLOCKAGE
# ==============================================================

def geometric_blockage_ratio():

    return (
        TOTAL_VANE_AREA_M2 /
        DUCT_AREA_M2
    )


# ==============================================================
# 18. PROJECTED BLOCKAGE
# ==============================================================

def projected_vane_area(
    angle_deg
):

    angle_rad = math.radians(
        angle_deg
    )

    return (
        TOTAL_VANE_AREA_M2 *
        abs(
            math.sin(
                angle_rad
            )
        )
    )


def projected_blockage_ratio(
    angle_deg
):

    return (
        projected_vane_area(
            angle_deg
        ) /
        DUCT_AREA_M2
    )


# ==============================================================
# 19. VANE SWEEP ENVELOPE
# ==============================================================

"""
Approximate extra lateral displacement generated by rotating
the vane about one edge.

This is useful later for CAD keep-out generation.
"""


def vane_sweep_displacement_mm(
    angle_deg
):

    angle_rad = math.radians(
        angle_deg
    )

    return (
        VANE_CHORD_MM *
        abs(
            math.sin(
                angle_rad
            )
        )
    )


# ==============================================================
# 20. FLOW REPORT
# ==============================================================

def flow_report(
    name,
    thrust_n
):

    vi = induced_velocity(
        thrust_n
    )

    velocity = vane_flow_velocity(
        thrust_n
    )

    q = dynamic_pressure(
        velocity
    )

    print()
    print(name)
    print("-" * 78)

    print(
        f"Thrust                 : "
        f"{thrust_n:.3f} N"
    )

    print(
        f"Induced velocity       : "
        f"{vi:.2f} m/s"
    )

    print(
        f"Estimated vane velocity: "
        f"{velocity:.2f} m/s"
    )

    print(
        f"Dynamic pressure       : "
        f"{q:.1f} Pa"
    )


# ==============================================================
# 21. ANGLE SWEEP REPORT
# ==============================================================

def angle_sweep_report(
    thrust_n
):

    angles = [
        0,
        5,
        10,
        15,
        20,
        25
    ]

    print()
    print(
        "VANE ANGLE / CONTROL AUTHORITY"
    )

    print("-" * 100)

    print(
        f"{'Angle':>8}"
        f"{'Cn':>10}"
        f"{'1 vane F':>14}"
        f"{'Pair F':>14}"
        f"{'Torque':>14}"
        f"{'Alpha':>14}"
        f"{'10deg time':>14}"
    )

    print(
        f"{'(deg)':>8}"
        f"{'':>10}"
        f"{'(N)':>14}"
        f"{'(N)':>14}"
        f"{'(N*m)':>14}"
        f"{'(rad/s2)':>14}"
        f"{'(s)':>14}"
    )

    for angle in angles:

        cn = (
            normal_force_coefficient(
                angle
            )
        )

        single_force = (
            single_vane_force(
                thrust_n,
                angle
            )
        )

        pair_force = (
            control_pair_force(
                thrust_n,
                angle
            )
        )

        torque = (
            control_torque(
                thrust_n,
                angle
            )
        )

        alpha = (
            angular_acceleration(
                thrust_n,
                angle,
                I_APPROX_KGM2
            )
        )

        rotation_time = (
            approximate_rotation_time(
                10,
                alpha
            )
        )

        print(
            f"{angle:8.1f}"
            f"{cn:10.3f}"
            f"{single_force:14.4f}"
            f"{pair_force:14.4f}"
            f"{torque:14.6f}"
            f"{alpha:14.2f}"
            f"{rotation_time:14.3f}"
        )


# ==============================================================
# 22. BLOCKAGE REPORT
# ==============================================================

def blockage_report():

    print()
    print(
        "VANE BLOCKAGE"
    )

    print("-" * 78)

    print(
        f"Duct area          : "
        f"{DUCT_AREA_M2*1e6:.1f} mm^2"
    )

    print(
        f"Single vane area   : "
        f"{VANE_AREA_M2*1e6:.1f} mm^2"
    )

    print(
        f"Four vane area     : "
        f"{TOTAL_VANE_AREA_M2*1e6:.1f} mm^2"
    )

    print(
        f"Raw area ratio     : "
        f"{100*geometric_blockage_ratio():.1f}%"
    )

    for angle in [
        0,
        5,
        10,
        15,
        20,
        25
    ]:

        blockage = (
            projected_blockage_ratio(
                angle
            )
        )

        print(
            f"Projected blockage "
            f"at {angle:2d} deg : "
            f"{100*blockage:6.2f}%"
        )


# ==============================================================
# 23. SWEEP REPORT
# ==============================================================

def sweep_report():

    print()
    print(
        "MECHANICAL SWEEP ENVELOPE"
    )

    print("-" * 78)

    displacement = (
        vane_sweep_displacement_mm(
            MAX_VANE_ANGLE_DEG
        )
    )

    print(
        f"Vane chord                 : "
        f"{VANE_CHORD_MM:.2f} mm"
    )

    print(
        f"Maximum deflection         : "
        f"+/- {MAX_VANE_ANGLE_DEG:.1f} deg"
    )

    print(
        f"Approx. lateral sweep      : "
        f"{displacement:.2f} mm"
    )

    print(
        "CAD must reserve this swept region, not only the neutral vane."
    )


# ==============================================================
# 24. INERTIA REPORT
# ==============================================================

def inertia_report():

    print()
    print(
        "PROVISIONAL VEHICLE INERTIA"
    )

    print("-" * 78)

    print(
        f"Solid-sphere approximation: "
        f"{I_APPROX_KGM2:.8e} kg*m^2"
    )

    print(
        "This value MUST later be replaced by File 03 output."
    )


# ==============================================================
# 25. SANITY CHECKS
# ==============================================================

def validation():

    print()
    print(
        "VALIDATION"
    )

    print("-" * 78)

    if (
        MAX_VANE_ANGLE_DEG >
        30
    ):

        print(
            "WARNING: large vane angle likely produces strong separation."
        )

    else:

        print(
            "PASS: vane angular range remains within preliminary study range."
        )


    blockage_25 = (
        projected_blockage_ratio(
            MAX_VANE_ANGLE_DEG
        )
    )


    if blockage_25 > 0.20:

        print(
            "WARNING: projected vane blockage exceeds 20% at maximum deflection."
        )

    else:

        print(
            "PASS: projected geometric blockage below provisional 20% threshold."
        )


    if (
        VANE_SPAN_MM >
        DUCT_DIAMETER_MM
    ):

        print(
            "HARD FAIL: vane span exceeds duct diameter."
        )

    else:

        print(
            "PASS: preliminary vane span fits within duct diameter."
        )


# ==============================================================
# 26. MAIN
# ==============================================================

def main():

    print("=" * 100)

    print(
        "AIDRONE CONTROL AUTHORITY SOLVER"
    )

    print("=" * 100)

    print(
        f"Design mass              : "
        f"{DESIGN_MASS_G:.1f} g"
    )

    print(
        f"Hover thrust             : "
        f"{HOVER_THRUST_N:.3f} N"
    )

    print(
        f"Control-condition thrust : "
        f"{CONTROL_THRUST_N:.3f} N"
    )

    print(
        f"Maximum design thrust    : "
        f"{MAX_THRUST_N:.3f} N"
    )

    print(
        f"Vane count               : "
        f"{VANE_COUNT}"
    )

    print(
        f"Preliminary vane size    : "
        f"{VANE_SPAN_MM:.1f} x "
        f"{VANE_CHORD_MM:.1f} x "
        f"{VANE_THICKNESS_MM:.1f} mm"
    )

    inertia_report()

    flow_report(
        "HOVER FLOW CONDITION",
        HOVER_THRUST_N
    )

    flow_report(
        "CONTROL FLOW CONDITION",
        CONTROL_THRUST_N
    )

    angle_sweep_report(
        CONTROL_THRUST_N
    )

    blockage_report()

    sweep_report()

    validation()

    print()
    print("=" * 100)

    print(
        "ENGINEERING INTERPRETATION"
    )

    print("=" * 100)

    print(
        "1. Forces are preliminary aerodynamic estimates."
    )

    print(
        "2. Final control authority depends on measured rotor wake."
    )

    print(
        "3. Final inertia must come from the complete mass model."
    )

    print(
        "4. The complete +/-25 degree swept volume must become a CAD keep-out."
    )

    print(
        "5. Vane dimensions remain UNLOCKED until propulsion and actuator data exist."
    )

    print("=" * 100)


if __name__ == "__main__":
    main()