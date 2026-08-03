/*
================================================================
AIDRONE - FILE 02 / 24
MATERIALS + MANUFACTURING + TOLERANCE AUTHORITY
================================================================
*/
$fn=100;

PROCESS_FDM=1;
MANUFACTURING_PROCESS=PROCESS_FDM;
NOZZLE_D=0.40;
LAYER_HEIGHT=0.20;
EXTRUSION_WIDTH=0.45;

WALL_LIGHT=3*EXTRUSION_WIDTH;
WALL_STANDARD=4*EXTRUSION_WIDTH;
WALL_STRUCTURAL=5*EXTRUSION_WIDTH;
WALL_HEAVY=6*EXTRUSION_WIDTH;
DUCT_WALL_NOMINAL=2.00;
MIN_CRASH_MEMBER=2.00;
PREFERRED_CRASH_MEMBER=2.40;
MIN_PRINT_FEATURE=0.80;

CLEARANCE_CLOSE=0.10;
CLEARANCE_REMOVABLE=0.15;
CLEARANCE_SLIDING=0.20;
CLEARANCE_MOVING=0.35;
CLEARANCE_SERVICE=0.40;

function female_bore_for_male(male_diameter,radial_clearance)=male_diameter+2*radial_clearance;
function male_for_female_bore(female_diameter,radial_clearance)=female_diameter-2*radial_clearance;
function pocket_dimension(part_dimension,side_clearance)=part_dimension+2*side_clearance;

CORE_OD=74.0;
CORE_COLLAR_RADIAL_CLEARANCE=CLEARANCE_SLIDING;
COLLAR_BORE=female_bore_for_male(CORE_OD,CORE_COLLAR_RADIAL_CLEARANCE);

// Keep the camera-fit authority self-contained.  Passing the clearance
// explicitly avoids OpenSCAD scope/evaluation ambiguity seen in imported files.
CAMERA_BODY_X=14.0;
CAMERA_BODY_Y=14.0;
CAMERA_BODY_Z=14.0;
CAMERA_SIDE_CLEARANCE=0.15;
CAMERA_POCKET_X=CAMERA_BODY_X+2*CAMERA_SIDE_CLEARANCE;
CAMERA_POCKET_Y=CAMERA_BODY_Y+2*CAMERA_SIDE_CLEARANCE;
CAMERA_POCKET_Z=CAMERA_BODY_Z+2*CAMERA_SIDE_CLEARANCE;

KEY_SIDE_CLEARANCE=CLEARANCE_SLIDING;
function keyway_width(key_width)=key_width+2*KEY_SIDE_CLEARANCE;
function keyway_depth(key_projection)=key_projection+CLEARANCE_SLIDING;
PIVOT_RADIAL_CLEARANCE=CLEARANCE_MOVING;
function pivot_bore(shaft_diameter)=shaft_diameter+2*PIVOT_RADIAL_CLEARANCE;
METAL_PIN_RADIAL_CLEARANCE=0.10;
function metal_pin_bore(pin_diameter)=pin_diameter+2*METAL_PIN_RADIAL_CLEARANCE;

M1_6_NOMINAL=1.60; M2_NOMINAL=2.00; M2_5_NOMINAL=2.50;
M1_6_CLEARANCE_HOLE=1.90; M2_CLEARANCE_HOLE=2.40; M2_5_CLEARANCE_HOLE=2.90;
SCREW_EDGE_FACTOR=2.0;
function minimum_screw_edge_distance(screw_nominal_d)=screw_nominal_d*SCREW_EDGE_FACTOR;
BOSS_WALL_MIN=1.60;
function boss_outer_diameter(hole_diameter)=hole_diameter+2*BOSS_WALL_MIN;

INSERT_SELECTED=false; INSERT_OD=0; INSERT_LENGTH=0; INSERT_HOLE_D=0;
MIN_STRUCTURAL_FILLET=1.0; PREFERRED_STRUCTURAL_FILLET=1.5;
WIRE_CHANNEL_SIDE_CLEARANCE=0.50;
function wire_channel_width(wire_bundle_width)=wire_bundle_width+2*WIRE_CHANNEL_SIDE_CLEARANCE;
WIRE_MIN_BEND_RADIUS_FACTOR=3.0;
function wire_min_bend_radius(cable_diameter)=cable_diameter*WIRE_MIN_BEND_RADIUS_FACTOR;
BATTERY_SIDE_CLEARANCE=0.50;
function battery_pocket_dimension(battery_dimension)=battery_dimension+2*BATTERY_SIDE_CLEARANCE;
BATTERY_MIN_PADDING=1.0;
MOTOR_SUPPORT_MIN_THICKNESS=2.40;
MOTOR_SUPPORT_PREFERRED_THICKNESS=3.00;
MIN_ROTOR_STATIC_RADIAL_CLEARANCE=1.00;
VANE_SWEEP_MIN_CLEARANCE=1.00;
CAMERA_FOV_MARGIN_DEG=3.0;

XY_EXTERNAL_COMPENSATION=0.00;
XY_INTERNAL_COMPENSATION=0.00;
Z_COMPENSATION=0.00;
function compensated_external(dimension)=dimension+XY_EXTERNAL_COMPENSATION;
function compensated_internal(dimension)=dimension+XY_INTERNAL_COMPENSATION;

assert(NOZZLE_D>0,"Nozzle diameter must be positive.");
assert(WALL_STANDARD>=3*NOZZLE_D,"Standard wall unexpectedly thin.");
assert(MIN_CRASH_MEMBER>=2.0,"Crash member below structural study minimum.");
assert(CLEARANCE_MOVING>CLEARANCE_SLIDING,"Moving fit must be looser than sliding fit.");
assert(CLEARANCE_SLIDING>CLEARANCE_CLOSE,"Sliding fit must be looser than close fit.");
assert(abs(COLLAR_BORE-74.4)<0.0001,"Core/collar interface changed unexpectedly.");
assert(abs(CAMERA_POCKET_X-14.3)<0.0001 && abs(CAMERA_POCKET_Y-14.3)<0.0001 && abs(CAMERA_POCKET_Z-14.3)<0.0001,"Camera pocket tolerance authority changed unexpectedly.");
assert(MIN_ROTOR_STATIC_RADIAL_CLEARANCE>=1.0,"Rotor manufacturing clearance below current safety floor.");

echo("============================================");
echo("AIDRONE MATERIAL / TOLERANCE AUTHORITY");
echo("Nozzle diameter =",NOZZLE_D);
echo("Layer height =",LAYER_HEIGHT);
echo("Light wall =",WALL_LIGHT);
echo("Standard wall =",WALL_STANDARD);
echo("Structural wall =",WALL_STRUCTURAL);
echo("Preferred crash member =",PREFERRED_CRASH_MEMBER);
echo("Sliding radial clearance =",CLEARANCE_SLIDING);
echo("Core OD =",CORE_OD);
echo("Collar bore =",COLLAR_BORE);
echo("Camera pocket X =",CAMERA_POCKET_X);
echo("Camera pocket Y =",CAMERA_POCKET_Y);
echo("Camera pocket Z =",CAMERA_POCKET_Z);
echo("M2 printed clearance hole =",M2_CLEARANCE_HOLE);
echo("Minimum motor support thickness =",MOTOR_SUPPORT_MIN_THICKNESS);
echo("Minimum rotor radial clearance =",MIN_ROTOR_STATIC_RADIAL_CLEARANCE);
echo("============================================");
