dMotor = 47.5;
hMotor = 57;

dGap = 44.4;
hGap = 23;
wGapClamp = 11;
hGapClampOverlap = 12.7;

dBattery = 40.7;
hBattery = 78;

hHanger = 21.2;
hHangerHorizontal = 12.3;
dHanger = 1.9;
hHangerOverlap = 15;
wHanger = 44.4;
wHangerEar = 12.7;

lMount = 10;
wMount = 14;
hMount = 10;

hSwitchSocket = 22;
wSwitchSocket = 9.8;
lSwitchSocket = 1.5;
hSwitch = 7.6;
wSwitch = 3.7;
lSwitch = 2.6;
hSwitchSocketPosition = 11.6;
aSwitchSocketPosition = 0;

module endOfParameters() {};

cadFix = 0.005;
module cadOffset(n=1) {
    translate([0, 0, - cadFix * n]) children();
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

    rotate([0, 0, 90])
    translate([dMotor / 2 - lBridgeToMotor, - wSwitchSocket / 2, hSwitchSocketPosition])
        socketWithLever();
}

module motor() {
    cylinder(hMotor, d = dMotor);
    mount(0);
    mount(- 180);
    switch();
}

module gap() {
    hGapClampCad = hGap + hGapClampOverlap + 2 * cadFix;
    lMask = dMotor;
    wMask = dGap / 2;
    hMask = hGapClampCad+ 2* cadFix;
    cadOffset()
        difference() {
            cylinder(hGapClampCad, d = dGap);
            cadOffset() cylinder(hGapClampCad , d = dBattery);
            translate([-lMask/2, wGapClamp/2, -cadFix])
                cube([lMask, wMask, hMask]);
            translate([-lMask/2, - wGapClamp/2 -wMask, -cadFix])
                cube([lMask, wMask, hMask]);
        }
}

module battery() {
    cylinder(hBattery, d = dBattery);
}

module hanger() {
    shape = [
            [0, 0],
            [0, hHangerOverlap + hHangerHorizontal],
            [(wHanger - wHangerEar) / 2, hHangerOverlap + hHangerHorizontal],
            [(wHanger - wHangerEar) / 2, hHangerOverlap + hHanger],
            [(wHanger + wHangerEar) / 2, hHangerOverlap + hHanger],
            [(wHanger + wHangerEar) / 2, hHangerOverlap + hHangerHorizontal],
            [wHanger, hHangerOverlap + hHangerHorizontal],
            [wHanger, 0],
            [wHanger - dHanger, 0],
            [wHanger - dHanger, hHangerOverlap + hHangerHorizontal - dHanger],
            [(wHanger + wHangerEar) / 2 - dHanger, hHangerOverlap + hHangerHorizontal - dHanger],
            [(wHanger + wHangerEar) / 2 - dHanger, hHangerOverlap + hHanger - dHanger],
            [(wHanger - wHangerEar) / 2 + dHanger, hHangerOverlap + hHanger - dHanger],
            [(wHanger - wHangerEar) / 2 + dHanger, hHangerOverlap + hHangerHorizontal - dHanger],
            [dHanger, hHangerOverlap + hHangerHorizontal - dHanger],
            [dHanger, 0]
        ];
    translate([- wHanger / 2, dHanger / 2, - hHangerOverlap])
        rotate([90, 0, 0])
            linear_extrude(dHanger) {polygon(shape);}
}

module mirrorBallMotor() {
    motor();
    lift(hMotor) gap();
    lift(hMotor + hGap) battery();
    lift(hMotor + hGap + hBattery) hanger();
}

//mirrorBallMotor();
