/* BUDDY FILE57 - EQUATORIAL SERVICE CHASSIS
Carries four camera pockets, four thin PCB bays and two opposed battery bays.
Hardware envelopes are provisional until selected parts exist. */
include <55_stage1_print_parameters.scad>
$fn=100; SHOW_REFS=true;
R0=37.8; BELT_H=26; BELT_OUT_R=54.0; BELT_T=1.6;
module service_chassis(){difference(){union(){belt();camera_brackets();pcb_brackets();battery_brackets();}airway_keepout();}}
module belt(){difference(){cylinder(h=BELT_H,d=2*BELT_OUT_R,center=true);cylinder(h=BELT_H+1,d=2*(BELT_OUT_R-BELT_T),center=true);for(a=[0:45:315])rotate([0,0,a])translate([BELT_OUT_R,0,0])cube([10,20,18],center=true);}}
module camera_brackets(){for(a=[0:90:270])rotate([0,0,a])difference(){translate([46,0,0])cube([16,17,17],center=true);translate([45.5,0,0])cube([15.2,14.4,14.4],center=true);}}
module pcb_brackets(){for(a=[45,135,225,315])rotate([0,0,a])translate([40.2,0,0])difference(){cube([5.0,15,19],center=true);translate([1,0,0])cube([4,13,17],center=true);}}
module battery_brackets(){for(a=[90,270])rotate([0,0,a])translate([41.2,0,0])difference(){cube([7,19,25],center=true);translate([1,0,0])cube([6,17.5,23.5],center=true);}}
module airway_keepout(){cylinder(h=72,d=B1_AIRWAY_D,center=true);}
if(SHOW_REFS){%sphere(d=B1_CAVITY_D);%cylinder(h=70,d=B1_AIRWAY_D,center=true);}service_chassis();
assert(R0-B1_DUCT_OD/2>=B1_CAMERA_DUCT_GAP);
echo("FILE57 equatorial service chassis");
echo("Hardware pockets provisional; verify selected components before print");
