"""BUDDY build-readiness gate.
This gate prevents prototype/manufacturing claims while critical hardware inputs are unknown.
It is deliberately conservative.
"""
checks={
 'CAD dependency graph clean':True,
 '115 mm outer architecture locked':True,
 '70 mm protected airway locked':True,
 'dynamic rotor envelope has positive duct clearance':True,
 'dynamic rotor/stator axial clearance >=1 mm':True,
 'distributed V2 packaging has analytical shell clearance':True,
 'actual motor selected with measured thrust curve':False,
 'actual rotor selected and balanced':False,
 'actual ESC selected and thermally/current validated':False,
 'actual battery selected with dimensions/mass/sag data':False,
 'actual actuator selected with torque-speed-current data':False,
 'measured all-up mass and XYZ CoG available':False,
 'vane control authority bench validated':False,
 'shell impact/rotor-containment tested':False,
 'full moving collision test passes locally':False,
}
print('BUDDY BUILD READINESS GATE')
failed=[]
for name,ok in checks.items():
 print(('PASS ' if ok else 'BLOCK'),name)
 if not ok: failed.append(name)
print('\nRESULT:', 'NOT READY FOR FLIGHT BUILD' if failed else 'READY FOR CONTROLLED PROTOTYPE')
print('Open blockers:',len(failed))
