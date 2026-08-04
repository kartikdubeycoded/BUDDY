/* BUDDY FILE84 - MODULAR ELECTRONICS CARRIERS
Four quadrant trays; board dimensions remain hardware inputs. */
include <55_stage1_print_parameters.scad>
$fn=64;
PCB=[18,14,4]; WALL=1.0; CLEAR=.5; R=43;
module pcb_tray(){
 difference(){
  cube([PCB[2]+WALL,PCB[0]+2*WALL,PCB[1]+2*WALL],center=true);
  translate([WALL/2,0,0])cube([PCB[2]+CLEAR,PCB[0]+CLEAR,PCB[1]+CLEAR],center=true);
 }
 // two strain-relief / tie slots
 for(z=[-4,4])translate([0,0,z])cube([PCB[2]+2,3,1.5],center=true);
}
module electronics_four(){for(a=[45,135,225,315])rotate([0,0,a])translate([R,0,0])pcb_tray();}
electronics_four();
assert(R-PCB[2]/2>B1_DUCT_OD/2,"electronics carrier intrudes into duct envelope");
echo("FILE84 modular electronics carriers; replace PCB envelope after selection",PCB);
