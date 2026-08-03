"""BUDDY mass/CoG budget. Replace provisional masses with measured values."""
from dataclasses import dataclass
@dataclass
class Item: name:str; m:float; x:float; y:float; z:float; status:str='PROVISIONAL'
items=[
 Item('shell',28,0,0,0), Item('duct',18,0,0,0),
 Item('rotor_A',12,0,0,12), Item('rotor_B',12,0,0,-12),
 Item('motor_A',12,0,0,6), Item('motor_B',12,0,0,-6),
 Item('battery_E',28,45,0,0), Item('battery_W',28,-45,0,0),
 Item('electronics_pair_X',12,0,0,0), Item('electronics_pair_Y',12,0,0,0),
 Item('cameras',16,0,0,0), Item('actuators',12,0,0,-27),
 Item('speaker_wiring_fasteners',8,0,0,0)
]
M=sum(i.m for i in items); mx=sum(i.m*i.x for i in items); my=sum(i.m*i.y for i in items); mz=sum(i.m*i.z for i in items)
cog=(mx/M,my/M,mz/M)
print('BUDDY MASS / COG GATE')
for i in items: print(f'{i.name:24s} {i.m:6.1f} g  ({i.x:5.1f},{i.y:5.1f},{i.z:5.1f}) {i.status}')
print(f'TOTAL = {M:.1f} g')
print('COG mm = (%.3f, %.3f, %.3f)'%cog)
print('XY PASS =', (cog[0]**2+cog[1]**2)**0.5<=1.0)
print('Z PASS provisional =', abs(cog[2])<=2.0)
print('MASS TARGET 180g =',M<=180,' DESIGN CEILING 200g =',M<=200,' HARD CEILING 225g =',M<=225)
print('BLOCKER: all masses above are placeholders until weighed/selected.')
