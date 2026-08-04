"""BUDDY Stage1 deterministic geometry/math audit.
Checks relationships we can prove without pretending unselected hardware is known.
"""
import math
OD=115.; CAV=111.; AIR=70.; DUCT=74.; ROTOR_R=34.6
SHELL=(OD-CAV)/2
polar=74.8
static_gap=AIR/2-ROTOR_R
annulus=(math.pi/4)*(DUCT**2-AIR**2)
open_area=math.pi*(AIR/2)**2
print('BUDDY STAGE1 MATH AUDIT')
checks={
 'shell radial thickness = 2mm':abs(SHELL-2)<1e-9,
 'duct wall radial thickness = 2mm':abs((DUCT-AIR)/2-2)<1e-9,
 'polar opening clears duct':polar>DUCT,
 'rotor static radial gap positive':static_gap>0,
 'rotor diameter below airway':2*ROTOR_R<AIR,
 'airway open area > 3800 mm2':open_area>3800,
}
for k,v in checks.items():print(('PASS ' if v else 'FAIL ')+k)
print(f'shell thickness={SHELL:.3f}mm duct wall={(DUCT-AIR)/2:.3f}mm rotor static gap={static_gap:.3f}mm')
print(f'airway area={open_area:.1f}mm2 duct material cross-section={annulus:.1f}mm2')
assert all(checks.values())
print('DETERMINISTIC STAGE1 GEOMETRY RELATIONS PASS')
print('This does not validate thrust, structural strength, vibration, heat, or printed dimensional accuracy.')
