"""BUDDY bounded follow-motion model.
Demonstrates the intended companion behavior: high-level target motion is filtered
through speed, acceleration and jerk limits before reaching the flight controller.
This is a design/simulation utility, not production flight-control software.
"""
from dataclasses import dataclass
import math

@dataclass
class Limits:
    speed: float = 1.5       # m/s provisional indoor follow ceiling
    accel: float = 2.0       # m/s^2
    jerk: float = 6.0        # m/s^3

@dataclass
class State:
    x: float = 0.0
    v: float = 0.0
    a: float = 0.0

def clamp(x, lo, hi): return max(lo, min(hi, x))

def step(s: State, target_x: float, dt: float, lim=Limits()):
    # Critically simple outer-loop screening model. Production control requires
    # full 3-D state estimation and tested controller design.
    position_error = target_x - s.x
    desired_v = clamp(1.6 * position_error, -lim.speed, lim.speed)
    desired_a = clamp(2.5 * (desired_v - s.v), -lim.accel, lim.accel)
    da = clamp(desired_a - s.a, -lim.jerk * dt, lim.jerk * dt)
    a = clamp(s.a + da, -lim.accel, lim.accel)
    v = clamp(s.v + a * dt, -lim.speed, lim.speed)
    x = s.x + v * dt
    return State(x, v, a)

def simulate():
    dt=.02; s=State(); history=[]
    # Human target abruptly changes at t=1 s; BUDDY must not instantaneously copy it.
    for k in range(250):
        t=k*dt
        target=0.0 if t<1.0 else 2.0
        s=step(s,target,dt)
        history.append((t,target,s.x,s.v,s.a))
    max_v=max(abs(r[3]) for r in history); max_a=max(abs(r[4]) for r in history)
    max_j=max(abs((history[i][4]-history[i-1][4])/dt) for i in range(1,len(history)))
    print('BUDDY FOLLOW DYNAMICS SCREEN')
    print(f'max speed = {max_v:.3f} m/s <= 1.500')
    print(f'max accel = {max_a:.3f} m/s^2 <= 2.000')
    print(f'max jerk  = {max_j:.3f} m/s^3 <= 6.000')
    print('PASS bounded response =',max_v<=1.500001 and max_a<=2.000001 and max_j<=6.000001)
    print('NOTE: 1-D behavioral model only; not a validated flight controller.')

if __name__=='__main__': simulate()
