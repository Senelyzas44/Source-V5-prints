// TBS Source One V5 FPV accessories. Dimensions in mm.
// Select a part and render (F6) before exporting STL.
part = "phoenix2"; // [phoenix2,camera-tilt-gauge,sma,elrs,wire_right,wire_left,arm-right16,arm-left16,arm-right19,arm-left19,front-skid,rear-skid,duct-right,duct-left,antenna]
camera_width = 19.35;
camera_screw_d = 2.2;
camera_pivot_setback = 10.283;
camera_pivot_height = 12;
camera_up_tilt = 15;
standoff_bore = 5.35;
sma_d = 6.55;
sma_flat = 6.05; // Set equal to sma_d for a round body.
sma_panel = 3.2;
sma_up_tilt = 30;
receiver_width = 14.5; // Including heat shrink
receiver_length = 24;
wire_height = 4.2; // Space above carbon
tie_width = 3.2;
bumper_screw_d = 3.35;
bumper_head_d = 6.4;
bumper_deck = 2.6;
$fn = 64;
e = 0.03;

module slab(points, height, z=0) {
    translate([0,0,z]) linear_extrude(height) polygon(points);
}

module post_holes(pitch, h) {
    for (s=[-1,1])
        translate([s*pitch/2,0,-e]) cylinder(d=standoff_bore,h=h+2*e);
}

module post_rings(pitch, h, outer=8.7) {
    for (s=[-1,1])
        translate([s*pitch/2,0,0]) cylinder(d=outer,h=h);
}

module camera_rail() {
    translate([camera_width/2,0,0]) rotate([90,0,90])
        linear_extrude(3.3)
            polygon([[-28.6,0],[-28.6,5],[-25.4,13.3],[-22.8,18.2],
                     [-7,18.2],[0.8,10.2],[2.8,4],[1.8,0]]);
}

module phoenix2() {
    difference() {
        union() {
            post_rings(19,9.7,8.8);
            slab([[-12,-29],[12,-29],[12,-26],[-12,-26]],1.6);
            for(s=[-1,1]) scale([s,1,1]) {
                camera_rail();
                hull() {
                    translate([9.5,0,0]) cylinder(d=8,h=9.5);
                    translate([camera_width/2,-5,0]) cube([3,3,6]);
                }
            }
        }
        post_holes(19,10);
        translate([-7.85,-9,4.25]) cube([15.7,15,16]);
        for(i=[0:3])
            translate([-20,-camera_pivot_setback-3.3*i,camera_pivot_height+.45*(i%2)])
                rotate([0,90,0]) cylinder(d=camera_screw_d,h=40);
        // Two long relief slots leave the four screw seats along the center rib.
        for(z=[5.9,15.35])
            hull() for(y=[-22,-10.7])
                translate([-20,y,z]) rotate([0,90,0]) cylinder(d=2,h=40,$fn=32);
    }
}

module camera_tilt_gauge() {
    // Stand on a flat surface and compare its slope with the camera body.
    linear_extrude(3)
        polygon([[0,0],[33,0],[33,3+33*tan(camera_up_tilt)],[0,3]]);
}

module rear_base(pitch, h) {
    post_rings(pitch, h);
    slab([[-pitch/2,-2.6],[pitch/2,-2.6],[pitch/2,2.8],[-pitch/2,2.8]],3);
}

module sma_face() {
    translate([0,12.1,8.8])
        rotate([sma_up_tilt,0,0]) children();
}

module sma() {
    difference() {
        union() {
            rear_base(22,12);
            hull() {
                translate([-11,0,0]) cube([22,2.7,3]);
                sma_face() rotate([-90,0,0]) cylinder(d=13,h=sma_panel);
            }
        }
        post_holes(22,15);
        sma_face() {
            translate([0,-7,0]) rotate([-90,0,0])
                linear_extrude(14)
                    intersection() {
                        circle(d=sma_d);
                        translate([-sma_d/2,-sma_d/2])
                            square([sma_flat,sma_d]);
                    }
            // Seat the inner washer on a flat surface normal to the connector.
            translate([0,e,0]) rotate([90,0,0]) cylinder(d=11,h=15);
        }
    }
}

module receiver() {
    w = receiver_width+8;
    first = 3;
    last = first+receiver_length;
    difference() {
        union() {
            rear_base(20,8);
            slab([[-10,-1],[10,-1],[w/2,4],[w/2,last-2],
                  [w/2-2,last],[-w/2+2,last],[-w/2,last-2],[-w/2,4]],2.2);
            for (s=[-1,1])
                translate([s*(receiver_width/2+0.75)-0.75,first,0])
                    cube([1.5,receiver_length-2,5]);
        }
        post_holes(20,8);
        for (s=[-1,1], p=[0.30,0.66])
            translate([s*(receiver_width/2+2.65)-0.7,first+receiver_length*p,-e])
                cube([1.4,tie_width,3]);
    }
}

// Arm X stations measured from the motor center along its radial axis.
// The guard is upside down in print orientation.
function arm_low(x) = -4.53-0.0044*x;
function arm_high(x) = 2.83-0.0553*x;
module guard_span(margin,z,h) {
    slab([[-66,arm_low(-66)-margin],[-29,arm_low(-29)-margin],
          [-29,arm_high(-29)+margin],[-66,arm_high(-66)+margin]],h,z);
}
module wire_guard() {
    roof=2.1;
    lip=1.4;
    difference() {
        union() {
            hull() {
                guard_span(1.0,0,0.2);
                guard_span(1.95,1.0,roof+wire_height+lip-1);
            }
        }
        // Extend the cut beyond both ends for wire entry.
        slab([[-67,arm_low(-67)-0.45],[-28,arm_low(-28)-0.45],
              [-28,arm_high(-28)+0.45],[-67,arm_high(-67)+0.45]],
              wire_height+lip+e,roof);
        for (x=[-59,-37])
            translate([x-tie_width/2,-15,-e]) cube([tie_width,30,0.85]);
    }
}

module antenna() {
    difference() {
        union() {
            rear_base(22,5.5);
            slab([[-11,0],[11,0],[11,3],[5.5,7],[4.5,14.8],
                  [-4.5,14.8],[-5.5,7],[-11,3]],3.5);
            translate([-4.5,11.5,0]) cube([9,3.3,5.5]);
        }
        post_holes(22,5.5);
        translate([-5.6,12.2,1.5]) cube([11.2,1.3,2.5]);
    }
}

if(part=="phoenix2") phoenix2();
if(part=="camera-tilt-gauge") camera_tilt_gauge();
if(part=="sma") sma();
if(part=="elrs") receiver();
if(part=="wire_right") translate([47.5,0,0]) mirror([0,1,0]) wire_guard();
if(part=="wire_left") translate([47.5,0,0]) wire_guard();
if(part=="antenna") antenna();

include <arm-outline.scad>

module capsule_pair(pitch,h,r) {
    hull() for (s=[-1,1]) translate([s*pitch/2,0,0])
        cylinder(r=r,h=h,$fn=40);
}

module skid(pitch,h) {
    difference() {
        hull() {
            capsule_pair(pitch-2,0.4,3);
            translate([0,0,1.7]) capsule_pair(pitch,h-1.7,4.45);
        }
        for (s=[-1,1]) translate([s*pitch/2,0,-e]) {
            cylinder(d=3.4,h=h+2*e);
            cylinder(d=6.6,h=h-2.6+e);
        }
    }
}

module duct_profile(inside=false,mouth=false) {
    if(inside)
        polygon(mouth ?
            [[19.8,3.8],[23,3.8],[26.3,9.1],[26.3,13.4],[23.8,18.3],[19.8,18.3]] :
            [[19.8,2.8],[23.1,2.8],[26.85,8.3],[26.85,14.15],[24,19.8],[19.8,19.8]]);
    else
        polygon([[22.8,0],[25.1,0],[28.9,7.1],[28.9,15.5],[25.3,22],[22.8,22]]);
}

module scoop_section(y, expanded=false, hollow=false) {
    translate([0,y,0]) rotate([90,0,0]) linear_extrude(.17)
        if (!expanded)
            duct_profile(hollow);
        else if(hollow)
            polygon([[19.8,2.65],[23.7,2.65],[27.35,7.6],
                     [27.35,14.9],[24.4,19.9],[19.8,19.9]]);
        else
            polygon([[22.7,0],[25.6,0],[29.6,6.5],[29.6,16.4],
                     [25.8,22],[22.7,22]]);
}

module scoop(hollow=false) {
    hull() {
        scoop_section(29,false,hollow);
        scoop_section(hollow ? 38.17 : 38,true,hollow);
    }
}

module side_duct() {
    difference() {
        union() {
            translate([0,35,0]) rotate([90,0,0])
                linear_extrude(74) duct_profile();
            scoop();
            for (pos=[[9.5,32.883],[10,-42.883]])
                hull() {
                    translate([pos[0],pos[1],19.75]) cylinder(d=8.5,h=2.4);
                    translate([23.3,max(-39.7,pos[1]-1.9),19.75]) cube([2.4,3.8,2.4]);
                }
        }
        // Thicker rims keep the faceted openings from folding inward.
        for(segment=[[33,70,false],[-36.9,2.25,true]])
            translate([0,segment[0],0]) rotate([90,0,0])
                linear_extrude(segment[1]) duct_profile(true,segment[2]);
        scoop(true);
        for (pos=[[9.5,32.883],[10,-42.883]])
            translate([pos[0],pos[1],19.5]) cylinder(d=5.45,h=3);
    }
}

module nose_outline(extra) {
    intersection() {
        offset(r=extra,$fn=32) polygon(arm_outline);
        translate([-16,-28]) square([45,56]);
    }
}

module arm_bumper(pattern) {
    difference() {
        union() {
            hull() {
                linear_extrude(.25) nose_outline(1.2);
                translate([0,0,1.5]) linear_extrude(7.5) nose_outline(2.5);
            }
            translate([0,0,8.9]) linear_extrude(4.6)
                difference() {
                    nose_outline(2.5);
                    offset(r=.45,$fn=32) polygon(arm_outline);
                    // Leave the inboard throat open for the arm shoulder.
                    translate([-22,-10]) square([8,20]);
                }
        }
        translate([0,0,-e]) cylinder(d=8.2,h=13.5+2*e);
        for (s=[-1,1],t=[-1,1])
            translate([s*pattern/sqrt(8),t*pattern/sqrt(8),-e]) {
                cylinder(d=bumper_head_d,h=6.43);
                cylinder(d=bumper_screw_d,h=13.5+2*e);
            }
    }
}

if(part=="front-skid") skid(19,12.2);
if(part=="rear-skid") skid(22,5.75);
if(part=="duct-right") translate([-9.5,5,0]) side_duct();
if(part=="duct-left") mirror([1,0,0]) translate([-9.5,5,0]) side_duct();
if(part=="arm-right16") arm_bumper(16);
if(part=="arm-left16") mirror([0,1,0]) arm_bumper(16);
if(part=="arm-right19") arm_bumper(19);
if(part=="arm-left19") mirror([0,1,0]) arm_bumper(19);
