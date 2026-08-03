/* BUDDY FILE 31 - COMPACT SYMMETRIC PACKAGING V2
Concept packaging generated from spherical-boundary constraints.
Not printable until real hardware dimensions are selected. */
$fn=100;
SHELL_ID=111; SHELL_R=55.5; DUCT_OD=74; DUCT_R=37; AIRWAY_R=35;
SERVICE_GAP=0.6;
// Four camera pods: shallow radial packaging around equator.
CAM_INNER_R=37.8; CAM_D=15.8; CAM_W=16.6; CAM_H=16.6;
// Split batteries moved to +/-Y, flattened to follow equatorial annulus.
BAT_INNER_R=38.0; BAT_D=6.0; BAT_W=18.0; BAT_H=24.0;
// Electronics use four thin quadrant cards rather than a tall spine.
PCB_INNER_R=37.8; PCB_D=4.5; PCB_W=14.0; PCB_H=18.0;
SHOW_REFS=true;
if(SHOW_REFS){ %sphere(d=SHELL_ID); %cylinder(h=70,d=70,center=true); }
for(a=[0:90:270]) rotate([0,0,a]) pod(CAM_INNER_R,CAM_D,CAM_W,CAM_H,0);
for(a=[90,270]) rotate([0,0,a]) pod(BAT_INNER_R,BAT_D,BAT_W,BAT_H,0);
for(a=[45,135,225,315]) rotate([0,0,a]) pod(PCB_INNER_R,PCB_D,PCB_W,PCB_H,0);
module pod(r,d,w,h,z){ translate([r+d/2,0,z]) cube([d,w,h],center=true); }
function shell_r(z)=sqrt(SHELL_R*SHELL_R-z*z);
function corner_r(r,d,w)=sqrt((r+d)*(r+d)+(w/2)*(w/2));
function clearance(r,d,w,h,z)=shell_r(abs(z)+h/2)-corner_r(r,d,w);
CAM_CLEAR=clearance(CAM_INNER_R,CAM_D,CAM_W,CAM_H,0);
BAT_CLEAR=clearance(BAT_INNER_R,BAT_D,BAT_W,BAT_H,0);
PCB_CLEAR=clearance(PCB_INNER_R,PCB_D,PCB_W,PCB_H,0);
assert(CAM_INNER_R-DUCT_R>=0.2,"camera/duct gap fail");
assert(BAT_INNER_R-DUCT_R>=0.2,"battery/duct gap fail");
assert(PCB_INNER_R-DUCT_R>=0.2,"PCB/duct gap fail");
assert(CAM_CLEAR>=0.2,"camera shell clearance fail");
assert(BAT_CLEAR>=0.2,"battery shell clearance fail");
assert(PCB_CLEAR>=0.2,"PCB shell clearance fail");
echo("PACKAGING V2 clearances camera/battery/PCB =",CAM_CLEAR,BAT_CLEAR,PCB_CLEAR);
echo("STATUS: geometric envelope concept only; hardware selection required.");
