"""
================================================================
AIDRONE
FILE 06 / 24
STRUCTURAL LOAD + PLA SIZING SOLVER

PURPOSE
-------
First-order structural design model.

Evaluates:
- maneuver loads
- landing loads
- side impact loads
- motor mount loads
- thrust loads
- beam bending stress
- axial stress
- safety factors
- PLA directional strength assumptions
- shell/lattice member sizing

IMPORTANT
---------
This is NOT FEA.

Final structural validation requires:
1. final CAD geometry
2. actual print orientation
3. measured material properties
4. impact testing
5. vibration testing
================================================================
"""

import math


# ==============================================================
# 1. CONSTANTS
# ==============================================================

G = 9.80665


# ==============================================================
# 2. VEHICLE MASS
# ==============================================================

DESIGN_MASS_G = 200.0

HARD_LIMIT_MASS_G = 225.0

DESIGN_MASS_KG = (
    DESIGN_MASS_G / 1000.0
)

HARD_LIMIT_MASS_KG = (
    HARD_LIMIT_MASS_G / 1000.0
)


# ==============================================================
# 3. VEHICLE GEOMETRY
# ==============================================================

VEHICLE_OD_MM = 115.0

VEHICLE_RADIUS_MM = (
    VEHICLE_OD_MM / 2.0
)

VEHICLE_RADIUS_M = (
    VEHICLE_RADIUS_MM / 1000.0
)


# ==============================================================
# 4. PLA PROVISIONAL MATERIAL MODEL
# ==============================================================

"""
These are conservative ENGINEERING DESIGN ALLOWABLES,
not claims about every PLA print.

Actual printed properties depend strongly on:
- material brand
- moisture
- nozzle temperature
- layer height
- raster direction
- wall count
- infill
- print orientation

Final values must be replaced with coupon-test data.
"""

PLA_XY_TENSILE_ALLOWABLE_MPA = 30.0

PLA_Z_TENSILE_ALLOWABLE_MPA = 18.0

PLA_XY_BENDING_ALLOWABLE_MPA = 35.0

PLA_Z_BENDING_ALLOWABLE_MPA = 20.0


# ==============================================================
# 5. SAFETY FACTORS
# ==============================================================

STATIC_SAFETY_FACTOR = 2.0

MOTOR_MOUNT_SAFETY_FACTOR = 2.5

IMPACT_SAFETY_FACTOR = 1.5


# ==============================================================
# 6. MANEUVER LOAD CASE
# ==============================================================

MANEUVER_G = 3.0


def maneuver_force_n(
    mass_kg
):

    return (
        mass_kg *
        G *
        MANEUVER_G
    )


# ==============================================================
# 7. THRUST LOAD CASE
# ==============================================================

MAX_THRUST_RATIO = 2.0


def max_thrust_n(
    mass_kg
):

    return (
        mass_kg *
        G *
        MAX_THRUST_RATIO
    )


# ==============================================================
# 8. LANDING IMPACT MODEL
# ==============================================================

"""
Simplified energy model.

Vehicle drops vertically by DROP_HEIGHT.

Potential energy:

    E = mgh

Assume crash structure stops vehicle over STOP_DISTANCE.

Average stopping force from work-energy:

    F_avg * d = mgh

therefore:

    F_avg = mgh / d

Actual peak force can be substantially larger.
"""

DROP_HEIGHT_M = 0.50

STOP_DISTANCE_MM = 8.0

STOP_DISTANCE_M = (
    STOP_DISTANCE_MM /
    1000.0
)


def impact_energy_j(
    mass_kg
):

    return (
        mass_kg *
        G *
        DROP_HEIGHT_M
    )


def average_impact_force_n(
    mass_kg
):

    return (
        impact_energy_j(
            mass_kg
        ) /
        STOP_DISTANCE_M
    )


# ==============================================================
# 9. SIDE IMPACT
# ==============================================================

SIDE_IMPACT_SPEED_MPS = 2.0


def kinetic_energy_j(
    mass_kg,
    speed_mps
):

    return (
        0.5 *
        mass_kg *
        speed_mps**2
    )


def side_impact_force_n(
    mass_kg
):

    energy = (
        kinetic_energy_j(
            mass_kg,
            SIDE_IMPACT_SPEED_MPS
        )
    )

    return (
        energy /
        STOP_DISTANCE_M
    )


# ==============================================================
# 10. LATTICE MEMBER
# ==============================================================

"""
Preliminary crash-cage member.

Square section chosen because it maps naturally to FDM walls.

Not locked.
"""

MEMBER_WIDTH_MM = 2.0

MEMBER_HEIGHT_MM = 2.0


# ==============================================================
# 11. CROSS SECTION
# ==============================================================

def rectangular_area_mm2(
    width_mm,
    height_mm
):

    return (
        width_mm *
        height_mm
    )


def rectangular_second_moment_mm4(
    width_mm,
    height_mm
):

    return (
        width_mm *
        height_mm**3 /
        12.0
    )


# ==============================================================
# 12. AXIAL STRESS
# ==============================================================

def axial_stress_mpa(
    force_n,
    area_mm2
):

    # 1 N/mm² = 1 MPa

    return (
        force_n /
        area_mm2
    )


# ==============================================================
# 13. BENDING STRESS
# ==============================================================

def bending_stress_mpa(
    force_n,
    beam_length_mm,
    width_mm,
    height_mm
):

    moment_nmm = (
        force_n *
        beam_length_mm
    )

    I_mm4 = (
        rectangular_second_moment_mm4(
            width_mm,
            height_mm
        )
    )

    c_mm = (
        height_mm /
        2.0
    )

    return (
        moment_nmm *
        c_mm /
        I_mm4
    )


# ==============================================================
# 14. SAFETY FACTOR
# ==============================================================

def safety_factor(
    allowable_mpa,
    actual_mpa
):

    if actual_mpa <= 0:
        return math.inf

    return (
        allowable_mpa /
        actual_mpa
    )


# ==============================================================
# 15. MOTOR MOUNT MODEL
# ==============================================================

"""
Motor support arms carry propulsion thrust.

Assume four structural arms.

Actual motor geometry is not selected yet.
"""

MOTOR_SUPPORT_ARM_COUNT = 4

MOTOR_ARM_LENGTH_MM = 18.0

MOTOR_ARM_WIDTH_MM = 3.0

MOTOR_ARM_HEIGHT_MM = 3.0


def motor_arm_force_n():

    total_thrust = (
        max_thrust_n(
            DESIGN_MASS_KG
        )
    )

    return (
        total_thrust /
        MOTOR_SUPPORT_ARM_COUNT
    )


# ==============================================================
# 16. CRASH MEMBER LOAD DISTRIBUTION
# ==============================================================

"""
Assume impact load initially enters four major structural ribs.

This is deliberately conservative compared with distributing
load across the entire lattice.
"""

PRIMARY_RIB_COUNT = 4


def rib_force_from_impact(
    total_force_n
):

    return (
        total_force_n /
        PRIMARY_RIB_COUNT
    )


# ==============================================================
# 17. STRUCTURAL REPORT
# ==============================================================

def vehicle_load_report():

    print()
    print(
        "VEHICLE LOAD CASES"
    )

    print("-" * 76)

    weight = (
        DESIGN_MASS_KG *
        G
    )

    maneuver = (
        maneuver_force_n(
            DESIGN_MASS_KG
        )
    )

    thrust = (
        max_thrust_n(
            DESIGN_MASS_KG
        )
    )

    landing_energy = (
        impact_energy_j(
            DESIGN_MASS_KG
        )
    )

    landing_force = (
        average_impact_force_n(
            DESIGN_MASS_KG
        )
    )

    side_energy = (
        kinetic_energy_j(
            DESIGN_MASS_KG,
            SIDE_IMPACT_SPEED_MPS
        )
    )

    side_force = (
        side_impact_force_n(
            DESIGN_MASS_KG
        )
    )

    print(
        f"Vehicle weight            : "
        f"{weight:.3f} N"
    )

    print(
        f"{MANEUVER_G:.1f}g maneuver load        : "
        f"{maneuver:.3f} N"
    )

    print(
        f"Maximum propulsion thrust : "
        f"{thrust:.3f} N"
    )

    print(
        f"0.5 m drop energy         : "
        f"{landing_energy:.3f} J"
    )

    print(
        f"Average landing force     : "
        f"{landing_force:.1f} N"
    )

    print(
        f"2 m/s side impact energy  : "
        f"{side_energy:.3f} J"
    )

    print(
        f"Average side impact force : "
        f"{side_force:.1f} N"
    )


# ==============================================================
# 18. LATTICE MEMBER REPORT
# ==============================================================

def lattice_report():

    print()
    print(
        "PRELIMINARY CRASH-LATTICE MEMBER"
    )

    print("-" * 76)

    area = (
        rectangular_area_mm2(
            MEMBER_WIDTH_MM,
            MEMBER_HEIGHT_MM
        )
    )

    landing_force = (
        average_impact_force_n(
            DESIGN_MASS_KG
        )
    )

    rib_force = (
        rib_force_from_impact(
            landing_force
        )
    )

    axial_stress = (
        axial_stress_mpa(
            rib_force,
            area
        )
    )

    sf_xy = (
        safety_factor(
            PLA_XY_TENSILE_ALLOWABLE_MPA,
            axial_stress
        )
    )

    sf_z = (
        safety_factor(
            PLA_Z_TENSILE_ALLOWABLE_MPA,
            axial_stress
        )
    )

    print(
        f"Member section           : "
        f"{MEMBER_WIDTH_MM:.1f} x "
        f"{MEMBER_HEIGHT_MM:.1f} mm"
    )

    print(
        f"Cross-sectional area     : "
        f"{area:.2f} mm^2"
    )

    print(
        f"Impact force / major rib : "
        f"{rib_force:.2f} N"
    )

    print(
        f"Axial stress             : "
        f"{axial_stress:.2f} MPa"
    )

    print(
        f"XY safety factor         : "
        f"{sf_xy:.2f}"
    )

    print(
        f"Z safety factor          : "
        f"{sf_z:.2f}"
    )

    if (
        sf_z <
        IMPACT_SAFETY_FACTOR
    ):

        print(
            "FAIL: 2x2 mm member insufficient "
            "for conservative Z-oriented impact case."
        )

    else:

        print(
            "PASS: preliminary axial impact criterion."
        )


# ==============================================================
# 19. MOTOR SUPPORT REPORT
# ==============================================================

def motor_mount_report():

    print()
    print(
        "MOTOR SUPPORT ARM"
    )

    print("-" * 76)

    force = (
        motor_arm_force_n()
    )

    stress = (
        bending_stress_mpa(
            force,
            MOTOR_ARM_LENGTH_MM,
            MOTOR_ARM_WIDTH_MM,
            MOTOR_ARM_HEIGHT_MM
        )
    )

    sf_xy = (
        safety_factor(
            PLA_XY_BENDING_ALLOWABLE_MPA,
            stress
        )
    )

    sf_z = (
        safety_factor(
            PLA_Z_BENDING_ALLOWABLE_MPA,
            stress
        )
    )

    print(
        f"Arm count                : "
        f"{MOTOR_SUPPORT_ARM_COUNT}"
    )

    print(
        f"Load per arm             : "
        f"{force:.3f} N"
    )

    print(
        f"Arm length               : "
        f"{MOTOR_ARM_LENGTH_MM:.1f} mm"
    )

    print(
        f"Arm cross section        : "
        f"{MOTOR_ARM_WIDTH_MM:.1f} x "
        f"{MOTOR_ARM_HEIGHT_MM:.1f} mm"
    )

    print(
        f"Estimated bending stress : "
        f"{stress:.2f} MPa"
    )

    print(
        f"XY safety factor         : "
        f"{sf_xy:.2f}"
    )

    print(
        f"Z safety factor          : "
        f"{sf_z:.2f}"
    )

    if (
        sf_z <
        MOTOR_MOUNT_SAFETY_FACTOR
    ):

        print(
            "FAIL: motor support requires redesign "
            "for weak-axis printed loading."
        )

    else:

        print(
            "PASS: preliminary motor-support criterion."
        )


# ==============================================================
# 20. MEMBER SIZE SWEEP
# ==============================================================

def member_size_sweep():

    print()
    print(
        "CRASH MEMBER SIZE SENSITIVITY"
    )

    print("-" * 76)

    landing_force = (
        average_impact_force_n(
            DESIGN_MASS_KG
        )
    )

    force = (
        rib_force_from_impact(
            landing_force
        )
    )

    sizes = [
        1.6,
        2.0,
        2.4,
        2.8,
        3.2
    ]

    print(
        f"{'Size':>10}"
        f"{'Area':>12}"
        f"{'Stress':>14}"
        f"{'SF XY':>12}"
        f"{'SF Z':>12}"
    )

    print(
        f"{'(mm)':>10}"
        f"{'(mm2)':>12}"
        f"{'(MPa)':>14}"
        f"{'':>12}"
        f"{'':>12}"
    )

    for size in sizes:

        area = (
            size *
            size
        )

        stress = (
            axial_stress_mpa(
                force,
                area
            )
        )

        sf_xy = (
            safety_factor(
                PLA_XY_TENSILE_ALLOWABLE_MPA,
                stress
            )
        )

        sf_z = (
            safety_factor(
                PLA_Z_TENSILE_ALLOWABLE_MPA,
                stress
            )
        )

        print(
            f"{size:10.1f}"
            f"{area:12.2f}"
            f"{stress:14.2f}"
            f"{sf_xy:12.2f}"
            f"{sf_z:12.2f}"
        )


# ==============================================================
# 21. HARD-LIMIT IMPACT CASE
# ==============================================================

def hard_mass_case():

    print()
    print(
        "225 g HARD-MASS IMPACT CHECK"
    )

    print("-" * 76)

    landing_force = (
        average_impact_force_n(
            HARD_LIMIT_MASS_KG
        )
    )

    side_force = (
        side_impact_force_n(
            HARD_LIMIT_MASS_KG
        )
    )

    print(
        f"Landing average force : "
        f"{landing_force:.1f} N"
    )

    print(
        f"Side average force    : "
        f"{side_force:.1f} N"
    )


# ==============================================================
# 22. MAIN
# ==============================================================

def main():

    print("=" * 76)

    print(
        "AIDRONE STRUCTURAL LOAD SOLVER"
    )

    print("=" * 76)

    print(
        "Material model: provisional conservative PLA allowables"
    )

    print(
        "This analysis is pre-FEA and pre-impact-test."
    )

    vehicle_load_report()

    lattice_report()

    motor_mount_report()

    member_size_sweep()

    hard_mass_case()

    print()
    print("=" * 76)

    print(
        "DESIGN RULE:"
    )

    print(
        "Crash-cage geometry must follow load paths rather than "
        "a uniform decorative mesh."
    )

    print(
        "Final structural members must be rechecked using actual "
        "CAD section geometry and print orientation."
    )

    print("=" * 76)


if __name__ == "__main__":
    main()