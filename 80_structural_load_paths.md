# BUDDY Stage 1 Structural Load Paths

The cage is not cosmetic. Loads must move through deliberate reinforced paths instead of thin shell surfaces.

## Primary load paths
1. Propulsion reaction: motor/stator carrier -> duct wall/reinforced collar -> equatorial chassis/cage nodes.
2. Cage impact: local rib -> latitude/longitude junction -> equatorial clamp and neighboring ribs -> distributed structure.
3. Battery inertia: battery retention feature -> service chassis -> equatorial reinforced ring.
4. Vane reaction: vane shaft/cartridge -> local duct-exit reinforcement -> duct structure; never through a thin unsupported shell panel.
5. Service fasteners: insert boss -> local gusset/rib -> primary ring; fastener bosses must not terminate in isolated thin walls.

## Design rules
- Avoid abrupt section changes at loaded interfaces; use fillets/gussets where printable.
- Do not place layer-separation-prone print planes across the highest expected tensile load without evidence.
- The central duct requires circularity under assembly clamp loads; cage fasteners must not ovalize it.
- Battery retention must react inertial load mechanically rather than relying on friction alone.
- Motor carrier loads include thrust, torque, vibration and imbalance; exact sizing remains blocked by motor/rotor selection.

## Evidence progression
Analytical free-body estimates -> material/process coupons -> selected-hardware load estimates -> FEA where useful -> instrumented/guarded physical testing. Structural margins cannot be declared from visual CAD alone.
