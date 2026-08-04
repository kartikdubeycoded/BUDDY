"""BUDDY system fault-injection campaign against the reference safety supervisor.
Requirements-level testing only.
"""
from dataclasses import dataclass
from enum import Enum
class Mode(Enum): HOVER='HOVER'; FOLLOW='FOLLOW'; AVOID='AVOID'; BRAKE='BRAKE'; LAND='LAND'
@dataclass
class S:
 battery:bool=True; sensors:bool=True; link:bool=True; track:float=1; obstacle:float=10; attitude:bool=False; saturation:bool=False; age:float=0; follow:bool=True

def supervisor(x):
 if not x.battery or not x.sensors or x.attitude:return Mode.LAND
 if x.obstacle<.45:return Mode.AVOID
 if x.saturation or x.track<.55:return Mode.BRAKE
 if not x.link or x.age>.5:return Mode.HOVER
 return Mode.FOLLOW if x.follow else Mode.HOVER

def run():
 tests=[('nominal',S(),Mode.FOLLOW),('battery fault',S(battery=False),Mode.LAND),('sensor fault',S(sensors=False),Mode.LAND),('link loss',S(link=False),Mode.HOVER),('stale command',S(age=.8),Mode.HOVER),('tracking collapse',S(track=.2),Mode.BRAKE),('obstacle',S(obstacle=.25),Mode.AVOID),('actuator saturation',S(saturation=True),Mode.BRAKE),('excess attitude',S(attitude=True),Mode.LAND),('obstacle + chatter',S(obstacle=.2,track=1),Mode.AVOID)]
 print('BUDDY FAULT INJECTION CAMPAIGN')
 for name,state,want in tests:
  got=supervisor(state); ok=got==want; print(f'{name:22s}{got.value:8s}', 'PASS' if ok else 'FAIL'); assert ok
 print(f'{len(tests)}/{len(tests)} reference fault scenarios PASS')
 print('Thresholds and recovery actions require SIL/HIL/physical validation.')
if __name__=='__main__':run()
