"""BUDDY DIGITAL TWIN V1
Integrated first-order system model: mass, energy, thrust reserve, attitude tilt,
follow acceleration, camera coverage, link/safety state and requirement gates.
This is a screening twin, not CFD/FEA or production flight software.
"""
from dataclasses import dataclass
import math
G=9.80665
@dataclass
class Design:
 mass_g:float=190; max_thrust_N:float=3.8; battery_V:float=7.4; battery_Ah:float=1.0
 usable:float=.8; aux_W:float=8; propulsion_hover_W:float=45
 camera_hfov:float=120; camera_count:int=4; vehicle_d_mm:float=115; airway_d_mm:float=70
@dataclass
class Scenario:
 name:str; tilt_deg:float; thrust_ratio:float; duration_s:float

def run(d=Design()):
 W=d.mass_g/1000*G
 print('BUDDY DIGITAL TWIN V1')
 print(f'mass={d.mass_g}g weight={W:.3f}N thrust/weight max={d.max_thrust_N/W:.2f}')
 cases=[Scenario('hover',0,1,60),Scenario('follow',20,1.25,60),Scenario('45deg recovery',45,1.6,5)]
 for c in cases:
  T=W*c.thrust_ratio; vz=T*math.cos(math.radians(c.tilt_deg)); ax=T*math.sin(math.radians(c.tilt_deg))/(d.mass_g/1000)
  print(f'{c.name:16s} T={T:.2f}N vertical_margin={vz-W:+.2f}N lateral_a={ax:.2f}m/s2 thrust_available={T<=d.max_thrust_N}')
 energy_Wh=d.battery_V*d.battery_Ah*d.usable
 hover_total=d.propulsion_hover_W+d.aux_W
 print(f'usable energy={energy_Wh:.2f}Wh ideal hover endurance={energy_Wh/hover_total*60:.2f}min')
 overlap=d.camera_hfov-360/d.camera_count
 print(f'camera neighbor overlap={overlap:.1f}deg coverage_screen={overlap>=0}')
 gates={
  'mass<=190g':d.mass_g<=190,
  'max T/W>=1.8':d.max_thrust_N/W>=1.8,
  '45deg level requirement':1.6*math.cos(math.radians(45))>=1,
  'camera horizontal coverage':overlap>=0,
  'airway locked 70mm':d.airway_d_mm==70,
  'vehicle locked 115mm':d.vehicle_d_mm==115,
 }
 for k,v in gates.items(): print(('PASS ' if v else 'FAIL ')+k)
 print('Hardware-dependent inputs remain provisional.')
if __name__=='__main__': run()
