/* BUDDY FILE70 - MASS DUMMY SYSTEM
Printable/visual ballast envelopes for inert Stage1 CoG and fit checks. Replace dimensions/masses with selected hardware. */
include <55_stage1_print_parameters.scad>
$fn=64;
module mass_block(size=[10,10,10],label="dummy"){cube(size,center=true);}
module stage1_mass_dummies(){
 for(a=[90,270])rotate([0,0,a])translate([44,0,0])mass_block([6,18,24],"battery");
 for(a=[45,135,225,315])rotate([0,0,a])translate([42,0,0])mass_block([4.5,14,18],"electronics");
 for(a=[0:90:270])rotate([0,0,a])translate([45.3,0,0])mass_block([15,16.2,16.2],"camera");
 for(z=[-6,6])translate([0,0,z])%cylinder(h=10,d=20,center=true);
}
stage1_mass_dummies();
echo("FILE70 inert mass-dummy envelopes for fit/CoG article; actual ballast mass must be measured");
