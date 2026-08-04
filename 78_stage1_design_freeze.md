# BUDDY Stage 1 Design Freeze Candidate

## Frozen at this checkpoint
The coordinate system, 115 mm external target, 111 mm nominal internal cage cavity, 70 mm protected airway, 74 mm nominal duct OD, central Z propulsion axis, segmented crash cage concept, equatorial service split, distributed symmetric service chassis, four camera stations, two opposed battery stations, four electronics quadrants, removable propulsion cartridge, four replaceable vane cartridges, reserved wiring routes, calibration-first FDM policy, and phone/onboard safety authority split are frozen as the Stage 1 architecture candidate.

## Not frozen
Motor model and mounting pattern, rotor geometry, ESC, battery chemistry/pack dimensions, flight controller, camera/lens, actuator, speaker, connectors, inserts/fasteners, exact material, exact print process compensation, structural rib sizing after impact evidence, cooling details after thermal evidence, and controller gains.

## Change classes
- Class A: component-level adjustment inside an existing controlled envelope; rerun local fit/collision/mass checks.
- Class B: interface change affecting neighboring systems; rerun Stage1 master, collision regression, mass/CoG and relevant documentation.
- Class C: change to 115/111/70 architecture, propulsion topology or control topology; requires explicit architecture review rather than silent modification.

## Freeze exit criteria
The candidate becomes a released Stage1 CAD baseline after local compilation of the new SCAD chain, deterministic math audit, collision-regression review, and correction of any syntax/interface failures discovered by those checks.
