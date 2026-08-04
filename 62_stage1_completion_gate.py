"""BUDDY Stage-1 modelling completion gate.
A 'pass' means model architecture is ready for local CAD/manufacturing validation,
not that the aircraft is safe to fly.
"""
items=[
('product requirements locked',True),('115/111/70 architecture locked',True),('segmented printable cage model',True),('equatorial service chassis model',True),('replaceable propulsion cartridge model',True),('replaceable vane cartridge model',True),('V3 camera housing model',True),('FDM calibration coupon',True),('mass budget and growth reserve',True),('energy/thrust screening',True),('follow dynamics model',True),('safety supervisor + fault injection',True),('phone/aircraft protocol',True),('perception coverage screen',True),('manufacturing/test documentation',True),
('all Stage1 SCAD files locally F5 clean',False),('all moving collision tests locally pass',False),('V3 camera >=1mm margin locally confirmed',False),('real hardware dimensions frozen',False),('measured BOM <=190g',False),('measured propulsion data supports T/W gate',False)]
print('BUDDY STAGE1 MODELLING COMPLETION GATE')
for n,v in items:print(('PASS ' if v else 'OPEN ')+n)
model=sum(v for _,v in items[:15]);print(f'\nARCHITECTURE/MODEL PACKAGE: {model}/15 defined')
print('LOCAL/HARDWARE CLOSURE:',sum(v for _,v in items[15:]),'/',len(items)-15)
print('NEXT: finish deterministic local CAD closure, then freeze actual hardware interfaces. No free-flight claim follows from this gate.')
