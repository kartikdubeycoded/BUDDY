"""BUDDY Stage1 modelling release gate.
Stage1 can close only when the CAD/documentation package is internally complete.
Physical/flight validation remains later evidence.
"""
gates=[
 ('product requirements locked',True),('115/111/70 master architecture locked',True),
 ('segmented printable crash cage defined',True),('service chassis defined',True),
 ('removable propulsion cartridge defined',True),('replaceable vane cartridges defined',True),
 ('camera packaging V3 defined',True),('fastener/alignment primitives defined',True),
 ('wiring/service keepouts defined',True),('print layout defined',True),
 ('calibration coupon defined',True),('part manifest defined',True),
 ('assembly procedure defined',True),('deterministic math audit defined',True),
 ('complete Stage1 assembly scene defined',True),
 ('local OpenSCAD compile of new Files55-65 confirmed',False),
 ('File66 math audit run confirmed',False),
 ('real printer calibration values entered',False),
 ('real hardware envelopes selected',False),
]
print('BUDDY STAGE1 MODELLING RELEASE GATE')
for n,ok in gates:print(('PASS ' if ok else 'PENDING ')+n)
model=[x for x in gates[:15]]
print(f'\nMODEL PACKAGE DEFINITION {sum(v for _,v in model)}/{len(model)}')
print('Remaining local compile/audit checks are required before declaring Stage1 CAD release.')
print('Printer calibration and hardware selection are physical-convergence inputs, not reasons to invent dimensions.')
