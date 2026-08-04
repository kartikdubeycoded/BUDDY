/* BUDDY FILE70 - MASS DUMMY SYSTEM
Controlled hardware envelopes for inert Stage1 fit/CoG checks.
These are packaging envelopes, not printable ballast parts. Replace with measured selected hardware. */
include <55_stage1_print_parameters.scad>
$fn=64;
CAM=[15.0,14.0,14.0]; PCB=[4.0,13.0,17.0]; BAT=[6.0,17.0,23.0];
CAM_R=46.0; PCB_R=41.2; BAT_R=42.2;
module mass_block(size=[10,10,10]){cube(size,center=true);}
module stage1_mass_dummies(){
 // Cameras: radial depth 15 mm, tangent/vertical 14 mm.
 for(a=[0:90:270])rotate([0,0,a])translate([CAM_R,0,0])mass_block(CAM);
 // Electronics: radial thickness 4 mm, tangent 13 mm, vertical 17 mm.
 for(a=[45,135,225,315])rotate([0,0,a])translate([PCB_R,0,0])mass_block(PCB);
 // Batteries: radial thickness 6 mm, tangent 17 mm, vertical 23 mm.
 for(a=[90,270])rotate([0,0,a])translate([BAT_R,0,0])mass_block(BAT);
 // Motor envelopes are references only and intentionally excluded from payload collision Boolean tests.
 for(z=[-6,6])translate([0,0,z])%cylinder(h=10,d=20,center=true);
}
stage1_mass_dummies();
assert(CAM_R-CAM[0]/2>=B1_DUCT_OD/2+B1_CAMERA_DUCT_GAP,"camera envelope violates duct gap");
assert(PCB_R-PCB[0]/2>B1_DUCT_OD/2,"PCB envelope violates duct");
assert(BAT_R-BAT[0]/2>B1_DUCT_OD/2,"battery envelope violates duct");
echo("FILE70 controlled inert hardware envelopes; selected hardware must replace provisional dimensions");
