"""BUDDY Stage1 printed-mass sensitivity estimator.
Uses user-supplied slicer volumes for real estimates; defaults are deliberately None.
"""
DENSITY={'PLA':1.24,'PETG':1.27,'ABS':1.04,'PA12':1.01} # g/cm3 nominal screening values
parts={'cage_upper':None,'cage_lower':None,'equator_clamp':None,'service_chassis':None,'duct':None,'stator_carriers':None,'vane_cartridges':None,'camera_housings':None,'battery_carriers':None,'electronics_carriers':None}

def estimate(material='PLA',effective_solid_fraction=.35):
 rho=DENSITY[material]; known={k:v for k,v in parts.items() if v is not None}
 print('BUDDY PRINTED MASS ESTIMATOR')
 if not known:
  print('No slicer volumes entered. Export/slice each printable part and enter material volume in cm^3.')
  print('Formula: mass = slicer material volume * density. Do not multiply by infill twice if slicer already reports used material.')
  return
 total=sum(v*rho for v in known.values())
 for k,v in known.items():print(f'{k:22s}{v:7.2f} cm3 -> {v*rho:6.2f} g')
 print('printed subtotal =',round(total,2),'g')
if __name__=='__main__':estimate()
