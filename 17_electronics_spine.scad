/*
================================================================
AIDRONE
FILE 17 / 24
ELECTRONICS STRUCTURAL SPINE / COLLAR

PURPOSE
-------
Creates the central electronics carrier around the propulsion
duct.

PACKAGING TARGETS
-----------------
- flight controller
- IMU
- regulator / power board
- communications interface
- speaker electronics
- wiring
- future sensor interfaces

DESIGN RULES
------------
1. NOTHING enters the Ø70 aerodynamic airway.
2. Carrier fits around Ø74 duct.
3. Fourfold structural symmetry.
4. Electronics mass should remain near Z=0.
5. Heavy components should be paired across the origin.
6. Wiring receives dedicated channels.
7. Rotor and vane keep-outs remain untouched.
8. All electronics dimensions are provisional envelopes until
   real hardware is selected.

GLOBAL DATUM
------------
Origin = vehicle geometric center.
================================================================
*/


include <00_master_parameters.scad>
include <02_materials_tolerances.scad>


$fn = 100;


// ============================================================
// 1. VEHICLE ENVELOPE
// ============================================================

VEHICLE_D = 115;

VEHICLE_R =
    VEHICLE_D / 2;


SHELL_INNER_D = 111;

SHELL_INNER_R =
    SHELL_INNER_D / 2;


// ============================================================
// 2. DUCT INTERFACE
// ============================================================

DUCT_OD_LOCAL = 74;

DUCT_R =
    DUCT_OD_LOCAL / 2;


// Correct sliding bore.

SPINE_ID =

    female_bore_for_male(
        DUCT_OD_LOCAL,
        CLEARANCE_SLIDING
    );


SPINE_INNER_R =
    SPINE_ID / 2;


// ============================================================
// 3. MAIN STRUCTURAL RING
// ============================================================

SPINE_RADIAL_WALL = 2.4;

SPINE_OD =

    SPINE_ID +
    2 * SPINE_RADIAL_WALL;


SPINE_OUTER_R =
    SPINE_OD / 2;


SPINE_HEIGHT = 22;


// Centered exactly at global Z=0.

SPINE_Z = 0;


// ============================================================
// 4. ELECTRONICS STATIONS
// ============================================================

STATION_COUNT = 4;

STATION_ANGLE_OFFSET = 45;


// ============================================================
// 5. PCB ENVELOPE
// ============================================================

/*
Placeholder dimensions.

These do NOT claim a selected flight controller.
*/

PCB_WIDTH = 18;

PCB_HEIGHT = 18;

PCB_DEPTH = 4;


// ============================================================
// 6. PCB CLEARANCE
// ============================================================

PCB_CLEARANCE = 0.5;


PCB_POCKET_WIDTH =

    PCB_WIDTH +
    2 * PCB_CLEARANCE;


PCB_POCKET_HEIGHT =

    PCB_HEIGHT +
    2 * PCB_CLEARANCE;


PCB_POCKET_DEPTH =

    PCB_DEPTH +
    PCB_CLEARANCE;


// ============================================================
// 7. STATION WALLS
// ============================================================

STATION_WALL = 1.6;


// ============================================================
// 8. STATION OUTER DIMENSIONS
// ============================================================

STATION_WIDTH =

    PCB_POCKET_WIDTH +
    2 * STATION_WALL;


STATION_HEIGHT =

    PCB_POCKET_HEIGHT +
    2 * STATION_WALL;


STATION_DEPTH =

    PCB_POCKET_DEPTH +
    STATION_WALL;


// ============================================================
// 9. STATION RADIAL LOCATION
// ============================================================

STATION_INNER_R =

    SPINE_OUTER_R - 0.1;


STATION_CENTER_R =

    STATION_INNER_R +
    STATION_DEPTH / 2;


// ============================================================
// 10. MAXIMUM STATION RADIUS
// ============================================================

STATION_MAX_R =

    STATION_CENTER_R +
    STATION_DEPTH / 2;


// ============================================================
// 11. WIRING CHANNEL
// ============================================================

WIRE_BUNDLE_WIDTH = 3;

WIRE_BUNDLE_HEIGHT = 2;


WIRE_CHANNEL_W =

    wire_channel_width(
        WIRE_BUNDLE_WIDTH
    );


WIRE_CHANNEL_H =

    WIRE_BUNDLE_HEIGHT +
    1;


// ============================================================
// 12. AXIAL WIRE TRUNK
// ============================================================

AXIAL_TRUNK_WIDTH = 4;

AXIAL_TRUNK_DEPTH = 1.5;


// ============================================================
// 13. BOARD RETENTION
// ============================================================

RETAINER_LIP = 0.8;

RETAINER_DEPTH = 1.0;


// ============================================================
// 14. VIBRATION ISOLATION SPACE
// ============================================================

/*
Physical isolator material is not modeled yet.

This is reserved free space around the IMU/FC station.
*/

ISOLATION_GAP = 0.8;


// ============================================================
// 15. AIRFLOW KEEP-OUT
// ============================================================

AIRWAY_D = 70;

AIRWAY_R =
    AIRWAY_D / 2;


// ============================================================
// 16. DISPLAY
// ============================================================

SHOW_STRUCTURE = true;

SHOW_PCB_ENVELOPES = true;

SHOW_AIRWAY = false;

SHOW_DUCT = false;

SHOW_SPHERE = false;

SHOW_SHELL_INNER = false;


// ============================================================
// 17. MAIN
// ============================================================

electronics_spine();


// ============================================================
// 18. COMPLETE ASSEMBLY
// ============================================================

module electronics_spine()
{
    if (SHOW_STRUCTURE)
    {
        difference()
        {
            union()
            {
                main_spine_ring();

                station_housings();
            }

            pcb_pockets();

            wiring_channels();

            axial_wire_trunks();
        }
    }


    if (SHOW_PCB_ENVELOPES)
    {
        pcb_envelopes();
    }


    if (SHOW_AIRWAY)
    {
        %airway_keepout();
    }


    if (SHOW_DUCT)
    {
        %duct_reference();
    }


    if (SHOW_SPHERE)
    {
        %sphere_reference();
    }


    if (SHOW_SHELL_INNER)
    {
        %shell_inner_reference();
    }
}


// ============================================================
// 19. MAIN SPINE RING
// ============================================================

module main_spine_ring()
{
    translate([
        0,
        0,
        SPINE_Z
    ])

    difference()
    {
        cylinder(
            h = SPINE_HEIGHT,
            d = SPINE_OD,
            center = true
        );

        cylinder(
            h = SPINE_HEIGHT + 0.2,
            d = SPINE_ID,
            center = true
        );
    }
}


// ============================================================
// 20. STATION HOUSINGS
// ============================================================

module station_housings()
{
    for (
        i = [
            0 :
            STATION_COUNT - 1
        ]
    )
    {
        station_angle =
            STATION_ANGLE_OFFSET +
            i *
            360 /
            STATION_COUNT;


        rotate([
            0,
            0,
            station_angle
        ])

        translate([
            STATION_CENTER_R,
            0,
            0
        ])

        cube([
            STATION_DEPTH,
            STATION_WIDTH,
            STATION_HEIGHT
        ],

        center = true);
    }
}


// ============================================================
// 21. PCB POCKETS
// ============================================================

module pcb_pockets()
{
    for (
        i = [
            0 :
            STATION_COUNT - 1
        ]
    )
    {
        station_angle =
            STATION_ANGLE_OFFSET +
            i *
            360 /
            STATION_COUNT;


        rotate([
            0,
            0,
            station_angle
        ])

        translate([
            STATION_CENTER_R +
            STATION_WALL / 2,

            0,

            0
        ])

        cube([
            PCB_POCKET_DEPTH,
            PCB_POCKET_WIDTH,
            PCB_POCKET_HEIGHT
        ],

        center = true);
    }
}


// ============================================================
// 22. PCB ENVELOPES
// ============================================================

module pcb_envelopes()
{
    for (
        i = [
            0 :
            STATION_COUNT - 1
        ]
    )
    {
        station_angle =
            STATION_ANGLE_OFFSET +
            i *
            360 /
            STATION_COUNT;


        rotate([
            0,
            0,
            station_angle
        ])

        translate([
            STATION_CENTER_R +
            STATION_WALL / 2,

            0,

            0
        ])

        %cube([
            PCB_DEPTH,
            PCB_WIDTH,
            PCB_HEIGHT
        ],

        center = true);
    }
}


// ============================================================
// 23. CIRCUMFERENTIAL WIRING CHANNELS
// ============================================================

module wiring_channels()
{
    /*
    Four local channels connecting electronics stations to
    the main ring.
    */

    for (
        i = [
            0 :
            STATION_COUNT - 1
        ]
    )
    {
        station_angle =
            STATION_ANGLE_OFFSET +
            i *
            360 /
            STATION_COUNT;


        rotate([
            0,
            0,
            station_angle
        ])

        translate([
            SPINE_OUTER_R,
            0,
            0
        ])

        cube([
            STATION_DEPTH + 1,
            WIRE_CHANNEL_W,
            WIRE_CHANNEL_H
        ],

        center = true);
    }
}


// ============================================================
// 24. AXIAL WIRE TRUNKS
// ============================================================

module axial_wire_trunks()
{
    /*
    Four shallow external channels.

    These route wiring toward:
    - motors
    - cameras
    - actuator ring
    - power subsystem

    They remain OUTSIDE the Ø74 duct.
    */

    for (
        i = [
            0 :
            STATION_COUNT - 1
        ]
    )
    {
        angle =
            i *
            360 /
            STATION_COUNT;


        rotate([
            0,
            0,
            angle
        ])

        translate([
            SPINE_INNER_R +
            SPINE_RADIAL_WALL / 2,

            0,

            0
        ])

        cube([
            SPINE_RADIAL_WALL + 0.5,

            AXIAL_TRUNK_WIDTH,

            SPINE_HEIGHT + 0.2
        ],

        center = true);
    }
}


// ============================================================
// 25. AIRWAY KEEP-OUT
// ============================================================

module airway_keepout()
{
    cylinder(
        h = 70,
        d = AIRWAY_D,
        center = true
    );
}


// ============================================================
// 26. DUCT REFERENCE
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
// 27. VEHICLE REFERENCES
// ============================================================

module sphere_reference()
{
    sphere(
        d = VEHICLE_D
    );
}


module shell_inner_reference()
{
    sphere(
        d = SHELL_INNER_D
    );
}


// ============================================================
// 28. SPHERE RADIUS FUNCTION
// ============================================================

function sphere_radius_at_z(
    sphere_r,
    z
) =

    abs(z) <= sphere_r

    ?

    sqrt(
        sphere_r * sphere_r -
        z * z
    )

    :

    0;


// ============================================================
// 29. AVAILABLE RADIAL SPACE
// ============================================================

/*
Station extends +/- STATION_HEIGHT/2 in Z.

Worst shell clearance therefore occurs at its highest |Z|.
*/

STATION_Z_EXTREME =

    STATION_HEIGHT / 2;


AVAILABLE_SHELL_R_AT_STATION_EDGE =

    sphere_radius_at_z(
        SHELL_INNER_R,
        STATION_Z_EXTREME
    );


// ============================================================
// 30. RADIAL CLEARANCE
// ============================================================

STATION_TO_SHELL_CLEARANCE =

    AVAILABLE_SHELL_R_AT_STATION_EDGE -
    STATION_MAX_R;


// ============================================================
// 31. AIRWAY CLEARANCE
// ============================================================

MIN_STRUCTURE_RADIUS =

    SPINE_INNER_R;


AIRWAY_STRUCTURE_CLEARANCE =

    MIN_STRUCTURE_RADIUS -
    AIRWAY_R;


// ============================================================
// 32. XY SYMMETRY CHECK
// ============================================================

/*
Four identical stations separated by 90 degrees produce zero
ideal XY first moment if their installed masses are equal.

This is a geometric symmetry condition, not a mass guarantee.
*/

IDEAL_X_FIRST_MOMENT = 0;

IDEAL_Y_FIRST_MOMENT = 0;


// ============================================================
// 33. VALIDATION
// ============================================================

assert(
    STATION_COUNT == 4,

    "FAIL: electronics spine must remain fourfold symmetric."
);


assert(
    SPINE_ID >=
    74.4,

    "FAIL: spine bore violates duct sliding clearance."
);


assert(
    AIRWAY_STRUCTURE_CLEARANCE >
    0,

    "FAIL: electronics structure enters aerodynamic airway."
);


assert(
    STATION_TO_SHELL_CLEARANCE >=
    0.2,

    "FAIL: electronics station intersects inner crash shell."
);


assert(
    STATION_MAX_R <
    VEHICLE_R,

    "FAIL: electronics station exits vehicle envelope."
);


assert(
    SPINE_Z == 0,

    "FAIL: electronics spine no longer centered on global datum."
);


// ============================================================
// 34. OUTPUT
// ============================================================

echo(
    "============================================"
);

echo(
    "AIDRONE FILE 17 — ELECTRONICS SPINE"
);

echo(
    "Spine ID =",
    SPINE_ID
);

echo(
    "Spine OD =",
    SPINE_OD
);

echo(
    "Spine height =",
    SPINE_HEIGHT
);

echo(
    "Station count =",
    STATION_COUNT
);

echo(
    "Station angular offset =",
    STATION_ANGLE_OFFSET
);

echo(
    "PCB envelope =",
    PCB_WIDTH,
    PCB_HEIGHT,
    PCB_DEPTH
);

echo(
    "PCB pocket =",
    PCB_POCKET_WIDTH,
    PCB_POCKET_HEIGHT,
    PCB_POCKET_DEPTH
);

echo(
    "Station maximum radius =",
    STATION_MAX_R
);

echo(
    "Available shell radius at station edge =",
    AVAILABLE_SHELL_R_AT_STATION_EDGE
);

echo(
    "Station / shell clearance =",
    STATION_TO_SHELL_CLEARANCE
);

echo(
    "Airway / electronics structural clearance =",
    AIRWAY_STRUCTURE_CLEARANCE
);

echo(
    "Ideal X first moment =",
    IDEAL_X_FIRST_MOMENT
);

echo(
    "Ideal Y first moment =",
    IDEAL_Y_FIRST_MOMENT
);

echo(
    "============================================"
);