// TBS Source One V5 FPV accessories. Dimensions in mm.
// Select a part and render (F6) before exporting STL.
part = "phoenix2"; // [phoenix2,camera-tilt-gauge,sma,elrs,wire_right,wire_left,arm-right16,arm-left16,arm-right19,arm-left19,front-skid,rear-skid,duct-right,duct-left,antenna]
camera_width = 19.35;
camera_screw_d = 2.4;
camera_hole_pitch = 4.2;
camera_rail_thickness = 4.5;
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
tie_width = 3.8;
bumper_screw_d = 3.5;
bumper_head_d = 6.8;
bumper_deck = 2.9;
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
    rounded_polygon([[-35.1,0],[-35.1,5.4],[-32.4,14.2],[-29.0,20.8],
                     [-26.8,21.75],[-8.1,21.75],[-3.2,20.45],[1.8,16],
                     [4.8,9],[4.3,2.6],[1.4,0]],.8);
}

module camera_rail() {
    translate([camera_width/2,0,0]) rotate([90,0,90])
        union() {
            linear_extrude(camera_rail_thickness-.7) camera_outline();
            hull() {
                translate([0,0,camera_rail_thickness-.78])
                    linear_extrude(.10) camera_outline();
                translate([0,0,camera_rail_thickness-.10])
                    linear_extrude(.10) offset(delta=-.60) camera_outline();
            }
        }
}

module camera_collar() {
    hull() {
        cylinder(d=9.8,h=.7);
        translate([0,0,.9]) cylinder(d=10.6,h=20.6);
        translate([0,0,21.75]) cylinder(d=9.8,h=.55);
    }
}

module phoenix2() {
    difference() {
        union() {
            slab([[-12,-34.9],[12,-34.9],[12,-31.6],[-12,-31.6]],2.3);
            for(s=[-1,1]) scale([s,1,1]) {
                translate([9.5,0,0]) camera_collar();
                camera_rail();
            }
        }
        post_holes(19,22.3);
        // Barrel clearance between the two tall front collars.
        translate([0,-9.7,14.1]) rotate([-90,0,0]) scale([1,1.16,1])
            cylinder(r=8.05,h=15.8);
        for(i=[0:3]) {
            y = -camera_pivot_setback-camera_hole_pitch*i;
            z = camera_pivot_height+.35*(i%2);
            translate([-20,y,z]) rotate([0,90,0]) cylinder(d=camera_screw_d,h=40);
            for(s=[-1,1]) scale([s,1,1])
                translate([camera_width/2+camera_rail_thickness-.64,y,z])
                    rotate([0,90,0]) cylinder(d1=camera_screw_d,d2=3.5,h=.69);
        }
        for (window=[[6.1,-27.1,-9.3,3.8],[17.4,-26,-9.7,3.7]])
            hull() for(y=[window[1],window[2]])
                translate([-20,y,window[0]]) rotate([0,90,0])
                    cylinder(d=window[3],h=40,$fn=40);
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

module guard_span(margin,z,h) {
    translate([0,0,z]) linear_extrude(h)
        rounded_polygon([[wire_start,arm_low(wire_start)-margin],
                         [wire_end,arm_low(wire_end)-margin],
                         [wire_end,arm_high(wire_end)+margin],
                         [wire_start,arm_high(wire_start)+margin]],1.5);
}

module wire_guard() {
    roof=3.1;
    lip=1.65;
    bottom=roof+wire_height+lip;
    difference() {
        hull() {
            guard_span(1.8,0,0.25);
            guard_span(2.85,1.25,bottom-1.25);
        }
        slab([[wire_start-1,arm_low(wire_start-1)-.55],
              [wire_end+1,arm_low(wire_end+1)-.55],
              [wire_end+1,arm_high(wire_end+1)+.55],
              [wire_start-1,arm_high(wire_start-1)+.55]],
              wire_height+lip+e,roof);
        for (x=[-57,-34])
            translate([x-tie_width/2,-15,-e]) cube([tie_width,30,1.0]);
        // Shallow center relief keeps the protective roof continuous.
        translate([0,0,-e]) linear_extrude(.78)
            hull() for (x=[-50.5,-40.5])
                translate([x,.55]) circle(d=3.6,$fn=40);
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
        inside ? [[19.05,4],[20.2,2.95],[26.35,2.95],[28.35,5],
                  [28.6,8],[27.4,12.65],[23.8,18.9],[22.25,19.35],
                  [20.1,19.35],[19.05,18]] :
                 [[16.6,2],[18.5,0],[26.7,0],[30.8,3.4],[31.2,8.2],
                  [29.9,13.9],[25.2,21.8],[22.7,22.2],[18.6,22.2],[16.6,19.8]]
    ) : section==1 ? (
        inside ? [[18.3,3.15],[26.75,3.15],[29.4,7.1],[29.4,13],
                  [26.85,18.05],[24.4,19.3],[18.3,19.3]] :
                 [[23.45,0],[27.9,0],[32.1,5.6],[32.1,14.3],
                  [28.35,20.9],[24.9,22.25],[21.5,22.25],[21.5,19.8],[23.45,16.3]]
    ) : (
        inside ? [[18.2,3.2],[24.75,3.2],[26.55,6.5],[26.55,12.1],
                  [24.7,18.4],[23.45,19.2],[18.2,19.2]] :
                 [[23.05,0],[26.2,0],[29.2,4.9],[29.2,13.4],
                  [26.1,20.8],[24.75,22.15],[21.6,22.15],[21.6,19.75],[23.05,16.7]]
    );

module duct_section(y,section,inside) {
    translate([0,y,0]) rotate([90,0,0]) linear_extrude(.16,center=true)
        rounded_polygon(duct_outline(section,inside),inside ? .7 : .85);
}

module duct_shell(inside=false) {
    // Forward flare blends into the open inboard channel.
    stations = inside ? [[36,0],[32,0],[25,1],[-22,1],[-38,2]] :
                        [[35.6,0],[31,0],[24,1],[-22,1],[-37.6,2]];
    for(i=[0:len(stations)-2])
        hull() {
            duct_section(stations[i][0],stations[i][1],inside);
            duct_section(stations[i+1][0],stations[i+1][1],inside);
        }
}

module side_duct(service_port=false) {
    difference() {
        union() {
            duct_shell();
            for (pos=[[9.5,32.883],[10,-42.883]])
                hull() {
                    translate([pos[0],pos[1],19.3]) cylinder(d=9.65,h=2.95);
                    translate([22.2,max(-37.6,pos[1]-2.5),19.3]) cube([3.25,5,2.95]);
                }
        }
        duct_shell(true);
        for (pos=[[9.5,32.883],[10,-42.883]])
            translate([pos[0],pos[1],19.1]) cylinder(d=5.45,h=3.4);
        if(service_port)
            hull() for(y=[-2.25,5.85])
                translate([20,y,14.1]) rotate([0,90,0])
                    cylinder(d=7.65,h=16,$fn=48);
    }
}

module nose_outline(extra) {
    intersection() {
        offset(r=extra,$fn=32) polygon(arm_outline);
        translate([-16,-28]) square([45,56]);
    }
}

module arm_bumper(pattern) {
    contact=9;
    rim=4.75;
    difference() {
        union() {
            hull() {
                linear_extrude(.25) nose_outline(1.8);
                translate([0,0,1.8]) linear_extrude(contact-1.8) nose_outline(3.25);
            }
            translate([0,0,contact-.11]) linear_extrude(rim+.11)
                difference() {
                    nose_outline(3.25);
                    offset(r=.55,$fn=32) polygon(arm_outline);
                    translate([-22,-10.5]) square([8,21]);
                }
        }
        translate([0,0,-e]) cylinder(d=8.2,h=contact+rim+2*e);
        for (s=[-1,1],t=[-1,1])
            translate([s*pattern/sqrt(8),t*pattern/sqrt(8),-e]) {
                cylinder(d=bumper_screw_d,h=contact+rim+2*e);
                // Flatten the inner side of each pocket to retain the center web.
                intersection() {
                    union() {
                        cylinder(d=bumper_head_d,h=contact-bumper_deck+e);
                        cylinder(d1=7.6,d2=bumper_head_d,h=1.15);
                    }
                    rotate([0,0,atan2(t,s)]) translate([-3.2,-5,-e])
                        cube([8.4,10,contact]);
                }
            }
    }
}

if(part=="front-skid") skid(19,12.2);
if(part=="rear-skid") skid(22,5.75);
if(part=="duct-right") translate([-9.5,5,0]) side_duct(true);
if(part=="duct-left") mirror([1,0,0]) translate([-9.5,5,0]) side_duct();
if(part=="arm-right16") arm_bumper(16);
if(part=="arm-left16") mirror([0,1,0]) arm_bumper(16);
if(part=="arm-right19") arm_bumper(19);
if(part=="arm-left19") mirror([0,1,0]) arm_bumper(19);
