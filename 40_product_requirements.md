# BUDDY — Finished Product Engineering Contract

BUDDY is a compact spherical autonomous flying companion, targeted around a 115 mm outside diameter. It follows one human, maintains safe relative position, perceives surrounding space through cameras and flight sensors, survives abrupt user movement without blindly chasing into obstacles, and speaks through an onboard speaker with a deliberately talkative companion personality. High-level AI, conversation, memory, semantic perception, and user context primarily live on the paired phone; the aircraft retains only the low-latency functions that must continue locally for safe flight: attitude estimation, motor control, obstacle/emergency logic, link supervision, and controlled landing.

## Locked mechanical architecture
- Vehicle outside diameter: 115 mm target.
- Protected shell cavity: 111 mm nominal.
- Central protected airflow diameter: 70 mm.
- Spherical crash cage around the propulsion and electronics system.
- Distributed, rotationally balanced electronics rather than a single heavy side module.
- Four-direction visual coverage target.
- Moving propulsion/control geometry must be evaluated using swept volumes, not static poses.
- No payload/electronics geometry may choke the protected 70 mm airway.

## Flight behavior target
- Stable hover near a person.
- Relative-position following rather than direct high-speed pursuit.
- Smooth translation and stopping.
- Abrupt-motion handling with acceleration/jerk limits.
- Obstacle avoidance has authority over conversational/follow commands.
- Loss of phone link must not cause loss of basic stabilization.
- Low battery, sensor disagreement, excessive attitude, actuator saturation, or navigation uncertainty must transition to a safe behavior rather than continued pursuit.

## Intelligence split
### On aircraft
- IMU / attitude estimation.
- Flight-control loop.
- Motor/actuator outputs.
- Essential proximity/obstacle safety.
- Link watchdog.
- Emergency hover/land behavior.

### On paired phone
- Speech recognition and synthesis orchestration.
- Conversational model and personality.
- Memory and user context.
- Higher-level vision/perception where latency permits.
- Follow intent and semantic decisions.

The phone may request motion; it must never directly command raw motor outputs.

## Engineering acceptance principle
A CAD compile is not a flight validation. Dimensions may be marked VERIFIED when directly constrained by geometry/math. Aerodynamic, structural, thermal, battery, actuator, and propulsion claims remain PROVISIONAL until supported by selected hardware data, simulation, bench measurements, or physical tests as appropriate.

## Current V3 convergence targets
- Provisional mass target: <= 190 g.
- Design rejection threshold: > 200 g before justified redesign.
- Camera-to-shell design margin: >= 1.0 mm.
- Camera-to-duct service gap: >= 0.8 mm.
- XY CoG offset target: <= 1.0 mm.
- |Z CoG| target: <= 1.0 mm.
- Maintain the 115/111/70 mm architecture unless measured hardware proves it infeasible.
