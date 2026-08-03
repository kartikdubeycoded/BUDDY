/* BUDDY FILE 33 - COMPANION SHELL V2
115 mm spherical protective cage with equatorial service belt and polar duct openings.
Concept geometry; impact containment requires FEA + destructive testing. */
$fn=120;
OD=115; ID=111; R=OD/2; RI=ID/2; POLAR_D=74.8;
BELT_H=20; BELT_T=2.2; RIB_D=2.4; RING_D=2.4;
OPENING_MARGIN=0.4;
companion_shell();
module companion_shell(){
 union(){ latitude_rings(); longitude_ribs(); service_belt(); polar_rings(); }
}
module latitude_rings(){
 for(z=[-40,-28,-16,16,28,40]){
   rr=sqrt(max(0,R*R-z*z));
   translate([0,0,z]) rotate_extrude() translate([rr-RING_D/2,0]) circle(d=RING_D);
 }
}
module longitude_ribs(){
 for(a=[0:30:150]) rotate([0,0,a]) intersection(){
   difference(){ sphere(d=OD); sphere(d=ID); }
   cube([RIB_D,OD+2,OD+2],center=true);
 }
}
module service_belt(){
 difference(){
  cylinder(h=BELT_H,d=OD,center=true);
  cylinder(h=BELT_H+0.2,d=OD-2*BELT_T,center=true);
  // four broad cooling/service windows
  for(a=[0:90:270]) rotate([0,0,a]) translate([R-1,0,0]) cube([8,18,12],center=true);
 }
}
module polar_rings(){
 for(s=[-1,1]) translate([0,0,s*(sqrt(R*R-(POLAR_D/2)*(POLAR_D/2))-1)])
 difference(){ cylinder(h=2,d=POLAR_D+5,center=true); cylinder(h=2.2,d=POLAR_D,center=true); }
}
assert(POLAR_D>=74+2*OPENING_MARGIN,"polar duct opening lacks margin");
echo("FILE33 companion shell V2 OD/ID =",OD,ID);
echo("STATUS: cage architecture only; rotor containment is UNVERIFIED.");
