"""BUDDY electrical power/endurance sensitivity study; provisional hardware."""
V=7.4; AH=1.0; USABLE=.80
loads={'phone_link/compute':2.0,'4 cameras':2.0,'speaker/audio':1.5,'FC+sensors':1.0,'actuators avg':1.5}
aux=sum(loads.values())
prop_cases={'hover':45,'control':75,'peak':110}
print('BUDDY ENERGY BUDGET'); print('Battery provisional:',V,'V',AH,'Ah usable',USABLE*100,'%')
for k,w in loads.items(): print(f'{k:20s}{w:6.1f} W')
print('AUX TOTAL',aux,'W')
for name,p in prop_cases.items():
 total=p+aux; amps=total/V; mins=V*AH*USABLE/total*60
 print(f'{name:8s}: total={total:6.1f}W current={amps:5.1f}A ideal_endurance={mins:4.1f}min')
print('BLOCKERS: propulsion watts, battery sag/C-rating, regulator efficiency and thermal data require selected hardware/bench data.')
