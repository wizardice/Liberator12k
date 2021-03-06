include <../../Meta/Animation.scad>;

use <../../Meta/Manifold.scad>;
use <../../Meta/Units.scad>;
use <../../Meta/Debug.scad>;
use <../../Meta/Resolution.scad>;
use <../../Meta/RenderIf.scad>;

use <../../Meta/Math/Triangles.scad>;

use <../../Shapes/Components/Cylinder Redux.scad>;
use <../../Shapes/Components/Pump Grip.scad>;

use <../Lower/Lower.scad>;
use <../Lower/Trigger.scad>;

use <../../Shapes/Chamfer.scad>;

use <../../Shapes/Bearing Surface.scad>;
use <../../Shapes/Teardrop.scad>;
use <../../Shapes/TeardropTorus.scad>;
use <../../Shapes/Semicircle.scad>;
use <../../Shapes/ZigZag.scad>;

use <../../Vitamins/Nuts And Bolts.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Metric.scad>;
use <../../Vitamins/Nuts and Bolts/BoltSpec_Inch.scad>;
use <../../Vitamins/Rod.scad>;

use <../../Ammo/Shell Slug.scad>;

use <../Receiver.scad>;
use <../Linear Hammer.scad>;
use <../Recoil Plate.scad>;
use <../Charging Pump.scad>;
use <../Lugs.scad>;
use <../Frame.scad>;

/* [What to Render] */

// Configure settings below, then choose a part to render. Render that part (F6) then export STL (F7). Assembly is not for printing.
_RENDER = "Assembly"; // ["Assembly", "FrameSpacer", "RevolverReceiverFront", "Crane", "CraneShield", "CraneSupport", "CraneLatch", "Foregrip", "RevolverZigZagCylinder"]
//$t = 1; // [0:0.01:1]

_CUTAWAY_RECEIVER = true;
_ALPHA_RECEIVER_TUBE = 1; // [0:0.1:1]
_ALPHA_RECEIVER_COUPLING = 1;  // [0:0.1:1]

_SHOW_RECEIVER_FRONT = true;
_ALPHA_RECEIVER_FRONT = 1;   // [0:0.1:1]

_SHOW_FOREND = true;
_CUTAWAY_FOREND = false;
_ALPHA_FOREND = 1;  // [0:0.1:1]

_SHOW_CYLINDER = true;
_CUTAWAY_CYLINDER = false;
_ALPHA_CYLINDER = 1; // [0:0.1:1]

_SHOW_CRANE = true;
_ALPHA_CRANE = 1; // [0:0.1:1]
_CUTAWAY_CRANE = false;

_SHOW_EXTRACTOR = true;
_ALPHA_EXTRACTOR = 1; // [0:0.1:1]
_CUTAWAY_EXTRACTOR = false;

_SHOW_LATCH = true;
_ALPHA_LATCH = 1; // [0:0.1:1]
_CUTAWAY_LATCH = false;

_SHOW_BARREL = true;
_SHOW_FRAME = true;
_ALPHA_RECOIL_PLATE_HOUSING=1; // [0:0.1:1]


BARREL_DIAMETER = 1;
BARREL_CLEARANCE = 0.01;

// Settings: Lengths
function ShellRimLength() = 0.06;
function ChamberLength() = 3;
function BarrelLength() = 18-ChamberLength();
function ActuatorPretravel() = 0.125;
function ForendGasGap() = 1.5;
function RevolverSpindleOffset() = BARREL_DIAMETER+0.125 + ManifoldGap();
function WallBarrel() = 0.375;
function WallSpindle() = 0.25;

function ChamferRadius() = 1/16;
function CR() = 1/16;


// Settings: Vitamins
// ZigZag Cylinder
function CylinderRod() = Spec_RodFiveSixteenthInch();
function SpindleCollarWidth() = 0.32;
function SpindleCollarDiameter() = 0.63;
function SpindleCollarRadius() = SpindleCollarDiameter()/2;

function CranePivotRod() = Spec_RodFiveSixteenthInch();
function CraneBolt() = Spec_BoltFiveSixteenths();
function CraneLatchBolt() = Spec_BoltM4();

// Shorthand: Measurements
function BarrelRadius(clearance=0)
    = (BARREL_DIAMETER+clearance)/2;

function BarrelDiameter(clearance=0)
    = (BARREL_DIAMETER+clearance);

function BarrelCollarDiameter() = 1 + (5/8);
function BarrelCollarRadius() = BarrelCollarDiameter()/2;
function BarrelCollarWidth() = (5/8);


// Calculated: Lengths

function FrameBoltLength() = 10;
function ReceiverFrontLength() = 0.5;
function ReceiverBackLength() = 0.5;
function ForendLength() = FrameExtension(length=FrameBoltLength())
                        -ReceiverFrontLength()
                        -ReceiverBackLength();
                        
function ForendFrontLength() = ForendLength()
                             - ChamberLength()
                             - ForendGasGap();


// Calculated: Positions
function ForendMaxX() = ForendLength();
function ForendMinX() = ForendMaxX()-ForendFrontLength();

function BarrelCollarMinX() = ForendMinX()-BarrelCollarWidth();

function RecoilPlateTopZ() = ReceiverOR()
                           + FrameBoltDiameter()
                           + (WallFrameBolt()*2);

// Crane
function CranePivotAngle() = 90;
function WallCrane() = 0.25;

function CranePivotRadius(clearance=0)
    = BoltRadius(CraneBolt(), clearance);
function CranePivotDiameter(clearance=0)
    = BoltDiameter(CraneBolt(), clearance);


function CraneLatchTravel() = BarrelCollarWidth();
function CraneLatchLength() = CraneLatchTravel()+(WallBarrel()*sqrt(2));
function CraneLatchHandleWall() = 0.125;
function CraneLatchGuideWidth() = 0.25;
function CraneLatchHandleZ() = -(RevolverSpindleOffset()*2);
function CraneLatchHandleMaxZ() = -RevolverSpindleOffset()
                                  -(SpindleCollarRadius()+WallCrane());

function CraneLengthFront() = 0.5;
function CraneLengthRear() = 0.5;
function CraneLength() = CraneLengthFront()
                       + CraneLengthRear()
                       + ForendFrontLength()
                       + BarrelCollarWidth();
function CraneMaxX() = ForendMaxX()
                     + CraneLengthFront();
function CraneMinX() = CraneMaxX()-CraneLength();

function CranePivotY() =  1.09375; //FrameBoltY()+(3/32);
function CranePivotZ() =  0.4525; //FrameBoltZ()-(15/16);

function CranePivotHypotenuse() = pyth_A_B(CranePivotY(), CranePivotZ());
function CranePivotPinAngle() = CranePivotHypotenuse()*asin(CranePivotZ());

function CraneLatchMinX() = CraneMaxX();
function CraneLatchMaxX() = CraneLatchMinX()+CraneLatchLength();


// Pivot modules
module CranePivotPath(clearance=0.005, $fn=Resolution(30,90)) {

    //
    // Pivot Paths (mirrored for ambidexterity)
    // XDL = MaxX, Diameter, Length
    for (M = [0,1]) mirror([0,M,0])
    for (XDL = [[CraneLatchMaxX(),
                 BarrelDiameter(BARREL_CLEARANCE),
                 CraneLatchMaxX()],
                [ForendMaxX()+clearance,
                 BarrelCollarDiameter()+(clearance*2),
                 ForendFrontLength()+BarrelCollarWidth()+(clearance*2)]])
      translate([XDL[0]+ManifoldGap(),CranePivotY(),CranePivotZ()])
      rotate([0,-90,0])
      linear_extrude(height=XDL[2])
      semidonut(major=(CranePivotHypotenuse()*2)+XDL[1],
                minor=(CranePivotHypotenuse()*2)-XDL[1],
                angle=90+(CranePivotPinAngle()/2)+5); // TODO: Why is this off by 5 degrees?
}
module CranePivotPosition(angle=CranePivotAngle(), factor=1) {
  translate([0,CranePivotY(),CranePivotZ()])
  rotate([angle*factor,0,0])
  translate([0,-CranePivotY(),-CranePivotZ()])
  children();
}


// Vitamins
module Barrel(barrelLength=BarrelLength(),
              clearance=undef, cutter=false,
              alpha=1, debug=false) {

  clear = (cutter ? 0.005 : 0);
  clear2 = clear*2;

  color("Silver", alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  translate([ChamberLength()+ShellRimLength(),0,0])
  rotate([0,90,0])
  cylinder(r=BarrelRadius(), h=barrelLength, $fn=Resolution(20,50));

  // Rear Shaft Collar
  color("DimGrey", alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  translate([ForendMinX(),0,0])
  rotate([0,-90,0])
  cylinder(r=BarrelCollarRadius()+clear,
           h=BarrelCollarWidth()+ManifoldGap(), $fn=Resolution(30,80));

  // Front Shaft Collar
  color("DimGrey", alpha) DebugHalf(enabled=debug) RenderIf(!cutter)
  translate([CraneMaxX()-ManifoldGap(),0,0])
  rotate([0,90,0])
  cylinder(r=BarrelCollarRadius()+clear,
           h=BarrelCollarWidth()+clear+ManifoldGap(), $fn=Resolution(30,80));
}

module RevolverSpindle(teardrop=false, cutter=false, clearance=0.01) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  color("Silver") RenderIf(!cutter)
  translate([RecoilPlateRearX(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  Rod(CylinderRod(),
      length=CraneLatchMaxX()-RecoilPlateRearX()
            +ManifoldGap(3),
      clearance=cutter?RodClearanceSnug():undef,
      teardrop=cutter&&teardrop);


  // Rearward shaft collar
  color("SteelBlue")
  translate([ManifoldGap(),0,-RevolverSpindleOffset()])
  rotate([0,90,0])
  cylinder(r=SpindleCollarRadius()+clear,
           h=SpindleCollarWidth(),
           $fn=Resolution(20,50));

  // Forward shaft collar
  color("SteelBlue")
  translate([CraneLatchMaxX()+ManifoldGap(),0,-RevolverSpindleOffset()])
  rotate([0,-90,0])
  cylinder(r=SpindleCollarRadius()+clear,
           h=SpindleCollarWidth(), $fn=Resolution(20,50));
}

module CranePivotPin(cutter=false, teardrop=false, clearance=0.005) {
  color("Silver") RenderIf(!cutter)
  translate([CraneMaxX()+ManifoldGap(),CranePivotY(),CranePivotZ()])
  rotate([0,-90,0])
  NutAndBolt(bolt=CraneBolt(), head="hex",
             boltLength=CraneLength()
                       +ManifoldGap(2),
             clearance=cutter?clearance:0,
             nutHeightExtra=cutter?CraneLengthRear():0,
             teardrop=teardrop&&cutter);
}



// Printed Parts
module RevolverReceiverFront(debug=false, alpha=_ALPHA_RECEIVER_FRONT) {
  length = abs(RecoilPlateRearX());
  
  color("YellowGreen", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    translate([RecoilPlateRearX(),0,0])
    union() {
      
      translate([0,0,-0.0625])
      FrameSupport(length=length,
                   height=((FrameBoltRadius()+WallFrameBolt())*2)+0.125);
        
      ReceiverCouplingPattern(length=length, frameLength=length);

      // Backing plate for the cylinder
      translate([0,0,-RevolverSpindleOffset()])
      rotate([0,90,0])
      ChamferedCylinder(r1=(BarrelRadius()*3)+(CR()*2), r2=CR(),
               h=length-ManifoldGap(), $fn=Resolution(80, 200));
    }
    
    FrameBolts(cutter=true);

    RecoilPlate(cutter=true);

    RecoilPlateFiringPinAssembly(cutter=true);

    translate([RecoilPlateThickness(),0,0])
    ChargingRod(clearance=RodClearanceSnug(), cutter=true);

    RevolverSpindle(cutter=true);
  }
}


module CraneLatch(cutter=false, clearance=0.005,
                  alpha=1, debug=false, $fn=Resolution(20,80)) {
    clear = clearance;
    clear2 = clear*2;

  color("BurlyWood", alpha)
  DebugHalf(enabled=debug) RenderIf(!cutter)
  difference() {
      union() {
        hull() {

          // Square the top
          translate([CraneLatchMinX(),
                     -BarrelCollarRadius()-(WallBarrel()/2),0])
          ChamferedCube([BarrelCollarWidth(),
                        BarrelCollarDiameter()+WallBarrel(),
                        RevolverSpindleOffset()+BarrelRadius()],
                        r=CR(),
                            $fn=Resolution(20,40));

          // Square the top front
          translate([CraneLatchMinX()+BarrelCollarWidth(),
                     -BarrelCollarRadius(),0])
          ChamferedCube([CraneLatchLength()-BarrelCollarWidth(),
                        BarrelCollarDiameter(),
                        RevolverSpindleOffset()+BarrelRadius()],
                        r=CR(),
                            $fn=Resolution(20,40));

          // Around the barrel collar
          translate([CraneLatchMinX(),0,0])
          rotate([0,90,0])
          ChamferedCylinder(r1=BarrelCollarRadius()+WallBarrel(), r2=CR(),
                   h=BarrelCollarWidth(),
                   $fn=Resolution(30,60));

          // In front of the barrel collar, narrow tapered portion
          translate([CraneLatchMaxX(),0,0])
          rotate([0,-90,0])
          ChamferedCylinder(r1=BarrelCollarRadius(), r2=CR(),
                   h=WallBarrel(),                   $fn=Resolution(30,60));
      }

      hull() {

        // Around the spindle
        translate([CraneLatchMinX(),0,-RevolverSpindleOffset()])
        rotate([0,90,0])
        ChamferedCylinder(r1=SpindleCollarRadius()+WallSpindle(), r2=CR(),
                          h=CraneLatchLength());

        // Guide block straight segment
        translate([CraneLatchMinX(),-(CraneLatchGuideWidth()/2)-clear,CraneLatchHandleMaxZ()])
        ChamferedCube([CraneLatchLength(),
                       CraneLatchGuideWidth()+clear2,
                       abs(CraneLatchHandleMaxZ())],
                      r=CR());

        // Guide Block Cover
        translate([CraneLatchMinX(),
                   -(CraneLatchGuideWidth()/2)-CraneLatchHandleWall(),
                   CraneLatchHandleMaxZ()-clear])
        ChamferedCube([BarrelCollarWidth(),
              CraneLatchGuideWidth()+(CraneLatchHandleWall()*2),
              abs(CraneLatchHandleMaxZ())+clear],
              r=CR());
      }
    }

    // Barrel collar chamfer
    translate([CraneLatchMinX(),0,0])
    rotate([0,90,0])
    HoleChamfer(r1=BarrelCollarRadius()+clearance, r2=CR()*2,
                teardrop=true);

    // Barrel chamfer
    translate([CraneLatchMaxX()+ManifoldGap(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=(BARREL_CLEARANCE*2)),
                                               r2=CR(), h=CraneLatchLength()-BarrelCollarWidth());

    CranePivotPath();

    Barrel(cutter=true, clearance=BARREL_CLEARANCE);

    RevolverSpindle(cutter=true);
  }
}

module CraneLatch_print() {
  rotate([0,90,0]) translate([-CraneLatchMaxX(),0,0])
  CraneLatch();
}

module Crane(cutter=false, teardrop=false, clearance=0.005,
                     $fn=Resolution(30,100), alpha=1, debug=false) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+clearance;

  color("OliveDrab", alpha)
  DebugHalf(enabled=debug) RenderIf(!cutter)
  difference() {
    union() {
      hull() {

        // Around the crane pivot rods
        for (Y = [1,-1])
        translate([CraneMinX(),CranePivotY()*Y,CranePivotZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=CR(),
                 h=CraneLength());

        // Body around the barrel
        difference() {
          intersection() {
            translate([CraneMinX(),0,0])
            rotate([0,90,0])
            ChamferedCylinder(r1=CranePivotY()+CranePivotRadius()+WallCrane(), r2=CR(),
                     h=CraneLength());

            translate([CraneMinX(),0,0])
            rotate([0,90,0])
            rotate(90)
            linear_extrude(height=CraneLength())
            semidonut(major=(CranePivotY()+CranePivotRadius()+WallCrane())*2,
                      minor=BarrelDiameter(),
                      angle=180);
          }
        }

        // Flat-top fills in, and gets trimmed down for the pivot path
        translate([CraneMinX(),0,CranePivotZ()])
        ChamferedCube([CraneLength(),
                       abs(CranePivotY()),
                       CranePivotRadius()+WallCrane()],
                       r=CR(),$fn=20);
      }

      // Guide Block Cover
      translate([CraneMinX(),
                 -(CraneLatchGuideWidth()/2)-CraneLatchHandleWall(),
                 CraneLatchHandleMaxZ()])
      ChamferedCube([CraneLength(),
            CraneLatchGuideWidth()+(CraneLatchHandleWall()*2),
            abs(CraneLatchHandleMaxZ())],
            r=CR());
    }

    // Forend clearance (Crane Supports)
    translate([ForendMinX()-0.005+ManifoldGap(),
               -CranePivotY()-(pivotCutterRadius*2),
                CranePivotZ()-(pivotCutterRadius)])
    cube([ForendFrontLength()+0.01,
          (CranePivotY()+pivotCutterRadius*2)*2,
          (pivotCutterRadius)*3]);

    // Forend + Rear Barrel Collar clearance
    translate([ForendMaxX()+clearance+ManifoldGap(), 0, 0])
    rotate([0,-90,0])
    cylinder(r=BarrelCollarRadius()+clearance,
             h=ForendFrontLength()+BarrelCollarWidth()+(clearance*2));

    // Chamfered Barrel Cutout: Front
    translate([CraneMaxX()+ManifoldGap(),0,0])
    rotate([0,-90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=(BARREL_CLEARANCE*2)),
                                               r2=CR(), h=CraneMaxX()-ForendMaxX());

    // Chamfered Barrel Cutout: Rear
    translate([ManifoldGap(),0,0])
    translate([CraneMinX(),0,0])
    rotate([0,90,0])
    ChamferedCircularHole(r1=BarrelRadius(clearance=(BARREL_CLEARANCE*2)),
                                                   r2=CR(), h=CraneLengthRear());

    CranePivotPath();

    for (M = [0,1]) mirror([0,M,0]) // Ambidexterity mirror
    CranePivotPin(cutter=true);

    RevolverSpindle(cutter=true);

    *Barrel(cutter=true, clearance=BARREL_CLEARANCE);
  }
}

module Crane_print() {
  rotate(90) rotate([0,-90,0]) translate([-CraneMinX(),0,0])
  Crane();
}

module CraneShield(cutter=false, clearance=0.006,
                     debug=false, $fn=Resolution(30,100), alpha=1) {
  clear = cutter ? clearance : 0;
  clear2 = clear*2;

  pivotCutterRadius = RodRadius(CylinderRod())+WallCrane()+0.005;
  craneRadius = CranePivotY()+CranePivotRadius()+WallCrane();
  cylinderMaxX = 2.75+ShellRimLength();

  color("OliveDrab", alpha) DebugHalf(enabled=debug)  RenderIf(!cutter)
  difference() {
    union() {

      // Around cylinder
      difference() {
        translate([CraneMinX(),0,-RevolverSpindleOffset()])
        rotate([0,-90,0])
        ChamferedCylinder(r1=1.875, r2=CR(),
                          h=CraneMinX()-cylinderMaxX-0.005);

        // Cutout for chambers
        translate([0,0,-RevolverSpindleOffset()])
        rotate([0,90,0])
        ChamferedCylinder(r1=RevolverSpindleOffset()+BarrelRadius()+(CR()/2), r2=1/64,
        h=ChamberLength()+ShellRimLength()+0.005);
      }
    }

    RevolverSpindle(cutter=true);

    Barrel(cutter=true, clearance=(BARREL_CLEARANCE*2));

    CranePivotPath();

    rotate([0,90,0])
    rotate(180)
    linear_extrude(height=CraneMinX()+ManifoldGap())
    difference() {
    translate([-BarrelRadius(),0,0])
      semidonut(major=6, minor=BarrelDiameter(),
                angle=130, center=true);

      translate([-BarrelDiameter(),0])
      for (R = [-60,0,60]) rotate(R)
      translate([BarrelDiameter(),0])
      circle(r=0.505);
    }
  }
}

module CraneShield_print() {
  rotate([0,90,0]) translate([-CraneMinX(),0,0])
  CraneShield();
}

module CraneSupport(debug=false, alpha=1, $fn=Resolution(30,100)) {

  // Forward plate
  color("DarkOliveGreen", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    union() {

      // Around the barrel
      translate([ForendMaxX(),0,0])
      rotate([0,-90,0])
      ChamferedCylinder(r1=BarrelCollarRadius(), r2=CR(),
               h=ForendFrontLength());

      // Join the barrel to the frame
      for (M = [0,1]) mirror([0,M,0])
      translate([ForendMaxX(),0,0])
      translate([0,BarrelCollarRadius(),
                 CranePivotZ()-WallCrane()-CranePivotRadius()])
      rotate([0,-90,0])
      Fillet(r=CR(), h=ForendFrontLength(),
                     inset=true, taperEnds=true);

    // Crane Pivot Supports
    translate([ForendMinX(),0,0])
    hull() {

        // Around the upper bolts
        FrameSupport(length=ForendFrontLength());

        // Around the crane pivot pin
        for (M = [0,1]) mirror([0,M,0])
        translate([0,CranePivotY(),CranePivotZ()])
        rotate([0,90,0])
        ChamferedCylinder(r1=CranePivotRadius()+WallCrane(), r2=CR(),
                           h=ForendFrontLength());
      }
    }

    // Cutout for a picatinny rail insert
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.0625])
    cube([FrameExtension()+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);

    Barrel(clearance=BARREL_CLEARANCE);

    ChargingRod(cutter=true);

    RevolverSpindle(cutter=true);

    for (M = [0,1]) mirror([0,M,0])
    CranePivotPin(cutter=true);
  }
}

module CraneSupport_print() {
  rotate([0,-90,0]) translate([-ForendMinX(),0,0])
  CraneSupport();
}

module FrameSpacer(length=4.5, debug=false, alpha=1) {
  color("Tan", alpha)
  DebugHalf(enabled=debug) render()
  difference() {
    translate([0,0,-0.0625])
    FrameSupport(length=length,
                 height=((FrameBoltRadius()+WallFrameBolt())*2)+0.125);

    // Picatinny rail cutout
    translate([-ManifoldGap(), -UnitsMetric(15.6/2), FrameTopZ()-0.0625])
    cube([length+ManifoldGap(2), UnitsMetric(15.6), 0.25]);

    FrameBolts(cutter=true);
    
    ChargingRod(cutter=true);
  }
}

module FrameSpacer_print() {
  rotate([0,-90,0])
  translate([0,0,-FrameBoltZ()])
  FrameSpacer();
}


module RevolverReceiverFront_print() {
  rotate([0,-90,0]) translate([-RecoilPlateRearX(),0,0])
  RevolverReceiverFront();
}


module RevolverZigZagCylinder(supports=true, chambers=false,
                             chamberBolts=false,
                             debug=_CUTAWAY_CYLINDER, alpha=_ALPHA_CYLINDER) {                               
  OffsetZigZagRevolver(
      centerOffset=RevolverSpindleOffset(),
      chamberRadius=BarrelRadius(), chamberClearance=BARREL_CLEARANCE,
      chamberInnerRadius=0.81/2,
      zigzagAngle=55, wall=0.1875+0.125,
      extraTop=ActuatorPretravel(),
      supportsBottom=false, supportsTop=supports, chamberBolts=chamberBolts,
      chambers=chambers, chamberLength=ChamberLength(),
      debug=debug, alpha=alpha) {
  
    translate([0,0,-ManifoldGap()])
    cylinder(r=SpindleCollarRadius()+0.005,
             h=2.5+ManifoldGap(2), $fn=60);
  }
}


module RevolverZigZagCylinder_print() {
  translate([0,0,2.75])
  rotate([0,180,0])
  RevolverZigZagCylinder(supports=true);
}

// Assemblies
module RevolverForendAssembly(stock=true,
                               pipeAlpha=1, debug=false) {

  if (_SHOW_RECEIVER_FRONT)
  translate([0,0,0]) {
    RevolverReceiverFront(debug=debug);
    RecoilPlateFiringPinAssembly(debug=debug);
    RecoilPlate(debug=debug);
  }

  translate([0,0,0]) {

    ChargingPumpAssembly(debug=debug);

    Barrel(debug=debug);

    CraneSupport(debug=debug);
    
    FrameSpacer(debug=debug);

    CranePivotPosition(factor=Animate(ANIMATION_STEP_UNLOAD)
                     -Animate(ANIMATION_STEP_LOAD)) {

      translate([ShellRimLength(),0,0])
      translate([0,0,-RevolverSpindleOffset()])
      rotate([0,90,0])
      rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGER_RESET, start=0.25, end=0.8))
      rotate(-360/6/2*SubAnimate(ANIMATION_STEP_CHARGE, start=0.4, end=0.98)) {
        RevolverZigZagCylinder(supports=false, chambers=true);
      }

      CranePivotPin();
      
      if (_SHOW_CRANE)
      Crane(alpha=_ALPHA_CRANE, debug=_CUTAWAY_CRANE);
      
      if (_SHOW_CRANE)
      CraneShield(alpha=_ALPHA_CRANE, debug=_CUTAWAY_CRANE);

      // Latch
      translate([CraneLatchTravel()*(SubAnimate(ANIMATION_STEP_UNLOCK, end=0.5)
                    -SubAnimate(ANIMATION_STEP_LOCK, start=0.5)),0,0])
      {
          RevolverSpindle();
          CraneLatch(debug=debug);
      }
    }
  }
}

module RevolverFireControlAssembly() {

  translate([FiringPinMinX(),0,0])
  HammerAssembly(insertRadius=0.75, alpha=0.5);

  RecoilPlateFiringPinAssembly();

  RecoilPlate();

  Charger();
}



if (_RENDER == "Assembly") {
    
  translate([-ReceiverFrontLength(),0,0])
  Receiver(debug=_CUTAWAY_RECEIVER,
           pipeAlpha=_ALPHA_RECEIVER_TUBE,
           buttstockAlpha=_ALPHA_RECEIVER_TUBE,

           couplingAlpha=_ALPHA_RECEIVER_COUPLING,
           couplingBoltHead="flat",
           couplingBoltExtension=ReceiverFrontLength(),
           
           frameBolts=_SHOW_FRAME,
           frameBoltLength=FrameBoltLength(),
           frameBoltBackset=ReceiverBackLength(),
  
           triggerAnimationFactor=Animate(ANIMATION_STEP_TRIGGER)
                          -Animate(ANIMATION_STEP_TRIGGER_RESET));

    RevolverForendAssembly(pipeAlpha=0.5, debug=false);

    RevolverFireControlAssembly();

}

scale(25.4) {

  if (_RENDER == "Crane")
  Crane_print();

  if (_RENDER == "CraneShield")
  CraneShield_print();

  if (_RENDER == "CraneSupport")
  CraneSupport_print();

  if (_RENDER == "CraneLatch")
  CraneLatch_print();

  if (_RENDER == "FrameSpacer")
  FrameSpacer_print();

  if (_RENDER == "ReceiverFront")
  ReceiverFront_print();

  if (_RENDER == "RevolverReceiverFront")
  RevolverReceiverFront_print();
  
  if (_RENDER == "RevolverZigZagCylinder")
  RevolverZigZagCylinder_print();
}
