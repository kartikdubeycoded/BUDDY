# BUDDY Stage 1 Mechanical Part Manifest

Stage 1 means a complete CAD-defined mechanical prototype architecture. It does not mean the unselected propulsion/electrical hardware has magically become validated.

| ID | Part | Qty | Manufacturing intent | Primary interface |
|---|---|---:|---|---|
| P01 | upper crash-cage hemisphere | 1 | FDM prototype | equatorial clamp / polar duct |
| P02 | lower crash-cage hemisphere | 1 | FDM prototype | equatorial clamp / polar duct |
| P03 | equatorial cage clamp | 1 | FDM prototype | cage halves / service chassis |
| P04 | equatorial service chassis | 1 | FDM prototype | cameras / battery / PCB quadrants |
| P05 | central propulsion duct | 1 | high-accuracy print or alternate process after tests | stators / cage polar interface |
| P06 | upper stator/motor carrier | 1 | removable prototype module | duct / selected motor |
| P07 | lower stator/motor carrier | 1 | removable prototype module | duct / selected motor |
| P08 | vane cartridge | 4 | FDM prototype | duct exit / actuator linkage |
| P09 | camera housing | 4 | FDM prototype | chassis / selected camera |
| P10 | battery carrier | 2 | FDM prototype | chassis / selected cell pack |
| P11 | electronics carrier | 4 | FDM prototype | chassis / FC/ESC/power/audio |
| P12 | alignment pins/features | as required | integrated/printed | cage/chassis registration |
| P13 | threaded insert bosses | as required | integrated/printed | service fasteners |
| P14 | vibration/damping pads | TBD | elastomer/nonprinted | motors/electronics/cameras |
| P15 | wire retainers/strain relief | as required | printed + ties as selected | service routes |

## Nonprinted hardware classes still requiring selection
Two motors, two counter-rotating rotor/propeller elements, ESC/power stage, battery cells/pack, flight controller/IMU, four camera modules, four vane actuators, speaker/amplifier, voltage regulation, wiring/connectors, fasteners/inserts, bearings/bushings/linkages as required.

## Assembly hierarchy
1. Calibrate printer/interface coupons.
2. Verify duct dimensional article.
3. Install stator/motor carriers and inert rotor gauges.
4. Install vane cartridges and verify full swept travel manually.
5. Build equatorial service chassis with dummy/real measured hardware.
6. Route wiring through reserved service volumes.
7. Join chassis to propulsion cartridge.
8. Install upper/lower cage and equatorial clamp.
9. Measure final mass, XYZ CoG, airway obstruction and all dynamic clearances before any powered test.
