/* BUDDY FILE83 - OPPOSED BATTERY RETENTION V1
Parametric carrier concept; exact pack dimensions must come from selected cells/pack. */
include <55_stage1_print_parameters.scad>
$fn=64;
PACK=[24,18,7]; CLEAR=.6; WALL=1.2; R=43;
module tray(){
 difference(){
  cube([PACK[0]+2*WALL,PACK[1]+2*WALL,PACK[2]+WALL],center=true);
  translate([0,0,WALL/2])cube([PACK[0]+CLEAR,PACK[1]+CLEAR,PACK[2]+CLEAR],center=true);
 }
 // retention ears for strap/clip concept
 for(y=[-1,1])translate([0,y*(PACK[1]/2+WALL+2),0])cube([8,4,2],center=true);
}
module battery_pair(){for(a=[90,270])rotate([0,0,a])translate([R,0,0])rotate([0,90,0])tray();}
battery_pair();
assert(R-PACK[2]/2>B1_DUCT_OD/2,"battery pack intrudes into duct envelope");
echo("FILE83 opposed battery retention; PACK dimensions provisional",PACK);
