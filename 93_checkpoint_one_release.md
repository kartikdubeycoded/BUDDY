# BUDDY CHECKPOINT ONE — STAGE 1 MODEL RELEASE CANDIDATE

## Definition
Checkpoint One is the complete first-pass engineering model of the BUDDY companion: a ~115 mm spherical protected flying companion architecture with a 70 mm central airway, distributed payload/electronics, four-direction camera concept, protected propulsion/control system, phone-assisted intelligence architecture, onboard flight-safety authority, printable/serviceable mechanical decomposition, and an evidence-driven path to a physical prototype.

## Included engineering domains
Mechanical architecture; print/process parameters; segmented crash cage; propulsion cartridge; motor/stator interfaces; rotor envelopes; vane cartridges and actuator linkage; camera cassettes/windows; opposed battery retention; modular electronics carriers; audio/IMU packaging; wiring/service routes; ventilation/reinforcement concepts; fastener/alignment interfaces; part manifest; print layout; exploded/master/integration views; mass and CoG budgets/tools; energy and flight-envelope screens; perception coverage; bounded follow dynamics; safety state machine; behavior arbitration; phone-aircraft protocol; fault injection; structural/inertial/thermal rules; risk register; verification matrix; assembly/manufacturing/test procedures.

## What this checkpoint proves
It proves that the intended product has been decomposed into a coherent first-pass system architecture with explicit interfaces, requirements, models, printable-part concepts and validation gates. Deterministic geometry relationships can be checked without pretending hardware-dependent physics are known.

## What it does not prove
It does not prove that BUDDY can fly. Thrust, coaxial/duct performance, rotor dynamics, actuator authority, structural containment, battery performance, thermal behavior, acoustic performance, real camera fields, printed tolerance, final mass and flight control require selected components and measured/simulated/physical evidence.

## Local release procedure
1. Pull the checkpoint branch/merged baseline when instructed.
2. Run `python 79_stage1_validation_runner.py`.
3. Run `python 92_checkpoint_one_audit.py`.
4. Open `91_stage1_complete_prototype.scad`; F5 VIEW 0 through 4.
5. Open `76_stage1_collision_regression.scad`; F5 TEST 1 through 3. Any red solid geometry is a failure requiring correction.
6. Compile the critical individual printable modules if the master scene reports an error.
7. Report console output/errors. Correct integration defects before calling the CAD baseline released.

Checkpoint Two begins hardware convergence: select actual propulsion, battery, actuator, camera, controller, audio and electrical hardware against the controlled envelopes; replace placeholders; rerun mass/power/CoG/collision models; then manufacture the inert dimensional article.
