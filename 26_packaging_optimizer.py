"""BUDDY spherical packaging optimizer. First-order axis-aligned envelope search."""
import math
R_SHELL=55.5; R_VEH=57.5; R_DUCT=37.0; R_AIR=35.0
MIN_SHELL=0.50; MIN_DUCT=0.40
# name, radial depth, tangential width, axial height, preferred z
parts=[
 ('camera',16.8,17.0,17.0,0.0),
 ('electronics',6.1,22.2,22.2,0.0),
 ('actuator',5.0,8.0,10.0,-27.0),
 ('battery',8.0,24.0,30.0,0.0),
]
def shell_radius(z): return math.sqrt(max(0,R_SHELL**2-z**2))
def max_corner_radius(inner,depth,width): return math.hypot(inner+depth,width/2)
def clearance(inner,depth,width,height,z):
    zext=abs(z)+height/2
    return shell_radius(zext)-max_corner_radius(inner,depth,width)
def search(name,depth,width,height,zpref):
    best=None
    for zi in range(-350,351):
        z=zi/10
        if abs(z)+height/2>=R_SHELL: continue
        for ii in range(int((R_DUCT+MIN_DUCT)*10),500):
            inner=ii/10
            c=clearance(inner,depth,width,height,z)
            if c<MIN_SHELL: continue
            score=abs(z-zpref)*2+(inner-(R_DUCT+MIN_DUCT))
            cand=(score,c,inner,z,max_corner_radius(inner,depth,width))
            if best is None or cand<best: best=cand
    return best
print('BUDDY PACKAGING OPTIMIZER')
print('shell R',R_SHELL,'duct R',R_DUCT,'required shell clearance',MIN_SHELL)
for p in parts:
    b=search(*p)
    if not b: print(p[0], 'NO FEASIBLE AXIS-ALIGNED PLACEMENT')
    else:
        score,c,inner,z,rmax=b
        print(f'{p[0]:12s} innerR={inner:5.1f} z={z:5.1f} shell_clear={c:5.2f} cornerR={rmax:5.2f}')
print('\nNOTE: optimizer is a bounding-box screen, not collision CAD/CFD/FEA.')
