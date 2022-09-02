use <MotorModel.scad>

renderMode = 0; //[0:render, 1: cutoff -X, 2: cuttof -Y, 3: collisions]

hMirrorBallRotator = 180;

hHangerHorizontal = 12.24;
hHanger = 21.2;
wHangerEarGap = 8.9;
dHanger = 1.9;
dHangRing = 30;
wHangRing = 3 ;

dTube = 15;

hBatteryHolder = 78;

hGap = 23;

hMotor = 57;
dMotor = 47.5;
lWall = 0.8;
lSpace = 1.5;

module endOfParameters() {};

cadFix = 0.005;
module cadOffset(n=1) {
    translate([0, 0, - cadFix * n]) children();
}

$fn = 120;

RENDER = 0;
CUTOFF_X = 1;
CUTOFF_Y = 2;
COLLISION = 3;

wHangerEar = wHangerEarGap + 2 * dHanger;
dCupHollow = dMotor + 2 * lSpace;
dCup = dCupHollow + 2 * lWall;
hCupHollow = hMotor + hGap + hBatteryHolder + hHanger - dHanger + dHangRing - wHangRing;
hCup = hCupHollow + lWall;

module cup() {
    difference() {
        cylinder(hCup, d = dCup);
        cadOffset()
        cylinder(hCupHollow + cadFix, d = dCupHollow);
    }
}
module tubeBore() {
    translate([0, dCup, hCupHollow - (dHangRing + dTube) / 2])
        rotate([90, 0, 0])
            cylinder(2 * dCup, d = dTube);
}

module protectorCup() {
    difference() {
        cup();
        tubeBore();
        if (renderMode == CUTOFF_X) {
            translate([- 2 * dCup, - dCup, - dCup * .5])
                cube([2 * dCup, 2 * dCup, 2 * hCup]);
        }
        if (renderMode == CUTOFF_Y) {
            translate([- dCup, - 2 * dCup, - dCup * .5])
                cube([2 * dCup, 2 * dCup, 2 * hCup]);
        }
    }
}
if(renderMode == COLLISION) {
    color("red", 0.5)
        intersection () {
          protectorCup();
          cadOffset(13) mirrorBallMotor();
        }
    color("grey", 0.2)        protectorCup();
} else {
    protectorCup();
}
if(renderMode != RENDER) {
    color("blue", 0.2 ) mirrorBallMotor();
}
