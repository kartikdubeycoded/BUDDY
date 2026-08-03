"""
================================================================
AIDRONE
FILE 04 / 24
PROPULSION PHYSICS SOLVER

PURPOSE
-------
First-order propulsion feasibility analysis for the 70 mm
ducted propulsion system.

This file does NOT design a propeller.

It establishes:
    - required thrust
    - disk loading
    - ideal induced velocity
    - ideal induced power
    - approximate electrical power
    - battery current
    - endurance
    - rotor tip speed
    - tip Mach number
    - thrust-to-weight requirements
    - sensitivity to vehicle mass

Momentum theory gives an IDEAL lower bound.
Real hardware must later be validated using measured thrust data.
================================================================
"""

import math


# ==============================================================
# 1. PHYSICAL CONSTANTS
# ==============================================================

G = 9.80665

AIR_DENSITY = 1.225

SPEED_OF_SOUND = 343.0


# ==============================================================
# 2. VEHICLE PARAMETERS
# ==============================================================

DESIGN_MASS_G = 200.0

TARGET_MASS_G = 180.0

HARD_LIMIT_MASS_G = 225.0


# ==============================================================
# 3. DUCT PARAMETERS
# ==============================================================

DUCT_DIAMETER_MM = 70.0

DUCT_RADIUS_M = (
    DUCT_DIAMETER_MM /
    2000.0
)

DISK_AREA_M2 = (
    math.pi *
    DUCT_RADIUS_M**2
)


# ==============================================================
# 4. PRELIMINARY ROTOR ENVELOPE
# ==============================================================

ROTOR_DIAMETER_MM = 68.0

ROTOR_RADIUS_M = (
    ROTOR_DIAMETER_MM /
    2000.0
)


STATIC_RADIAL_CLEARANCE_MM = (
    DUCT_DIAMETER_MM -
    ROTOR_DIAMETER_MM
) / 2.0


# ==============================================================
# 5. THRUST REQUIREMENTS
# ==============================================================

HOVER_THRUST_RATIO = 1.0

CONTROL_THRUST_RATIO = 1.5

MAX_THRUST_RATIO = 2.0


# ==============================================================
# 6. SYSTEM EFFICIENCY CASES
# ==============================================================

"""
These are NOT measured efficiencies.

They are sensitivity-analysis assumptions representing combined
losses between ideal induced power and battery electrical power.

Actual efficiency must later come from propulsion testing.
"""

EFFICIENCY_CASES = [
    0.35,
    0.45,
    0.55,
    0.65
]


# ==============================================================
# 7. BATTERY STUDY CASE
# ==============================================================

"""
Placeholder study case only.

This is NOT the selected battery.

Example:
2S LiPo nominal voltage = 7.4 V
"""

BATTERY_NOMINAL_VOLTAGE = 7.4

BATTERY_CAPACITY_MAH = 1000.0


# Reserve capacity instead of assuming 100% usable energy.

BATTERY_USABLE_FRACTION = 0.80


# ==============================================================
# 8. AUXILIARY ELECTRICAL LOAD
# ==============================================================

"""
Non-propulsion electrical consumption.

Four cameras alone are roughly several watts.

FC, MCU, sensors, audio, radio and regulation will add more.

Use a provisional system allowance until real electronics are
selected.
"""

AUXILIARY_POWER_W = 8.0


# ==============================================================
# 9. ROTOR RPM STUDY
# ==============================================================

RPM_CASES = [
    10000,
    20000,
    30000,
    40000,
    50000,
    60000
]


# ==============================================================
# 10. BASIC PHYSICS FUNCTIONS
# ==============================================================

def mass_to_weight(mass_g):

    return (
        mass_g /
        1000.0
    ) * G


def thrust_required(
    mass_g,
    thrust_ratio
):

    return (
        mass_to_weight(mass_g) *
        thrust_ratio
    )


def disk_loading(
    thrust_n
):

    return (
        thrust_n /
        DISK_AREA_M2
    )


def mass_disk_loading(
    mass_g
):

    mass_kg = (
        mass_g /
        1000.0
    )

    return (
        mass_kg /
        DISK_AREA_M2
    )


# ==============================================================
# 11. MOMENTUM THEORY
# ==============================================================

def induced_velocity(
    thrust_n
):

    return math.sqrt(
        thrust_n /
        (
            2.0 *
            AIR_DENSITY *
            DISK_AREA_M2
        )
    )


def ideal_induced_power(
    thrust_n
):

    vi = induced_velocity(
        thrust_n
    )

    return (
        thrust_n *
        vi
    )


# ==============================================================
# 12. ELECTRICAL POWER ESTIMATE
# ==============================================================

def estimated_propulsion_power(
    thrust_n,
    total_efficiency
):

    if not (
        0 <
        total_efficiency <=
        1
    ):
        raise ValueError(
            "Efficiency must be between 0 and 1."
        )

    ideal_power = (
        ideal_induced_power(
            thrust_n
        )
    )

    return (
        ideal_power /
        total_efficiency
    )


def total_vehicle_power(
    thrust_n,
    total_efficiency
):

    propulsion = (
        estimated_propulsion_power(
            thrust_n,
            total_efficiency
        )
    )

    return (
        propulsion +
        AUXILIARY_POWER_W
    )


# ==============================================================
# 13. BATTERY CURRENT
# ==============================================================

def battery_current(
    power_w,
    voltage_v
):

    if voltage_v <= 0:
        raise ValueError(
            "Battery voltage must be positive."
        )

    return (
        power_w /
        voltage_v
    )


# ==============================================================
# 14. BATTERY ENERGY
# ==============================================================

def battery_nominal_energy_wh(
    voltage_v,
    capacity_mah
):

    capacity_ah = (
        capacity_mah /
        1000.0
    )

    return (
        voltage_v *
        capacity_ah
    )


def battery_usable_energy_wh():

    nominal = (
        battery_nominal_energy_wh(
            BATTERY_NOMINAL_VOLTAGE,
            BATTERY_CAPACITY_MAH
        )
    )

    return (
        nominal *
        BATTERY_USABLE_FRACTION
    )


# ==============================================================
# 15. ENDURANCE
# ==============================================================

def endurance_minutes(
    total_power_w
):

    usable_energy = (
        battery_usable_energy_wh()
    )

    hours = (
        usable_energy /
        total_power_w
    )

    return (
        hours *
        60.0
    )


# ==============================================================
# 16. ROTOR TIP SPEED
# ==============================================================

def rotor_tip_speed(
    rpm
):

    rotations_per_second = (
        rpm /
        60.0
    )

    angular_velocity = (
        2.0 *
        math.pi *
        rotations_per_second
    )

    return (
        angular_velocity *
        ROTOR_RADIUS_M
    )


def rotor_tip_mach(
    rpm
):

    return (
        rotor_tip_speed(rpm) /
        SPEED_OF_SOUND
    )


# ==============================================================
# 17. MASS SENSITIVITY
# ==============================================================

def mass_sensitivity():

    masses = [
        150,
        175,
        180,
        200,
        225,
        250,
        300
    ]

    print()
    print(
        "MASS SENSITIVITY — HOVER"
    )

    print("-" * 78)

    print(
        f"{'Mass':>7}"
        f"{'Thrust':>11}"
        f"{'DiskLoad':>13}"
        f"{'Vi':>11}"
        f"{'Ideal P':>13}"
    )

    print(
        f"{'(g)':>7}"
        f"{'(N)':>11}"
        f"{'(N/m2)':>13}"
        f"{'(m/s)':>11}"
        f"{'(W)':>13}"
    )

    for mass in masses:

        thrust = (
            thrust_required(
                mass,
                1.0
            )
        )

        dl = (
            disk_loading(
                thrust
            )
        )

        vi = (
            induced_velocity(
                thrust
            )
        )

        power = (
            ideal_induced_power(
                thrust
            )
        )

        print(
            f"{mass:7.0f}"
            f"{thrust:11.3f}"
            f"{dl:13.1f}"
            f"{vi:11.2f}"
            f"{power:13.2f}"
        )


# ==============================================================
# 18. THRUST CASE REPORT
# ==============================================================

def thrust_case_report(
    name,
    thrust_ratio
):

    thrust = (
        thrust_required(
            DESIGN_MASS_G,
            thrust_ratio
        )
    )

    vi = (
        induced_velocity(
            thrust
        )
    )

    ideal_power = (
        ideal_induced_power(
            thrust
        )
    )

    dl = (
        disk_loading(
            thrust
        )
    )

    print()
    print(
        name
    )

    print("-" * 78)

    print(
        f"Thrust ratio      : "
        f"{thrust_ratio:.2f}"
    )

    print(
        f"Required thrust   : "
        f"{thrust:.3f} N"
    )

    print(
        f"Disk loading      : "
        f"{dl:.1f} N/m^2"
    )

    print(
        f"Induced velocity  : "
        f"{vi:.2f} m/s"
    )

    print(
        f"Ideal power       : "
        f"{ideal_power:.2f} W"
    )

    print()
    print(
        "Efficiency sensitivity:"
    )

    for efficiency in (
        EFFICIENCY_CASES
    ):

        propulsion_power = (
            estimated_propulsion_power(
                thrust,
                efficiency
            )
        )

        total_power = (
            propulsion_power +
            AUXILIARY_POWER_W
        )

        current = (
            battery_current(
                total_power,
                BATTERY_NOMINAL_VOLTAGE
            )
        )

        endurance = (
            endurance_minutes(
                total_power
            )
        )

        print(
            f"  eta={efficiency:.2f}"
            f" | prop={propulsion_power:7.2f} W"
            f" | total={total_power:7.2f} W"
            f" | current={current:6.2f} A"
            f" | endurance={endurance:5.2f} min"
        )


# ==============================================================
# 19. RPM REPORT
# ==============================================================

def rpm_report():

    print()
    print(
        "ROTOR TIP-SPEED STUDY"
    )

    print("-" * 78)

    print(
        f"{'RPM':>10}"
        f"{'Tip speed':>16}"
        f"{'Tip Mach':>14}"
    )

    print(
        f"{'':>10}"
        f"{'(m/s)':>16}"
        f"{'':>14}"
    )

    for rpm in RPM_CASES:

        speed = (
            rotor_tip_speed(
                rpm
            )
        )

        mach = (
            rotor_tip_mach(
                rpm
            )
        )

        print(
            f"{rpm:10.0f}"
            f"{speed:16.2f}"
            f"{mach:14.3f}"
        )


# ==============================================================
# 20. GEOMETRIC VALIDATION
# ==============================================================

def geometry_validation():

    print()
    print(
        "PROPULSION GEOMETRY"
    )

    print("-" * 78)

    print(
        f"Duct diameter             : "
        f"{DUCT_DIAMETER_MM:.2f} mm"
    )

    print(
        f"Preliminary rotor diameter: "
        f"{ROTOR_DIAMETER_MM:.2f} mm"
    )

    print(
        f"Static radial clearance   : "
        f"{STATIC_RADIAL_CLEARANCE_MM:.2f} mm"
    )

    if (
        ROTOR_DIAMETER_MM >=
        DUCT_DIAMETER_MM
    ):

        print(
            "HARD FAIL: rotor does not fit duct."
        )

    elif (
        STATIC_RADIAL_CLEARANCE_MM <
        0.5
    ):

        print(
            "WARNING: extremely small static tip clearance."
        )

    else:

        print(
            "Geometry passes preliminary static clearance check."
        )


# ==============================================================
# 21. BATTERY REPORT
# ==============================================================

def battery_report():

    nominal_energy = (
        battery_nominal_energy_wh(
            BATTERY_NOMINAL_VOLTAGE,
            BATTERY_CAPACITY_MAH
        )
    )

    usable_energy = (
        battery_usable_energy_wh()
    )

    print()
    print(
        "BATTERY STUDY CASE"
    )

    print("-" * 78)

    print(
        f"Nominal voltage : "
        f"{BATTERY_NOMINAL_VOLTAGE:.2f} V"
    )

    print(
        f"Capacity        : "
        f"{BATTERY_CAPACITY_MAH:.0f} mAh"
    )

    print(
        f"Nominal energy  : "
        f"{nominal_energy:.2f} Wh"
    )

    print(
        f"Usable fraction : "
        f"{BATTERY_USABLE_FRACTION:.0%}"
    )

    print(
        f"Usable energy   : "
        f"{usable_energy:.2f} Wh"
    )

    print(
        "WARNING: battery is a study case, not selected hardware."
    )


# ==============================================================
# 22. MAIN
# ==============================================================

def main():

    print("=" * 78)

    print(
        "AIDRONE PROPULSION PHYSICS SOLVER"
    )

    print("=" * 78)

    print(
        f"Design mass = "
        f"{DESIGN_MASS_G:.1f} g"
    )

    print(
        f"70 mm disk area = "
        f"{DISK_AREA_M2:.8f} m^2"
    )

    print(
        f"Mass disk loading = "
        f"{mass_disk_loading(DESIGN_MASS_G):.2f} kg/m^2"
    )

    geometry_validation()

    battery_report()

    mass_sensitivity()

    thrust_case_report(
        "HOVER CONDITION",
        HOVER_THRUST_RATIO
    )

    thrust_case_report(
        "CONTROL-MARGIN CONDITION",
        CONTROL_THRUST_RATIO
    )

    thrust_case_report(
        "MAXIMUM DESIGN CONDITION",
        MAX_THRUST_RATIO
    )

    rpm_report()

    print()
    print("=" * 78)

    print(
        "IMPORTANT:"
    )

    print(
        "Momentum-theory power is an ideal lower bound."
    )

    print(
        "Do not select motors from this solver alone."
    )

    print(
        "Final propulsion requires measured motor/rotor thrust data."
    )

    print("=" * 78)


if __name__ == "__main__":
    main()