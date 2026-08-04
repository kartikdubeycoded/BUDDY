"""BUDDY V3 MASTER ENGINEERING DASHBOARD
Single console snapshot of current targets and blockers.
"""
TARGETS={'OD_mm':115,'shell_ID_mm':111,'airway_mm':70,'mass_target_g':190,'bom_target_g':166,'camera_shell_margin_mm':1.0,'camera_duct_gap_mm':.8,'xy_cog_mm':1.0,'z_cog_mm':1.0}
verified=['115 mm architecture','111 mm cavity architecture','70 mm airway architecture','V2 assembly clean preview','positive analytical packaging clearances','safety hierarchy defined','phone/raw-motor authority separation defined']
blockers=['real motor+rotor thrust/current curves','real coaxial/duct interaction','battery sag/current/thermal data','actuator torque-speed-current data','measured mass and XYZ CoG','V3 camera local CAD compile/clearance','moving collision regression','vane authority bench data','rotor containment evidence','stable independent hover','obstacle/perception validation','human-follow validation']
print('='*76);print('BUDDY V3 MASTER ENGINEERING DASHBOARD');print('='*76)
print('TARGETS');
for k,v in TARGETS.items():print(f' {k:28s}{v}')
print('\nSUPPORTED ARCHITECTURE')
for x in verified:print(' PASS ',x)
print('\nOPEN BLOCKERS')
for i,x in enumerate(blockers,1):print(f' {i:02d}. {x}')
print('\nPROGRAM PHASE: V3 CONVERGENCE -> HARDWARE SELECTION -> BENCH ARTICLE')
print('NEXT HARD GATE: selected propulsion/battery/actuator hardware must satisfy geometry, mass, power and control constraints simultaneously.')
