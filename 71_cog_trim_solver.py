"""BUDDY Stage1 CoG trim solver.
Given measured assembly mass and CoG, computes the ideal correction mass at an available trim radius.
Use measured values only; output is an engineering aid, not automatic approval.
"""
import math

def solve(total_mass_g,cog_mm,trim_radius_mm=48.0):
 x,y,z=cog_mm
 radial=math.hypot(x,y)
 # First-order counterweight relation m*r ~= M*offset. Z trim is reported separately.
 mxy=total_mass_g*radial/trim_radius_mm if trim_radius_mm else math.inf
 az=(math.degrees(math.atan2(y,x))+180)%360 if radial else 0
 mz=total_mass_g*abs(z)/trim_radius_mm if trim_radius_mm else math.inf
 print('BUDDY COG TRIM SOLVER')
 print(f'measured mass={total_mass_g:.2f}g measured CoG=({x:.3f},{y:.3f},{z:.3f})mm')
 print(f'XY correction estimate={mxy:.2f}g at radius {trim_radius_mm:.1f}mm, azimuth {az:.1f}deg')
 print(f'Z correction magnitude estimate={mz:.2f}g at opposite axial extreme if geometry permits')
 print('Prefer relocating existing hardware over adding dead ballast.')
 print('Re-measure after every change; coupled 3-D trim requires the actual available mounting coordinates.')

if __name__=='__main__': solve(190,(0.8,-0.4,-1.2))
