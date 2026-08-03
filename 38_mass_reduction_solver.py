"""BUDDY V3 provisional mass-reduction budget.
Numbers are targets, not claims about unselected hardware.
"""
base={'shell':28,'duct':18,'rotors':24,'motors':24,'batteries':56,'electronics':24,'cameras':16,'actuators':12,'misc':8}
target={'shell':22,'duct':15,'rotors':18,'motors':20,'batteries':42,'electronics':18,'cameras':12,'actuators':10,'misc':7}
print('BUDDY V3 MASS REDUCTION SOLVER')
print('subsystem        old_g target_g saving_g')
for k in base:
 print(f'{k:14s}{base[k]:7.1f}{target[k]:9.1f}{base[k]-target[k]:9.1f}')
old=sum(base.values()); new=sum(target.values())
print(f'OLD TOTAL {old:.1f} g')
print(f'V3 TARGET {new:.1f} g')
print(f'REDUCTION {old-new:.1f} g ({100*(old-new)/old:.1f}%)')
print('TARGET PASS <=190g:',new<=190)
print('DESIGN CEILING PASS <=200g:',new<=200)
print('NOTE: target masses become constraints for hardware selection; they are not measured masses.')
