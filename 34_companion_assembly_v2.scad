/* BUDDY FILE 34 - COMPANION ASSEMBLY V2
High-information architecture view combining propulsion core, V2 distributed
packaging, protective cage, datum and dynamic control envelopes. */
$fn=100;
use <10_aero_duct.scad>
use <12_motor_stator.scad>
use <13_rotor_envelopes.scad>
use <14_vane_system.scad>
use <15_vane_actuator_ring.scad>
use <31_packaging_v2.scad>
use <33_companion_shell_v2.scad>
SHOW_SHELL=true; SHOW_PROPULSION=true; SHOW_PACKAGING=true; SHOW_DYNAMIC=true; SHOW_DATUM=true;
if(SHOW_SHELL) companion_shell();
if(SHOW_PROPULSION){ aidrone_aero_duct(); motor_stator_system(); }
if(SHOW_PACKAGING) packaging_v2();
if(SHOW_DYNAMIC){ rotor_envelope_system(); vane_system(); for(i=[0:3]) vane_sweep_envelope(i); }
if(SHOW_DATUM){ %sphere(d=2); %cylinder(h=115,d=.35,center=true); }
// Local callable V2 packaging because File31 also has a top-level preview.
module packaging_v2(){
 CAM_INNER_R=37.8; CAM_D=15.8; CAM_W=16.6; CAM_H=16.6;
 BAT_INNER_R=38.0; BAT_D=6.0; BAT_W=18.0; BAT_H=24.0;
 PCB_INNER_R=37.8; PCB_D=4.5; PCB_W=14.0; PCB_H=18.0;
 for(a=[0:90:270]) rotate([0,0,a]) pod(CAM_INNER_R,CAM_D,CAM_W,CAM_H);
 for(a=[90,270]) rotate([0,0,a]) pod(BAT_INNER_R,BAT_D,BAT_W,BAT_H);
 for(a=[45,135,225,315]) rotate([0,0,a]) pod(PCB_INNER_R,PCB_D,PCB_W,PCB_H);
}
module pod(r,d,w,h){ translate([r+d/2,0,0]) cube([d,w,h],center=true); }
echo("FILE34 BUDDY COMPANION ASSEMBLY V2");
echo("Architecture: 70mm protected duct + distributed equatorial nervous-system belt + 115mm cage");
echo("Flight status remains PROVISIONAL pending selected propulsion/electrical hardware and physical tests.");
