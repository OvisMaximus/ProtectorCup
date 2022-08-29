dMotor = 47.5;
hMotor = 57;

dGap = 44.4;
hGap = 23;

dBattery = 40.7;
hBattery = 78;

hHanger = 21.2;
hHangerHor = 12.3;
dHanger = 1.9;
hHangerOverlap = 15;
wHanger = 44.4;
wHangerEar = 12.7;

lMount = 10;
wMount = 14;
hMount = 10;

hSwitchSocket = 22;
wSwitchSocket = 10; // guess
lSwitchSocket = 2;//guess
hSwitch = 7.5;
wSwitch = 4;//guess
lSwitch = 4;//guess
hSwitchSocketPosition = 16; // guess
aSwitchSocketPosition = 0; //guess


module endOfParameters() {};

cadFix = 0.005;
module cadOffset() {
    translate([0, 0, - cadFix]) children();
}

module lift(h) {
    translate([0, 0, h]) children();
}

$fn = 120;

module mount(aHorizontal) {
    lDistanceFromCenter = dMotor / 2;
    lBridgeToMotor = lMount;
    lMountWithBridgeToMotor = lMount + lBridgeToMotor;
    rotate([0, 0, aHorizontal])
        translate([lDistanceFromCenter - lBridgeToMotor, - wMount / 2, 0])
            cube([lMountWithBridgeToMotor, wMount, hMount]);
}

module switch() {
    lBridgeToMotor = lSwitchSocket;
    module socketWithLever() {
        lSocketModel = lBridgeToMotor + lSwitchSocket;
        cube([lSocketModel, wSwitchSocket, hSwitchSocket]);
        translate([lSocketModel - cadFix,
                (wSwitchSocket - wSwitch) / 2, (hSwitchSocket - hSwitch) / 2])
            cube([lSwitch + cadFix, wSwitch, hSwitch]);
    }

    translate([dMotor / 2 - lBridgeToMotor, - wSwitchSocket / 2, hSwitchSocketPosition])
        socketWithLever();
}

module motor() {
    cylinder(hMotor, d = dMotor);
    mount(90);
    mount(- 90);
    switch();
}

module gap() {
    cadOffset() cylinder(hGap + 2 * cadFix, d = dGap);
}

module battery() {
    cylinder(hBattery, d = dBattery);

}

module hanger() {
    shape = [
            [0, 0],
            [0, hHangerOverlap + hHangerHor],
            [(wHanger - wHangerEar) / 2, hHangerOverlap + hHangerHor],
            [(wHanger - wHangerEar) / 2, hHangerOverlap + hHanger],
            [(wHanger + wHangerEar) / 2, hHangerOverlap + hHanger],
            [(wHanger + wHangerEar) / 2, hHangerOverlap + hHangerHor],
            [wHanger, hHangerOverlap + hHangerHor],
            [wHanger, 0],
            [wHanger - dHanger, 0],
            [wHanger - dHanger, hHangerOverlap + hHangerHor - dHanger],
            [(wHanger + wHangerEar) / 2 - dHanger, hHangerOverlap + hHangerHor - dHanger],
            [(wHanger + wHangerEar) / 2 - dHanger, hHangerOverlap + hHanger - dHanger],
            [(wHanger - wHangerEar) / 2 + dHanger, hHangerOverlap + hHanger - dHanger],
            [(wHanger - wHangerEar) / 2 + dHanger, hHangerOverlap + hHangerHor - dHanger],
            [dHanger, hHangerOverlap + hHangerHor - dHanger],
            [dHanger, 0]
        ];
    translate([- wHanger / 2, dHanger / 2, - hHangerOverlap])
        rotate([90, 0, 0])
            linear_extrude(dHanger) {polygon(shape);}
}

module mirrorBallMotor() {
    motor();
    lift(hMotor)
    gap();
    lift(hMotor + hGap)
    battery();
    lift(hMotor + hGap + hBattery)
    hanger();
}

mirrorBallMotor();
