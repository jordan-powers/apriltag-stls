TAG_PATH="C:/Users/jordan/Documents/git/apriltag-stls/test.svg";
TAG_ID = 1;

SELECTOR = 1;

THICKNESS = 1;
DEPTH = 0.4;
TAG_WIDTH = 6.5 * 25.4;
WIDTH = 8.125 * 25.4;
HEIGHT = 9.75 * 25.4;


module design(extrude_depth) {
    translate([(WIDTH - TAG_WIDTH) / 2, ((WIDTH - TAG_WIDTH) / 2) + (HEIGHT-WIDTH),THICKNESS - DEPTH]) {
        linear_extrude(extrude_depth) {
            import(TAG_PATH);
        }
    }
    translate([WIDTH/2, (((WIDTH - TAG_WIDTH) / 2) + (HEIGHT-WIDTH))/2, THICKNESS - DEPTH]) {
        linear_extrude(extrude_depth) {
            text(str("ID ", TAG_ID), size=22, font="Arial Black", halign="center", valign="center");
        }
    }
}

if(SELECTOR) {
    difference() {
        cube([WIDTH, HEIGHT,THICKNESS]);
        #design(extrude_depth=DEPTH+0.2);
    }
} else {
    design(extrude_depth=DEPTH);
}