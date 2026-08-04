/* BUDDY FILE88 - VANE ACTUATOR/LINKAGE V1
Kinematic packaging model. Torque/backlash remain hardware/test controlled. */
include <55_stage1_print_parameters.scad>
$fn=64;
SERVO=[12,8,18]; ARM_R=6; LINK_LEN=13; SHAFT_D=2; R=45;
module actuator(){cube(SERVO,center=true);translate([0,0,SERVO[2]/2])cylinder(h=2,d=5,center=true);}
module linkage(){
 cylinder(h=2,d=2*ARM_R,center=true);
 translate([LINK_LEN/2,0,0])cube([LINK_LEN,2,2],center=true);
 translate([LINK_LEN,0,0])cylinder(h=5,d=SHAFT_D,center=true);
}
module actuator_quadrants(){for(a=[0:90:270])rotate([0,0,a]){translate([R,0,-24])actuator();translate([R,0,-14])linkage();}}
actuator_quadrants();
echo("FILE88 actuator/linkage packaging; validate full swept motion, torque, backlash and current with selected hardware");
