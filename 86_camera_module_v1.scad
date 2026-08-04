/* BUDDY FILE86 - CAMERA RETENTION + WINDOW MODULE
Parametric printable camera cassette. Lens/FOV dimensions must be replaced by selected camera data. */
include <55_stage1_print_parameters.scad>
$fn=72;
BODY=[15.0,14.2,14.2]; CLEAR=.5; WALL=1.0; LENS_D=9.0; R=37.8;
module camera_cassette(){
 difference(){
  cube([BODY[0]+2*WALL,BODY[1]+2*WALL,BODY[2]+2*WALL],center=true);
  translate([WALL/2,0,0])cube([BODY[0]+CLEAR,BODY[1]+CLEAR,BODY[2]+CLEAR],center=true);
  translate([BODY[0]/2+WALL,0,0])rotate([0,90,0])cylinder(h=2*WALL+1,d=LENS_D,center=true);
 }
 // rear retention bridge / strain relief land
 translate([-BODY[0]/2-WALL-.8,0,0])cube([1.6,8,5],center=true);
}
module camera_four(){for(a=[0:90:270])rotate([0,0,a])translate([R+BODY[0]/2,0,0])camera_cassette();}
camera_four();
assert(R-B1_DUCT_OD/2>=.8,"camera cassette violates duct service gap");
echo("FILE86 camera cassette; BODY/LENS dimensions provisional until hardware selection");
