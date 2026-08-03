"""
================================================================
AIDRONE
FILE 18 / 24
MASS PROPERTIES + CENTER OF GRAVITY SOLVER

PURPOSE
-------
Track the complete vehicle mass architecture.

Calculates:
- total vehicle mass
- X/Y/Z center of gravity
- radial CoG error
- first moments
- approximate inertia tensor
- principal moments
- mass-budget margin
- required balancing correction
- subsystem mass percentages

IMPORTANT
---------
Current masses are ENGINEERING PLACEHOLDERS.

Replace every placeholder with:
1. measured component mass
2. final CAD-derived printed-part mass
3. actual installed coordinates

A geometrically symmetric CAD model does NOT guarantee a
balanced aircraft.
================================================================
"""

import math
import numpy as np
from dataclasses import dataclass


# ==============================================================
# 1. DESIGN TARGETS
# ==============================================================

TARGET_MASS_G = 200.0

MAX_MASS_G = 220.0

MAX_XY_COG_ERROR_MM = 1.0

MAX_Z_COG_ERROR_MM = 2.0


# ==============================================================
# 2. VEHICLE GEOMETRY
# ==============================================================

VEHICLE_DIAMETER_MM = 115.0

VEHICLE_RADIUS_MM = (
    VEHICLE_DIAMETER_MM / 2
)


# ==============================================================
# 3. COMPONENT MODEL
# ==============================================================

@dataclass
class Component:
    name: str

    mass_g: float

    x_mm: float
    y_mm: float
    z_mm: float

    # Approximate physical dimensions for inertia estimate.
    dx_mm: float
    dy_mm: float
    dz_mm: float


# ==============================================================
# 4. COMPONENT DATABASE
# ==============================================================

"""
CURRENT VALUES ARE PLACEHOLDERS.

The positions reflect the architecture developed so far.

Masses must later come from:
- scale measurements
- manufacturer datasheets
- CAD volume * material density
"""


components = [

    # ----------------------------------------------------------
    # CENTRAL STRUCTURE
    # ----------------------------------------------------------

    Component(
        "Central duct",
        12.0,
        0, 0, 0,
        74, 74, 70
    ),

    Component(
        "Electronics spine",
        8.0,
        0, 0, 0,
        79, 79, 22
    ),

    Component(
        "Crash shell",
        15.0,
        0, 0, 0,
        115, 115, 115
    ),


    # ----------------------------------------------------------
    # PROPULSION
    # ----------------------------------------------------------

    Component(
        "Upper motor",
        8.0,
        0, 0, 8,
        18, 18, 12
    ),

    Component(
        "Lower motor",
        8.0,
        0, 0, -8,
        18, 18, 12
    ),

    Component(
        "Upper rotor",
        2.0,
        0, 0, 12,
        68, 68, 4
    ),

    Component(
        "Lower rotor",
        2.0,
        0, 0, -12,
        68, 68, 4
    ),

    Component(
        "Upper stator",
        3.0,
        0, 0, 8,
        70, 70, 5
    ),

    Component(
        "Lower stator",
        3.0,
        0, 0, -8,
        70, 70, 5
    ),


    # ----------------------------------------------------------
    # VANES
    # ----------------------------------------------------------

    Component(
        "Vane +X",
        1.0,
        19.5, 0, -27,
        25, 15, 2
    ),

    Component(
        "Vane +Y",
        1.0,
        0, 19.5, -27,
        15, 25, 2
    ),

    Component(
        "Vane -X",
        1.0,
        -19.5, 0, -27,
        25, 15, 2
    ),

    Component(
        "Vane -Y",
        1.0,
        0, -19.5, -27,
        15, 25, 2
    ),


    # ----------------------------------------------------------
    # ACTUATORS
    # ----------------------------------------------------------

    Component(
        "Actuator +X",
        2.5,
        42.1, 0, -27,
        5, 8, 10
    ),

    Component(
        "Actuator +Y",
        2.5,
        0, 42.1, -27,
        8, 5, 10
    ),

    Component(
        "Actuator -X",
        2.5,
        -42.1, 0, -27,
        5, 8, 10
    ),

    Component(
        "Actuator -Y",
        2.5,
        0, -42.1, -27,
        8, 5, 10
    ),


    # ----------------------------------------------------------
    # ELECTRONICS
    #
    # Four stations at 45, 135, 225, 315 degrees.
    # ----------------------------------------------------------

    Component(
        "Flight controller",
        5.0,
        30, 30, 0,
        18, 4, 18
    ),

    Component(
        "Power board",
        5.0,
        -30, 30, 0,
        18, 4, 18
    ),

    Component(
        "Communication board",
        5.0,
        -30, -30, 0,
        18, 4, 18
    ),

    Component(
        "Audio / sensor board",
        5.0,
        30, -30, 0,
        18, 4, 18
    ),


    # ----------------------------------------------------------
    # CAMERAS
    #
    # Placeholder 14 mm camera stations.
    # ----------------------------------------------------------

    Component(
        "Camera +X",
        4.0,
        46, 0, 0,
        14, 14, 15
    ),

    Component(
        "Camera +Y",
        4.0,
        0, 46, 0,
        14, 14, 15
    ),

    Component(
        "Camera -X",
        4.0,
        -46, 0, 0,
        14, 14, 15
    ),

    Component(
        "Camera -Y",
        4.0,
        0, -46, 0,
        14, 14, 15
    ),


    # ----------------------------------------------------------
    # BATTERY
    #
    # Split-ring assumption.
    # Opposed masses cancel XY moment.
    # Z remains centered.
    # ----------------------------------------------------------

    Component(
        "Battery half A",
        28.0,
        0, 39, 0,
        18, 30, 12
    ),

    Component(
        "Battery half B",
        28.0,
        0, -39, 0,
        18, 30, 12
    ),


    # ----------------------------------------------------------
    # AUDIO
    # ----------------------------------------------------------

    Component(
        "Speaker",
        4.0,
        0, 0, 20,
        20, 20, 5
    ),


    # ----------------------------------------------------------
    # WIRING / CONNECTORS
    # ----------------------------------------------------------

    Component(
        "Wiring + connectors",
        8.0,
        0, 0, 0,
        60, 60, 50
    ),
]


# ==============================================================
# 5. TOTAL MASS
# ==============================================================

def total_mass_g():

    return sum(
        c.mass_g
        for c in components
    )


# ==============================================================
# 6. FIRST MOMENTS
# ==============================================================

def first_moments_gmm():

    mx = sum(
        c.mass_g * c.x_mm
        for c in components
    )

    my = sum(
        c.mass_g * c.y_mm
        for c in components
    )

    mz = sum(
        c.mass_g * c.z_mm
        for c in components
    )

    return mx, my, mz


# ==============================================================
# 7. CENTER OF GRAVITY
# ==============================================================

def center_of_gravity_mm():

    mass = total_mass_g()

    mx, my, mz = (
        first_moments_gmm()
    )

    return (
        mx / mass,
        my / mass,
        mz / mass
    )


# ==============================================================
# 8. RADIAL COG ERROR
# ==============================================================

def radial_cog_error_mm():

    x, y, _ = (
        center_of_gravity_mm()
    )

    return math.sqrt(
        x*x +
        y*y
    )


# ==============================================================
# 9. COMPONENT INERTIA
# ==============================================================

def cuboid_inertia_about_own_center(
    component
):

    """
    Approximate each component as a rectangular cuboid.

    Units returned:
        g * mm^2
    """

    m = component.mass_g

    dx = component.dx_mm
    dy = component.dy_mm
    dz = component.dz_mm

    ixx = (
        m / 12.0 *
        (
            dy**2 +
            dz**2
        )
    )

    iyy = (
        m / 12.0 *
        (
            dx**2 +
            dz**2
        )
    )

    izz = (
        m / 12.0 *
        (
            dx**2 +
            dy**2
        )
    )

    return np.array([
        [ixx, 0, 0],
        [0, iyy, 0],
        [0, 0, izz]
    ])


# ==============================================================
# 10. PARALLEL AXIS THEOREM
# ==============================================================

def shifted_inertia_tensor(
    component,
    cog
):

    local = (
        cuboid_inertia_about_own_center(
            component
        )
    )

    rx = (
        component.x_mm -
        cog[0]
    )

    ry = (
        component.y_mm -
        cog[1]
    )

    rz = (
        component.z_mm -
        cog[2]
    )

    r = np.array([
        rx,
        ry,
        rz
    ])

    r2 = np.dot(
        r,
        r
    )

    identity = np.eye(3)

    shift = (
        component.mass_g *
        (
            r2 * identity -
            np.outer(r, r)
        )
    )

    return (
        local +
        shift
    )


# ==============================================================
# 11. VEHICLE INERTIA TENSOR
# ==============================================================

def vehicle_inertia_tensor():

    cog = (
        center_of_gravity_mm()
    )

    tensor = np.zeros(
        (3, 3)
    )

    for component in components:

        tensor += (
            shifted_inertia_tensor(
                component,
                cog
            )
        )

    return tensor


# ==============================================================
# 12. PRINCIPAL INERTIAS
# ==============================================================

def principal_inertias():

    tensor = (
        vehicle_inertia_tensor()
    )

    values, vectors = (
        np.linalg.eigh(
            tensor
        )
    )

    return values, vectors


# ==============================================================
# 13. MASS BUDGET
# ==============================================================

def mass_budget_report():

    mass = total_mass_g()

    print()
    print(
        "MASS BUDGET"
    )

    print("-" * 78)

    print(
        f"Current estimated mass : "
        f"{mass:.2f} g"
    )

    print(
        f"Target mass            : "
        f"{TARGET_MASS_G:.2f} g"
    )

    print(
        f"Absolute ceiling       : "
        f"{MAX_MASS_G:.2f} g"
    )

    print(
        f"Target margin          : "
        f"{TARGET_MASS_G - mass:.2f} g"
    )

    print(
        f"Ceiling margin         : "
        f"{MAX_MASS_G - mass:.2f} g"
    )


# ==============================================================
# 14. COMPONENT TABLE
# ==============================================================

def component_report():

    total = total_mass_g()

    print()
    print(
        "COMPONENT MASS LEDGER"
    )

    print("-" * 110)

    print(
        f"{'Component':<28}"
        f"{'Mass g':>10}"
        f"{'X mm':>10}"
        f"{'Y mm':>10}"
        f"{'Z mm':>10}"
        f"{'% mass':>10}"
    )

    print("-" * 110)

    for c in components:

        percentage = (
            100 *
            c.mass_g /
            total
        )

        print(
            f"{c.name:<28}"
            f"{c.mass_g:>10.2f}"
            f"{c.x_mm:>10.2f}"
            f"{c.y_mm:>10.2f}"
            f"{c.z_mm:>10.2f}"
            f"{percentage:>10.2f}"
        )


# ==============================================================
# 15. COG REPORT
# ==============================================================

def cog_report():

    x, y, z = (
        center_of_gravity_mm()
    )

    radial = (
        radial_cog_error_mm()
    )

    mx, my, mz = (
        first_moments_gmm()
    )

    print()
    print(
        "CENTER OF GRAVITY"
    )

    print("-" * 78)

    print(
        f"CoG X              : "
        f"{x:.4f} mm"
    )

    print(
        f"CoG Y              : "
        f"{y:.4f} mm"
    )

    print(
        f"CoG Z              : "
        f"{z:.4f} mm"
    )

    print(
        f"Radial XY error    : "
        f"{radial:.4f} mm"
    )

    print()
    print(
        f"First moment X     : "
        f"{mx:.3f} g*mm"
    )

    print(
        f"First moment Y     : "
        f"{my:.3f} g*mm"
    )

    print(
        f"First moment Z     : "
        f"{mz:.3f} g*mm"
    )


# ==============================================================
# 16. INERTIA REPORT
# ==============================================================

def inertia_report():

    tensor = (
        vehicle_inertia_tensor()
    )

    principal, axes = (
        principal_inertias()
    )

    print()
    print(
        "APPROXIMATE INERTIA TENSOR"
    )

    print("-" * 78)

    print(
        "Units = g*mm^2"
    )

    print()

    print(tensor)

    print()
    print(
        "Principal moments:"
    )

    for index, value in enumerate(
        principal
    ):

        print(
            f"I{index + 1} = "
            f"{value:.2f} g*mm^2"
        )

    print()
    print(
        "Principal-axis vectors:"
    )

    print(axes)


# ==============================================================
# 17. REQUIRED COUNTERWEIGHT
# ==============================================================

def counterweight_for_axis(
    first_moment_gmm,
    available_radius_mm
):

    if (
        available_radius_mm <= 0
    ):
        return None

    return (
        abs(first_moment_gmm) /
        available_radius_mm
    )


def balancing_report():

    mx, my, mz = (
        first_moments_gmm()
    )

    usable_radial_position = 45.0

    usable_axial_position = 40.0

    x_mass = (
        counterweight_for_axis(
            mx,
            usable_radial_position
        )
    )

    y_mass = (
        counterweight_for_axis(
            my,
            usable_radial_position
        )
    )

    z_mass = (
        counterweight_for_axis(
            mz,
            usable_axial_position
        )
    )

    print()
    print(
        "BALANCING REQUIREMENT"
    )

    print("-" * 78)

    print(
        f"Countermass for X moment "
        f"at {usable_radial_position:.1f} mm:"
    )

    print(
        f"{x_mass:.3f} g"
    )

    print()
    print(
        f"Countermass for Y moment "
        f"at {usable_radial_position:.1f} mm:"
    )

    print(
        f"{y_mass:.3f} g"
    )

    print()
    print(
        f"Countermass for Z moment "
        f"at {usable_axial_position:.1f} mm:"
    )

    print(
        f"{z_mass:.3f} g"
    )


# ==============================================================
# 18. VALIDATION
# ==============================================================

def validation():

    mass = (
        total_mass_g()
    )

    x, y, z = (
        center_of_gravity_mm()
    )

    radial = (
        radial_cog_error_mm()
    )

    print()
    print(
        "DESIGN VALIDATION"
    )

    print("-" * 78)

    if mass <= MAX_MASS_G:

        print(
            "PASS: mass below absolute ceiling."
        )

    else:

        print(
            "FAIL: mass exceeds absolute ceiling."
        )


    if radial <= MAX_XY_COG_ERROR_MM:

        print(
            "PASS: XY CoG within provisional tolerance."
        )

    else:

        print(
            "FAIL: XY CoG exceeds tolerance."
        )


    if abs(z) <= MAX_Z_COG_ERROR_MM:

        print(
            "PASS: Z CoG within provisional tolerance."
        )

    else:

        print(
            "FAIL: Z CoG exceeds tolerance."
        )


    if (
        abs(x) < 1e-9 and
        abs(y) < 1e-9
    ):

        print(
            "PASS: ideal XY mass symmetry achieved."
        )


# ==============================================================
# 19. MAIN
# ==============================================================

def main():

    print("=" * 78)

    print(
        "AIDRONE FILE 18 — MASS PROPERTIES"
    )

    print("=" * 78)

    component_report()

    mass_budget_report()

    cog_report()

    inertia_report()

    balancing_report()

    validation()

    print()
    print("=" * 78)

    print(
        "WARNING"
    )

    print("=" * 78)

    print(
        "Current component masses are placeholders."
    )

    print(
        "Replace them with measured masses before flight."
    )

    print(
        "Printed structure mass should eventually come from"
        " actual CAD volume and chosen material density."
    )

    print("=" * 78)


if __name__ == "__main__":
    main()