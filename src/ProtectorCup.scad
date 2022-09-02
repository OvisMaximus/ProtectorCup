include <MotorModel.scad>

renderMode = 0; //[0:render, 1: cutoff -X, 2: cuttof -Y, 3: collisions]

dHangRing = 30;
wHangRing = 3 ;

dTube = 15;

lWall = 0.8;
lSpace = 1.5;

module endOfParameters() {};

$fn = 120;

RENDER = 0;
CUTOFF_X = 1;
CUTOFF_Y = 2;
COLLISION = 3;

dCupHollow = dMotor + 2 * lSpace;
dCup = dCupHollow + 2 * lWall;
hMotorHangPoint = hMotor + hGap + hBattery + hHanger - 2*dHanger;
dHangRingInside = dHangRing - 2 *  wHangRing;
hCupHollow = hMotorHangPoint + dHangRingInside + 3 * wHangRing;
hCup = hCupHollow + lWall;
zTube = hCupHollow - 2.5 * wHangRing - dTube / 2;

module cup() {
    difference() {
        cylinder(hCup, d = dCup);
        cadOffset()
        cylinder(hCupHollow + cadFix, d = dCupHollow);
    }
}
module tube() {
    translate([-dCup, 0, zTube])
        rotate([90, 0, 90])
            cylinder(2 * dCup, d = dTube);
}

module protectorCup() {
    module switchCover() {
        cube([4*lWall + hSwitchSocket, 2*lWall + lSwitchSocket + lSwitch, 1.5 * hSwitchSocket + 2 * lWall]);
    }
    module bodySolid() {
        cup();
        switchCover();
    }
    difference() {
        bodySolid();
        tube();
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

module hangRing() {
    rRingInside = (dHangRing-wHangRing)/2;
    translate([0,0, hMotorHangPoint + rRingInside])
    rotate([0,90,0])
    rotate_extrude(angle=360)
        translate([rRingInside,0,0])
        circle(d=wHangRing);
}

if(renderMode == COLLISION) {
    color("red", 0.5)
        intersection () {
          protectorCup();
          cadOffset(13) mirrorBallMotor();
        }
    color("grey", 0.2)
        protectorCup();
} else {
    protectorCup();
}

if(renderMode != RENDER) {
    color("blue", 0.2 ) mirrorBallMotor();
    color("gray", 0.2 ) tube();
    color("gray", 0.2) hangRing();
}
