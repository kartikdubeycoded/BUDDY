"""BUDDY V3 convergence report from the latest local validation run.
Separates contradictions, accepted geometry, and redesign requirements.
"""
print('BUDDY V3 CONVERGENCE REPORT')
print('='*68)
print('ACCEPTED')
for x in [
 '115 mm vehicle envelope compiles cleanly',
 '111 mm shell cavity architecture compiles cleanly',
 '70 mm airway architecture remains locked',
 'V2 analytical camera clearance = 0.637 mm',
 'V2 battery clearance = 9.276 mm',
 'V2 PCB clearance = 11.890 mm',
 'dynamic rotor radial clearance = 0.400 mm',
 'dynamic stator axial clearance = 1.000 mm',
 'V2 full assembly preview compiles cleanly (122 normalized elements)',
]: print(' PASS:',x)
print('\nREJECT / REDESIGN')
for x in [
 'Legacy optimizer camera envelope (16.8 mm radial depth) has no feasible placement; it is superseded by V2 camera depth 15.8 mm.',
 '210 g provisional mass exceeds 180 g target and 200 g design ceiling.',
 '0.637 mm camera-shell margin passes geometry but is too small for an uncalibrated FDM production claim.',
 'Rotor tip margin 0.400 mm is mathematically positive but demands measured runout/deflection and manufacturing control.',
]: print(' REDESIGN:',x)
print('\nTARGETS FOR V3')
print(' mass target <= 190 g before measured hardware; hard rejection > 200 g')
print(' camera shell design margin >= 1.0 mm')
print(' retain >= 0.8 mm camera-to-duct service gap')
print(' preserve XY symmetry and target |Z CoG| <= 1.0 mm')
print(' do not change 115/111/70 mm architecture merely to hide packaging failures')
