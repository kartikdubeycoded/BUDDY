/* BUDDY FILE 30 - INTEGRATED ENGINEERING DASHBOARD
Visual engineering scene, not printable geometry. */
$fn=100;
use <10_aero_duct.scad>
use <12_motor_stator.scad>
use <13_rotor_envelopes.scad>
use <14_vane_system.scad>
use <15_vane_actuator_ring.scad>
use <17_electronics_spine.scad>
use <19_battery_cradle.scad>
use <20_camera_ring.scad>
use <21_crash_shell.scad>
SHOW_SHELL=true; SHOW_AIRWAY=true; SHOW_DYNAMIC=true; SHOW_SWEEP=true; SHOW_HARDWARE=true; SHOW_DATUM=true;
if(SHOW_SHELL){ %sphere(d=115); %sphere(d=111); crash_shell_system(); }
if(SHOW_AIRWAY) %cylinder(h=70,d=70,center=true);
if(SHOW_HARDWARE){ aidrone_aero_duct(); motor_stator_system(); actuator_system(); electronics_spine(); battery_system(); camera_ring(); }
if(SHOW_DYNAMIC){ rotor_envelope_system(); vane_system(); }
if(SHOW_SWEEP) for(i=[0:3]) vane_sweep_envelope(i);
if(SHOW_DATUM){ sphere(d=2); axes(); }
module axes(){ rotate([0,90,0]) cylinder(h=115,d=.4,center=true); rotate([90,0,0]) cylinder(h=115,d=.4,center=true); cylinder(h=115,d=.4,center=true); }
echo("BUDDY FILE30 ENGINEERING DASHBOARD");
echo("Transparent spheres: 115mm vehicle and 111mm shell cavity");
echo("Transparent cylinder: protected 70mm airway");
echo("Dynamic rotor/vane geometry remains diagnostic, not printable hardware");
