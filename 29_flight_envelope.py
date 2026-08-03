"""BUDDY first-order flight-envelope screening. Not a flight controller or certification model."""
import math
G=9.80665; MASS=.200
cases=[('hover',0,1.0),('translation 20deg',20,1.25),('aggressive 45deg',45,1.60),('recovery reserve',30,2.0)]
print('BUDDY FLIGHT ENVELOPE SCREEN')
for name,tilt,tr in cases:
 T=MASS*G*tr; vertical=T*math.cos(math.radians(tilt)); horizontal=T*math.sin(math.radians(tilt));
 margin=vertical-MASS*G; accel=horizontal/MASS
 print(f'{name:20s} tilt={tilt:2d} thrust={T:5.2f}N vertical_margin={margin:6.2f}N lateral_a={accel:5.2f}m/s2')
 if margin<0: print('  FAIL: insufficient vertical component at assumed thrust ratio')
print('At 45deg, level-altitude thrust ratio must be >=',1/math.cos(math.radians(45)))
print('BLOCKERS: aerodynamic drag, coaxial interaction, attitude inertia, controller latency and real thrust curves are unverified.')
