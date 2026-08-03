/*
================================================================
AIDRONE
FILE 20 / 24
FOUR-CAMERA PERCEPTION RING

PURPOSE
-------
Packages four symmetric micro-camera stations around the
vehicle for spatial perception.

CAMERA STATIONS
---------------
0 deg   = +X
90 deg  = +Y
180 deg = -X
270 deg = -Y

DESIGN RULES
------------
- exact fourfold rotational symmetry
- camera pocket = 14.2 x 14.2 mm face clearance
- no camera structure enters Ø70 airway
- lens points radially outward
- lens aperture remains unobstructed
- explicit field-of-view keep-out cone
- camera housing remains inside Ø111 inner crash-shell surface
- camera center remains near Z=0 to minimize CoG shift

IMPORTANT
---------
Camera body dimensions remain parameterized.

The optical FOV values are provisional until the exact
camera/lens is selected.
================================================================
*/


include <00_master_parameters.scad>
include <02_materials_tolerances.scad>

$fn = 100;


// ============================================================
// 1. VEHICLE
// ============================================================

VEHICLE_D = 115.0;
VEHICLE_R = VEHICLE_D / 2;

SHELL_INNER_D = 111.0;
SHELL_INNER_R = SHELL_INNER_D / 2;


// ============================================================
// 2. CENTRAL DUCT
// ============================================================

DUCT_OD = 74.0;
DUCT_R = DUCT_OD / 2;

AIRWAY_D = 70.0;
AIRWAY_R = AIRWAY_D / 2;


// ============================================================
// 3. CAMERA COUNT
// ============================================================

CAMERA_COUNT = 4;

CAMERA_ANGLE_OFFSET = 0;


// ============================================================
// 4. CAMERA BODY
// ============================================================

/*
Required internal face clearance:
14.2 x 14.2 mm

Depth is retained at 15 mm from the earlier packaging
requirement.
*/

CAMERA_BODY_W = 14.0;
CAMERA_BODY_H = 14.0;
CAMERA_BODY_D = 15.0;


CAMERA_POCKET_W = 14.2;
CAMERA_POCKET_H = 14.2;


// Additional depth clearance.

CAMERA_DEPTH_CLEARANCE = 0.4;

CAMERA_POCKET_D =
    CAMERA_BODY_D +
    CAMERA_DEPTH_CLEARANCE;


// ============================================================
// 5. CAMERA HOUSING
// ============================================================

CAMERA_WALL = 1.4;


HOUSING_W =
    CAMERA_POCKET_W +
    2 * CAMERA_WALL;


HOUSING_H =
    CAMERA_POCKET_H +
    2 * CAMERA_WALL;


HOUSING_D =
    CAMERA_POCKET_D +
    CAMERA_WALL;


// ============================================================
// 6. CAMERA RADIAL POSITION
// ============================================================

/*
Housing starts outside the Ø74 duct.

This prevents intrusion into the propulsion airway.
*/

CAMERA_DUCT_GAP = 1.0;


HOUSING_INNER_R =
    DUCT_R +
    CAMERA_DUCT_GAP;


HOUSING_CENTER_R =
    HOUSING_INNER_R +
    HOUSING_D / 2;


HOUSING_OUTER_R =
    HOUSING_INNER_R +
    HOUSING_D;


// ============================================================
// 7. CAMERA AXIAL POSITION
// ============================================================

CAMERA_Z = 0;


// ============================================================
// 8. LENS
// ============================================================

/*
Provisional optical aperture.

Replace with measured lens barrel dimensions.
*/

LENS_APERTURE_D = 8.0;

LENS_CLEARANCE = 0.5;


LENS_OPENING_D =
    LENS_APERTURE_D +
    2 * LENS_CLEARANCE;


// Lens center located on outward housing face.

LENS_PLANE_R =
    HOUSING_OUTER_R;


// ============================================================
// 9. FIELD OF VIEW
// ============================================================

/*
Provisional full-angle FOV.

This is used only to create a collision keep-out.

Replace after camera selection.
*/

HORIZONTAL_FOV_DEG = 120;

VERTICAL_FOV_DEG = 100;


// ============================================================
// 10. FOV KEEP-OUT LENGTH
// ============================================================

FOV_LENGTH = 35;


// ============================================================
// 11. FOV RADII AT KEEP-OUT END
// ============================================================

FOV_HALF_H =
    HORIZONTAL_FOV_DEG / 2;


FOV_HALF_V =
    VERTICAL_FOV_DEG / 2;


FOV_END_HALF_WIDTH =
    FOV_LENGTH *
    tan(FOV_HALF_H);


FOV_END_HALF_HEIGHT =
    FOV_LENGTH *
    tan(FOV_HALF_V);


// ============================================================
// 12. CAMERA RETENTION
// ============================================================

RETAINER_LIP = 0.8;

RETAINER_DEPTH = 1.0;


// ============================================================
// 13. REAR CABLE EXIT
// ============================================================

CABLE_EXIT_W = 5.0;

CABLE_EXIT_H = 4.0;


// ============================================================
// 14. DISPLAY
// ============================================================

SHOW_HOUSINGS = true;

SHOW_CAMERAS = true;

SHOW_FOV = false;

SHOW_DUCT = false;

SHOW_AIRWAY = false;

SHOW_SHELL_INNER = false;

SHOW_OUTER_SPHERE = false;


// ============================================================
// 15. MAIN
// ============================================================

camera_ring();


// ============================================================
// 16. COMPLETE CAMERA RING
// ============================================================

module camera_ring()
{
    if (SHOW_HOUSINGS)
    {
        for (
            i = [
                0 :
                CAMERA_COUNT - 1
            ]
        )
        {
            camera_housing_at_station(
                i
            );
        }
    }


    if (SHOW_CAMERAS)
    {
        for (
            i = [
                0 :
                CAMERA_COUNT - 1
            ]
        )
        {
            %camera_envelope_at_station(
                i
            );
        }
    }


    if (SHOW_FOV)
    {
        for (
            i = [
                0 :
                CAMERA_COUNT - 1
            ]
        )
        {
            %camera_fov_at_station(
                i
            );
        }
    }


    if (SHOW_DUCT)
    {
        %duct_reference();
    }


    if (SHOW_AIRWAY)
    {
        %airway_reference();
    }


    if (SHOW_SHELL_INNER)
    {
        %sphere_reference(
            SHELL_INNER_D
        );
    }


    if (SHOW_OUTER_SPHERE)
    {
        %sphere_reference(
            VEHICLE_D
        );
    }
}


// ============================================================
// 17. SINGLE CAMERA HOUSING
// ============================================================

module camera_housing()
{
    difference()
    {
        camera_housing_outer();

        camera_pocket();

        lens_opening();

        cable_exit();
    }

    camera_retention_lips();
}


// ============================================================
// 18. OUTER HOUSING
// ============================================================

module camera_housing_outer()
{
    translate([
        HOUSING_CENTER_R,
        0,
        CAMERA_Z
    ])
    cube([
        HOUSING_D,
        HOUSING_W,
        HOUSING_H
    ],
    center = true);
}


// ============================================================
// 19. CAMERA POCKET
// ============================================================

module camera_pocket()
{
    /*
    Pocket is slightly extended toward the rear to avoid
    coincident boolean surfaces.
    */

    translate([
        HOUSING_INNER_R +
        CAMERA_WALL +
        CAMERA_POCKET_D / 2,

        0,

        CAMERA_Z
    ])
    cube([
        CAMERA_POCKET_D + 0.2,
        CAMERA_POCKET_W,
        CAMERA_POCKET_H
    ],
    center = true);
}


// ============================================================
// 20. LENS OPENING
// ============================================================

module lens_opening()
{
    translate([
        HOUSING_OUTER_R,
        0,
        CAMERA_Z
    ])
    rotate([
        0,
        90,
        0
    ])
    cylinder(
        h = 2 * CAMERA_WALL + 1,
        d = LENS_OPENING_D,
        center = true
    );
}


// ============================================================
// 21. REAR CABLE EXIT
// ============================================================

module cable_exit()
{
    translate([
        HOUSING_INNER_R,
        0,
        CAMERA_Z
    ])
    cube([
        2 * CAMERA_WALL + 1,
        CABLE_EXIT_W,
        CABLE_EXIT_H
    ],
    center = true);
}


// ============================================================
// 22. RETENTION LIPS
// ============================================================

module camera_retention_lips()
{
    for (
        side = [-1, 1]
    )
    {
        translate([
            HOUSING_OUTER_R -
            RETAINER_DEPTH / 2,

            side *
            (
                CAMERA_POCKET_W / 2 +
                RETAINER_LIP / 2
            ),

            CAMERA_Z
        ])
        cube([
            RETAINER_DEPTH,
            RETAINER_LIP,
            CAMERA_POCKET_H
        ],
        center = true);
    }
}


// ============================================================
// 23. STATION TRANSFORM
// ============================================================

module camera_housing_at_station(
    station
)
{
    angle =
        CAMERA_ANGLE_OFFSET +
        station *
        360 /
        CAMERA_COUNT;


    rotate([
        0,
        0,
        angle
    ])
    camera_housing();
}


// ============================================================
// 24. CAMERA ENVELOPE
// ============================================================

module camera_envelope()
{
    translate([
        HOUSING_INNER_R +
        CAMERA_WALL +
        CAMERA_BODY_D / 2,

        0,

        CAMERA_Z
    ])
    cube([
        CAMERA_BODY_D,
        CAMERA_BODY_W,
        CAMERA_BODY_H
    ],
    center = true);
}


module camera_envelope_at_station(
    station
)
{
    angle =
        CAMERA_ANGLE_OFFSET +
        station *
        360 /
        CAMERA_COUNT;


    rotate([
        0,
        0,
        angle
    ])
    camera_envelope();
}


// ============================================================
// 25. FIELD-OF-VIEW KEEP-OUT
// ============================================================

module camera_fov()
{
    /*
    OpenSCAD has circular cones, while the camera FOV is
    rectangular.

    We therefore construct a rectangular pyramidal frustum
    using hull() between:
      - lens aperture plane
      - far FOV rectangle

    This is a geometric keep-out, not an optical ray tracer.
    */

    lens_plane_x =
        LENS_PLANE_R;


    far_plane_x =
        LENS_PLANE_R +
        FOV_LENGTH;


    hull()
    {
        translate([
            lens_plane_x,
            0,
            CAMERA_Z
        ])
        cube([
            0.1,
            LENS_OPENING_D,
            LENS_OPENING_D
        ],
        center = true);


        translate([
            far_plane_x,
            0,
            CAMERA_Z
        ])
        cube([
            0.1,
            2 * FOV_END_HALF_WIDTH,
            2 * FOV_END_HALF_HEIGHT
        ],
        center = true);
    }
}


module camera_fov_at_station(
    station
)
{
    angle =
        CAMERA_ANGLE_OFFSET +
        station *
        360 /
        CAMERA_COUNT;


    rotate([
        0,
        0,
        angle
    ])
    camera_fov();
}


// ============================================================
// 26. REFERENCES
// ============================================================

module duct_reference()
{
    difference()
    {
        cylinder(
            h = 70,
            d = DUCT_OD,
            center = true
        );

        cylinder(
            h = 70.2,
            d = AIRWAY_D,
            center = true
        );
    }
}


module airway_reference()
{
    cylinder(
        h = 70,
        d = AIRWAY_D,
        center = true
    );
}


module sphere_reference(
    diameter
)
{
    sphere(
        d = diameter
    );
}


// ============================================================
// 27. SPHERE RADIUS FUNCTION
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
// 28. CAMERA AXIAL EXTREMES
// ============================================================

CAMERA_Z_TOP =
    CAMERA_Z +
    HOUSING_H / 2;


CAMERA_Z_BOTTOM =
    CAMERA_Z -
    HOUSING_H / 2;


CAMERA_WORST_Z =
    max(
        abs(CAMERA_Z_TOP),
        abs(CAMERA_Z_BOTTOM)
    );


// ============================================================
// 29. AVAILABLE SHELL RADIUS
// ============================================================

AVAILABLE_SHELL_R =
    sphere_radius_at_z(
        SHELL_INNER_R,
        CAMERA_WORST_Z
    );


// ============================================================
// 30. SHELL CLEARANCE
// ============================================================

CAMERA_SHELL_CLEARANCE =
    AVAILABLE_SHELL_R -
    HOUSING_OUTER_R;


// ============================================================
// 31. AIRWAY CLEARANCE
// ============================================================

CAMERA_AIRWAY_CLEARANCE =
    HOUSING_INNER_R -
    AIRWAY_R;


// ============================================================
// 32. ANGULAR CAMERA COVERAGE
// ============================================================

CAMERA_SPACING_DEG =
    360 /
    CAMERA_COUNT;


HORIZONTAL_FOV_OVERLAP =
    HORIZONTAL_FOV_DEG -
    CAMERA_SPACING_DEG;


// ============================================================
// 33. VALIDATION
// ============================================================

assert(
    CAMERA_COUNT == 4,

    "FAIL: camera architecture requires four stations."
);


assert(
    CAMERA_POCKET_W >= 14.2,

    "FAIL: camera pocket width below requirement."
);


assert(
    CAMERA_POCKET_H >= 14.2,

    "FAIL: camera pocket height below requirement."
);


assert(
    CAMERA_AIRWAY_CLEARANCE > 0,

    "FAIL: camera structure enters propulsion airway."
);


assert(
    HOUSING_OUTER_R <
    VEHICLE_R,

    "FAIL: camera housing exits 115 mm vehicle envelope."
);


assert(
    CAMERA_SHELL_CLEARANCE >= 0.2,

    "FAIL: camera housing intersects inner crash shell."
);


assert(
    HORIZONTAL_FOV_OVERLAP >= 0,

    "FAIL: four-camera horizontal coverage contains blind sectors."
);


// ============================================================
// 34. OUTPUT
// ============================================================

echo(
    "============================================"
);

echo(
    "AIDRONE FILE 20 — CAMERA RING"
);

echo(
    "Camera count =",
    CAMERA_COUNT
);

echo(
    "Camera spacing =",
    CAMERA_SPACING_DEG
);

echo(
    "Camera body =",
    CAMERA_BODY_W,
    CAMERA_BODY_H,
    CAMERA_BODY_D
);

echo(
    "Camera pocket =",
    CAMERA_POCKET_W,
    CAMERA_POCKET_H,
    CAMERA_POCKET_D
);

echo(
    "Housing dimensions =",
    HOUSING_W,
    HOUSING_H,
    HOUSING_D
);

echo(
    "Housing inner radius =",
    HOUSING_INNER_R
);

echo(
    "Housing outer radius =",
    HOUSING_OUTER_R
);

echo(
    "Airway clearance =",
    CAMERA_AIRWAY_CLEARANCE
);

echo(
    "Available shell radius =",
    AVAILABLE_SHELL_R
);

echo(
    "Camera / shell clearance =",
    CAMERA_SHELL_CLEARANCE
);

echo(
    "Lens opening diameter =",
    LENS_OPENING_D
);

echo(
    "Horizontal FOV =",
    HORIZONTAL_FOV_DEG
);

echo(
    "Vertical FOV =",
    VERTICAL_FOV_DEG
);

echo(
    "Horizontal adjacent-camera overlap =",
    HORIZONTAL_FOV_OVERLAP
);

echo(
    "============================================"
);