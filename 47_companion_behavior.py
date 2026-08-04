"""BUDDY companion behavior arbitration.
Keeps personality subordinate to flight safety and attention limits.
Simulation/reference logic only.
"""
from enum import IntEnum
class Priority(IntEnum):
    CHAT=10; ATTENTION=20; FOLLOW=30; BRAKE=70; AVOID=80; LAND=90; EMERGENCY=100

def arbitrate(events):
    if not events: return ('HOVER',0)
    return max(events,key=lambda e:e[1])

def demo():
    cases=[
      [('SPEAK',Priority.CHAT),('FOLLOW',Priority.FOLLOW)],
      [('LOOK_AT_USER',Priority.ATTENTION),('AVOID',Priority.AVOID)],
      [('FOLLOW',Priority.FOLLOW),('BRAKE',Priority.BRAKE)],
      [('SPEAK',Priority.CHAT),('LAND',Priority.LAND)],
    ]
    expected=['FOLLOW','AVOID','BRAKE','LAND']
    print('BUDDY COMPANION BEHAVIOR ARBITRATION')
    for c,want in zip(cases,expected):
        got=arbitrate(c)[0]; print(c,'=>',got,'PASS' if got==want else 'FAIL'); assert got==want
    print('Rule: personality can influence speech/attention/high-level intent; it cannot override flight safety.')
if __name__=='__main__': demo()
