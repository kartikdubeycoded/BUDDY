"""BUDDY safety-supervisor reference model.
State-machine logic for simulation and requirements verification only.
Not production flight-control software.
"""
from dataclasses import dataclass
from enum import Enum, auto

class Mode(Enum):
    DISARMED=auto(); ARMING=auto(); HOVER=auto(); FOLLOW=auto(); AVOID=auto(); BRAKE=auto(); LAND=auto()

@dataclass
class Inputs:
    armed: bool=False
    sensors_ok: bool=True
    battery_ok: bool=True
    phone_link_ok: bool=True
    tracking_confidence: float=1.0
    obstacle_distance_m: float=10.0
    command_age_s: float=0.0
    follow_requested: bool=False
    land_requested: bool=False
    excessive_attitude: bool=False
    actuator_saturated: bool=False

class Supervisor:
    def __init__(self): self.mode=Mode.DISARMED
    def update(self,x:Inputs):
        if not x.armed: self.mode=Mode.DISARMED; return self.mode
        if x.land_requested or not x.battery_ok or not x.sensors_ok or x.excessive_attitude:
            self.mode=Mode.LAND; return self.mode
        if x.obstacle_distance_m < 0.45:
            self.mode=Mode.AVOID; return self.mode
        if x.actuator_saturated or x.tracking_confidence < .55:
            self.mode=Mode.BRAKE; return self.mode
        if not x.phone_link_ok or x.command_age_s > .5:
            self.mode=Mode.HOVER; return self.mode
        if x.follow_requested:
            self.mode=Mode.FOLLOW; return self.mode
        self.mode=Mode.HOVER; return self.mode

def self_test():
    s=Supervisor()
    tests=[
      (Inputs(armed=False),Mode.DISARMED),
      (Inputs(armed=True),Mode.HOVER),
      (Inputs(armed=True,follow_requested=True),Mode.FOLLOW),
      (Inputs(armed=True,follow_requested=True,obstacle_distance_m=.3),Mode.AVOID),
      (Inputs(armed=True,follow_requested=True,tracking_confidence=.3),Mode.BRAKE),
      (Inputs(armed=True,follow_requested=True,phone_link_ok=False),Mode.HOVER),
      (Inputs(armed=True,follow_requested=True,battery_ok=False),Mode.LAND),
    ]
    for i,(inp,want) in enumerate(tests):
        got=s.update(inp); print(i,got.name,'PASS' if got==want else 'FAIL')
        assert got==want
    print('Safety supervisor reference tests PASS')
    print('Thresholds are provisional and require system-level testing.')
if __name__=='__main__': self_test()
