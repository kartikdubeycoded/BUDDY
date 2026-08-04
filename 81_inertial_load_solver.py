"""BUDDY Stage1 inertial load screening.
Produces first-order retention loads from mass and acceleration factors.
Not structural certification; selected materials/geometry require analysis/tests.
"""
G=9.80665
items={'battery_pair_g':42,'electronics_g':18,'camera_system_g':12,'motor_rotor_pair_g':38}
load_cases={'normal_maneuver_g':2.0,'hard_recovery_g':4.0,'prototype_retention_screen_g':8.0}
print('BUDDY INERTIAL LOAD SCREEN')
for case,n in load_cases.items():
 print('\n'+case, n,'g')
 total=0
 for name,m_g in items.items():
  F=m_g/1000*G*n;total+=F
  print(f' {name:24s}{F:6.2f} N')
 print(f' represented subsystem load {total:.2f} N')
print('\nThese loads size retention concepts only. Impact/shock spectra, material allowables, stress concentrations, print anisotropy and fatigue are not represented.')
