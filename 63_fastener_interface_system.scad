/* BUDDY FILE63 - FASTENER + ALIGNMENT INTERFACE SYSTEM
Printable interface primitives for Stage1. Insert/head dimensions remain provisional until hardware is selected. */
include <55_stage1_print_parameters.scad>
$fn=64;
module insert_boss(h=5,wall=1.5){difference(){cylinder(h=h,d=B1_INSERT_OD+2*wall);translate([0,0,-.1])cylinder(h=h+.2,d=B1_INSERT_OD);}}
module screw_clearance(h=6){cylinder(h=h,d=B1_M2_CLEAR);}
module head_pocket(h=B1_M2_HEAD_H+.2){cylinder(h=h,d=B1_M2_HEAD);}
module alignment_pin(d=2.4,h=3){cylinder(h=h,d=d);}
module alignment_socket(d=2.4,h=3){cylinder(h=h+.1,d=d+2*B1_FDM_SLIDE);}
module interface_demo(){
 difference(){cube([24,12,5],center=true);translate([-6,0,-3])screw_clearance(6);translate([-6,0,0.8])head_pocket();translate([6,0,-3])alignment_socket();}
 translate([6,0,2.5])alignment_pin();
}
interface_demo();
echo("FILE63 interface system; calibrate File61 before relying on fits");
