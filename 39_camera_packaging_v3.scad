/* BUDDY FILE 39 - CAMERA PACKAGING V3
Goal: retain 14.2mm minimum square cavity while increasing shell margin.
Concept envelope until exact camera/lens/connector hardware is selected. */
$fn=100;
SHELL_R=55.5; DUCT_R=37;
POCKET=14.2; BODY_DEPTH=15.0;
SIDE_WALL=1.0; BACK_WALL=0.8; FRONT_RIM=0.6;
INNER_R=37.8;
OUTER_DEPTH=BODY_DEPTH+BACK_WALL+FRONT_RIM;
OUTER_W=POCKET+2*SIDE_WALL;
OUTER_H=POCKET+2*SIDE_WALL;
SHOW_REFS=true;
camera_packaging_v3();
module camera_packaging_v3(){
 if(SHOW_REFS){ %sphere(d=111); %cylinder(h=70,d=70,center=true); }
 for(a=[0:90:270]) rotate([0,0,a]) housing();
}
module housing(){
 difference(){
  translate([INNER_R+OUTER_DEPTH/2,0,0]) cube([OUTER_DEPTH,OUTER_W,OUTER_H],center=true);
  translate([INNER_R+BACK_WALL+BODY_DEPTH/2,0,0]) cube([BODY_DEPTH+0.1,POCKET,POCKET],center=true);
  translate([INNER_R+OUTER_DEPTH,0,0]) rotate([0,90,0]) cylinder(h=2,d=9,center=true);
 }
}
function sr(z)=sqrt(SHELL_R*SHELL_R-z*z);
function cr()=sqrt((INNER_R+OUTER_DEPTH)*(INNER_R+OUTER_DEPTH)+(OUTER_W/2)*(OUTER_W/2));
CLEAR=sr(OUTER_H/2)-cr();
DUCT_GAP=INNER_R-DUCT_R;
assert(POCKET>=14.2,"camera cavity below requirement");
assert(DUCT_GAP>=0.8,"camera duct service gap below target");
assert(CLEAR>=1.0,"V3 camera shell design margin below 1.0 mm");
echo("FILE39 camera V3 shell clearance =",CLEAR);
echo("FILE39 camera V3 duct gap =",DUCT_GAP);
