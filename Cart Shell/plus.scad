// License: https://creativecommons.org/licenses/by-nc/3.0/
// (c)2020 Andrew Davie

// YOU MUST CHANGE "MODE" TO RENDER THE PART YOU WANT!!!


// VERSION 5
// shifted board down
// shifted middle pinholder mounts down
// adjusted trench depth





// Choose the type of shell
SHELL_TYPE = 1; //[0:UnoCart,1:PlusCart]
// Which part to render
part = 0; // [0:FRONT,1:BACK,4:LOGO,5:LABEL,6:LETTERS,8:PINS:9:STICKER,10:PADS]



// Add logo to front of shell
FRONT_LOGO = true; //[true:Yes,false:No]
// Add logo to back of shell
BACK_LOGO = false; //[true:Yes,false:No]
// Pins
JOINING_PINS = true;

///////////////////////////////////////////////////////////////////////////
// Multiple part definitions...  textDO NOT MODIFY...
// Set "MODE" to the part you want rendered

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


// Word on the label. Should be 8 letters maximum
LABEL_TEXT = "PLUSCART"; //8


// Side-wall thickness.
WALL = 3.2;

// Front/back wall thickness
WALLZ = 2;
ADJUST_BOARD_Y = -1.5;


BOXX = 82;
BOXY = 98.4;
BOXZ = 18.275;

LIP_WIDTH = 1.6;
LIP_HEIGHT = 1.6;
LIP_TOL = 0.3;

ANGX = 18.91;
ANGY = 1.6;
ANGY2 = 2.8;
ANGX2 = 5;

ROUNDBOXRADIUS = 1.5;


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
SLOTBARZ = BOXZ/2-WALLZ;
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

PIN_EDGE_TO_EDGE = 55.85;
PIN_WIDTH = 7.5-0.8;

PIN_THICK = 3.0; //3.0;
PIN_THICK_STRING = "3.0";

PIN_LENGTH = 10;
PRONG_THICK = 3;


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

}


module top(){
    

        
    difference(){
        union(){
    
            pinMountsTop();
            rightAngle(BOXZ/2+2,false);


            translate([0,0,BOXZ/2]) {
                difference(){
                    roundedcube(size=[BOXX,BOXY,BOXZ],center=true,radius=ROUNDBOXRADIUS);

                    if (SHELL_TYPE != UNOCART) {
                        translate([0,-0.4-0.4-0.3,0])
                            roundedcube(size=[BOXX-2*WALL,BOXY-2*WALL,BOXZ-2*WALLZ],center=true);
                    }
    
                    if (SHELL_TYPE == UNOCART) {
                        translate([0,0,0])
                            roundedcube(size=[BOXX-2*WALL,BOXY-2*WALL,BOXZ-2*WALLZ],center=true);
                    }    

                    // slice off top half
                    translate([-BOXX/2-1,-BOXY/2-1,2])
                        cube([BOXX+2,BOXY+2,BOXZ]);
                    
                    // cut off bottom opening
                    translate([-BOXX/2+WALL,-BOXY/2-5,-BOXZ/2+WALLZ])
                        cube([BOXX-2*WALL,10,BOXZ]);
                }
            }
            
    // tensioners
/*            translate([-BOXX/2+WALL,-BOXY/2,WALLZ])
                cube([1.2,14,BOXZ/2+2-WALLZ]);
            translate([BOXX/2-WALL-1.2,-BOXY/2,WALLZ])
                cube([1.2,14,BOXZ/2+2-WALLZ]);
*/

        }

        // masking lip
        /*for (x =[-1,1]) {
            translate([x*(BOXX/2-WALL)-(x+1)/2*LIP_WIDTH,
            -BOXY/2+14,BOXZ/2+WALLZ-LIP_HEIGHT-0.4])
                cube([LIP_WIDTH,BOXY-17.5,LIP_HEIGHT+1]);
        }*/

        for (x =[-1,1]) {
        translate([x*(BOXX/2-WALL+LIP_WIDTH/2-0.6/2),
            -BOXY/2+14+LIP_TOL+((BOXY-17.5-5-LIP_TOL*2)/2),
            BOXZ/2+WALLZ-LIP_HEIGHT/2-0.4])
                cube([LIP_WIDTH+0.6,(BOXY-17.5+5),LIP_HEIGHT+1],center=true);
    }


        if (SHELL_TYPE != UNOCART) {
            translate([0,-0.1,0.2])
                labelSlot();
            translate([0,0,0.2])
                labelSlot();
        }

        if (BACK_LOGO)
            logo(0.2);

  //          sticker();

//        if (SHELL_TYPE == UNOCART) {
//            bigSdSlot();
//        }

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
            translate([BOXX-54.9+1,0,4.5])
                rotate([-90,180,0])
                    scale([1,1,1])
                        linear_extrude(0.4)
                                text(LABEL_TEXT,font="HammerFat",size=10);
        }
    color("green")
        translate([0,BOXY/2-1.4,0]) {
            translate([BOXX-54.9-59.5,0,-2+4.5])
                rotate([-90,270-45,0])
                    scale([1,1,1])
                        linear_extrude(0.4)
                                text("SD",font="HammerFat",size=8);
        }
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
GAPFILLER_TOLERANCE = 0.8;
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
                solidPillar(width-2*wall,length-2*wall,height+2,radius2);
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

    translate([0,BRACE_Y,WALLZ])
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
        
    translate([0,BRACE_Y,WALLZ])
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

        if (SHELL_TYPE != UNOCART) {
            frontSupport(
                SLOTBARX, SLOTBARY, SLOTBARZ,
                _SUPPORTBOXX, _SUPPORTBOXY,
                SUPPORTBOXRADIUS, SUPPORTBOXRADIUS2,
                SUPPORTBOXWALL
            );
        } else {
            difference(){
                frontSupport(
                    SLOTBARX, SLOTBARY, SLOTBARZ,
                    41.5 + WALL * 2, 25.75,
                    SUPPORTBOXRADIUS, SUPPORTBOXRADIUS2,
                    SUPPORTBOXWALL
                );            
                // another slot, as the UnoCart board has components here
                translate([-(SLOTX-4)/2,-6,9-2-0.5])
                    cube([SLOTX-4,SLOTBARY+5,SLOTBARZ+2]);
            }
        }
        
    } else {
       
        if (SHELL_TYPE != UNOCART)
            backSupport(
                SLOTBARX, SLOTBARY, SLOTBARZ,
                _SUPPORTBOXX, _SUPPORTBOXY,
                SUPPORTBOXRADIUS, SUPPORTBOXRADIUS2, SUPPORTBOXWALL
            );
        else
            difference(){
                backSupport(
                    SLOTBARX, SLOTBARY, SLOTBARZ,
                    41.5+ WALL*2, 25.75,
                    SUPPORTBOXRADIUS, SUPPORTBOXRADIUS2, SUPPORTBOXWALL
                );
            }
     }
}


module ledWindow() {
    if (SHELL_TYPE != UNOCART && LED_WINDOW) {
        translate([BOXX/2-12.5,-BOXY/2+BOXY-16.5+ADJUST_BOARD_Y-0.5,-BOXZ/2+0.4]){
            cylinder(r1=2,r2=2.5,h=2);
        }
    }
}    

module maskingLip() {
    for (x =[-1,1]) {
        translate([x*(BOXX/2-WALL+LIP_WIDTH/2),
            -BOXY/2+14+LIP_TOL+((BOXY-17.5-5-LIP_TOL*2)/2),
            BOXZ/2+WALLZ-2+LIP_HEIGHT/2])
                cube([LIP_WIDTH,(BOXY-17.5+5-LIP_TOL*2),LIP_HEIGHT],center=true);

/*        // masking lip
        for (x =[-1,1]) {
            translate([x*(BOXX/2-WALL+LIP_WIDTH-0.2)-(x+1)/2*LIP_WIDTH,
            -BOXY/2+14,BOXZ/2+WALLZ-LIP_HEIGHT-0.4])
                cube([LIP_WIDTH+0.2,BOXY-14.8,LIP_HEIGHT+1]);
        }
*/

    }
}    

module basicShell() {

    if (SHELL_TYPE != UNOCART)
        translate([0,-0.4-0.4-0.3,0])
            roundedcube(size=[BOXX-2*WALL,BOXY-2*WALL,BOXZ-2*WALLZ],center=true);
    
    if (SHELL_TYPE == UNOCART)
        translate([0,0,0])
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
    translate([0,-0.2,0.2])
        labelSlot();
    translate([0,0,0.2])
        labelSlot();
}

module middleAndBottomPins() {

    //middle
    for (x=[-1,1])
        translate([x*(BOXX/2-WALL-PINHOLDER_WALL-0.15), 1.5+2-0.375+ADJUST_BOARD_Y-1.6, WALLZ]) {
            rotate([0,0,90])
            pinholder(BOXZ/2-WALLZ);
    }

    // bottom
    for (x=[-1,1]) {
        translate([x*PIN_OFFSET_X,-25+0.6,WALLZ]) {
            rotate([0,0,90*x+90])
                pinholder(4.3, true);
        }
    }
}
    
module pinMounts(){
    
    if (JOINING_PINS) {
        if (SHELL_TYPE  != UNOCART) {
            for (x=[-1,1])
                translate([x*(BOXX/2-WALL-PINHOLDER_WALL-0.15), 42.1-0.8, WALLZ]) {
                    rotate([0,0,90])
                    pinholder(BOXZ/2-WALLZ);            
            }
        } else {
            translate([0,45.38,WALLZ])
                pinholder(BOXZ/2-WALLZ);            
        }
        
        middleAndBottomPins();
    }
}

module pinMountsTop() {
    
    if (JOINING_PINS) {
    
        if (SHELL_TYPE == PLUSCART) {
            for (x=[-1,1])
            translate([x*(BOXX/2-WALL-PINHOLDER_WALL-0.15), 42.1-0.8, WALLZ])
                rotate([0,0,90])
                    pinholder(BOXZ/2+2-WALLZ-PRONG_THICK-0.4);            
        }
        
        if (SHELL_TYPE == UNOCART) {
                translate([0,45.38,WALLZ])
                    pinholder(BOXZ/2+2-WALLZ-PRONG_THICK-0.4);            
        }
        

        // middle
        for (x=[-1,1])
            translate([x*(BOXX/2-WALL-PINHOLDER_WALL-0.15), 1.5+2-0.375+ADJUST_BOARD_Y-1.6, WALLZ]) {
                rotate([0,0,90])
                pinholder(BOXZ/2+2-WALLZ-PRONG_THICK-0.4);            
        }

        // bottom
        for (x=[-1,1]) {
            translate([x*PIN_OFFSET_X,-25+0.6,WALLZ]) {
                rotate([0,0,90*x+90])
                    pinholder(8.2/*BOXZ/2-WALLZ-PIN_THICK*/, true);
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

        scale([1.005,1.005,1])
            frontShell();
    }
    
}


module frontShell(){

        
    translate([0,0,-0.008])
    difference(){
        union(){
            translate([0,0,BOXZ/2])
                difference(){
                    roundedcube(size=[BOXX,BOXY,BOXZ],center=true,radius=ROUNDBOXRADIUS);
                    basicShell();
                    ledWindow();
                }
        
            rightAngle(BOXZ/2-1-ROUNDBOXRADIUS/2, true);
            maskingLip();
            //tensioners();
        }

        if (SHELL_TYPE == PLUSCART && MICROSD_SLOT)
            sdCardSlot();
   
        if (SHELL_TYPE == PLUSCART)
            labelSlotX2();

        if (SHELL_TYPE == UNOCART) {
            bigSdSlot();
        }

        if (FRONT_LOGO) {
            //for (z=[-0.1,0,0.2])
            translate([-0,-0,-0.4])
                    //rotate([0,180,0]) {
                        //logo2(-0.4,-1, 0.4);
                        logo2(0,0,0.4);
                    //}
            
        }
            
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



//    if (SHELL_TYPE == UNOCART) {
//        bigSdSlotGapFiller();
//    }
    pinMounts();
/*            translate([0,0,WALLZ+0.41])
                    rotate([0,180,0]) {
                        logo2(0,-1, 0.4);
                        logo2(1);
                    }
 */           
}


if (part == _XMODE_FRONT){
    frontShell();
    
    
}

//if (part == MODE_FRONTANDLOGO){
//    frontShell();
//    logo(1.6);
//}

module latch(rd,ht,rot, tol=0){
    
    translate([0.55,0,ht])
        rotate([90,40,0])
            cube([2*(rd+tol),2*(rd+tol),10+2*tol],center=true);
 
    translate([0.3,-5,0])
        cube([3.75,10+2*tol,ht+(2*(rd+tol)/sqrt(2))]);
    
}

if (part == MODE_BACK)
    top();

if (part ==MODE_ALL){

    top();

    translate([0,0,BOXZ+2+0.1])
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
            translate([0,0,BOXZ/2-WALLZ+2+PIN_THICK/2])
                pin(6, 6, 16);
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
    
/*    difference(){
        translate([-25,0,0])
            cube([50,35,2]);
        translate([0,0,-0.4])
            logo2(0.4);
    }
  */
    
    
    
    
        //translate([0,0,-0.4])
        //    logo2(-0.95-0.2,0,0.4);
        //logo2(0,-2, 0.4);
        //logo2(0,-1, 0.4);

    
      translate([0,0,-0.4])
        logo2(1.3 /*0.95-0.1*/,0,0.4);
}


PIN_OFFSET_X = (PIN_EDGE_TO_EDGE+PIN_WIDTH)/2;

module pin(flange=5, flange2=5, length=PIN_LENGTH) {

    rotate([0,90,0])
        translate([0,-length,-PIN_WIDTH/2])
            rotate([0,0,180]) {
    
                difference() {
                    linear_extrude(PIN_WIDTH) {

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
    
/*                    translate([-4.85,-length-PIN_THICK/2+0.4,1])
                    rotate([90,0,0])
                        linear_extrude(0.6)
                            text(PIN_THICK_STRING,font="Lucida Console",size=5);
 */
                    }



            }    
}

PINHOLDER_WALL = 1.6;
PINHOLDER_WIDTH = 6.7 + 2 * PINHOLDER_WALL + 0.55;
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
    
    for (x=[0,1])
        translate([-x*10,x*5,0])
            rotate([0,90,0]) {
                translate([0,0,0])
                    pin(6,6, 16);
//                scale([0.9,0.99,0.95])
//                    pin(6,6, 16);
            }
    
    for (x=[-1,0,1,2])
            translate([20+x*8,0,0])
                rotate([0,90,90]) {
                translate([0,0,0])
                    pin(BOXZ/2-WALLZ-0.4,BOXZ/2-WALLZ-0.4, 1);
//                scale([0.9,0.99,0.95])

//                    pin(BOXZ/2-WALLZ-0.4,BOXZ/2-WALLZ-0.4, 1);
                }    
}



module logo(tolx=0,ht=WALLZ+0.1){
    
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



LGX = 47;
LGY = 35;

module logo2(tolx=0,offset=-1,height=WALLZ+0.8/*SQ/4*//*0.8*/){

    //translate([-LGX/2,0,0])
    //    cube([LGX,LGY,0.4]);
//    hull(){
//    logo(offset,0.4);
 //   }
    translate([0,0,0.4])
        logo(tolx,height);

    
    
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
    
    
    