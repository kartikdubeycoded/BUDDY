# BUDDY Prototype Manufacturing Strategy V1

## Objective
Produce geometry that can be measured, revised, and safely bench-tested. The first physical build is an engineering prototype, not a finished flight product.

## Part architecture
1. Central duct: separate high-dimensional-accuracy component. Protect circularity and internal surface quality.
2. Motor/stator carriers: removable modules so propulsion hardware can change without discarding the duct/shell.
3. Vane cartridges: individually replaceable, with mechanical hard stops beyond commanded travel.
4. Equatorial electronics belt: removable quadrant carriers for cameras, PCB, power and audio modules.
5. Battery carrier: mechanically retained independently of cosmetic shell pieces.
6. Crash cage: segmented so damaged cage elements can be replaced without disturbing propulsion alignment.

## Tolerance policy
- Do not use one universal 0.2 mm tolerance for every interface.
- Sliding printed fits require calibration coupons for the actual printer/material/orientation.
- Rotor dynamic clearance includes manufacturing error, shaft runout, bearing play, thermal effects and structural deflection; nominal CAD gap alone is insufficient.
- Camera-shell V3 design target is >=1.0 mm before printer/process uncertainty.
- Fastener holes and inserts follow selected hardware dimensions rather than placeholders.

## Material strategy
Material is not locked. Candidate polymers must be screened for density, stiffness, impact behavior, heat resistance, layer adhesion and print repeatability. Shell and duct need not use the same material.

## Prototype sequence
A. Print dimensional coupons and duct ring sections.
B. Print central duct and verify ID/OD/circularity.
C. Fit inert motor/rotor envelope gauges before powered hardware.
D. Print one camera/electronics quadrant and validate real hardware fit.
E. Assemble complete inert mass dummy and measure mass/CoG.
F. Only then manufacture powered propulsion/control prototype parts.

## Inspection record
Every physical revision records part mass, critical dimensions, print orientation, material, machine/profile, defects, fit corrections and revision ID. CAD values become VERIFIED manufacturing values only after inspection.
