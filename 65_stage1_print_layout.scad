/* BUDDY FILE65 - STAGE1 PRINT LAYOUT
Exploded print-bed planning scene. Not a slicer replacement. */
use <56_segmented_crash_cage.scad>
use <57_equatorial_service_chassis.scad>
use <59_vane_cartridge_v2.scad>
$fn=80;
translate([-65,0,0])hemisphere(1);
translate([65,0,0])rotate([180,0,0])hemisphere(-1);
translate([0,65,0])equator_clamp();
translate([0,-65,0])service_chassis();
for(i=[0:3])translate([-36+24*i,-100,0])rotate([0,0,90*i])cartridge();
echo("FILE65 Stage1 print layout: cage halves, clamp, chassis, four vane cartridges");
echo("Orientations/support strategy must be finalized per material/printer after calibration");
