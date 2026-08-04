# BUDDY Stage 1 Engineering Risk Register

| Risk | Consequence | Current control | Closure evidence |
|---|---|---|---|
| rotor clearance consumed by print/runout/deflection | contact/failure | explicit nominal gap + inert gauges | measured rotating clearance and guarded bench data |
| coaxial/duct propulsion underperforms | cannot hover / poor reserve | thrust gates remain provisional | measured dual-rotor ducted thrust-current curves |
| 190 g mass target exceeded | thrust/endurance degradation | 166 g BOM target + growth margin | measured BOM and assembled mass |
| CoG offset | control bias/saturation | symmetric architecture + trim solver | measured XYZ CoG <= accepted limits |
| camera station too tight | assembly/optical obstruction | V3 margin target | real camera fit and calibrated FOV |
| battery thermal/current inadequacy | voltage collapse/heat | hardware contract | discharge/sag/temperature measurements |
| vane authority insufficient | poor attitude/translation control | replaceable cartridges | guarded airflow force/control tests |
| vane collision/backlash | jam/control loss | swept-volume rule + hard stops | loaded travel test |
| cage too weak/heavy | impact hazard or mass failure | segmented rib architecture | FEA/material coupons/impact tests as appropriate |
| phone link loss | pursuit/control discontinuity | onboard HOVER/BRAKE/LAND supervision | fault-injection + integrated tests |
| perception latency/false target | unsafe following | confidence gating and braking | calibrated scenario tests |
| wiring enters moving parts | mechanical/electrical failure | reserved routes/strain relief | assembled inspection |
| print tolerance mismatch | poor fit/misalignment | calibration coupon/process parameters | measured coupons and article inspection |
| thermal accumulation inside sphere | electronics/ESC degradation | distributed architecture; no claim yet | instrumented sustained-load test |

Risk retirement is evidence-driven. A clean render does not close a physical risk.
