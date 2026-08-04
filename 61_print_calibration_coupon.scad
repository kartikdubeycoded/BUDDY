/* BUDDY FILE61 - FDM FIT CALIBRATION COUPON
Print before structural parts. Measures actual pin/hole and sliding-fit behavior. */
$fn=60; BASE=[70,28,3]; nominal=[2.0,2.2,2.4,3.0,3.2,4.0]; clearances=[0.10,0.20,0.30,0.40];
difference(){cube(BASE);for(i=[0:len(nominal)-1])translate([7+i*10,7,-.1])cylinder(h=4,d=nominal[i]);for(i=[0:len(clearances)-1])translate([10+i*15,20,-.1])cube([8+clearances[i],4+clearances[i],4]);}
for(i=[0:len(clearances)-1])translate([10+i*15,34,0])cube([8,4,3]);
echo("FILE61 calibration coupon: measure printed holes and test slide bars");
echo("Do not transfer nominal PROCESS clearances into production until coupon results are recorded");
