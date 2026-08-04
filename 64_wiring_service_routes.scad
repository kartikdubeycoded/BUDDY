/* BUDDY FILE64 - WIRING / SERVICE ROUTES
Defines reserved routing volumes so wires cannot be added as an afterthought across the airway or moving vanes. */
include <55_stage1_print_parameters.scad>
$fn=64;
ROUTE_D=3.2; EQUATOR_R=46.0; VERTICAL_R=39.0;
module equatorial_routes(){for(a=[45,135,225,315])rotate([0,0,a])translate([EQUATOR_R,0,0])rotate([90,0,0])cylinder(h=12,d=ROUTE_D,center=true);}
module vertical_routes(){for(a=[0:90:270])rotate([0,0,a])translate([VERTICAL_R,0,0])cylinder(h=42,d=ROUTE_D,center=true);}
module connector_service_keepouts(){for(a=[0:90:270])rotate([0,0,a])translate([49,0,0])cube([8,10,7],center=true);}
module wiring_keepouts(){%equatorial_routes();%vertical_routes();%connector_service_keepouts();}
wiring_keepouts();
assert(VERTICAL_R>B1_DUCT_OD/2,"wire route intersects duct envelope");
echo("FILE64 reserved wiring/service volumes outside protected airway");
