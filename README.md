# BUDDY

**A ducted-fan aircraft engineering rig — parametric CAD and first-order physics solvers that
argue with each other until the design either closes or is told it doesn't.**

![OpenSCAD](https://img.shields.io/badge/OpenSCAD-f9d72c?style=flat-square&logo=openscad&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![status](https://img.shields.io/badge/status-design%20study-blue?style=flat-square)
![scope](https://img.shields.io/badge/analysis-first--order%20only-orange?style=flat-square)

BUDDY is a 115 mm ducted-fan companion aircraft, thrust-vectored by control vanes in the exhaust.
The repo holds the whole design as **code**: the geometry is parametric OpenSCAD, and the physics
is a chain of Python solvers. Change one number in `00_master_parameters.scad` and the ducts,
vanes, spine, shells and the mass budget all move with it.

> **Scope, stated up front:** this is analytical screening — closed-form propulsion, control and
> structural estimates. It is **not** CFD, not FEA, not flight-certified, and no hardware has been
> validated. The repo enforces that claim itself (see [Gates](#the-gates)).

---

## How it's organised

Files are numbered because they form a dependency chain — each stage consumes the one before it.

| Range | What it does |
|---|---|
| `00–02` | **Contract layer** — master parameters, hardware database, materials and tolerances. Every downstream file reads from here; nothing hardcodes a dimension. |
| `04–06` | **Physics solvers** — propulsion (disk loading, induced velocity, ideal power), control authority (vane normal force, thrust vectoring), structural loads. |
| `10–23` | **Geometry** — aero duct, inlet lip, motor stator, rotor envelopes, vane system and actuator ring, electronics spine, battery cradle, camera ring, crash shell, full assembly. |
| `16–18` | **Sizing** — actuator sizing against required vane torque; mass properties rolled up from the assembly. |
| `24–36` | **Budgets and gates** — packaging optimiser, mass and energy budgets, flight envelope, and the gates that decide whether the design is allowed to claim anything. |

---

## The gates

The part I'd point at first. Four scripts exist purely to stop the project lying to itself:

- **`24_feasibility_gate.py`** — integrated first-order feasibility. Screens the design and says
  where it fails, labelling every result as *verified* or *assumed*.
- **`32_architecture_gate.py`** — checks the architecture is internally consistent before geometry
  work continues.
- **`35_build_readiness_gate.py`** — *"prevents prototype/manufacturing claims while critical
  hardware inputs are unknown. It is deliberately conservative."* You cannot mark this design
  buildable while a motor is still a guess.
- **`36_hardware_contract.py`** — the hardware interface contract: *"Fill only from manufacturer
  data or measured hardware. No guessed dimensions."* Every unselected component is an explicit
  `None`, and `validate()` fails loudly rather than defaulting to something plausible.

Run `35_build_readiness_gate.py` today and it reports **6 checks passing, 9 blocking** —
`NOT READY FOR FLIGHT BUILD`. The geometry side has closed (CAD graph clean, 115 mm outer
architecture and 70 mm protected airway locked, rotor/stator clearances positive). Everything
blocking is real hardware nobody has bought or measured yet: motor, rotor, ESC, battery, actuator,
plus bench validation of vane authority and rotor containment.

That's the intended state. The gate is doing its job.

---

## Run the solvers

No dependencies beyond the Python standard library — the solvers are closed-form.

```bash
python 04_propulsion_solver.py      # thrust, disk loading, induced velocity, ideal power
python 05_control_authority.py      # vane forces, thrust vectoring authority
python 24_feasibility_gate.py       # integrated feasibility screen
python 27_mass_budget.py            # mass roll-up
python 28_energy_budget.py          # endurance against the pack
python 35_build_readiness_gate.py   # what still blocks a build
```

## View the CAD

Open in [OpenSCAD](https://openscad.org/) (free). Start with the full assembly:

```bash
openscad 22_full_assembly.scad
```

Edit `00_master_parameters.scad` to change the aircraft — everything else follows from it.

---

## Why build it this way

Most hobby airframe projects are a folder of STLs and a number someone remembers. Putting the
parameters, the physics and the refusal-to-overclaim in the same repo means the design can be
re-derived from scratch, and a wrong assumption surfaces as a failing gate rather than a broken
prototype.

---

*Part of [kartikdubeycoded](https://github.com/kartikdubeycoded)'s project tree.*
