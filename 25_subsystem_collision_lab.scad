/* BUDDY FILE 25 - SUBSYSTEM COLLISION ISOLATION LAB
Diagnostic only. Any red geometry in a selected violation view is a failure.
TEST: 0 overview, 1 actuator, 2 electronics, 3 battery, 4 camera,
5 duct, 6 stator, 7 vanes. MODE: 0 outside 115mm, 1 outside 111mm cavity,
2 inside 70mm airway. */
$fn=100;
use <10_aero_duct.scad>
use <12_motor_stator.scad>
use <14_vane_system.scad>
use <15_vane_actuator_ring.scad>
use <17_electronics_spine.scad>
use <19_battery_cradle.scad>
use <20_camera_ring.scad>
VEHICLE_D=115; SHELL_ID=111; AIRWAY_D=70; DUCT_H=70;
TEST=0; MODE=1;
module selected(){
 if(TEST==1) actuator_system();
 else if(TEST==2) electronics_spine();
 else if(TEST==3) battery_system();
 else if(TEST==4) camera_ring();
 else if(TEST==5) aidrone_aero_duct();
 else if(TEST==6) motor_stator_system();
 else if(TEST==7) vane_system();
}
module all(){ actuator_system(); electronics_spine(); battery_system(); camera_ring(); aidrone_aero_duct(); motor_stator_system(); vane_system(); }
module violation(){
 color("red")
 if(MODE==0) difference(){ selected(); sphere(d=VEHICLE_D); }
 else if(MODE==1) difference(){ selected(); sphere(d=SHELL_ID); }
 else if(MODE==2) intersection(){ selected(); cylinder(h=DUCT_H+0.2,d=AIRWAY_D,center=true); }
}
if(TEST==0){ %sphere(d=VEHICLE_D); %sphere(d=SHELL_ID); %cylinder(h=DUCT_H,d=AIRWAY_D,center=true); all(); }
else violation();
assert(TEST>=0&&TEST<=7,"TEST must be 0..7");
assert(MODE>=0&&MODE<=2,"MODE must be 0..2");
echo("FILE25 collision lab TEST=",TEST," MODE=",MODE);
echo("Selected violation views must be EMPTY to pass.");
