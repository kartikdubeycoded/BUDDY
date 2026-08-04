"""BUDDY V3 integrated engineering gate.
Collects the current architectural requirements into one explicit status report.
"""
checks=[
 ('vehicle OD locked at 115 mm',True,'GEOMETRY'),
 ('protected airway locked at 70 mm',True,'GEOMETRY'),
 ('V2/V3 packaging analytical clearances positive',True,'GEOMETRY'),
 ('camera production margin >=1 mm',False,'LOCAL CAD TEST REQUIRED'),
 ('provisional mass <=190 g',False,'HARDWARE CONVERGENCE'),
 ('measured XY CoG <=1 mm',False,'PHYSICAL'),
 ('selected propulsion produces required thrust reserve',False,'BENCH'),
 ('battery supports peak current with acceptable sag',False,'BENCH'),
 ('vane control authority validated',False,'BENCH/CFD'),
 ('stable independent hover validated',False,'FLIGHT TEST'),
 ('obstacle avoidance validated',False,'SYSTEM TEST'),
 ('phone-link fault behavior validated',False,'FAULT INJECTION'),
 ('human-follow behavior validated',False,'SYSTEM TEST'),
 ('shell rotor containment validated',False,'STRUCTURAL TEST'),
]
print('BUDDY V3 SYSTEM GATE')
for name,ok,evidence in checks:
 print(('PASS ' if ok else 'BLOCK'),f'{name:58s}',evidence)
passed=sum(x[1] for x in checks)
print(f'\nSTATUS {passed}/{len(checks)} gates currently supported')
print('Interpretation: architecture is converging; aircraft is not yet a flight-ready prototype.')
