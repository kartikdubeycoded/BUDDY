/*
================================================================
AIDRONE
FILE 01 / 24
HARDWARE DATABASE

PURPOSE
-------
Central hardware envelope database.

IMPORTANT:
0 = NOT YET SELECTED / NOT VERIFIED.

Do not design final mounting geometry around zero-valued hardware.
================================================================
*/


// ============================================================
// STATUS FLAGS
// ============================================================

STATUS_UNKNOWN  = 0;
STATUS_PLANNING = 1;
STATUS_LOCKED   = 2;


// ============================================================
// CAMERA — RUNCAM NANO 4
// ============================================================

CAM_STATUS = STATUS_LOCKED;

CAM_COUNT = 4;

CAM_BODY_X = 14.0;
CAM_BODY_Y = 14.0;
CAM_BODY_Z = 14.0;

CAM_MASS_G = 2.9;

CAM_FOV_DEG = 155;

// Packaging cavity
CAM_CAVITY_X = 14.2;
CAM_CAVITY_Y = 14.2;
CAM_CAVITY_Z = 15.0;


// ============================================================
// MOTOR STAGE A
// ============================================================

MOTOR_A_STATUS = STATUS_UNKNOWN;

MOTOR_A_DIAMETER = 0;
MOTOR_A_HEIGHT = 0;
MOTOR_A_MASS_G = 0;

MOTOR_A_SHAFT_D = 0;
MOTOR_A_SHAFT_LENGTH = 0;

MOTOR_A_KV = 0;
MOTOR_A_MAX_CURRENT_A = 0;


// ============================================================
// MOTOR STAGE B
// ============================================================

MOTOR_B_STATUS = STATUS_UNKNOWN;

MOTOR_B_DIAMETER = 0;
MOTOR_B_HEIGHT = 0;
MOTOR_B_MASS_G = 0;

MOTOR_B_SHAFT_D = 0;
MOTOR_B_SHAFT_LENGTH = 0;

MOTOR_B_KV = 0;
MOTOR_B_MAX_CURRENT_A = 0;


// ============================================================
// ROTORS
// ============================================================

ROTOR_A_STATUS = STATUS_UNKNOWN;
ROTOR_B_STATUS = STATUS_UNKNOWN;

ROTOR_A_DIAMETER = 0;
ROTOR_B_DIAMETER = 0;

ROTOR_A_MASS_G = 0;
ROTOR_B_MASS_G = 0;

ROTOR_A_BLADE_COUNT = 0;
ROTOR_B_BLADE_COUNT = 0;


// ============================================================
// FLIGHT CONTROLLER
// ============================================================

FC_STATUS = STATUS_UNKNOWN;

FC_X = 0;
FC_Y = 0;
FC_Z = 0;

FC_MASS_G = 0;


// ============================================================
// ESC
// ============================================================

ESC_STATUS = STATUS_UNKNOWN;

ESC_COUNT = 0;

ESC_X = 0;
ESC_Y = 0;
ESC_Z = 0;

ESC_MASS_EACH_G = 0;


// ============================================================
// BATTERY
// ============================================================

BATTERY_STATUS = STATUS_UNKNOWN;

BATTERY_COUNT = 2;

BATTERY_X = 0;
BATTERY_Y = 0;
BATTERY_Z = 0;

BATTERY_MASS_EACH_G = 0;

BATTERY_CELL_COUNT_SERIES = 0;
BATTERY_CAPACITY_MAH = 0;

BATTERY_NOMINAL_VOLTAGE = 0;


// ============================================================
// VANE ACTUATORS
// ============================================================

ACTUATOR_STATUS = STATUS_UNKNOWN;

ACTUATOR_COUNT = 4;

ACTUATOR_X = 0;
ACTUATOR_Y = 0;
ACTUATOR_Z = 0;

ACTUATOR_MASS_EACH_G = 0;


// ============================================================
// IMU / SENSOR MODULE
// ============================================================

SENSOR_STATUS = STATUS_UNKNOWN;

SENSOR_X = 0;
SENSOR_Y = 0;
SENSOR_Z = 0;

SENSOR_MASS_G = 0;


// ============================================================
// SPEAKER
// ============================================================

SPEAKER_STATUS = STATUS_UNKNOWN;

SPEAKER_DIAMETER = 0;
SPEAKER_DEPTH = 0;

SPEAKER_MASS_G = 0;


// ============================================================
// AMPLIFIER
// ============================================================

AMP_STATUS = STATUS_UNKNOWN;

AMP_X = 0;
AMP_Y = 0;
AMP_Z = 0;

AMP_MASS_G = 0;


// ============================================================
// POWER REGULATION
// ============================================================

REGULATOR_STATUS = STATUS_UNKNOWN;

REGULATOR_X = 0;
REGULATOR_Y = 0;
REGULATOR_Z = 0;

REGULATOR_MASS_G = 0;


// ============================================================
// WIRING / CONNECTORS
// ============================================================

// Planning allowance only.
// Replace with measured harness mass later.

WIRING_STATUS = STATUS_PLANNING;

WIRING_MASS_ALLOWANCE_G = 8;


// ============================================================
// FASTENERS
// ============================================================

// Planning allowance.

FASTENER_STATUS = STATUS_PLANNING;

FASTENER_MASS_ALLOWANCE_G = 4;


// ============================================================
// PRINTED STRUCTURE MASS
// ============================================================

// NOT a final value.
// Actual mass must later come from CAD volume × material density.

STRUCTURE_STATUS = STATUS_PLANNING;

STRUCTURE_MASS_BUDGET_G = 35;


// ============================================================
// CAMERA TOTALS
// ============================================================

CAMERA_TOTAL_MASS_G =
    CAM_COUNT * CAM_MASS_G;


// ============================================================
// KNOWN MASS
// ============================================================

KNOWN_HARDWARE_MASS_G =
    CAMERA_TOTAL_MASS_G +
    WIRING_MASS_ALLOWANCE_G +
    FASTENER_MASS_ALLOWANCE_G +
    STRUCTURE_MASS_BUDGET_G;


// ============================================================
// HARDWARE STATUS OUTPUT
// ============================================================

echo("========================================");

echo("AIDRONE HARDWARE DATABASE");

echo(
    "Camera mass total g =",
    CAMERA_TOTAL_MASS_G
);

echo(
    "Known/planning mass before propulsion, battery, FC, etc g =",
    KNOWN_HARDWARE_MASS_G
);

echo(
    "Motor A status =",
    MOTOR_A_STATUS
);

echo(
    "Motor B status =",
    MOTOR_B_STATUS
);

echo(
    "Battery status =",
    BATTERY_STATUS
);

echo(
    "Flight controller status =",
    FC_STATUS
);

echo(
    "Actuator status =",
    ACTUATOR_STATUS
);

echo("========================================");