use <MotorModel.scad>

renderMode = 0; //[0:render, 1: cutoff -X, 2: cuttof -Y]

hMirrorBallRotator = 180;

hHangerHorizontal = 12.24;
hHanger = 21.2;
wHangerEarGap = 8.9;
dHanger = 1.9;

dTube = 15;

hBatteryHolder = 78;

hGap = 23;

hMotor = 57;
dMotor = 47.5;
lWall = 0.8;
lSpace = 1.5;

module endOfParameters() {};

cadFix = 0.005;
module cadOffset() {
    translate([0, 0, - cadFix]) children();
}

$fn = 120;

wHangerEar = wHangerEarGap + 2 * dHanger;
dCupHollow = dMotor + 2 * lSpace;
dCup = dCupHollow + 2 * lWall;
hCupHollow = hMotor + hGap + hBatteryHolder + hHangerHorizontal;
hCup = hCupHollow + lWall;

module cup() {
    difference() {
        cylinder(hCup, d = dCup);
        cadOffset()
        cylinder(hCupHollow + cadFix, d = dCupHollow);
    }
}
module tubeBore() {
    translate([0, dCup, hCupHollow - dTube / 2])
        rotate([90, 0, 0])
            cylinder(2 * dCup, d = dTube);
}
module hangSlot() {
    lHangerSpace = 0.4;
    ySlot = dHanger + lHangerSpace;
    xSlot = wHangerEar + lHangerSpace;
    cadOffset()
    translate([xSlot / - 2, ySlot / - 2, hCupHollow])
        cube([xSlot, ySlot, lWall + 2 * cadFix]);
}
difference() {
    cup();
    tubeBore();
    hangSlot();
    if (renderMode == 1) {
        translate([- 2 * dCup, - dCup, - dCup * .5])
            cube([2 * dCup, 2 * dCup, 2 * hCup]);
    }
    if (renderMode == 2) {
        translate([- dCup, - 2 * dCup, - dCup * .5])
            cube([2 * dCup, 2 * dCup, 2 * hCup]);
    }
}
if(renderMode != 0) {
    color("blue", 0.2 ) mirrorBallMotor();
}
