# BUDDY Prototype Test Campaign V1

## Stage 0 — Software and geometry
Run CAD assertions, static/swept collision tests, mass/energy models, follow-dynamics tests, safety-supervisor tests and fault injection. Resolve every deterministic failure before manufacturing.

## Stage 1 — Inert dimensional article
No powered rotors. Build duct, cage and representative mass blocks. Measure actual OD, airway ID, rotor-envelope clearance gauges, camera fit, mass and XYZ CoG. Drop/impact testing here uses inert masses only.

## Stage 2 — Propulsion bench article
Use guarded/restrained fixture. Measure thrust, electrical power/current, RPM where available, vibration, temperatures and shutdown behavior across the intended operating range. Characterize both rotors together; single-rotor data is insufficient for the coaxial/ducted system.

## Stage 3 — Vane/actuator bench
With guarded airflow, measure vane force/control moment proxy, actuator current, response time, backlash, saturation and thermal behavior over the full commanded range. Verify no swept-volume collision under load.

## Stage 4 — Integrated restrained controls
Install flight controller and propulsion on a fixture that prevents uncontrolled translation. Validate sensor sign conventions, motor directions, controller saturation behavior, link-loss handling and emergency states.

## Stage 5 — Controlled independent hover
No human following. Use a protected test area. Establish repeatable takeoff, hover, disturbance recovery and landing before enabling perception-driven motion.

## Stage 6 — Perception/avoidance
Test camera calibration, occlusions, latency, obstacle detection and avoidance using controlled targets. Inject stale/lost perception and confirm BRAKE/HOVER behavior.

## Stage 7 — Human-follow progression
Begin at low speed and large separation. Increase trajectory complexity only after bounded stopping, avoidance and link-loss behavior pass. Conversation/audio remains non-flight-critical and cannot override safety states.

## Evidence policy
Record configuration, firmware/software revision, CAD revision, BOM, battery, test environment and measured data for every run. A pass belongs to a specific configuration; changing propulsion, battery, geometry or controller can invalidate previous evidence.
