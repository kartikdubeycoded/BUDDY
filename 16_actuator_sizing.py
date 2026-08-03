"""
================================================================
AIDRONE
FILE 16 / 24
VANE ACTUATOR SIZING SOLVER

PURPOSE
-------
Estimate actuator requirements for one thrust-vectoring vane.

Calculates:
- local wake velocity
- dynamic pressure
- vane normal force
- aerodynamic center estimate
- hinge moment
- linkage force
- required actuator torque
- safety-factor requirement
- actuator angular travel
- required angular speed
- approximate actuation power
- sensitivity versus thrust and vane angle

IMPORTANT
---------
This is first-order sizing, NOT CFD.

Final actuator selection requires measured:
- rotor wake velocity
- vane hinge moment
- actuator torque-speed curve
- backlash
- current draw
- thermal behavior
- vibration resistance
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
    DESIGN_MASS_G /
    1000.0
)


# ==============================================================
# 3. DUCT
# ==============================================================

DUCT_DIAMETER_M = 0.070

DUCT_RADIUS_M = (
    DUCT_DIAMETER_M /
    2.0
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

CONTROL_THRUST_N = (
    HOVER_THRUST_N *
    1.5
)

MAX_THRUST_N = (
    HOVER_THRUST_N *
    2.0
)


# ==============================================================
# 5. VANE
# ==============================================================

VANE_SPAN_MM = 25.0

VANE_CHORD_MM = 15.0

VANE_AREA_M2 = (
    (
        VANE_SPAN_MM /
        1000.0
    )
    *
    (
        VANE_CHORD_MM /
        1000.0
    )
)

MAX_VANE_ANGLE_DEG = 25.0


# ==============================================================
# 6. HINGE MODEL
# ==============================================================

"""
Current CAD rotates the vane about a spanwise axis near the
geometric mid-chord assumption.

For conservative preliminary sizing we deliberately assume
the aerodynamic resultant acts some distance from the hinge.

HINGE_ARM_MM is NOT a final aerodynamic center.
"""

HINGE_ARM_MM = 4.0

HINGE_ARM_M = (
    HINGE_ARM_MM /
    1000.0
)


# ==============================================================
# 7. WAKE MODEL
# ==============================================================

"""
Ideal actuator disk:

vi = sqrt(T / (2 rho A))

far wake ~= 2 vi

Vanes may experience less than ideal far-wake velocity.

The factor is deliberately configurable.
"""

WAKE_VELOCITY_FACTOR = 0.75


# ==============================================================
# 8. ACTUATOR / LINKAGE GEOMETRY
# ==============================================================

"""
From File 15.

Final geometry changes after actuator selection.
"""

VANE_HORN_RADIUS_MM = 5.0

ACTUATOR_HORN_RADIUS_MM = 4.0


VANE_HORN_RADIUS_M = (
    VANE_HORN_RADIUS_MM /
    1000.0
)

ACTUATOR_HORN_RADIUS_M = (
    ACTUATOR_HORN_RADIUS_MM /
    1000.0
)


# ==============================================================
# 9. LINKAGE EFFICIENCY
# ==============================================================

"""
Accounts approximately for:
- friction
- angular misalignment
- compliance
- imperfect force transmission

Not measured yet.
"""

LINKAGE_EFFICIENCY = 0.75


# ==============================================================
# 10. ACTUATOR SAFETY FACTOR
# ==============================================================

ACTUATOR_TORQUE_SAFETY_FACTOR = 2.5


# ==============================================================
# 11. RESPONSE REQUIREMENT
# ==============================================================

"""
Target full vane transition:

-25 deg -> +25 deg

within this time.

This is a preliminary control requirement.
"""

FULL_TRANSITION_DEG = 50.0

TARGET_FULL_TRANSITION_TIME_S = 0.10


# ==============================================================
# 12. FLOW PHYSICS
# ==============================================================

def induced_velocity(
    thrust_n
):

    return math.sqrt(
        thrust_n /
        (
            2.0 *
            AIR_DENSITY *
            DUCT_AREA_M2
        )
    )


def vane_flow_velocity(
    thrust_n
):

    return (
        2.0 *
        induced_velocity(
            thrust_n
        )
        *
        WAKE_VELOCITY_FACTOR
    )


def dynamic_pressure(
    velocity_mps
):

    return (
        0.5 *
        AIR_DENSITY *
        velocity_mps**2
    )


# ==============================================================
# 13. NORMAL FORCE COEFFICIENT
# ==============================================================

def normal_force_coefficient(
    angle_deg
):

    alpha = math.radians(
        angle_deg
    )

    return (
        2.0 *
        math.sin(alpha) *
        math.cos(alpha)
    )


# ==============================================================
# 14. VANE FORCE
# ==============================================================

def vane_normal_force(
    thrust_n,
    angle_deg
):

    velocity = (
        vane_flow_velocity(
            thrust_n
        )
    )

    q = (
        dynamic_pressure(
            velocity
        )
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
# 15. HINGE MOMENT
# ==============================================================

def aerodynamic_hinge_moment(
    thrust_n,
    angle_deg
):

    force = (
        vane_normal_force(
            thrust_n,
            angle_deg
        )
    )

    return (
        force *
        HINGE_ARM_M
    )


# ==============================================================
# 16. LINKAGE FORCE
# ==============================================================

def required_linkage_force(
    thrust_n,
    angle_deg
):

    hinge_moment = (
        aerodynamic_hinge_moment(
            thrust_n,
            angle_deg
        )
    )

    return (
        hinge_moment /
        VANE_HORN_RADIUS_M
    )


# ==============================================================
# 17. ACTUATOR TORQUE
# ==============================================================

def actuator_torque_without_sf(
    thrust_n,
    angle_deg
):

    linkage_force = (
        required_linkage_force(
            thrust_n,
            angle_deg
        )
    )

    ideal_actuator_torque = (
        linkage_force *
        ACTUATOR_HORN_RADIUS_M
    )

    return (
        ideal_actuator_torque /
        LINKAGE_EFFICIENCY
    )


def required_actuator_torque(
    thrust_n,
    angle_deg
):

    return (
        actuator_torque_without_sf(
            thrust_n,
            angle_deg
        )
        *
        ACTUATOR_TORQUE_SAFETY_FACTOR
    )


# ==============================================================
# 18. TORQUE UNIT CONVERSIONS
# ==============================================================

def nm_to_ncm(
    torque_nm
):

    return (
        torque_nm *
        100.0
    )


def nm_to_kgcm(
    torque_nm
):

    return (
        torque_nm *
        10.19716213
    )


# ==============================================================
# 19. REQUIRED SPEED
# ==============================================================

def required_speed_deg_per_sec():

    return (
        FULL_TRANSITION_DEG /
        TARGET_FULL_TRANSITION_TIME_S
    )


def required_time_per_60deg():

    speed = (
        required_speed_deg_per_sec()
    )

    return (
        60.0 /
        speed
    )


# ==============================================================
# 20. APPROXIMATE MECHANICAL POWER
# ==============================================================

def actuator_mechanical_power(
    torque_nm
):

    angular_speed_deg_s = (
        required_speed_deg_per_sec()
    )

    angular_speed_rad_s = (
        math.radians(
            angular_speed_deg_s
        )
    )

    return (
        torque_nm *
        angular_speed_rad_s
    )


# ==============================================================
# 21. SINGLE CONDITION REPORT
# ==============================================================

def condition_report(
    name,
    thrust_n,
    angle_deg
):

    vi = (
        induced_velocity(
            thrust_n
        )
    )

    wake = (
        vane_flow_velocity(
            thrust_n
        )
    )

    q = (
        dynamic_pressure(
            wake
        )
    )

    force = (
        vane_normal_force(
            thrust_n,
            angle_deg
        )
    )

    hinge = (
        aerodynamic_hinge_moment(
            thrust_n,
            angle_deg
        )
    )

    linkage = (
        required_linkage_force(
            thrust_n,
            angle_deg
        )
    )

    actuator_raw = (
        actuator_torque_without_sf(
            thrust_n,
            angle_deg
        )
    )

    actuator_required = (
        required_actuator_torque(
            thrust_n,
            angle_deg
        )
    )

    power = (
        actuator_mechanical_power(
            actuator_required
        )
    )

    print()
    print(name)
    print("-" * 82)

    print(
        f"Thrust                  : "
        f"{thrust_n:.3f} N"
    )

    print(
        f"Vane angle              : "
        f"{angle_deg:.1f} deg"
    )

    print(
        f"Induced velocity        : "
        f"{vi:.2f} m/s"
    )

    print(
        f"Estimated vane velocity : "
        f"{wake:.2f} m/s"
    )

    print(
        f"Dynamic pressure        : "
        f"{q:.1f} Pa"
    )

    print(
        f"Vane normal force       : "
        f"{force:.4f} N"
    )

    print(
        f"Hinge moment            : "
        f"{hinge:.6f} N*m"
    )

    print(
        f"Linkage force           : "
        f"{linkage:.3f} N"
    )

    print(
        f"Raw actuator torque     : "
        f"{actuator_raw:.6f} N*m"
    )

    print(
        f"Required torque with SF : "
        f"{actuator_required:.6f} N*m"
    )

    print(
        f"Required torque         : "
        f"{nm_to_ncm(actuator_required):.3f} N*cm"
    )

    print(
        f"Required torque         : "
        f"{nm_to_kgcm(actuator_required):.3f} kg*cm"
    )

    print(
        f"Approx mech power       : "
        f"{power:.3f} W"
    )


# ==============================================================
# 22. ANGLE SENSITIVITY
# ==============================================================

def angle_sensitivity():

    print()
    print(
        "MAX-THRUST ANGLE SENSITIVITY"
    )

    print("-" * 92)

    print(
        f"{'Angle':>8}"
        f"{'Force N':>14}"
        f"{'Hinge Nm':>16}"
        f"{'Link N':>14}"
        f"{'Req Nm':>14}"
        f"{'Req kgcm':>14}"
    )

    for angle in [
        5,
        10,
        15,
        20,
        25
    ]:

        force = (
            vane_normal_force(
                MAX_THRUST_N,
                angle
            )
        )

        hinge = (
            aerodynamic_hinge_moment(
                MAX_THRUST_N,
                angle
            )
        )

        linkage = (
            required_linkage_force(
                MAX_THRUST_N,
                angle
            )
        )

        torque = (
            required_actuator_torque(
                MAX_THRUST_N,
                angle
            )
        )

        print(
            f"{angle:8.1f}"
            f"{force:14.4f}"
            f"{hinge:16.6f}"
            f"{linkage:14.3f}"
            f"{torque:14.6f}"
            f"{nm_to_kgcm(torque):14.3f}"
        )


# ==============================================================
# 23. THRUST SENSITIVITY
# ==============================================================

def thrust_sensitivity():

    print()
    print(
        "25-DEG THRUST SENSITIVITY"
    )

    print("-" * 82)

    cases = [
        (
            "Hover",
            HOVER_THRUST_N
        ),
        (
            "1.5x control",
            CONTROL_THRUST_N
        ),
        (
            "2.0x maximum",
            MAX_THRUST_N
        )
    ]

    print(
        f"{'Condition':>18}"
        f"{'Thrust N':>12}"
        f"{'Wake m/s':>14}"
        f"{'Force N':>14}"
        f"{'Req kgcm':>14}"
    )

    for name, thrust in cases:

        wake = (
            vane_flow_velocity(
                thrust
            )
        )

        force = (
            vane_normal_force(
                thrust,
                MAX_VANE_ANGLE_DEG
            )
        )

        torque = (
            required_actuator_torque(
                thrust,
                MAX_VANE_ANGLE_DEG
            )
        )

        print(
            f"{name:>18}"
            f"{thrust:12.3f}"
            f"{wake:14.2f}"
            f"{force:14.4f}"
            f"{nm_to_kgcm(torque):14.3f}"
        )


# ==============================================================
# 24. SPEED REQUIREMENT
# ==============================================================

def speed_report():

    speed = (
        required_speed_deg_per_sec()
    )

    time60 = (
        required_time_per_60deg()
    )

    print()
    print(
        "ACTUATOR SPEED REQUIREMENT"
    )

    print("-" * 82)

    print(
        f"Required transition      : "
        f"{FULL_TRANSITION_DEG:.1f} deg"
    )

    print(
        f"Target transition time   : "
        f"{TARGET_FULL_TRANSITION_TIME_S:.3f} s"
    )

    print(
        f"Required average speed   : "
        f"{speed:.1f} deg/s"
    )

    print(
        f"Equivalent specification : "
        f"{time60:.3f} s / 60 deg"
    )


# ==============================================================
# 25. LINKAGE RATIO REPORT
# ==============================================================

def linkage_report():

    ratio = (
        ACTUATOR_HORN_RADIUS_M /
        VANE_HORN_RADIUS_M
    )

    print()
    print(
        "LINKAGE GEOMETRY"
    )

    print("-" * 82)

    print(
        f"Vane horn radius      : "
        f"{VANE_HORN_RADIUS_MM:.2f} mm"
    )

    print(
        f"Actuator horn radius  : "
        f"{ACTUATOR_HORN_RADIUS_MM:.2f} mm"
    )

    print(
        f"Torque geometry ratio : "
        f"{ratio:.3f}"
    )

    print(
        f"Linkage efficiency    : "
        f"{LINKAGE_EFFICIENCY:.2f}"
    )


# ==============================================================
# 26. VALIDATION
# ==============================================================

def validation():

    print()
    print(
        "VALIDATION"
    )

    print("-" * 82)

    if LINKAGE_EFFICIENCY <= 0:
        raise ValueError(
            "Linkage efficiency must be positive."
        )

    if VANE_HORN_RADIUS_M <= 0:
        raise ValueError(
            "Vane horn radius must be positive."
        )

    if ACTUATOR_HORN_RADIUS_M <= 0:
        raise ValueError(
            "Actuator horn radius must be positive."
        )

    if (
        TARGET_FULL_TRANSITION_TIME_S <=
        0
    ):
        raise ValueError(
            "Transition time must be positive."
        )

    print(
        "PASS: mathematical inputs valid."
    )

    print(
        "WARNING: aerodynamic hinge arm is provisional."
    )

    print(
        "WARNING: actuator torque must be checked at operating speed,"
        " not stall torque alone."
    )


# ==============================================================
# 27. MAIN
# ==============================================================

def main():

    print("=" * 82)

    print(
        "AIDRONE FILE 16 — ACTUATOR SIZING"
    )

    print("=" * 82)

    print(
        f"Vehicle mass             : "
        f"{DESIGN_MASS_G:.1f} g"
    )

    print(
        f"Vane size                : "
        f"{VANE_SPAN_MM:.1f} x "
        f"{VANE_CHORD_MM:.1f} mm"
    )

    print(
        f"Maximum vane angle       : "
        f"{MAX_VANE_ANGLE_DEG:.1f} deg"
    )

    print(
        f"Torque safety factor     : "
        f"{ACTUATOR_TORQUE_SAFETY_FACTOR:.2f}"
    )

    linkage_report()

    condition_report(
        "HOVER / MAXIMUM VANE DEFLECTION",
        HOVER_THRUST_N,
        MAX_VANE_ANGLE_DEG
    )

    condition_report(
        "CONTROL THRUST / MAXIMUM VANE DEFLECTION",
        CONTROL_THRUST_N,
        MAX_VANE_ANGLE_DEG
    )

    condition_report(
        "MAX THRUST / MAXIMUM VANE DEFLECTION",
        MAX_THRUST_N,
        MAX_VANE_ANGLE_DEG
    )

    angle_sensitivity()

    thrust_sensitivity()

    speed_report()

    validation()

    print()
    print("=" * 82)

    print(
        "ACTUATOR SELECTION RULE"
    )

    print("=" * 82)

    print(
        "Select from continuous/dynamic torque at required speed."
    )

    print(
        "Do NOT select from advertised stall torque alone."
    )

    print(
        "Final actuator must fit the File 15 envelope only after"
        " its real dimensions are entered into CAD."
    )

    print("=" * 82)


if __name__ == "__main__":
    main()