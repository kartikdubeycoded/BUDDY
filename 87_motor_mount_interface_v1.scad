/* BUDDY FILE87 - MOTOR/STATOR MOUNT INTERFACE V1
Hardware-controlled dimensions are explicit variables, never hidden guesses. */
include <55_stage1_print_parameters.scad>
$fn=72;
MOTOR_D=20; MOTOR_LEN=10; BOLT_CIRCLE=12; BOLT_D=2.2; HUB_D=7; PLATE_T=2.2;
module motor_plate(){
 difference(){
  cylinder(h=PLATE_T,d=30,center=true);
  cylinder(h=PLATE_T+1,d=HUB_D,center=true);
  for(a=[0:90:270])rotate([0,0,a])translate([BOLT_CIRCLE/2,0,0])cylinder(h=PLATE_T+1,d=BOLT_D,center=true);
 }
}
module stator_mount(){
 motor_plate();
 for(a=[0:90:270])rotate([0,0,a])translate([B1_DUCT_OD/4+7,0,0])cube([B1_DUCT_OD/2-14,2.2,PLATE_T],center=true);
}
stator_mount();
echo("FILE87 motor mount variables MUST be replaced by selected motor drawing",MOTOR_D,MOTOR_LEN,BOLT_CIRCLE,BOLT_D);
