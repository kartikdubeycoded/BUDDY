# BUDDY Stage 1 Interface Control Document

## Global datums
Origin is vehicle geometric center. +Z follows the propulsion axis. Equatorial plane is Z=0. Camera stations are nominally +X, +Y, -X, -Y. Battery stations are opposed to preserve first-order XY balance.

## Envelope interfaces
- External cage: <=115 mm nominal spherical envelope.
- Internal cage cavity: 111 mm nominal diameter.
- Central protected airway: 70 mm diameter keep-clear.
- Propulsion duct: 74 mm nominal OD, centered on Z.
- Polar cage opening: 74.8 mm nominal starting interface, subject to process calibration.

## Cage ↔ chassis
The equatorial clamp is the primary service split. Alignment features establish registration; fasteners retain rather than forcibly align warped parts. Chassis loads should enter reinforced equatorial structure rather than thin unsupported shell spans.

## Duct ↔ stators
Motor/stator carriers are removable. Motor bolt pattern, shaft diameter, bearing support and thermal interface remain hardware-controlled dimensions and cannot be frozen before motor selection.

## Duct ↔ vanes
Four vane cartridges are indexed at 90°. Their swept volumes are flight-critical keepouts. Wiring, shell ribs and electronics are prohibited from these volumes.

## Chassis ↔ cameras
Four radial camera stations target symmetric horizontal coverage. Current V3 cavity target is >=14.2 mm square with >=1.0 mm shell design margin and >=0.8 mm duct-side service gap. Lens opening must be regenerated around the selected lens/FOV rather than assumed universal.

## Chassis ↔ battery
Two opposed battery stations are preferred for balance and serviceability. Pack swelling allowance, connector exit, retention load and cell protection become mandatory once chemistry/pack is selected.

## Chassis ↔ electronics/audio
Electronics are distributed in quadrants. High-current paths should be kept short and separated from sensitive sensor wiring where practical. Speaker placement cannot obstruct the protected airway or camera fields.

## Wiring
File64 volumes are reserved routing corridors, not literal wire geometry. No wire may cross rotor or vane swept volumes. Every service disconnect needs strain relief and enough access for assembly without dismantling the propulsion core.

## Change rule
Any selected component exceeding its controlled envelope triggers an interface review across geometry, mass, CoG, power, cooling, service access and perception occlusion before CAD is altered.
