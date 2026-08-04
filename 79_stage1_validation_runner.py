"""BUDDY Stage1 local validation runner.
Runs deterministic Python checks available in the repository. OpenSCAD visual checks remain manual unless an openscad executable is available on PATH.
"""
import subprocess,sys,shutil
PY=['42_follow_dynamics.py','43_safety_supervisor.py','46_perception_geometry.py','47_companion_behavior.py','50_fault_injection.py','66_stage1_math_audit.py','69_stage1_release_gate.py']
print('BUDDY STAGE1 VALIDATION RUNNER')
fail=[]
for f in PY:
 r=subprocess.run([sys.executable,f],capture_output=True,text=True)
 print('\n---',f,'---');print(r.stdout.strip())
 if r.returncode: print(r.stderr.strip());fail.append(f)
openscad=shutil.which('openscad')
if openscad:
 for f in ['61_print_calibration_coupon.scad','63_fastener_interface_system.scad','65_stage1_print_layout.scad','75_stage1_master.scad','76_stage1_collision_regression.scad']:
  r=subprocess.run([openscad,'-o','NUL',f],capture_output=True,text=True)
  print('\nSCAD',f,'return',r.returncode)
  if r.returncode: print(r.stderr);fail.append(f)
else:
 print('\nOpenSCAD CLI not found on PATH: perform F5 checks manually in GUI.')
print('\nRESULT:', 'FAIL '+str(fail) if fail else 'AUTOMATED CHECKS PASS; MANUAL SCAD COLLISION VIEWS STILL REQUIRED')
raise SystemExit(1 if fail else 0)
