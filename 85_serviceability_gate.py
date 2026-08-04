"""BUDDY Stage1 serviceability gate.
Design requirements for a prototype that can actually be assembled and repaired.
"""
checks=[
('cage split without removing propulsion core',True),
('equatorial chassis independently accessible',True),
('vane cartridges individually replaceable',True),
('motor/stator carriers conceptually removable',True),
('battery carriers opposed and removable',True),
('electronics carriers modular',True),
('wiring corridors reserved',True),
('fastener/alignment primitives defined',True),
('real connector access verified with selected hardware',False),
('real tool access verified on printed article',False),
('real battery removal path verified',False),
('real camera focus/lens access verified',False),
]
print('BUDDY SERVICEABILITY GATE')
for n,v in checks:print(('PASS ' if v else 'PENDING ')+n)
print(f'ARCHITECTURAL SERVICEABILITY {sum(v for _,v in checks[:8])}/8')
print('Physical access items remain pending until actual hardware envelopes are selected.')
