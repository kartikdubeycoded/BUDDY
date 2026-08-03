/* BUDDY FILE 20 - FOUR-CAMERA PERCEPTION RING */
include <00_master_parameters.scad>
include <02_materials_tolerances.scad>
$fn=100;
VEHICLE_D=115; VEHICLE_R=57.5; SHELL_INNER_D=111; SHELL_INNER_R=55.5;
DUCT_OD_LOCAL=74; DUCT_R=37; AIRWAY_D=70; AIRWAY_R=35;
CAMERA_COUNT_LOCAL=4; CAMERA_ANGLE_OFFSET=0;
CAMERA_BODY_W=14; CAMERA_BODY_H=14; CAMERA_BODY_D=15;
CAMERA_POCKET_W=14.2; CAMERA_POCKET_H=14.2; CAMERA_DEPTH_CLEARANCE=0.4;
CAMERA_POCKET_D=CAMERA_BODY_D+CAMERA_DEPTH_CLEARANCE;
CAMERA_WALL=1.4; HOUSING_W=CAMERA_POCKET_W+2*CAMERA_WALL; HOUSING_H=CAMERA_POCKET_H+2*CAMERA_WALL; HOUSING_D=CAMERA_POCKET_D+CAMERA_WALL;
// 0.8 mm from duct OD preserves service clearance and gains shell margin.
CAMERA_DUCT_GAP=0.8; HOUSING_INNER_R=DUCT_R+CAMERA_DUCT_GAP; HOUSING_CENTER_R=HOUSING_INNER_R+HOUSING_D/2; HOUSING_OUTER_R=HOUSING_INNER_R+HOUSING_D; CAMERA_Z=0;
LENS_APERTURE_D=8; LENS_CLEARANCE=0.5; LENS_OPENING_D=LENS_APERTURE_D+2*LENS_CLEARANCE; LENS_PLANE_R=HOUSING_OUTER_R;
HORIZONTAL_FOV_DEG=120; VERTICAL_FOV_DEG=100; FOV_LENGTH=35; FOV_END_HALF_WIDTH=FOV_LENGTH*tan(HORIZONTAL_FOV_DEG/2); FOV_END_HALF_HEIGHT=FOV_LENGTH*tan(VERTICAL_FOV_DEG/2);
RETAINER_LIP=0.8; RETAINER_DEPTH=1; CABLE_EXIT_W=5; CABLE_EXIT_H=4;
SHOW_HOUSINGS=true; SHOW_CAMERAS=true; SHOW_FOV=false; SHOW_DUCT=false; SHOW_AIRWAY=false; SHOW_SHELL_INNER=false; SHOW_OUTER_SPHERE=false;
camera_ring();
module camera_ring(){ if(SHOW_HOUSINGS) for(i=[0:CAMERA_COUNT_LOCAL-1]) camera_housing_at_station(i); if(SHOW_CAMERAS) for(i=[0:CAMERA_COUNT_LOCAL-1]) %camera_envelope_at_station(i); if(SHOW_FOV) for(i=[0:CAMERA_COUNT_LOCAL-1]) %camera_fov_at_station(i); if(SHOW_DUCT) %duct_reference(); if(SHOW_AIRWAY) %airway_reference(); if(SHOW_SHELL_INNER) %sphere(d=SHELL_INNER_D); if(SHOW_OUTER_SPHERE) %sphere(d=VEHICLE_D); }
module camera_housing(){ difference(){ camera_housing_outer(); camera_pocket(); lens_opening(); cable_exit(); } camera_retention_lips(); }
module camera_housing_outer(){ translate([HOUSING_CENTER_R,0,CAMERA_Z]) cube([HOUSING_D,HOUSING_W,HOUSING_H],center=true); }
module camera_pocket(){ translate([HOUSING_INNER_R+CAMERA_WALL+CAMERA_POCKET_D/2,0,CAMERA_Z]) cube([CAMERA_POCKET_D+0.2,CAMERA_POCKET_W,CAMERA_POCKET_H],center=true); }
module lens_opening(){ translate([HOUSING_OUTER_R,0,CAMERA_Z]) rotate([0,90,0]) cylinder(h=2*CAMERA_WALL+1,d=LENS_OPENING_D,center=true); }
module cable_exit(){ translate([HOUSING_INNER_R,0,CAMERA_Z]) cube([2*CAMERA_WALL+1,CABLE_EXIT_W,CABLE_EXIT_H],center=true); }
module camera_retention_lips(){ for(side=[-1,1]) translate([HOUSING_OUTER_R-RETAINER_DEPTH/2,side*(CAMERA_POCKET_W/2+RETAINER_LIP/2),CAMERA_Z]) cube([RETAINER_DEPTH,RETAINER_LIP,CAMERA_POCKET_H],center=true); }
module camera_housing_at_station(station){ rotate([0,0,CAMERA_ANGLE_OFFSET+station*360/CAMERA_COUNT_LOCAL]) camera_housing(); }
module camera_envelope(){ translate([HOUSING_INNER_R+CAMERA_WALL+CAMERA_BODY_D/2,0,CAMERA_Z]) cube([CAMERA_BODY_D,CAMERA_BODY_W,CAMERA_BODY_H],center=true); }
module camera_envelope_at_station(station){ rotate([0,0,CAMERA_ANGLE_OFFSET+station*360/CAMERA_COUNT_LOCAL]) camera_envelope(); }
module camera_fov(){ hull(){ translate([LENS_PLANE_R,0,CAMERA_Z]) cube([0.1,LENS_OPENING_D,LENS_OPENING_D],center=true); translate([LENS_PLANE_R+FOV_LENGTH,0,CAMERA_Z]) cube([0.1,2*FOV_END_HALF_WIDTH,2*FOV_END_HALF_HEIGHT],center=true); } }
module camera_fov_at_station(station){ rotate([0,0,CAMERA_ANGLE_OFFSET+station*360/CAMERA_COUNT_LOCAL]) camera_fov(); }
module duct_reference(){ difference(){ cylinder(h=70,d=DUCT_OD_LOCAL,center=true); cylinder(h=70.2,d=AIRWAY_D,center=true); } }
module airway_reference(){ cylinder(h=70,d=AIRWAY_D,center=true); }
function sphere_radius_at_z(r,z)=abs(z)<=r?sqrt(r*r-z*z):0;
CAMERA_WORST_Z=max(abs(CAMERA_Z+HOUSING_H/2),abs(CAMERA_Z-HOUSING_H/2));
AVAILABLE_SHELL_R=sphere_radius_at_z(SHELL_INNER_R,CAMERA_WORST_Z);
CAMERA_SHELL_CLEARANCE=AVAILABLE_SHELL_R-HOUSING_OUTER_R;
CAMERA_AIRWAY_CLEARANCE=HOUSING_INNER_R-AIRWAY_R;
CAMERA_DUCT_CLEARANCE=HOUSING_INNER_R-DUCT_R;
CAMERA_SPACING_DEG=360/CAMERA_COUNT_LOCAL; HORIZONTAL_FOV_OVERLAP=HORIZONTAL_FOV_DEG-CAMERA_SPACING_DEG;
assert(CAMERA_COUNT_LOCAL==4,"FAIL: camera architecture requires four stations.");
assert(CAMERA_POCKET_W>=14.2 && CAMERA_POCKET_H>=14.2,"FAIL: camera pocket below 14.2 mm requirement.");
assert(CAMERA_DUCT_CLEARANCE>=0.2,"FAIL: camera housing too close to duct OD.");
assert(CAMERA_AIRWAY_CLEARANCE>0,"FAIL: camera structure enters propulsion airway.");
assert(HOUSING_OUTER_R<VEHICLE_R,"FAIL: camera housing exits vehicle envelope.");
assert(CAMERA_SHELL_CLEARANCE>=0.2,"FAIL: camera housing lacks 0.2 mm inner-shell clearance.");
assert(HORIZONTAL_FOV_OVERLAP>=0,"FAIL: four-camera horizontal coverage contains blind sectors.");
echo("============================================"); echo("BUDDY FILE 20 - CAMERA RING"); echo("Housing outer radius mm =",HOUSING_OUTER_R); echo("Worst housing |Z| mm =",CAMERA_WORST_Z); echo("Available shell radius mm =",AVAILABLE_SHELL_R); echo("Camera/shell clearance mm =",CAMERA_SHELL_CLEARANCE); echo("Camera/duct clearance mm =",CAMERA_DUCT_CLEARANCE); echo("Camera/airway clearance mm =",CAMERA_AIRWAY_CLEARANCE); echo("Adjacent horizontal FOV overlap deg =",HORIZONTAL_FOV_OVERLAP); echo("============================================");
