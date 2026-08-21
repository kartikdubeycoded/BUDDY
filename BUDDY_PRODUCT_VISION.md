# BUDDY — FINAL PRODUCT VISION

## 1. What BUDDY is

BUDDY is a small, autonomous, physical AI companion: a compact flying robot designed to exist around a person, interact with them, talk to them, perceive the environment, move intelligently, and behave like a friendly little companion rather than like a conventional remotely operated drone.

The intended mental model is closer to a **friendly Tesla-like physical AI system**, except the physical embodiment is a small flying companion. The aircraft is the body; cameras are its eyes; microphones/audio are its senses and voice; the flight controller is its nervous system; the AI provides intelligence, conversation and personality; and a dedicated onboard safety layer prevents the intelligence layer from commanding unsafe flight.

The product should feel like a small intelligent creature that happens to fly.

---

## 2. Physical vision

The target architecture is a compact approximately **115 mm spherical companion** with a protected central propulsion system and a strong, modular outer cage.

Core architectural targets currently established by the project:

- approximately 115 mm external spherical architecture;
- approximately 111 mm nominal internal cage cavity;
- approximately 70 mm protected central propulsion airway;
- enclosed/protected propulsion rather than exposed conventional drone arms and propellers;
- distributed electronics and battery packaging around the equatorial region;
- four-direction camera concept for near-360-degree horizontal perception;
- controllable vane/control system for directional authority;
- modular, replaceable internal components;
- crash-oriented cage architecture;
- 3D-printable mechanical decomposition wherever practical;
- serviceable assemblies rather than a permanently sealed shell.

The final physical object should look intentional and friendly, not like a collection of exposed drone components. The spherical body should visually communicate that it is a companion device and that the propulsion system is protected inside it.

The appearance must emerge from the engineering architecture rather than cosmetic parts being added after the mechanism is complete.

---

## 3. What BUDDY should be able to do

The desired end-state behavior includes:

### Autonomous movement

BUDDY should be capable of controlled flight without requiring the user to continuously operate a transmitter.

It should be able to:

- take off and hover when commanded;
- maintain a stable position;
- move toward a commanded location or person;
- follow its user at a controlled distance;
- stop and brake when required;
- avoid obstacles;
- recover from disturbances;
- return to a safe hover or land when conditions become unsafe;
- operate within bounded speed, acceleration, attitude and control limits.

### Human following

A central product behavior is autonomous following.

A user should be able to communicate an intent such as:

> "BUDDY, follow me."

BUDDY should identify the relevant person, establish an appropriate following position, move with them while maintaining safe separation, continuously reassess perception, and stop/brake/avoid/land if the situation becomes unsafe.

Following must not be implemented as blindly chasing a detected visual target. It requires bounded motion, perception confidence, obstacle handling, braking distance and loss-of-target behavior.

### Conversational interaction

BUDDY should talk naturally with the person it accompanies.

The intended interaction is conversational rather than command-only. The user should be able to speak to BUDDY, ask questions, make jokes, give instructions, discuss things and receive spoken responses.

The voice should feel like the voice of a character, not like a generic navigation system.

### Physical presence

The crucial difference from a phone or chatbot is that BUDDY physically exists in the user's environment.

It can:

- fly toward the user when called;
- hover nearby while the user talks;
- orient itself toward the person speaking;
- move with the user;
- look toward interesting objects or events through its camera orientation/body orientation;
- react through movement as well as speech;
- accompany the user from one place to another within its safe operating environment.

Movement therefore becomes part of communication.

---

## 4. Personality vision

BUDDY should behave like a **friendly, playful, slightly mischievous companion with a Minion-like energy**, while remaining an original character rather than copying any existing copyrighted character.

The personality should feel:

- playful;
- curious;
- expressive;
- loyal;
- slightly chaotic in a lovable way;
- humorous;
- socially responsive;
- occasionally surprised or confused;
- excited when something interesting happens;
- comfortable joking with the user;
- capable of showing personality through both speech and movement.

The user should feel that BUDDY has a recognizable character.

For example, if the user calls it from another room, BUDDY should not feel like a command-line robot executing `GO_TO_USER`. It should feel like a little companion responding to its person and coming over.

Personality should influence speech, attention, expression and high-level behavior. It must **never override flight safety, actuator limits, geofencing/operational limits, obstacle avoidance, emergency braking, battery protection or other safety-critical constraints**.

Personality is an interaction layer, not a flight-authority layer.

---

## 5. The desired user experience

The ideal interaction is simple:

The user owns BUDDY, talks to it naturally, and does not need to understand the engineering underneath it.

Examples of intended experiences:

**"BUDDY, come here."**

It identifies the user, navigates toward them safely, stops at an appropriate distance and responds verbally.

**"BUDDY, follow me."**

It establishes the user as its tracking target and follows within a controlled envelope.

**"What was that?"**

It uses its perception system and available AI capabilities to interpret the environment and respond.

**"Stay here."**

It remains in a safe hover/position until another valid instruction changes the high-level behavior.

If the user walks away, BUDDY can accompany them. If something enters its path, it should avoid or brake rather than blindly continue following.

If the communications link fails, BUDDY should not become uncontrolled. Its onboard flight system must enter a predefined safe state.

---

## 6. AI architecture philosophy

The project should separate **intelligence from flight authority**.

The high-level AI can handle:

- conversation;
- personality;
- natural-language interpretation;
- high-level goals;
- user interaction;
- contextual reasoning;
- perception interpretation;
- deciding that the user should be followed;
- deciding that BUDDY should approach, wait, look, speak or interact.

The onboard flight/safety system handles:

- stabilization;
- motor/actuator control;
- sensor validity;
- command bounds;
- attitude limits;
- acceleration limits;
- obstacle/emergency behavior;
- braking;
- hover;
- landing;
- battery protection;
- link-loss behavior;
- failsafe states.

The AI can request an action. It cannot directly bypass the safety envelope.

This separation is a fundamental product requirement.

---

## 7. Perception vision

BUDDY should perceive its surroundings well enough to function as a companion rather than merely as a remotely controlled aircraft.

The current architecture uses four outward-facing camera stations distributed around the body to provide broad horizontal coverage.

The perception system should eventually support:

- identifying and tracking the user;
- detecting obstacles;
- estimating relevant spatial relationships;
- detecting when the tracked person is lost;
- determining when perception confidence is insufficient;
- supporting safe approach/follow behavior;
- providing visual context to the conversational AI.

Real camera selection, lens geometry, distortion, calibration, synchronization, lighting performance, vertical blind zones and latency remain hardware/validation problems and must not be fabricated as solved facts.

---

## 8. Mechanical philosophy

The body should be engineered as a real physical product, not as a single decorative OpenSCAD object.

Major systems should be replaceable:

- propulsion modules;
- motor/stator carriers;
- rotor-related components;
- control-vane cartridges;
- vane actuators/linkages;
- camera modules;
- battery carriers;
- electronics carriers;
- audio components;
- wiring and connectors;
- damaged cage sections.

The outer cage should be segmented where practical so a damaged section can be replaced without rebuilding the entire aircraft.

The design should provide deliberate load paths for propulsion reaction, battery inertia, vane reaction, fastener loads and impact loads.

Fasteners should retain parts; alignment features should establish geometry. Do not rely on fasteners to force badly printed parts into alignment.

---

## 9. 3D-printing vision

A large portion of the prototype should be realistically manufacturable using 3D printing.

The CAD must therefore account for:

- printer/process tolerances;
- material selection;
- layer orientation;
- wall thickness;
- ribs and gussets;
- inserts and fasteners;
- assembly access;
- serviceability;
- support requirements;
- dimensional calibration;
- impact behavior;
- vibration;
- thermal environment.

Do not assume a generic printer tolerance and call the part production-ready.

A calibration coupon must establish the actual process fit before final interfaces are frozen.

Selected real hardware dimensions must replace placeholder envelopes before physical production parts are considered final.

---

## 10. Engineering philosophy

The project must distinguish three categories:

### Proven by deterministic modelling
Examples include fixed architectural dimensions and mathematical relationships that can be directly calculated from defined geometry.

### Provisional engineering assumptions
Examples include placeholder component masses, estimated power consumption, provisional camera dimensions, assumed material properties and simplified propulsion performance.

### Physically validated facts
Examples include measured motor thrust, measured current, measured battery sag, measured printed dimensions, measured mass/CoG, actuator torque/current, thermal measurements and actual collision/containment tests.

A clean CAD render does not prove flight.

A Python model does not prove a motor can produce the required thrust.

A successful OpenSCAD compile does not prove structural integrity.

The system must progressively replace assumptions with selected hardware data and physical evidence.

---

## 11. Safety philosophy

BUDDY is a flying machine. Safety is therefore a product-level requirement, not an optional feature.

The safety hierarchy must remain above personality and conversational intelligence.

Conceptually:

**DISARMED → HOVER → FOLLOW/AVOID → BRAKE → HOVER/LAND**

with faults able to force a safer state.

Examples:

- battery fault → safe landing;
- sensor fault → safe landing or other defined failsafe;
- communications loss → safe hover/land according to the operational state;
- stale command → ignore/hold safe state;
- tracking collapse → brake;
- obstacle → avoid;
- actuator saturation → brake/safe state;
- excessive attitude → land/safe state.

The exact thresholds must ultimately come from hardware and flight testing rather than being treated as validated merely because a simulation passes.

---

## 12. What the finished product should feel like

The finished BUDDY should not feel like:

- a toy quadcopter with an LLM attached;
- a phone speaker mounted to a drone;
- a remote-controlled camera;
- a chatbot that happens to have propellers;
- a fragile 3D-printed shell around exposed hardware.

It should feel like:

**a small physical AI companion that happens to fly.**

You should be able to enter a space with BUDDY, talk to it, ask it to follow you, have it move around you, hear it respond, watch it react to the environment, and trust that its underlying flight system will keep its behavior bounded when something goes wrong.

The personality, physical motion, perception and conversation should reinforce one another so that the machine feels like one coherent character.

---

## 13. Product-level success condition

The ultimate goal is not merely to make the CAD compile or to demonstrate that an isolated motor can spin.

The goal is a real prototype that combines:

**physical embodiment + autonomous flight + perception + conversation + personality + human following + obstacle handling + modular mechanical design + serviceability + safety.**

The prototype should progressively move from the current architecture to selected real hardware, measured mass/CoG, verified propulsion performance, validated actuator authority, calibrated cameras, validated thermal behavior, printed dimensional evidence, controlled flight tests and finally integrated autonomous companion behavior.

Every engineering decision should serve that product vision.

If a proposed implementation makes one subsystem look impressive but makes BUDDY less safe, less serviceable, less printable, less autonomous, less coherent as a companion, or incompatible with the controlled architecture, it is the wrong implementation.

## 14. Non-negotiable principle

**BUDDY is being built as a character embodied in a flying machine, not as a flying machine with a character attached.**

The engineering must make the character physically possible; the AI must make the machine socially meaningful; and the safety system must keep the entire thing under control.