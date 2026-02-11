TAG_PATH="C:/Users/jordan/Documents/git/apriltag-stls/svg/36h11/00001.svg";
TAG_ID = 1;

SELECTOR = 0;

THICKNESS = 1;
DEPTH = 0.5;
TAG_WIDTH = 6.5 * 25.4;
WIDTH = 8.125 * 25.4;
HEIGHT = 9.75 * 25.4;

OFFSET = 0.05;

HOLE_SIZE = 0.1695 * 25.4;
HOLE_DIST = 25.4/4 + (HOLE_SIZE / 2);

module screw_holes() {
    translate([HOLE_DIST, HOLE_DIST, 0])
    cylinder(THICKNESS + 0.2, r1=HOLE_SIZE/2, r2=HOLE_SIZE/2, $fn=128);
    
    translate([WIDTH - HOLE_DIST, HOLE_DIST, 0])
    cylinder(THICKNESS + 0.2, r1=HOLE_SIZE/2, r2=HOLE_SIZE/2, $fn=128);
    
    translate([HOLE_DIST, HEIGHT - HOLE_DIST, 0])
    cylinder(THICKNESS + 0.2, r1=HOLE_SIZE/2, r2=HOLE_SIZE/2, $fn=128);
    
    translate([WIDTH - HOLE_DIST, HEIGHT - HOLE_DIST, 0])
    cylinder(THICKNESS + 0.2, r1=HOLE_SIZE/2, r2=HOLE_SIZE/2, $fn=128);
}

module design() {
    translate([(WIDTH - TAG_WIDTH) / 2, ((WIDTH - TAG_WIDTH) / 2) + (HEIGHT-WIDTH),THICKNESS - DEPTH]) {
        union() {
            translate([0, 0, DEPTH/2])
            #linear_extrude(DEPTH/2)
                offset(delta=SELECTOR ? OFFSET : -OFFSET)
                import(TAG_PATH);
                
            linear_extrude(DEPTH/2)
                import(TAG_PATH);
        }
    }
    translate([WIDTH/2, 0.75 * 25.4, THICKNESS - DEPTH]) {
        linear_extrude(DEPTH) {
            text(str("ID ", TAG_ID), size=22, font="Arial Black", halign="center", valign="bottom");
        }
    }
}

if(SELECTOR) {
    difference() {
        cube([WIDTH, HEIGHT,THICKNESS]);
        design();
        screw_holes();
    }
} else {
    design();
}