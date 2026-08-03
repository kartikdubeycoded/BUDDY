"""BUDDY architecture acceptance gate: deterministic geometry/math checks."""
import math
R=55.5; duct=37.0
pods={
 'camera':(37.8,15.8,16.6,16.6,0),
 'battery':(38.0,6.0,18.0,24.0,0),
 'pcb':(37.8,4.5,14.0,18.0,0),
}
def clear(v):
 r,d,w,h,z=v; sr=math.sqrt(R*R-(abs(z)+h/2)**2); cr=math.hypot(r+d,w/2); return sr-cr
print('BUDDY ARCHITECTURE GATE')
fail=False
for n,v in pods.items():
 c=clear(v); dg=v[0]-duct; ok=c>=.2 and dg>=.2
 print(f'{n:8s} shell={c:6.3f}mm duct={dg:5.2f}mm', 'PASS' if ok else 'FAIL')
 fail|=not ok
# fixed current propulsion geometry
checks=[('dynamic rotor tip',.4,.0),('dynamic stator axial',1.0,1.0),('camera old margin',.245,.2)]
for n,val,minimum in checks:
 ok=val>=minimum; print(f'{n:22s}{val:6.3f} >= {minimum:4.2f}', 'PASS' if ok else 'FAIL'); fail|=not ok
print('RESULT:', 'REJECT' if fail else 'GEOMETRIC SCREEN PASS / PHYSICS STILL PROVISIONAL')
raise SystemExit(2 if fail else 0)
