// TBS Source One V5 FPV accessories. Dimensions in mm.
// Select a part and render (F6) before exporting STL.
part = "phoenix2-right"; // [phoenix2-right,phoenix2-left,camera-tilt-gauge,sma,elrs,wire_right,wire_left,arm-right16,arm-left16,arm-right19,arm-left19,arm-strap-right,arm-strap-left,front-skid,rear-skid,duct-right,duct-left,antenna]
camera_width = 19.8;
camera_screw_d = 2.6;
camera_hole_pitch = 3.6;
camera_rail_thickness = 3.2;
camera_post_bore = 5.85;
camera_lens_half_gap = 8.6;
camera_pivot_setback = 10.283;
camera_pivot_height = 11.25;
camera_up_tilt = 15;
standoff_bore = 5.35;
duct_post_bore = 5.85;
duct_top = 22.25;
sma_d = 6.55;
sma_flat = 6.05; // Set equal to sma_d for a round body.
sma_panel = 3.2;
sma_up_tilt = 30;
receiver_width = 14.5; // Including heat shrink
receiver_length = 24;
wire_height = 4.2; // Space above carbon
tie_width = 4.36;
bumper_screw_d = 3.5;
bumper_head_d = 6.8;
bumper_deck = 3.1;
$fn = 64;
e = 0.03;

module rounded_polygon(points,r) {
    offset(r=r,$fn=32) offset(delta=-r) polygon(points);
}

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

module camera_outline() {
    rounded_polygon([[-22.9,0],[-24.3,4.1],[-24.5,13.4],[-22,17.6],
                     [-8,20],[-1.5,18.8],[3,15],[4.4,9],[3.6,1.3],[1.4,0]],.75);
}

// Each cheek mounts on one post and leaves the rear connector area open.
module camera_rail() {
    translate([camera_width/2,0,0]) rotate([90,0,90])
        union() {
            linear_extrude(camera_rail_thickness-.55) camera_outline();
            hull() {
                translate([0,0,camera_rail_thickness-.63])
                    linear_extrude(.09) camera_outline();
                translate([0,0,camera_rail_thickness-.09])
                    linear_extrude(.09) offset(delta=-.48) camera_outline();
            }
        }
}

module camera_collar() {
    hull() {
        cylinder(d=10,h=.75);
        translate([0,0,.85]) cylinder(d=10.6,h=19.6);
        translate([0,0,20.65]) cylinder(d=9.9,h=.55);
    }
}

module chamfered_post_hole(d,h) {
    translate([0,0,-e]) cylinder(d=d,h=h+2*e);
    translate([0,0,-e]) cylinder(d1=d+1.0,d2=d,h=.82);
    translate([0,0,h-.8]) cylinder(d1=d,d2=d+1.0,h=.82);
}

module pointed_screw_hole(d,h) {
    r=d/2;
    translate([0,0,0]) rotate([90,0,90])
        linear_extrude(h) union() {
            circle(d=d);
            polygon([[-.707*r,.707*r],[.707*r,.707*r],[0,1.4143*r]]);
        }
}

module phoenix2_cheek() {
    collar_height=21.2;
    difference() {
        union() {
            translate([9.5,0,0]) camera_collar();
            camera_rail();
        }
        translate([9.5,0,0])
            chamfered_post_hole(camera_post_bore,collar_height);
        // The lower ring retains the post. The open upper collar clears the barrel.
        translate([0,-8,3.2]) cube([camera_lens_half_gap,15,20]);
        for(i=[0:3])
            translate([camera_width/2-e,
                       -camera_pivot_setback-camera_hole_pitch*i,camera_pivot_height])
                pointed_screw_hole(camera_screw_d,camera_rail_thickness+2*e);
    }
}

module camera_tilt_gauge() {
    linear_extrude(4.2)
        polygon([[0,0],[33,0],[33,3+33*tan(camera_up_tilt)],[0,3]]);
}

module rear_base(pitch,h,outer=9.9,bridge=4.1) {
    post_rings(pitch,h,outer);
    slab([[-pitch/2,-3.1],[pitch/2,-3.1],[pitch/2,3.25],[-pitch/2,3.25]],bridge);
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
                translate([-11,0,0]) cube([22,3.1,4.1]);
                sma_face() rotate([-90,0,0]) cylinder(d=15.2,h=sma_panel);
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
            translate([0,e,0]) rotate([90,0,0]) cylinder(d=11.7,h=15);
        }
    }
}

module receiver() {
    w = receiver_width+12.2;
    first = 3;
    last = first+receiver_length;
    difference() {
        union() {
            rear_base(20,8);
            slab([[-10,-1],[10,-1],[w/2,4],[w/2,last-4],
                  [w/2-3.35,last],[-w/2+3.35,last],[-w/2,last-4],[-w/2,4]],2.9);
            for (s=[-1,1]) scale([s,1,1])
                translate([receiver_width/2,first,0])
                    cube([2.3,receiver_length-3.5,5.7]);
        }
        post_holes(20,8);
        for (s=[-1,1], p=[0.30,0.66])
            translate([s*(receiver_width/2+3.6),first+receiver_length*p,-e])
                linear_extrude(4)
                    hull() for(y=[-.86,.86])
                        translate([0,y]) circle(d=2.08,$fn=32);
    }
}

// Arm X stations measured from the motor center along its radial axis.
// The guard is upside down in print orientation.
function arm_low(x) = -4.53-0.0044*x;
function arm_high(x) = 2.83-0.0553*x;
wire_start = -63.5;
wire_end = -27;

module wire_section(margin,z,end_setback=0) {
    x1=wire_start+end_setback;
    x2=wire_end-end_setback;
    translate([0,0,z]) linear_extrude(.18)
        rounded_polygon([[x1,arm_low(x1)-margin],[x2,arm_low(x2)-margin],
                         [x2,arm_high(x2)+margin],[x1,arm_high(x1)+margin]],1.7);
}

module wire_guard() {
    roof=3.8;
    lip=1.65;
    bottom=roof+wire_height+lip;
    difference() {
        union() {
            hull() {
                wire_section(1.65,0,2.25);
                wire_section(2.98,2.35);
            }
            hull() {
                wire_section(2.98,2.25);
                wire_section(2.66,bottom-.18);
            }
        }
        slab([[wire_start-1,arm_low(wire_start-1)-.55],
              [wire_end+1,arm_low(wire_end+1)-.55],
              [wire_end+1,arm_high(wire_end+1)+.55],
              [wire_start-1,arm_high(wire_start-1)+.55]],
              wire_height+lip+e,roof);
        for (x=[-57,-34])
            translate([x-tie_width/2,-15,-e]) cube([tie_width,30,1.17]);
        // The wide inset ends above a continuous roof.
        translate([0,0,-e]) linear_extrude(1.13)
            hull() for (x=[-51.1,-39.9])
                translate([x,.55]) circle(d=5.3,$fn=40);
    }
}

module antenna() {
    difference() {
        union() {
            intersection() {
                rear_base(22,6.6,10.2);
                translate([-18,-4.3,-e]) cube([36,12,7]);
            }
            slab([[-11,0],[11,0],[11,3.5],[6.4,7],[5.65,14.8],
                  [-5.65,14.8],[-6.4,7],[-11,3.5]],4.1);
            translate([-5.65,10.7,0]) cube([11.3,4.1,6.6]);
        }
        post_holes(22,6.6);
        translate([-6.2,12.05,1.75]) cube([12.4,1.65,3.15]);
    }
}

if(part=="phoenix2-right") phoenix2_cheek();
if(part=="phoenix2-left") mirror([1,0,0]) phoenix2_cheek();
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
    head_seat = h-2.9;
    difference() {
        hull() {
            capsule_pair(pitch,.45,5.2);
            translate([0,0,1.4]) capsule_pair(pitch,h-1.4,6);
        }
        for (s=[-1,1]) translate([s*pitch/2,0,-e]) {
            cylinder(d=3.5,h=h+2*e);
            cylinder(d=7.2,h=head_seat+e);
            cylinder(d1=8,d2=7.2,h=1.1);
        }
    }
}

function duct_outline(section,inside) =
    section==0 ? (
        inside ? [[19.05,-1.25],[24.65,-1.25],[28.35,5],
                  [28.6,8],[27.4,12.65],[23.8,18.9],[22.25,19.35],
                  [20.1,19.35],[19.05,18]] :
                 [[16.6,2],[18.5,0],[26.7,0],[30.8,3.4],[31.2,8.2],
                  [29.9,13.9],[25.2,21.8],[24.9,duct_top],[18.6,duct_top],[16.6,19.8]]
    ) : section==1 ? (
        inside ? [[18.3,-1.25],[25.7,-1.25],[29.4,7.1],[29.4,13],
                  [26.85,18.05],[24.4,19.3],[18.3,19.3]] :
                 [[23.45,0],[27.9,0],[32.1,5.6],[32.1,14.3],
                  [28.35,20.9],[27.1,duct_top],[21.5,duct_top],[21.5,19.8],[23.45,16.3]]
    ) : (
        inside ? [[18.2,-1.25],[24.3,-1.25],[26.55,6.5],[26.55,12.1],
                  [24.7,18.4],[23.45,19.2],[18.2,19.2]] :
                 [[23.05,0],[26.2,0],[29.2,4.9],[29.2,13.4],
                  [26.1,20.8],[24.75,duct_top],[21.6,duct_top],[21.6,19.75],[23.05,16.7]]
    );

module duct_section(y,section,inside) {
    translate([0,y,0]) rotate([90,0,0]) linear_extrude(.16,center=true)
        rounded_polygon(duct_outline(section,inside),inside ? .7 : .85);
}

module duct_shell(inside=false) {
    stations = inside ? [[36,0],[32,0],[25,1],[-22,1],[-38,2]] :
                        [[35.6,0],[31,0],[24,1],[-22,1],[-37.6,2]];
    for(i=[0:len(stations)-2])
        hull() {
            duct_section(stations[i][0],stations[i][1],inside);
            duct_section(stations[i+1][0],stations[i+1][1],inside);
        }
}

module side_duct() {
    ring_base=17.75;
    ring_h=duct_top-ring_base;
    difference() {
        union() {
            duct_shell();
            for (pos=[[9.5,32.883],[10,-42.883]])
                hull() {
                    translate([pos[0],pos[1],ring_base])
                        cylinder(d=10.1,h=ring_h);
                    translate([22.2,max(-37.6,pos[1]-2.5),ring_base])
                        cube([3.25,5,ring_h]);
                }
        }
        duct_shell(true);
        // USB and cable access across the stack, open at the installed lower edge.
        translate([17,0,0]) rotate([90,0,90]) linear_extrude(20)
            rounded_polygon([[-21,-3],[21,-3],[21,12.2],[18.8,18.45],
                             [-18.8,18.45],[-21,12.2]],1);
        for (pos=[[9.5,32.883],[10,-42.883]])
            translate([pos[0],pos[1],ring_base])
                chamfered_post_hole(duct_post_bore,ring_h);
    }
}

module print_duct() {
    // The tab and upper rail sit on the bed. The access notch grows upward.
    rotate([180,0,0])
        translate([-9.5,5,-duct_top]) side_duct();
}

module nose_outline(extra) {
    intersection() {
        offset(r=extra,$fn=32) polygon(arm_outline);
        translate([-16,-28]) square([45,56]);
    }
}

module bumper_section(extra,z,h=.2) {
    translate([0,0,z]) linear_extrude(h) nose_outline(extra);
}

module bumper_tread() {
    hull() {
        bumper_section(1.4,0);
        bumper_section(3.6,2.25);
    }
    hull() {
        bumper_section(3.6,2.15);
        bumper_section(3.65,6.25);
        bumper_section(3.42,8.78,.22);
    }
}

module arm_bumper(pattern) {
    contact=9;
    rim=4.75;
    difference() {
        union() {
            bumper_tread();
            translate([0,0,contact-.12]) linear_extrude(rim+.12)
                difference() {
                    nose_outline(3.42);
                    offset(r=.55,$fn=32) polygon(arm_outline);
                    translate([-22,-10.5]) square([8,21]);
                }
        }
        translate([0,0,-e]) cylinder(d=8.2,h=contact+rim+2*e);
        for (s=[-1,1],t=[-1,1])
            translate([s*pattern/sqrt(8),t*pattern/sqrt(8),-e]) {
                cylinder(d=bumper_screw_d,h=contact+rim+2*e);
                // The wider driver entry grows outward from the center web.
                intersection() {
                    union() {
                        cylinder(d=bumper_head_d,h=contact-bumper_deck+e);
                        cylinder(d1=8.2,d2=bumper_head_d,h=2.25);
                    }
                    rotate([0,0,atan2(t,s)]) translate([-3.2,-5,-e])
                        cube([8.5,10,contact]);
                }
            }
        // Shallow tread grooves sit outside the screw pockets.
        for (side=[-1,1])
            translate([0,side*11.9,-e]) linear_extrude(1.23)
                hull() for (x=[-4.15,5.15])
                    translate([x,0]) circle(d=1.7,$fn=32);
    }
}

module strap_saddle_section(start,margin,z,h) {
    end=-12.3;
    translate([0,0,z]) linear_extrude(h)
        rounded_polygon([[start,arm_low(start)-margin],[end,arm_low(end)-margin],
                         [end,arm_high(end)+margin],[start,arm_high(start)+margin]],2);
}

module arm_strap_bumper() {
    contact=9;
    rim=4.75;
    difference() {
        union() {
            bumper_tread();
            hull() {
                strap_saddle_section(-36.7,.65,0,.2);
                strap_saddle_section(-38.9,1.3,2.5,contact-2.5);
            }
            translate([0,0,contact-.12]) linear_extrude(rim+.12)
                difference() {
                    nose_outline(3.42);
                    offset(r=.55,$fn=32) polygon(arm_outline);
                    translate([-22,-10.5]) square([8,21]);
                }
        }
        // A common open pocket clears existing heads on both mounting patterns.
        translate([0,0,4.35]) cylinder(d=26.6,h=contact+rim);
        translate([0,0,-e]) cylinder(d=8.2,h=4.4);
        // Thread a 3.6 mm tie across the saddle at the wire shield's outer band.
        translate([-34,0,5.85]) rotate([90,0,0]) linear_extrude(22,center=true)
            hull() for(x=[-1.45,1.45])
                translate([x,0]) circle(d=1.65,$fn=40);
        for (side=[-1,1])
            translate([0,side*11.9,-e]) linear_extrude(1.23)
                hull() for (x=[-4.15,5.15])
                    translate([x,0]) circle(d=1.7,$fn=32);
    }
}

if(part=="front-skid") skid(19,12.2);
if(part=="rear-skid") skid(22,5.75);
if(part=="duct-right") print_duct();
if(part=="duct-left") mirror([1,0,0]) print_duct();
if(part=="arm-right16") arm_bumper(16);
if(part=="arm-left16") mirror([0,1,0]) arm_bumper(16);
if(part=="arm-right19") arm_bumper(19);
if(part=="arm-left19") mirror([0,1,0]) arm_bumper(19);

if(part=="arm-strap-right") arm_strap_bumper();
if(part=="arm-strap-left") mirror([0,1,0]) arm_strap_bumper();
