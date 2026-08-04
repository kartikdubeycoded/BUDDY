/* BUDDY FILE89 - AUDIO + IMU PACKAGING
Separates noisy audio/mechanical structure from central sensor mounting concept. */
include <55_stage1_print_parameters.scad>
$fn=64;
SPEAKER_D=20; SPEAKER_T=5; IMU=[18,18,4];
module speaker_mount(){
 difference(){cylinder(h=SPEAKER_T+2,d=SPEAKER_D+2.4,center=true);cylinder(h=SPEAKER_T+.6,d=SPEAKER_D+.5,center=true);}
 for(a=[0:60:300])rotate([0,0,a])translate([SPEAKER_D/4,0,0])cylinder(h=SPEAKER_T+3,d=2,center=true);
}
module imu_island(){
 cube([IMU[0]+2,IMU[1]+2,1.5],center=true);
 for(x=[-1,1],y=[-1,1])translate([x*8,y*8,-2])cylinder(h=4,d=2.5,center=true); // damping interface placeholders
 %translate([0,0,3])cube(IMU,center=true);
}
translate([0,43,0])rotate([90,0,0])speaker_mount();
translate([0,0,30])imu_island();
echo("FILE89 audio/IMU packaging; damping stiffness, speaker acoustics and sensor location require measured hardware validation");
