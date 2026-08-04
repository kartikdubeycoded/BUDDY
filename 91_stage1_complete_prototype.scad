/* BUDDY FILE91 - STAGE1 COMPLETE PROTOTYPE INTEGRATION
Top-level mechanical integration scene for Checkpoint One. */
include <55_stage1_print_parameters.scad>
use <56_segmented_crash_cage.scad>
use <57_equatorial_service_chassis.scad>
use <59_vane_cartridge_v2.scad>
use <83_battery_retention_v1.scad>
use <84_electronics_carrier_v1.scad>
use <86_camera_module_v1.scad>
use <87_motor_mount_interface_v1.scad>
use <88_actuator_linkage_v1.scad>
use <89_audio_imu_module.scad>
use <90_vent_reinforcement_v1.scad>
$fn=100;
VIEW=0; //0 complete 1 structure 2 payload 3 control 4 keepouts
module duct(){difference(){cylinder(h=70,d=B1_DUCT_OD,center=true);cylinder(h=71,d=B1_AIRWAY_D,center=true);}}
module structure(){hemisphere(1);hemisphere(-1);equator_clamp();duct();service_chassis();reinforcement_ribs();}
module payload(){battery_pair();electronics_four();camera_four();translate([0,43,0])rotate([90,0,0])speaker_mount();translate([0,0,30])imu_island();}
module control(){for(z=[-12,12])translate([0,0,z])stator_mount();for(i=[0:3])rotate([0,0,90*i])translate([B1_DUCT_OD/2+9,0,0])cartridge();actuator_quadrants();}
if(VIEW==0){structure();payload();control();}
if(VIEW==1)structure();
if(VIEW==2){%sphere(d=B1_CAVITY_D);payload();}
if(VIEW==3){%cylinder(h=70,d=B1_AIRWAY_D,center=true);control();}
if(VIEW==4){%sphere(d=B1_OD);%cylinder(h=72,d=B1_AIRWAY_D,center=true);%vent_cutouts();}
assert(B1_OD==115&&B1_CAVITY_D==111&&B1_AIRWAY_D==70);
echo("FILE91 BUDDY CHECKPOINT ONE COMPLETE PROTOTYPE VIEW=",VIEW);
echo("Hardware-controlled dimensions remain provisional until selected components replace envelopes.");
