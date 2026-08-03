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
echo("FILE34 BUDDY COMPANION ASSEMBLY V2");
echo("Architecture: 70mm protected duct + distributed equatorial nervous-system belt + 115mm cage");
echo("Flight status remains PROVISIONAL pending selected propulsion/electrical hardware and physical tests.");
