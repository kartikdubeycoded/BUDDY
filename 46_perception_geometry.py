"""BUDDY four-camera perception geometry screening.
Computes horizontal coverage/overlap for four equatorial camera stations.
Optical values remain provisional until the actual camera/lens is measured.
"""
import math
CAMERA_AZ=(0,90,180,270)
HFOV_DEG=120.0   # provisional
VFOV_DEG=90.0    # provisional
MIN_OVERLAP_DEG=15.0

def angular_delta(a,b): return abs((a-b+180)%360-180)
def sees(cam_az,target_az,hfov=HFOV_DEG): return angular_delta(cam_az,target_az)<=hfov/2

def coverage(step=.25):
    samples=int(360/step)
    uncovered=[]; multiplicity=[]
    for i in range(samples):
        az=i*step
        n=sum(sees(c,az) for c in CAMERA_AZ)
        multiplicity.append(n)
        if n==0: uncovered.append(az)
    return uncovered,multiplicity

print('BUDDY PERCEPTION GEOMETRY SCREEN')
uncovered,m=coverage()
neighbor_overlap=HFOV_DEG-90
print('camera azimuths =',CAMERA_AZ)
print('provisional HFOV/VFOV =',HFOV_DEG,VFOV_DEG,'deg')
print('neighbor overlap =',neighbor_overlap,'deg')
print('360 horizontal coverage =',not uncovered)
print('minimum simultaneous camera count =',min(m))
print('maximum simultaneous camera count =',max(m))
print('overlap target pass =',neighbor_overlap>=MIN_OVERLAP_DEG)
print('BLOCKER: vertical blind cones, shell occlusion, lens distortion, synchronization and real calibrated FOV require selected hardware.')
