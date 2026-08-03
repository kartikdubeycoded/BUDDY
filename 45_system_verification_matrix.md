# BUDDY System Verification Matrix

This matrix defines what evidence is required before each claim can move from PROVISIONAL to VERIFIED.

| Requirement | Current state | Required evidence |
|---|---|---|
| 115 mm external architecture | Geometry verified | CAD envelope/collision regression |
| 70 mm protected airway | Geometry verified | CAD regression + assembled inspection |
| Camera packaging | V3 analytical | F5/F6 geometry, printer calibration, real camera fit |
| <=190 g target | Provisional | selected BOM + measured assembled mass |
| CoG within 1 mm XY | Provisional | measured suspended/balance test or calibrated fixture |
| Stable hover | Unverified | restrained/tether progression then controlled hover test |
| Follow a human | Unverified | validated hover + perception + bounded-follow tests |
| Abrupt-motion handling | Model only | SIL/HIL and controlled trajectory tests |
| Obstacle avoidance | Architecture only | sensor selection, latency characterization, scenario testing |
| Phone-link loss safety | Architecture/model | communication fault-injection tests |
| Propulsion thrust reserve | Provisional | motor/rotor/duct bench thrust-current-RPM curves |
| Rotor containment | Unverified | structural analysis plus protected destructive testing |
| Vane authority | Provisional | CFD/bench force/torque data and flight tests |
| Battery endurance | Provisional | selected cell discharge curves and integrated power measurements |
| Thermal safety | Unverified | instrumented sustained-load testing |
| Talkative companion audio | Architecture only | selected speaker/amplifier and acoustic test |
| Four-direction spatial awareness | Architecture only | camera/sensor selection, calibrated FOV/occlusion testing |

## Prototype gates

### Gate A — CAD
All static and swept-volume collision checks pass.

### Gate B — Bench propulsion
Measured thrust, current, RPM, vibration, temperature, rotor clearance, and emergency shutdown behavior are acceptable.

### Gate C — Restrained controls
Attitude/control behavior is validated without free flight.

### Gate D — Independent hover
BUDDY can safely stabilize without human-follow behavior.

### Gate E — Perception and avoidance
Obstacle and user-relative localization meet tested latency/confidence limits.

### Gate F — Human follow
FOLLOW is enabled only after A-E pass. Conversation remains lower priority than flight safety throughout.
