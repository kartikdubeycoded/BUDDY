/* BUDDY FILE 55 - STAGE 1 PRINT / INTERFACE PARAMETERS
All dimensions mm. Values marked PROCESS are starting points for calibration coupons. */
B1_OD=115; B1_CAVITY_D=111; B1_AIRWAY_D=70; B1_DUCT_OD=74;
B1_SHELL_R=B1_OD/2; B1_CAVITY_R=B1_CAVITY_D/2;
B1_WALL=2.0; B1_MIN_RIB=2.2; B1_MIN_WEB=1.2;
B1_FDM_SLIDE=0.30;       // PROCESS: per side, calibrate
B1_FDM_PRESS=0.10;       // PROCESS: per side, calibrate
B1_INSERT_OD=3.2;        // PLACEHOLDER for M2-class heat-set insert; replace from selected insert drawing
B1_M2_CLEAR=2.4;         // PROCESS starting clearance
B1_M2_HEAD=4.3;          // PLACEHOLDER head pocket
B1_M2_HEAD_H=1.8;
B1_POLAR_OPENING_D=74.8;
B1_CAMERA_DUCT_GAP=0.8; B1_CAMERA_SHELL_MARGIN=1.0;
B1_ROTOR_NOMINAL_R=34.6; B1_ROTOR_STATIC_RADIAL_GAP=B1_AIRWAY_D/2-B1_ROTOR_NOMINAL_R;
assert(B1_OD==115); assert(B1_CAVITY_D==111); assert(B1_AIRWAY_D==70);
assert(B1_POLAR_OPENING_D>B1_DUCT_OD);
assert(B1_ROTOR_STATIC_RADIAL_GAP>0);
echo("FILE55 Stage1 architecture OD/cavity/airway =",B1_OD,B1_CAVITY_D,B1_AIRWAY_D);
echo("PROCESS tolerances require calibration before production prints");
