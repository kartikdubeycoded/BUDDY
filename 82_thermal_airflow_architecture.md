# BUDDY Stage 1 Thermal / Airflow Architecture

## Airflow rule
The 70 mm propulsion airway is flight hardware. Electronics cooling features may use peripheral pressure/flow opportunities only when they do not create protrusions, loose wiring, sharp blockage, or asymmetric obstruction inside the protected airway.

## Heat-source classes
- motors and bearings: propulsion core; temperature/vibration require direct measurement.
- ESC/power conversion: high-current electronics; place near useful structure/air access while isolating sensitive sensors.
- battery: protect from motor/ESC heat and mechanical damage; pack temperature must be measured during discharge.
- compute/flight controller: lower power but sensor bias can be temperature-sensitive.
- audio amplifier/speaker: intermittent auxiliary heat and power load.

## Packaging rules
1. Do not enclose the ESC in an unvented decorative cavity.
2. Do not use the battery as a heat sink.
3. Keep IMU away from direct motor heat and strong vibration paths where architecture permits.
4. Vent paths must retain cage strength and must not expose moving propulsion hardware.
5. Symmetric cooling openings are preferred where practical to avoid unnecessary aerodynamic asymmetry.
6. Any cooling duct that steals area from the 70 mm airway must be justified by measured system performance.

## Required thermal test data
Ambient temperature, battery voltage/current, motor temperatures, ESC temperature, battery temperature, regulator temperature, flight-controller temperature, run duration, thrust/command state and post-run inspection. Thermal equilibrium cannot be inferred from a short successful hover.
