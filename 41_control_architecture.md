# BUDDY Control Architecture V1

## Rule
The paired phone is the cognitive brain, but not the stabilization computer. Flight-critical loops remain onboard so network/phone latency cannot directly destabilize the aircraft.

## Command hierarchy
1. Emergency / hardware protection
2. Collision avoidance and minimum separation
3. Attitude and thrust limits
4. Follow-position controller
5. Phone high-level intent
6. Conversational behavior

A lower-priority layer cannot override a higher-priority safety layer.

## State machine

### DISARMED
Motors inactive. Validate IMU, battery, actuator position, cameras/safety sensors, phone link, and configuration before arming.

### ARMING
Establish attitude reference, verify plausible sensor agreement, confirm unobstructed rotor region, then permit controlled spool-up.

### HOVER
Maintain local position/attitude without requiring continuous phone commands. This is the fallback airborne state.

### FOLLOW
Phone/perception provides a desired relative position to the user. Onboard controller converts the bounded target into acceleration/attitude/thrust requests. Target motion passes through velocity, acceleration, and jerk limits.

### AVOID
Triggered by obstacle/separation risk. Temporarily overrides FOLLOW. Generates a safe local motion or braking target while maintaining stabilization.

### BRAKE
Used when the user moves abruptly, tracking confidence falls, or commanded trajectory becomes unsafe. Reduce relative velocity before selecting a new follow target.

### RETURN_TO_HOVER
Used after temporary command/perception loss. Stop pursuit and hold a safe local state if navigation confidence allows.

### LAND
Controlled descent for low battery, persistent link loss, degraded sensors, excessive uncertainty, or explicit user request.

### EMERGENCY_CUTOFF
Reserved for conditions where continuing powered flight is more dangerous than stopping propulsion. Exact criteria require hardware testing.

## Phone-to-aircraft interface
Allowed high-level messages include desired follow offset, bounded velocity intent, mode request, conversational attention direction, and land request. Raw PWM, raw motor RPM, or unrestricted attitude commands are not part of the companion interface.

## Abrupt human movement
The follower does not mirror the user's instantaneous acceleration. It predicts a short-horizon target, clamps target acceleration and jerk, checks obstacle/separation constraints, then moves. If confidence is poor, BRAKE/HOVER wins over pursuit.

## Required onboard measurements
- 6-axis or 9-axis IMU as selected by the flight-control design.
- Battery voltage/current monitoring.
- Motor/ESC health information where available.
- Local obstacle/proximity information sufficient for emergency braking/avoidance.
- Link heartbeat and command age.

## Validation sequence
SIL simulation -> hardware-in-loop where practical -> restrained propulsion bench -> protected tether/rig testing -> controlled indoor hover area -> follow testing. No human-follow test precedes stable independent hover and emergency-state validation.
