# BUDDY Phone ↔ Aircraft Protocol V1

The phone supplies cognition and high-level intent. The aircraft owns stabilization and safety.

## Phone -> aircraft messages

`HEARTBEAT`
- monotonic sequence
- phone timestamp
- session identifier

`MODE_REQUEST`
- requested mode: HOVER / FOLLOW / LAND
- request expiry time

`FOLLOW_TARGET`
- target relative position vector in an agreed local frame
- target relative velocity when available
- perception confidence
- observation timestamp

`ATTENTION_TARGET`
- direction/subject BUDDY should visually attend to when this does not conflict with flight safety

`AUDIO_EVENT`
- speech/audio payload reference or playback command
- priority below all flight-safety operations

## Aircraft -> phone messages

`STATE`
- current safety-supervisor mode
- attitude/velocity summary
- tracking state
- command age

`HEALTH`
- battery voltage/current/state estimate
- sensor health
- actuator saturation flags
- propulsion/ESC fault flags where supported
- thermal warnings where supported

`PERCEPTION_SAFETY`
- obstacle/separation warning
- avoidance active
- follow target rejected or clamped

## Hard interface rules
1. No phone message contains raw motor PWM or unrestricted motor RPM commands.
2. No phone command bypasses onboard attitude/thrust/safety limits.
3. Every motion request expires; stale commands are rejected.
4. Loss of heartbeat transitions airborne behavior toward onboard HOVER/BRAKE/LAND policy, not uncontrolled continuation.
5. Conversational/audio work may be dropped or delayed whenever flight compute/power/safety requires it.
6. Follow-target confidence is data, not authority: onboard safety can reject a high-confidence target.

## Timing classes
- Flight stabilization: onboard hard real-time domain.
- Obstacle/emergency supervision: onboard low-latency domain.
- Follow target updates: bounded high-level command domain.
- Conversation, memory, semantic reasoning: phone/non-real-time domain.

Exact update rates and timeout values remain provisional until the flight controller, sensors, radio link, and phone transport are selected and measured.
