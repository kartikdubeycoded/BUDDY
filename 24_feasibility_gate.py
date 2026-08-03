"""BUDDY integrated first-order feasibility gate.
Analytical screening only; not CFD, FEA, flight certification, or hardware validation.
Run: python 24_feasibility_gate.py
"""
import math

G=9.80665
RHO=1.225
DUCT_D=0.070
DUCT_A=math.pi*(DUCT_D/2)**2
ROTOR_D_MM=68.0
DYNAMIC_ROTOR_D_MM=69.2
DUCT_D_MM=70.0
DESIGN_MASS_G=200.0
TARGET_MASS_G=180.0
HARD_MASS_G=225.0
AUX_W=8.0
BATTERY_V=7.4
BATTERY_AH=1.0
USABLE=0.80
VANE_COUNT=4
VANE_SPAN=0.025
VANE_CHORD=0.015
VANE_AREA=VANE_SPAN*VANE_CHORD
VANE_ANGLE=25.0
VANE_ARM=0.028
WAKE_FACTOR=0.75
HINGE_ARM=0.004
VANE_HORN=0.005
ACT_HORN=0.004
LINK_EFF=0.75
TORQUE_SF=2.5
TARGET_TRANSITION_S=0.10
VEHICLE_R=0.0575

# Current CAD-derived values from Files 12, 13, 20.
STATOR_BLOCKAGE=0.1736
DYNAMIC_TIP_CLEARANCE_MM=(DUCT_D_MM-DYNAMIC_ROTOR_D_MM)/2
DYNAMIC_STATOR_CLEARANCE_MM=1.0
CAMERA_SHELL_CLEARANCE_MM=0.245
CAMERA_DUCT_CLEARANCE_MM=0.8

VERIFIED=[]; PROVISIONAL=[]; FAIL=[]
def gate(ok,msg,kind="verified"):
    (VERIFIED if kind=="verified" else PROVISIONAL if kind=="provisional" else FAIL).append(msg) if ok else FAIL.append(msg)

def weight(mg): return mg/1000*G
def vi(t): return math.sqrt(t/(2*RHO*DUCT_A))
def ideal_power(t): return t*vi(t)
def wake(t): return 2*vi(t)*WAKE_FACTOR
def q(t): return .5*RHO*wake(t)**2
def cn(a): return math.sin(math.radians(2*a))
def vane_force(t,a): return q(t)*VANE_AREA*cn(a)
def pair_torque(t,a): return 2*vane_force(t,a)*VANE_ARM
def inertia_sphere(mg): return .4*(mg/1000)*VEHICLE_R**2
def rotation_time(t,a,target=10):
    alpha=pair_torque(t,a)/inertia_sphere(DESIGN_MASS_G)
    return math.sqrt(2*math.radians(target)/alpha)
def actuator_torque(t,a):
    hm=vane_force(t,a)*HINGE_ARM
    linkage=hm/VANE_HORN
    raw=linkage*ACT_HORN/LINK_EFF
    return raw*TORQUE_SF
def kgcm(nm): return nm*10.19716213
def projected_vane_blockage(a): return VANE_COUNT*VANE_AREA*abs(math.sin(math.radians(a)))/DUCT_A

def power_case(mg,ratio,eta):
    t=weight(mg)*ratio
    prop=ideal_power(t)/eta
    total=prop+AUX_W
    current=total/BATTERY_V
    endurance=BATTERY_V*BATTERY_AH*USABLE/total*60
    return t,prop,total,current,endurance

def report():
    print("="*72); print("BUDDY INTEGRATED FEASIBILITY GATE"); print("="*72)
    gate(DYNAMIC_TIP_CLEARANCE_MM>0,"Dynamic rotor remains inside 70 mm duct")
    gate(DYNAMIC_STATOR_CLEARANCE_MM>=1.0,"Dynamic rotor/stator clearance >= 1.0 mm")
    gate(STATOR_BLOCKAGE<0.20,"Stator frontal blockage < 20%")
    gate(CAMERA_SHELL_CLEARANCE_MM>=0.2,"Camera housing has >=0.2 mm mathematical shell clearance")
    gate(CAMERA_DUCT_CLEARANCE_MM>=0.2,"Camera housing clears duct OD")

    hover=weight(DESIGN_MASS_G); control=1.5*hover; maximum=2*hover
    projected=projected_vane_blockage(VANE_ANGLE)
    ctrl_t=pair_torque(control,VANE_ANGLE)
    ctrl_time=rotation_time(control,VANE_ANGLE)
    req_act=actuator_torque(maximum,VANE_ANGLE)
    gate(projected<0.20,f"25 deg projected vane blockage = {projected*100:.1f}%", "provisional")
    gate(ctrl_t>0,f"Predicted 25 deg control torque at 1.5x thrust = {ctrl_t:.5f} N m", "provisional")
    gate(ctrl_time<0.25,f"Idealized 10 deg response estimate = {ctrl_time:.3f} s", "provisional")
    gate(req_act>0,f"Predicted actuator minimum with 2.5x SF = {kgcm(req_act):.3f} kg cm", "provisional")

    print(f"Design mass assumption          : {DESIGN_MASS_G:.0f} g")
    print(f"Hover thrust                    : {hover:.3f} N")
    print(f"1.5x control thrust             : {control:.3f} N")
    print(f"2.0x maximum thrust             : {maximum:.3f} N")
    print(f"Disk area                       : {DUCT_A:.6f} m^2")
    print(f"Dynamic rotor tip clearance     : {DYNAMIC_TIP_CLEARANCE_MM:.3f} mm")
    print(f"Stator blockage                 : {STATOR_BLOCKAGE*100:.2f}%")
    print(f"Camera-shell clearance          : {CAMERA_SHELL_CLEARANCE_MM:.3f} mm")
    print(f"25 deg vane projected blockage  : {projected*100:.2f}%")
    print(f"Control torque estimate         : {ctrl_t:.6f} N m")
    print(f"10 deg idealized response       : {ctrl_time:.3f} s")
    print(f"Actuator torque screening value : {kgcm(req_act):.3f} kg cm")

    print("\nPOWER SENSITIVITY (200 g, includes 8 W auxiliary placeholder)")
    print(" eta   case       thrustN   totalW   currentA  endurance_min")
    for eta in (.35,.45,.55,.65):
        for name,ratio in (("hover",1.0),("control",1.5),("max",2.0)):
            t,p,total,current,end=power_case(DESIGN_MASS_G,ratio,eta)
            print(f" {eta:.2f}  {name:7s}   {t:7.3f}   {total:7.1f}   {current:8.2f}   {end:8.2f}")

    print("\nVERIFIED GEOMETRY/MATH")
    for x in VERIFIED: print(" PASS:",x)
    print("\nPROVISIONAL PHYSICS")
    for x in PROVISIONAL: print(" STUDY:",x)
    print("\nHARD BLOCKERS BEFORE FLIGHT CLAIM")
    blockers=[
      "Measured all-up mass and full inertia tensor are absent.",
      "Motor, ESC and both counter-rotating rotors are not selected from measured thrust data.",
      "Coaxial/duct interaction is not represented by simple actuator-disk momentum theory.",
      "Vane wake factor and hinge moment are not validated by CFD or bench data.",
      "Actuator torque-speed-current/backlash data are not selected/validated.",
      "Battery voltage sag, C-rating, wiring and regulator thermal limits are unverified.",
      "Crash shell strength and rotor containment require FEA/physical testing.",
      "Camera-shell 0.245 mm margin is mathematically passing but too tight to call production-safe without printer calibration."
    ]
    for x in blockers: print(" BLOCK:",x)
    if FAIL:
        print("\nFAILED GATES")
        for x in FAIL: print(" FAIL:",x)
        raise SystemExit(2)
    print("\nRESULT: CAD feasibility gates pass; flight feasibility remains PROVISIONAL.")

if __name__=="__main__": report()
