"""BUDDY hardware interface contract.
Fill only from manufacturer data or measured hardware. No guessed dimensions.
"""
HARDWARE={
 'motor_A': {'selected':False,'mass_g':None,'diameter_mm':None,'length_mm':None,'max_current_A':None,'thrust_curve':None},
 'motor_B': {'selected':False,'mass_g':None,'diameter_mm':None,'length_mm':None,'max_current_A':None,'thrust_curve':None},
 'rotor_A': {'selected':False,'diameter_mm':None,'mass_g':None,'max_rpm':None},
 'rotor_B': {'selected':False,'diameter_mm':None,'mass_g':None,'max_rpm':None},
 'esc': {'selected':False,'mass_g':None,'continuous_A':None,'burst_A':None,'dimensions_mm':None},
 'battery': {'selected':False,'cells':None,'capacity_Ah':None,'mass_g':None,'dimensions_mm':None,'continuous_A':None},
 'actuator': {'selected':False,'mass_g':None,'dimensions_mm':None,'stall_torque_kgcm':None,'speed_s_per_60deg':None,'stall_current_A':None},
 'camera': {'selected':False,'mass_g':None,'dimensions_mm':(14,14,15),'power_W':None},
 'flight_controller': {'selected':False,'mass_g':None,'dimensions_mm':None,'power_W':None},
 'speaker': {'selected':False,'mass_g':None,'dimensions_mm':None,'power_W':None},
}

def validate():
 print('BUDDY HARDWARE CONTRACT')
 for name,d in HARDWARE.items():
  print(f'{name:18s}', 'SELECTED' if d['selected'] else 'UNSELECTED')
 if not all(d['selected'] for d in HARDWARE.values()):
  print('RESULT: geometry may remain conceptual; production mounts are forbidden.')
if __name__=='__main__': validate()
