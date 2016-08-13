//
// Pipe dimensions
//
PipeInnerDiameter   = 1; // Inner Diameter of pipe, smallest measurement if asymmetrical
PipeOuterDiameter   = 2; // Outer Diameter of pipe, largest measurement if asymmetrical
PipeTaperedDiameter = 3; // Threads are tapered, smallest measurement if asymmetrical
PipeThreadLength    = 4; // Total length of the pipe thread
PipeThreadDepth     = 5; // Depth when fully seated
PipeClearanceSnug   = 6; // Added to the diameter, should not slip (default)
PipeClearanceLoose  = 7; // Added to the diameter, should slide freely
PipeFn              = 8; // Number of sides
PipeWeightPerUnit   = 9;

function PipeClearanceSnug()  = PipeClearanceSnug;
function PipeClearanceLoose() = PipeClearanceLoose;


function PipeClearance(pipe, clearance)     = (clearance != undef) ? lookup(clearance, pipe) : 0;
function PipeOuterDiameter(pipe, clearance) = lookup(PipeOuterDiameter, pipe) + PipeClearance(pipe, clearance);
function PipeInnerDiameter(pipe, clearance) = lookup(PipeInnerDiameter, pipe) + PipeClearance(pipe, clearance);
function PipeOuterRadius(pipe, clearance)   = PipeOuterDiameter(pipe, clearance)/2;
function PipeInnerRadius(pipe, clearance)   = PipeInnerDiameter(pipe, clearance)/2;
function PipeThreadDepth(pipe)              = lookup(PipeThreadDepth, pipe);
function PipeWall(pipe)                     = PipeOuterRadius(pipe) - PipeInnerRadius(pipe);
function PipeFn(pipe, fn)                   = (fn == undef) ? lookup(PipeFn, pipe) : fn;


module Pipe2d(pipe, clearance=PipeClearanceSnug(), hollow=false, $fn=undef) {
  echo("PipeOuterRadius,PipeClearance: ", PipeOuterRadius(pipe=pipe, clearance=clearance), clearance);
  difference() {
    circle(r=PipeOuterRadius(pipe=pipe, clearance=clearance),
         $fn=PipeFn(pipe, $fn));

    if (hollow)
    circle(r=PipeInnerRadius(pipe, clearance),
         $fn=PipeFn(pipe, $fn));
  }
};
module Pipe(pipe, length = 1, clearance=PipeClearanceSnug(), center=false, hollow=false) {
  translate([0,0,center ? -length/2 : 0])
  linear_extrude(height=length)
  Pipe2d(pipe=pipe, clearance=clearance, hollow=hollow);
};

//Pipe(PipeOneInch, clearance=PipeClearanceLoose);


// 1/4" Pipe
PipeOneQuarterInch = [
  [PipeInnerDiameter,   0.265],
  [PipeOuterDiameter,   0.415],
  [PipeTaperedDiameter, 0.415], // TODO: Verify
  [PipeThreadLength,    0.5],   // TODO: Verify
  [PipeThreadDepth,     0.25],  // TODO: Verify
  [PipeClearanceSnug,   0.015], // TODO: Verify
  [PipeClearanceLoose,  0.027], // TODO: Verify
  [PipeFn,              20],
  [PipeWeightPerUnit,   0] // TODO
];
function Spec_PipeOneQuarterInch() = PipeOneQuarterInch;

// 12GaugeChamber - 12ga Chamber tolerances are much pickier than ERW pipe
12GaugeChamber = [
  [PipeInnerDiameter,   0.78],
  [PipeFn,              30]
];
function Spec_12GaugeChamber() = 12GaugeChamber;

// 3/4" Sch40 Pipe
PipeThreeQuarterInch = [
  [PipeInnerDiameter,   0.81],
  [PipeOuterDiameter,   1.07],
  [PipeTaperedDiameter, 1.018],
  [PipeThreadLength,    0.9],
  [PipeThreadDepth,     0.5],
  [PipeClearanceSnug,   0.005],
  [PipeClearanceLoose,  0.027],
  [PipeFn,              30],
  [PipeWeightPerUnit,   40]
];
function Spec_PipeThreeQuarterInch() = PipeThreeQuarterInch;

// 3/4" Sch80 Pipe
PipeThreeQuarterInchSch80 = [
  [PipeInnerDiameter,   0.73],
  [PipeOuterDiameter,   1.07],
  [PipeTaperedDiameter, 1.018],
  [PipeThreadLength,    0.9],
  [PipeThreadDepth,     0.5],
  [PipeClearanceSnug,   0.005],
  [PipeClearanceLoose,  0.027],
  [PipeFn,              30],
  [PipeWeightPerUnit,   40]
];
function Spec_PipeThreeQuarterInchSch80() = PipeThreeQuarterInchSch80;

// 1" Pipe
PipeOneInch = [
  [PipeInnerDiameter,   1.055],
  [PipeOuterDiameter,   1.315],
  [PipeTaperedDiameter, 1.285],
  [PipeThreadLength,    0.982],
  [PipeThreadDepth,     0.5], // TODO: Verify
  [PipeClearanceSnug,   0.02],
  [PipeClearanceLoose,  0.03],
  [PipeFn,              30],
  [PipeWeightPerUnit,   0] // TODO
];
function Spec_PipeOneInch() = PipeOneInch;

// 1.125x0.813" DOM Tubing
TubingOnePointOneTwoFive = [
  [PipeInnerDiameter,   0.813],
  [PipeOuterDiameter,   1.125],
  [PipeTaperedDiameter, 1.018],
  [PipeThreadLength,    0.9],
  [PipeThreadDepth,     0.5],
  [PipeClearanceSnug,   0.020],
  [PipeClearanceLoose,  0.022],
  [PipeFn,              30],
  [PipeWeightPerUnit,   42]
];
function Spec_TubingOnePointOneTwoFive() = TubingOnePointOneTwoFive;

// 0.75x0.410" DOM Tubing (Just guessing)
TubingZeroPointSevenFive = [
  [PipeInnerDiameter,   0.410],
  [PipeOuterDiameter,   0.750],
  [PipeTaperedDiameter, 0.750],
  [PipeThreadLength,    0.0],
  [PipeThreadDepth,     0.0],
  [PipeClearanceSnug,   0.020],
  [PipeClearanceLoose,  0.022],
  [PipeFn,              30],
  [PipeWeightPerUnit,   42]
];
function Spec_TubingZeroPointSevenFive() = TubingZeroPointSevenFive;

// 0.375" OD DOM Tubing (Just guessing)
TubingThreeEighthsInch = [
  [PipeInnerDiameter,   0.23],
  [PipeOuterDiameter,   0.375],
  [PipeTaperedDiameter, 0.375],
  [PipeThreadLength,    0.0],
  [PipeThreadDepth,     0.0],
  [PipeClearanceSnug,   0.020],
  [PipeClearanceLoose,  0.022],
  [PipeFn,              20],
  [PipeWeightPerUnit,   0]
];
function Spec_TubingThreeEighthsInch() = TubingThreeEighthsInch;

// 5/16" Brake Line, for .22LR
FiveSixteenthInchBrakeLine = [
  [PipeInnerDiameter,   0.22],
  [PipeOuterDiameter,   0.3125],
  [PipeTaperedDiameter, 0.3125],
  [PipeThreadLength,    0],
  [PipeThreadDepth,     0],
  [PipeClearanceSnug,   0.025],
  [PipeClearanceLoose,  0.025],
  [PipeFn,              10],
  [PipeWeightPerUnit,   42]
];
function Spec_FiveSixteenthInchBrakeLine() = FiveSixteenthInchBrakeLine;

// 3/4" OD x 5/8" ID Tube
TubingThreeQuarterByFiveEighthInch = [
  [PipeInnerDiameter,   0.645],
  [PipeOuterDiameter,   0.75],
  [PipeTaperedDiameter, 0.75],
  [PipeThreadLength,    0],
  [PipeThreadDepth,     0],
  [PipeClearanceSnug,   0.03],
  [PipeClearanceLoose,  0.035],
  [PipeFn,              20],
  [PipeWeightPerUnit,   0] // TODO
];
function Spec_TubingThreeQuarterByFiveEighthInch() = TubingThreeQuarterByFiveEighthInch;

// 0.56x9mm Barrel Blank
PointFiveSix9mmBarrel = [
  [PipeInnerDiameter,   0.0],
  [PipeOuterDiameter,   0.56],
  [PipeTaperedDiameter, 0.56],
  [PipeThreadLength,    0],
  [PipeThreadDepth,     0],
  [PipeClearanceSnug,   0.020],
  [PipeClearanceLoose,  0.022],
  [PipeFn,              25],
  [PipeWeightPerUnit,   0]
];
function Spec_PointFiveSix9mmBarrel() = PointFiveSix9mmBarrel;



// Fittings: Tee
TeeOuterDiameter   = 1; // Diameter of the body, not the rim
TeeWidth           = 2; // Across the top of the tee, side-to-side
TeeHeight          = 3; // From the middle of the bottom rim to the top of the body
TeeHeightClearance = 4; // Range for the height
TeeInnerDiameter   = 5; // Diameter of the threaded hole
TeeRimDiameter     = 6; // Diameter of the tee rim
TeeRimWidth        = 7; // Width of the tee rim
TeeInfillSphere    = 8; // Diameter of the infill sphere, cuts out the casting infill between the tee sections
TeeInfillOffset    = 9; // Offset for the infill sphere from center

// Anvil USA 3/4" Cast Iron Pipe Tee (DANGEROUS, OUTSIDE SPEC)
TeeThreeQuarterInch = [
  [TeeOuterDiameter,   1.41],
  [TeeWidth,           2.64],
  [TeeHeight,          2],     // Measured 1.998-2.042
  [TeeHeightClearance, 0.022], // Derived from (height range/2)
  [TeeInnerDiameter,   0.88],
  [TeeRimDiameter,     1.54], // Measured: 1.494-1.523
  [TeeRimWidth,        0.32],
  [TeeInfillSphere,    0.10],
  [TeeInfillOffset,    0.41]
];
function Spec_TeeThreeQuarterInch() = TeeThreeQuarterInch;

// Anvil USA 3/4" Forged Steel Pipe Tee
AnvilForgedSteel_TeeThreeQuarterInch = [
  [TeeOuterDiameter,   1.37],
  [TeeWidth,           2.765],
  [TeeHeight,          2],     // Measured 1.998-2.042
  [TeeHeightClearance, 0.022], // Derived from (height range/2)
  [TeeInnerDiameter,   0.88],
  [TeeRimDiameter,     1.556],
  [TeeRimWidth,        0.9],
  [TeeInfillSphere,    0.10],
  [TeeInfillOffset,    0.41]
];
function Spec_AnvilForgedSteel_TeeThreeQuarterInch() = AnvilForgedSteel_TeeThreeQuarterInch;


// Chinese 304SS-150 3/4" Tee (DANGEROUS, OUTSIDE SPEC)
304SS_150_TeeThreeQuarterInch = [
  [TeeOuterDiameter,   1.37],
  [TeeWidth,           2.64],
  [TeeHeight,          2],     // Measured 1.998-2.042
  [TeeHeightClearance, 0.022], // Derived from (height range/2)
  [TeeInnerDiameter,   0.88],
  [TeeRimDiameter,     1.4],
  [TeeRimWidth,        0.31],
  [TeeInfillSphere,    0.10],
  [TeeInfillOffset,    0.41]
];
function Spec_304SS_150_TeeThreeQuarterInch() = 304SS_150_TeeThreeQuarterInch;

function TeeOuterDiameter(tee) = lookup(TeeOuterDiameter, tee);
function TeeOuterRadius(tee)   = lookup(TeeOuterDiameter, tee)/2;
function TeeWidth(tee)         = lookup(TeeWidth, tee);
function TeeHeight(tee)        = lookup(TeeHeight, tee);
function TeeInnerDiameter(tee) = lookup(TeeInnerDiameter, tee);
function TeeInnerRadius(tee)   = lookup(TeeInnerDiameter, tee)/2;
function TeeRimDiameter(tee)   = lookup(TeeRimDiameter, tee);
function TeeRimRadius(tee)     = lookup(TeeRimDiameter, tee)/2;
function TeeRimWidth(tee)      = lookup(TeeRimWidth, tee);
function TeeCenter(tee)        = lookup(TeeWidth, tee)/2; //lookup(TeeHeight, tee) - TeeOuterRadius(tee);

function TeePipeEndOffset(tee, pipe) = TeeCenter(tee)-PipeThreadDepth(pipe);

module TeeTetris_Side(tee) {
  rotate([0,90,0])
  translate([TeeWidth(tee)/2,0,-TeeCenter(tee)])
  Tee(tee=tee);
}

module Tee(tee, $fn=40) {
   render()
   union() {

     // Top Body
     rotate([0,-90,0])
     translate([TeeHeight(tee) - (TeeOuterDiameter(tee)/2),0,0])
     cylinder(r=TeeOuterRadius(tee), h=TeeWidth(tee) * 0.99, center=true, $fn=36);

     // Bottom Body
     translate([0,0,TeeCenter(tee) * 0.01])
     cylinder(r=TeeOuterRadius(tee), h=TeeCenter(tee) * 0.98, $fn=36);

     // Bottom Rim
     cylinder(r=TeeRimRadius(tee), h=TeeRimWidth(tee), $fn=36);


    // Rims
    for (i = [1, -1]) {

      // Rim
      translate([i*TeeWidth(tee)/2,0,TeeCenter(tee)])
      rotate([0,i*-90,0]) {
      cylinder(r=TeeRimRadius(tee), h=TeeRimWidth(tee), $fn=36);

      // Casting Infill
      translate([0,0,TeeRimWidth(tee)])
      cylinder(r1=TeeRimRadius(tee),
               r2=TeeOuterRadius(tee),
                h=0.05,
                $fn=36);
      }
    }

    // Tee Body Casting Infill
    // TODO: Tweak this? Could be better, could be worse.
    *intersection() {
      translate([0,0,TeeCenter(tee) + lookup(TeeInfillSphere, tee)])
      sphere(r=TeeRimRadius(tee) + lookup(TeeInfillOffset, tee), $fn=36);

      translate([-TeeRimRadius(tee),-TeeOuterRadius(tee),0])
      cube([TeeRimDiameter(tee),TeeOuterDiameter(tee),TeeCenter(tee)]);
    }
   }
};

module CrossFitting(tee, infill=true, hollow=false, $fn=40) {
  render()
  difference()
   union() {

     // Horizontal Body
     rotate([0,-90,0])
     translate([TeeHeight(tee) - (TeeOuterDiameter(tee)/2),0,0])
     cylinder(r=TeeOuterRadius(tee), h=TeeWidth(tee) * 0.99, center=true, $fn=36);

     // Vertical Body
     translate([0,0,TeeCenter(tee) * 0.01])
     cylinder(r=TeeOuterRadius(tee), h=TeeWidth(tee) * 0.98, $fn=36);

     // Bottom Vertical Rim
     cylinder(r=TeeRimRadius(tee), h=TeeRimWidth(tee), $fn=36);

     // Top Vertical Rim
     translate([0,0,TeeWidth(tee)-TeeRimWidth(tee)])
     cylinder(r=TeeRimRadius(tee), h=TeeRimWidth(tee), $fn=36);


    // Rims
    for (i = [1, -1]) {

      // Rim
      translate([i*TeeWidth(tee)/2,0,TeeCenter(tee)])
      rotate([0,i*-90,0]) {
      cylinder(r=TeeRimRadius(tee), h=TeeRimWidth(tee), $fn=36);

      // Rim-Body Fillet
      translate([0,0,TeeRimWidth(tee)])
      cylinder(r1=TeeRimRadius(tee),
               r2=TeeOuterRadius(tee),
                h=0.05,
                $fn=36);
      }
    }

    for (n=[-1,1]) // Top of cross-fitting
    for (i=[-1,1]) { // Sides of tee-fitting

      // Body-Corner Infill
      translate([0,0,TeeCenter(tee)])
      translate([i*TeeOuterRadius(tee)/2,0,n*-TeeOuterRadius(tee)/2])
      rotate([0,n*i*45,0])
      cylinder(r=TeeOuterRadius(tee), h=0.5, center=true);
    }
  }
};

//Tee(TeeThreeQuarterInch);

module TeeRim(tee=TeeThreeQuarterInch, height=1, clearance=0) {
  cylinder(r=TeeRimRadius(tee) + clearance, h=height, $fn=36);
}

// Fittings: Bushings
BushingHeight    = 1;
BushingDiameter  = 2;
BushingDepth     = 3; // Bushing screws in about half an inch
BushingCapWidth  = 4;
BushingCapHeight = 5;


// 3/4" Bushing
BushingThreeQuarterInch = [
  [BushingHeight,    0.955],
  [BushingDiameter,  1.06], // Measured 1.05, adding clearance
  [BushingDepth,     0.48],
  [BushingCapWidth,  1.227],
  [BushingCapHeight, 0.215]
];
function Spec_BushingThreeQuarterInch() = BushingThreeQuarterInch;

function BushingHeight(bushing)    = lookup(BushingHeight, bushing);
function BushingDiameter(bushing)  = lookup(BushingDiameter, bushing);
function BushingRadius(bushing)    = lookup(BushingDiameter, bushing)/2;
function BushingDepth(bushing)     = lookup(BushingDepth, bushing);
function BushingExtension(bushing) = BushingHeight(bushing) - BushingDepth(bushing);
function BushingCapWidth(bushing)  = lookup(BushingCapWidth, bushing);
function BushingCapHeight(bushing) = lookup(BushingCapHeight, bushing);

module Bushing(spec=BushingThreeQuarterInch) {

  od        = lookup(BushingDiameter, spec);
  height    = lookup(BushingHeight, spec);
  capWidth  = lookup(BushingCapWidth, spec);
  capHeight = lookup(BushingCapHeight, spec);

  union() {

    // Body
    translate([0,0,capHeight/2])
    cylinder(r=BushingRadius(spec), h=height - (BushingCapHeight(spec)/2), $fn=20);

    // Head
    cylinder(r=BushingCapWidth(spec)/2, h=BushingCapHeight(spec), $fn=6);
  }
}

CrossFitting(AnvilForgedSteel_TeeThreeQuarterInch);
