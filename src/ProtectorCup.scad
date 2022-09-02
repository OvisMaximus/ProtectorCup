include <MotorModel.scad>

renderMode = 0; //[0:render, 1: cutoff -X, 2: cuttof -Y, 3: collisions]

dHangRing = 30;
wHangRing = 3 ;

dTube = 15.2;

lWall = 0.8;
lSpace = 1.5;

module endOfParameters() {};

$fn = 300;

RENDER = 0;
CUTOFF_X = 1;
CUTOFF_Y = 2;
COLLISION = 3;

dCupHollow = dMotor + 2 * lSpace;
dCup = dCupHollow + 2 * lWall;
hMotorHangPoint = hMotor + hGap + hBattery + hHanger - 2 * dHanger;
dHangRingInside = dHangRing - 2 * wHangRing;
hCupHollow = hMotorHangPoint + dHangRingInside + 3 * wHangRing;
hCup = hCupHollow + lWall;
zTube = hCupHollow - 2.5 * wHangRing - dTube / 2;

module cup() {

        cylinder(hCup, d = dCup);
}
module hollowCup() {
    cadOffset()
        cylinder(hCupHollow + cadFix, d = dCupHollow);
}
module tube() {
    translate([- dCup, 0, zTube])
        rotate([90, 0, 90])
            cylinder(2 * dCup, d = dTube);
}

module roofedCover(size) {
    hRoof = sqrt(2 * size.x * size.x);
    translate([0,size.y,size.z - cadFix])
        rotate([90, 0,0])
            linear_extrude(size.y)
                polygon([[size.x,0], [0,0], [0,hRoof]]);
    cube(size);
}

module protectorCup() {
    lSwitchSpace = lSwitchSocket + lSwitch + lSpace + lWall;
    lSwitchCover = lWall + lSwitchSpace;
    wSwitchSpace = 2 * lSpace + wSwitchSocket;
    wSwitchCover = 2 * lWall + wSwitchSpace;
    hSwitchSpace = 1.5 * hSwitchSocket + lSpace + hSwitchSocketPosition;
    hSwitchCover = lWall + hSwitchSpace;

    module positionSwitch() {
        translate([wSwitchCover / 2, dCupHollow / 2 - lWall, 0])
            rotate([0, 0, aSwitchSocketPosition + 90])
                children();
    }
    module switchCover() {
                positionSwitch()
                    roofedCover([lSwitchCover, wSwitchCover, hSwitchCover]);
    }
    module switchSpace() {
        positionSwitch()
            translate([-cadFix, lWall, -cadFix])
                roofedCover([lSwitchSpace, wSwitchSpace, hSwitchSpace]);
    }
    lMountSpace = lMount + lSpace + lWall;
    lMountCover = lMountSpace + lWall;
    wMountSpace = wMount + 2*lSpace;
    wMountCover = wMountSpace + 2* lWall;
    hMountSpace = hMount + lSpace + 0.5* hSwitchSocket;
    hMountCover = hMountSpace + lWall;
    module positionMountCover(aPosition) {
         rotate([0, 0, aPosition])
             translate([dCupHollow / 2 -lWall, 0, 0])
                children();
    }
    module mountCover(aPosition) {
        positionMountCover(aPosition)
            translate([-lWall,-wMountCover/2,0])
                roofedCover([lMountCover, wMountCover, hMountCover]);
    }
    module mountSpace(aPosition) {
        positionMountCover(aPosition)
        translate([-cadFix-lWall,-wMountSpace/2,-cadFix])
            roofedCover([lMountSpace, wMountSpace, hMountSpace]);
    }
    module bodySolid() {
        cup();
        switchCover();
        mountCover(0);
        mountCover(180);
    }
    difference() {
        bodySolid();
        hollowCup();
        switchSpace();
        mountSpace(0);
        mountSpace(180);
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
    rRingInside = (dHangRing - wHangRing) / 2;
    translate([0, 0, hMotorHangPoint + rRingInside])
        rotate([0, 90, 0])
            rotate_extrude(angle = 360)
                translate([rRingInside, 0, 0])
                    circle(d = wHangRing);
}

if (renderMode == COLLISION) {
    color("red", 0.5)
        intersection() {
            protectorCup();
            cadOffset(13) mirrorBallMotor();
        }
    color("grey", 0.2)
        protectorCup();
} else {
    protectorCup();
}

if (renderMode != RENDER) {
    color("blue", 0.2) mirrorBallMotor();
    color("gray", 0.2) tube();
    color("gray", 0.2) hangRing();
}
