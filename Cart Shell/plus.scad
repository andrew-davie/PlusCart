// License: https://creativecommons.org/licenses/by-nc/3.0/
// (c)2020 Andrew Davie

// YOU MUST CHANGE "MODE" TO RENDER THE PART YOU WANT!!!


// VERSION 5
// shifted board down
// shifted middle pinholder mounts down
// adjusted trench depth

VERSION_STRING = "20220414";



// Choose the type of shell
SHELL_TYPE = 1; //[0:UnoCart,1:PlusCart]



// Add logo to front of shell
FRONT_LOGO = true; //[true:Yes,false:No]
// Add logo to back of shell
BACK_LOGO = false; //[true:Yes,false:No]
// Pins
JOINING_PINS = true;

///////////////////////////////////////////////////////////////////////////
// Multiple part definitions...  textDO NOT MODIFY...
// Set "part" to the part you want rendered

/* [Hidden] */

UNOCART = 0;                // plain unocart
PLUSCART = 1;               // plain pluscart


$fn = 32;

_XMODE_FRONT= 0;     // frontShell (SCREW HOLES)
MODE_BACK = 1;       // BACK
MODE_ALL = 2;
MODE_LOGO = 4;
MODE_LABEL = 5;
MODE_LETTERS = 6;
MODE_PINS = 8;
MODE_STICKER = 9;
MODE_PADS = 10;

// Which part to render
part = 0; // [0:FRONT,1:BACK,4:LOGO,5:LABEL,6:LETTERS,8:PINS:9:STICKER,10:PADS]


// Word on the label. Should be 8 letters maximum
LABEL_TEXT = "PLUSCART"; //8


// Side-wall thickness.
WALL = 3.2;
GAPFILLER_TOLERANCE = 0.8;


BOXX = 81.8;
BOXY = 98.4;
BOXZ = 19.8; //20.2; //18
LOGOZ = 0.8;

INNER_Z = 17; //tmp 17

// Front/back wall thickness
WALLZ = (BOXZ - INNER_Z)/2;

ADJUST_BOARD_Y = -1.5;


ANGX = 18.91;
ANGY = 1.6;
ANGY2 = 2.8;
ANGX2 = 5;

ROUNDBOXRADIUS = 4; //1.75;
PIN_SLOT_LENGTH = 15;


LATCH_UP = 3;

SQ = (BOXX-5)/8;
SQ2 = SQ+1;
YOFF = 15;
RD = 1;

SPACERZ = 10;
SPACERX = 3;
SPACERY = 10;
SPACER_OFFSET = -7.2;
SPACERLIP=0;
CONSTRAINER_TOL = 0.05;


SLOTBARX = BOXX-2*WALL;
SLOTBARY = 3.8-0.1;
SLOTBARZ = BOXZ/2;
//
BOARD_THICKNESS = 1.6+0.1;

SLOTINDENTZ = BOARD_THICKNESS;

SLOTX = 36.6+0.75;

_SUPPORTBOXX = SLOTX-3;
_SUPPORTBOXY = 19;
SUPPORTBOXRADIUS = 2;
SUPPORTBOXRADIUS2 = 1;
SUPPORTBOXWALL = 2.2;

SLOTSTMX = 77;

PIN_EDGE_TO_EDGE = 56.25;
PIN_WIDTH = 6;

PIN_THICK = 2.8; //3.0;
PIN_THICK_STRING = "3.0";

BIASZ = 0;
PIN_LENGTH = 10;
PRONG_THICK = 2.4; //BIASZ-GAPFILLER_TOLERANCE;

LIP_WIDTH = 1.2;
LIP_HEIGHT = 1.6;
LIP_TOL = 0.3;


SDWIDE = 18;
SDDEEP = 18;
SDSOKETWIDE = 13.75+0.5;
SDSOKETDEEP = 11.65;
SDSOCKETHIGH = 1.91;
SDHIGH = 1.6;
SDOFFSETY = 8.71;
SDOFFSETX = 2.35;


/* [Global] */

///////////////////////////////////////////////////////////////////////////
// Customizable values...





///////////////////////////////////////////////////////////////////////////

   
/* [UnoCart] */
// Add an opening for access to UnoCart jumpers
UNO_JUMPER_SLOT = 0;        // [0:NO,1:YES]

/* [PlusCart] */
// Add a transparent window to see WiFi's LEDs
LED_WINDOW = true;
// Slot for MicroSD card
MICROSD_SLOT = false;

// More information: https://danielupshaw.com/openscad-rounded-corners/


module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}

    resize(size);
}


module top(){
        
    difference(){
        union(){

            pinMountsTop();
            rightAngle(BOXZ/2-BIASZ,false);
            version();
            
            translate([0,0,BOXZ/2]) {
                difference(){
                    
                    roundedcube(size=[BOXX,BOXY,BOXZ],center=true,radius=ROUNDBOXRADIUS);
                    translate([0,-0.4-0.4-0.3,0])
                        roundedcube(size=[BOXX-2*WALL,BOXY-2*WALL,BOXZ-2*WALLZ],center=true);
    
                    // slice off top half
                    translate([-BOXX/2-1,-BOXY/2-1,BIASZ])
                        cube([BOXX+2,BOXY+2,BOXZ]);
                    
                    // cut off bottom opening
                    translate([-BOXX/2+WALL,-BOXY/2-5,-BOXZ/2+WALLZ])
                        cube([BOXX-2*WALL,10,BOXZ]);
                }
            }
        }

        for (x =[-1,1]) {
            translate([x*(BOXX/2-WALL+LIP_WIDTH/2-0.4/2-GAPFILLER_TOLERANCE/2),
                -BOXY/2+14+LIP_TOL+((BOXY-17.5-5-LIP_TOL*2)/2),
                BOXZ/2])
                translate([0,0,LIP_HEIGHT])
                   cube([LIP_WIDTH+GAPFILLER_TOLERANCE+0.8,(BOXY-17.5+5),
                /*LIP_HEIGHT*2+GAPFILLER_TOLERANCE]*/LIP_HEIGHT*2+GAPFILLER_TOLERANCE*6],center=true);
    }


        labelSlotX2();
//    translate([0,-0.1,0.2])
//            labelSlot();
//        translate([0,-0.2,0.2])
//            labelSlot();

        if (BACK_LOGO)
            logo(0.2,LOGOZ);

        // slope insert tensioner
        translate([-BOXX/2+WALL/2,-BOXY/2,WALLZ])
            rotate([0,0,-15])
                cube([4,12,BOXZ/2+2]);

        translate([0,0,BOXZ/2+WALLZ*2])
            rotate([0,180,0])
                translate([-BOXX/2+WALL/2,-BOXY/2,WALLZ-1])
                    rotate([0,0,-15])
                        cube([4,12,BOXZ/2+1]);

    }
    
    if (SHELL_TYPE == UNOCART) {
        bigSdSlotGapFiller();
    }

}

module label(){

    translate([0,BOXY/2-1.4,0]) {
        translate([-(BOXX-45)-WALL*2,0,0])
            cube([73.9+0.5,0.4,16.3+0.5/*BOXX-WALL*2-1.2-0.4-1,0.4,BOXZ-0.6*/]);
    }
}

module letters(){

    color("green")
        translate([0,BOXY/2-1.4,0]) {
            translate([BOXX-54.9+1-3,0,4.5-0.5])
                rotate([-90,180,0])
                    scale([1.1,1,1])
                        linear_extrude(0.4)
                                text(LABEL_TEXT,font="HammerFat",size=10);
        }
/*    color("green")
        translate([0,BOXY/2-1.4,0]) {
            translate([BOXX-54.9-59.5,0,-2+4.5])
                rotate([-90,270-45,0])
                    scale([1,1,1])
                        linear_extrude(0.4)
                                text("SD",font="HammerFat",size=8);
        }
*/
}

module labelSlot(){

    translate([-(BOXX-WALL*2)/2,BOXY/2-1.6+0.2-0.2,WALLZ/2])
        cube([BOXX-WALL*2,0.8,BOXZ]);

    translate([-(BOXX-WALL*2)/2+WALL/2,BOXY/2-1.4,WALLZ])
        cube([BOXX-WALL*2-WALL,1.4,BOXZ]);
}

BIGSLOT_WIDTH = 26;
BIGSLOT_HEIGHT = 4.86-1.8;
JUMPERSLOT_WIDTH = 9.6;
JUMPERSLOT_HEIGHT = 5.4;
JUMPER_HEIGHT = 3;

module bigSdSlot(){
    
    if (SHELL_TYPE == UNOCART) {
        translate([+(BOXX-WALL*2)/2-WALL/2-4-BIGSLOT_WIDTH,
            BOXY/2-5,
            WALLZ+BOXZ/2-BIGSLOT_HEIGHT-1.8-2])
            cube([BIGSLOT_WIDTH,10,BIGSLOT_HEIGHT+2]);

        if (UNO_JUMPER_SLOT)
            translate([+(BOXX-WALL*2)/2+WALL/2-64.5-JUMPERSLOT_WIDTH,BOXY/2-5,
                WALLZ+BOXZ/2-JUMPERSLOT_HEIGHT-1.8-2])
                cube([JUMPERSLOT_WIDTH,10,JUMPERSLOT_HEIGHT+10]);
    }
}

module bigSdSlotGapFiller() {
    
    if (SHELL_TYPE == UNOCART) {
        translate([-(BOXX-WALL*2)/2+WALL/2+4+GAPFILLER_TOLERANCE/2,
            BOXY/2-WALL,
            WALLZ + BOXZ/2])
            //WALLZ+BOXZ/2-2-1.8-BIGSLOT_HEIGHT+BIGSLOT_HEIGHT+2])
                cube([BIGSLOT_WIDTH-GAPFILLER_TOLERANCE,
                    WALL,
                    1.8]);

        if (UNO_JUMPER_SLOT)
            translate([-(BOXX-WALL*2)/2-WALL/2+64.5+GAPFILLER_TOLERANCE/2,
                BOXY/2-WALL,
                WALLZ + BOXZ/2])
                //WALLZ+BOXZ/2-JUMPERSLOT_HEIGHT-1.8+GAPFILLER_TOLERANCE/2+JUMPER_HEIGHT])
                cube([JUMPERSLOT_WIDTH-GAPFILLER_TOLERANCE,WALL,
                    (4.25-1.8)]);
    }
    
}

module roundedPillar(width,length,height,radius,radius2,wall) {

    difference(){
        solidPillar(width,length,height,radius);
        if (wall>0) {
            translate([0,0,-1])
                solidPillar(width-2*wall+0.2,length-2*wall,height+2,radius2);
        }
    }
}

module solidPillar(width,length,height,radius){
    linear_extrude(height)
        hull(){
            for(x=[-1,1])
                for(y=[-1,1]) {
                    translate([-x*(width-2*radius)/2,-y*(length-2*radius)/2,-height/2])
                        circle(r=radius);
                }
            }
}

BRACE_Y = -4.2+ADJUST_BOARD_Y;

module backSupport(
    slotbarx, slotbary, slotbarz,
    supportboxx, supportboxy,
    radius, radius2, wall) {

    translate([0,BRACE_Y,0])
        difference(){
            
            union(){
            
                translate([-slotbarx/2,0,0])
                    cube([slotbarx,slotbary,slotbarz+2]);

                translate([0,-supportboxy/2+radius])
                    roundedPillar(
                        supportboxx,
                        supportboxy,
                        slotbarz+2,
                        radius,
                        radius2,
                        wall
                    );
            }

            // STM board insert
            translate([-SLOTSTMX/2,1.2+1,-1])
                cube([SLOTSTMX,SLOTBARY-1.2+1,SLOTBARZ+4]);

        }
}

module frontSupport(
    slotbarx, slotbary, slotbarz,
    supportboxx, supportboxy,
    radius, radius2, wall) {
        
    translate([0,BRACE_Y,0])
        difference(){
            union(){
                translate([-slotbarx/2,0,0])
                    cube([slotbarx,slotbary,slotbarz]);

                translate([0,-supportboxy/2+radius])
                    roundedPillar(
                        supportboxx,
                        supportboxy,
                        slotbarz-SLOTINDENTZ,
                        radius,
                        radius2,
                        wall
                    );
            }
            translate([-SLOTX/2,-1,slotbarz-SLOTINDENTZ])
                cube([SLOTX,slotbary+2,slotbarz+2]);
        }
}    

module rightAngle(z,pin,top=false) {
    
    if (pin){
        
        // Front shell
        // Section that holds the cart itself

        frontSupport(
            SLOTBARX, SLOTBARY, SLOTBARZ,
            _SUPPORTBOXX, _SUPPORTBOXY,
            SUPPORTBOXRADIUS, SUPPORTBOXRADIUS2,
            SUPPORTBOXWALL);
    } else {
        backSupport(
            SLOTBARX, SLOTBARY, SLOTBARZ-2,
            _SUPPORTBOXX, _SUPPORTBOXY,
            SUPPORTBOXRADIUS, SUPPORTBOXRADIUS2, SUPPORTBOXWALL);
    }
}


module ledWindow() {
    if (SHELL_TYPE != UNOCART && LED_WINDOW) {
        translate([BOXX/2-12.5,-BOXY/2+BOXY-16.5+ADJUST_BOARD_Y-0.5,-BOXZ/2+0.4]){
            cylinder(r1=2,r2=3.5,h=WALLZ);
        }
    }
}    

module maskingLip() {
    for (x =[-1,1]) {
        translate([x*(BOXX/2-WALL+LIP_WIDTH/2),
            -BOXY/2+14+LIP_TOL+((BOXY-17.5-5-LIP_TOL*2)/2),
            BOXZ/2+WALLZ-2+LIP_HEIGHT/2])
                cube([LIP_WIDTH,(BOXY-17.5+5-LIP_TOL*2),LIP_HEIGHT* 2],center=true);
    }
}    

module basicShell() {

    translate([0,-0.4-0.4-0.3,0])
        roundedcube(size=[BOXX-2*WALL,BOXY-2*WALL,BOXZ-2*WALLZ],center=true);
    
    // slice off top of box, leaving a tray
    translate([-BOXX/2-1,-BOXY/2-1,0])
        cube([BOXX+2,BOXY+2,BOXZ/2]);

    // slice off front of tray = cart insert hole
    translate([-BOXX/2+WALL,-BOXY/2-5,-BOXZ/2+WALLZ])
        cube([BOXX-2*WALL,10,BOXZ]);
}

module tensioners() {
//    translate([-BOXX/2+WALL,-BOXY/2,WALLZ])
//        cube([1.2,14,BOXZ/2-WALLZ]);
//    translate([BOXX/2-WALL-1.2,-BOXY/2,WALLZ])
//        cube([1.2,14,BOXZ/2-WALLZ]);
}    

module sdCardSlot() {
    // SD reader slot
    for (z=[-0.2,1])
        translate([BOXX/2-SDDEEP-(SDOFFSETY+SDSOKETDEEP-SDDEEP)-0.05,BRACE_Y+4.75+18.7+SDWIDE,BOXZ/2-1.6-SDSOCKETHIGH+z])
            rotate([0,0,-90])
                sdReader();
}    

module labelSlotX2() {
//    translate([0,-0.2,-0.2])
//        labelSlot();
//    translate([0,0,1])
//        labelSlot();


    translate([-(BOXX-5)/2,+BOXY/2-2.15+0.4-0.5,WALLZ/2+1])
        cube([BOXX-5,0.8,BOXZ]);

    translate([-(BOXX-6)/2,BOXY/2-0.15-1.4,WALLZ/2+2])
        cube([BOXX-6,1.6,BOXZ]);



}

module middleAndBottomPins() {

    //middle
    for (x=[-1,1])
        translate([x*(BOXX/2-WALL-PINHOLDER_WALL-0.15), 1.5+2-0.375+ADJUST_BOARD_Y, 0]) {
            rotate([0,0,90])
            pinholder(BOXZ/2);
    }

    // bottom
    for (x=[-1,1]) {
        translate([x*PIN_OFFSET_X,-25+0.6,0]) {
            rotate([0,0,90*x+90])
                pinholder(BOXZ/2-2.5, true);       // give clearance for up-pins on 2600
        }
    }
}
    
module pinMounts(){
    
    if (JOINING_PINS) {
        for (x=[-1,1])
            translate([x*(BOXX/2-WALL-PINHOLDER_WALL-0.15), 42.1-0.8, 0]) {
                rotate([0,0,90])
                pinholder(BOXZ/2);            
        }
        
        middleAndBottomPins();
    }
}

module pinMountsTop() {
 
    if (JOINING_PINS) {
    
        for (x=[-1,1])
            translate([x*(BOXX/2-WALL-PINHOLDER_WALL-0.35), 42.1-0.8, 0])
                rotate([0,0,90])
                    pinholder(BOXZ/2-BIASZ-PRONG_THICK-GAPFILLER_TOLERANCE);            
        
        // middle
        for (x=[-1,1])
            translate([x*(BOXX/2-WALL-PINHOLDER_WALL-0.35), 1.5+2-0.375+ADJUST_BOARD_Y, 0]) {
                rotate([0,0,90])
                pinholder(BOXZ/2-BIASZ-PRONG_THICK-GAPFILLER_TOLERANCE);            
        }

        // bottom
        for (x=[-1,1]) {
            translate([x*PIN_OFFSET_X,-25+0.6,0]) {
                rotate([0,0,90*x+90])
                    pinholder(BOXZ/2-BIASZ-GAPFILLER_TOLERANCE, true);
            }
        }



    }
}

module pads(){

    difference() {
        for (x=[-1,1])
            for (y=[-1,1])
                translate([x*BOXX/2,BOXY*y/2,0])
                    cylinder(r=10,h=0.2);

        scale([1.011,1.011,1])
            frontShell();
    }
    
}


module version(){
    
            translate([0,0,WALLZ])
                linear_extrude(0.4)
                    text(VERSION_STRING,font="Lucida Console",size=4);
                
    
    
}

module frontShell(){

    difference(){
        union(){

            translate([0,0,BOXZ/2])
                difference(){
                    roundedcube(size=[BOXX,BOXY,BOXZ],center=true,radius=ROUNDBOXRADIUS);
                    basicShell();
                    ledWindow();
                }
            rightAngle(BOXZ/2, true);
            maskingLip();
            version();
        }

        if (SHELL_TYPE == PLUSCART && MICROSD_SLOT)
            sdCardSlot();
   
        if (SHELL_TYPE == PLUSCART)
            labelSlotX2();

        if (SHELL_TYPE == UNOCART) {
            bigSdSlot();
        }

        if (FRONT_LOGO)
            logo2(0, LOGOZ);

        // Trim tensioner area...
        translate([-BOXX/2+WALL/2,-BOXY/2,WALLZ])
            rotate([0,0,-15])
                cube([4,12,BOXZ/2]);

        translate([0,0,BOXZ/2+WALLZ*2])
            rotate([0,180,0])
                translate([-BOXX/2+WALL/2,-BOXY/2,WALLZ])
                    rotate([0,0,-15])
                        cube([4,12,BOXZ/2]);
    }
    pinMounts();
}


if (part == _XMODE_FRONT){
    pads();
    frontShell();
    
    
}


module latch(rd,ht,rot, tol=0){
    
    translate([0.55,0,ht])
        rotate([90,40,0])
            cube([2*(rd+tol),2*(rd+tol),10+2*tol],center=true);
 
    translate([0.3,-5,0])
        cube([3.75,10+2*tol,ht+(2*(rd+tol)/sqrt(2))]);
    
}

if (part == MODE_BACK) {
    pads();
    top();
}

if (part ==MODE_ALL){

    top();

    translate([0,0,BOXZ+0.2])
        rotate([0,180,0]) {
            frontShell();
        //if (FRONT_LOGO)
            //logo(0.8);
        }
    if (SHELL_TYPE != UNOCART) {
        translate([WALL/2+WALL/2+0.2,0.2,WALLZ/2])
            label();
        translate([WALL/2+WALL/2+0.2,0.2,WALLZ/2])
            letters();
    }

    for (x=[-1,1])
        translate([x*PIN_OFFSET_X,-25,WALLZ])
            translate([0,0,BOXZ/2-WALLZ-0.5+PIN_THICK/2])
                pin(6, 6, 16);

    color("red")
        translate([-BOXX/2-5,-BOXY/2-5,0])
            cube([10,10,20]);

    color("red")
        translate([-BOXX/2,-5,-5])
            cube([BOXX,10,10]);

    color("red")
        translate([-BOXX/2+6,-BOXY/2-5,(20-16.75)/2])
            cube([5,5,16.75]);

    translate([0,0,20 - LOGOZ])
        logo2(1.3, LOGOZ);

}

if (part == MODE_LABEL){
    translate([0,0,-BOXY/2])
        rotate([90,0,0])
            label();
}

if (part == MODE_LETTERS){
    translate([0,0,-BOXY/2+0.4])
        rotate([90,0,0])
            letters();
}


if (part == MODE_LOGO){
    logo2(1.3, LOGOZ);
}


PIN_OFFSET_X = (PIN_EDGE_TO_EDGE+PIN_WIDTH)/2;

module mainProng(flange, flange2, length) {
        // the main extending prong...
    translate([0,-length/2,0])
        scale([1,length/PRONG_THICK])
            square(PRONG_THICK,center=true);

    // The tip of the prong
    hull() {
        square(PRONG_THICK,center=true);
        translate([0,PRONG_THICK,0])
            circle(r=PRONG_THICK/4);
        }
        

    // The insert tabs
    hull(){
        translate([-flange+PIN_THICK/2,-length,0])
            circle(r=PIN_THICK/2);
        translate([flange2-PIN_THICK/2,-length,0])
            circle(r=PIN_THICK/2);
    }
        
}

module pin(flange=5, flange2=5, length=PIN_LENGTH) {

    rotate([0,90,0])
        translate([0,-length,-PIN_WIDTH/2])
            rotate([0,0,180]) {
       
                linear_extrude(0.2)
                    difference() {
                        offset(r=4)
                            mainProng(flange, flange2, length);
                        offset(r=0.43)
                            mainProng(flange, flange2, length);
                    }
                
                difference() {
                    
                    
                    
                    
                    linear_extrude(PIN_WIDTH) {

                        mainProng(flange, flange2, length);
                        
                    }
    
/*                    translate([-4.85,-length-PIN_THICK/2+0.4,1])
                    rotate([90,0,0])
                        linear_extrude(0.6)
                            text(PIN_THICK_STRING,font="Lucida Console",size=5);
 */
                    }



            }    
}

PINHOLDER_WALL = 1.6;
PINHOLDER_WIDTH = PIN_WIDTH + 2 * PINHOLDER_WALL + 1;
PINHOLDER_LENGTH = 3 + 2 * PINHOLDER_WALL + 0.55;
PINHOLDER_RADIUS = 2;
PINHOLDER_RADIUS2 = 0.5;


module pinholder(height = SLOTBARZ-SLOTINDENTZ,mount=false) {
    
    translate([0,0,0])
        roundedPillar(
            PINHOLDER_WIDTH,
            PINHOLDER_LENGTH,
            height,
            PINHOLDER_RADIUS,
            PINHOLDER_RADIUS2,
            PINHOLDER_WALL
        );


    // fit tester...
/*    translate([-PIN_WIDTH/2,-PIN_THICK/2,height])
        cube([PIN_WIDTH,PIN_THICK,0.2]);
  */
    
    if (mount)
        translate([-8,-3/2,0])
            cube([4,3,height]);

}

if (part == MODE_STICKER) {
    sticker();
}

if (part == MODE_PADS) {
    pads();
}



if (part == MODE_PINS) {
    
    rotate([0,180,0]) {
    
    for (x=[0,1])
        translate([35-x*18,-13,0])
            rotate([0,90,0]) {
                translate([0,0,0])
                    pin(6,6, PIN_SLOT_LENGTH);
//                scale([0.9,0.99,0.95])
//                    pin(6,6, 16);
            }
    
    for (x=[-1,0,1,2])
            translate([20+x*12,0,0])
                rotate([0,90,90]) {
                translate([0,0,0])
                    pin(BOXZ/2-WALLZ-0.4,BOXZ/2-WALLZ-0.4, 1);
//                scale([0.9,0.99,0.95])

//                    pin(BOXZ/2-WALLZ-0.4,BOXZ/2-WALLZ-0.4, 1);
                }    
    }
}



module logo2(tolx=0,ht=LOGOZ){
    
    if (SHELL_TYPE != UNOCART) {
    
        L = [[0,1,0,0,0,1,0],
             [1,0,0,1,0,0,1],
             [1,0,1,1,1,0,1],
             [1,0,0,1,0,0,1],
             [0,1,0,0,0,1,0]];
        
        translate([0,18,0])
        scale([0.75,0.75,1])
        for (x=[0:6])
            for (y=[0:4]) {

                if (L[y][x]!=0)
                    translate([x*SQ-3*SQ,y*SQ-2*SQ,0])
                        linear_extrude(ht)
                            hull(){
                                for (cx=[-1,1])
                                    for (cy=[-1,1])
                                        translate([cx*(SQ2/2-RD-tolx),cy*(SQ2/2-RD-tolx),0])
                                            circle(r=RD);
                                }
                                
             }
             
/*        // Cartouche
        translate([0,10,0])
            roundedPillar(
                54,50,
                0.4,
                20,18,
                 2
            );
             
        translate([-27,34,0])
            cube([54,2,0.4]);
        // end cartouche
*/             
     }
     
     else {
         
         translate([-35,12,0])
            linear_extrude(0.4)
                scale([0.4,0.4,1])
                    import("UNOCART.svg");
         
         
     }
    
}


module sdReader() {
    
    cube([SDWIDE,SDDEEP,SDHIGH]);
    translate([SDOFFSETX,SDOFFSETY+0.1,SDHIGH]) {
        difference() {
            cube([SDSOKETWIDE,SDSOKETDEEP,SDSOCKETHIGH+2]); 
            //translate([SDSOKETWIDE/2,SDSOKETDEEP + 2,-1])
            //    cylinder(r=4,h=SDSOCKETHIGH+2);
        }
    }
}

STD=5;
STX = 72;
STY = 88.5;

module sticker(){
   // 72 x 88.5

    linear_extrude(0.4)
        hull(){
            for (x=[0-1,1])
                for (y=[-1,1])
                    translate([x*(STX-STD)/2,y*(STY-STD)/2,0])
                        circle(r=STD/2);
        }
}        
    
    
    