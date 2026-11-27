// TBS Source One V5 FPV accessories. Dimensions in mm.
// Select a part and render (F6) before exporting STL.
part = "stack-shroud"; // [stack-shroud,phoenix2-cradle,wire_right,wire_left,camera-tilt-gauge,sma,elrs,arm-right16,arm-left16,arm-right19,arm-left19,arm-strap-right,arm-strap-left,front-skid,rear-skid,antenna]
camera_width = 19.3;       // Inside distance between the screw seats
camera_screw_d = 2.5;
camera_rail_thickness = 3.4;
camera_post_bore = 5.3;     // Sliding clearance for 5 mm posts
camera_post_pitch = 19;     // Center distance between the nose posts
camera_pivot_setback = 11.5; // Rearward from the front post axis
camera_pivot_height = 10.95;   // Above the nose plate
camera_up_tilt = 15;
standoff_bore = 5.35;
shroud_post_bore = 5.85;
shroud_tail = -47.55;
shroud_top = 32.15;
sma_d = 6.55;
sma_flat = 6.05; // Set equal to sma_d for a round body.
sma_panel = 3.2;
sma_up_tilt = 30;
receiver_width = 14.5; // Including heat shrink
receiver_length = 24;
wire_start = -65;          // Distances along the arm measured from the motor axis
wire_end = -20;
wire_floor = 1.5;
wire_mouth_flare = .22;    // Extra clearance around the bore at both ends
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

// Closed low sleeves leave the stock posts exposed at lens height. The
// rear stays open and each screw seat grows out of its own continuous foot.
camera_sleeve_height = 4.65;
module cheek_profile() {
    rounded_polygon([[-25,2.0],[-25,15],[-22.4,19.5],[-17.5,22.4],
                     [-10.5,22.4],[-7.8,19.5],[-4.6,9.0],[-3.4,7.15],
                     [.35,7.15],[.35,0],[-22.6,0]],1.15);
}

module camera_side() {
    // The heel extends across the post axis. Its full width enters the sleeve.
    translate([camera_width/2,0,0]) rotate([90,0,90]) union() {
        linear_extrude(camera_rail_thickness-.55) cheek_profile();
        hull() {
            translate([0,0,camera_rail_thickness-.6])
                linear_extrude(.08) cheek_profile();
            translate([0,0,camera_rail_thickness-.06])
                linear_extrude(.06) offset(delta=-.48) cheek_profile();
        }
    }
    translate([camera_post_pitch/2,0,0]) hull() {
        cylinder(r=4.93,h=.45);
        translate([0,0,.65]) cylinder(r=5.1,h=camera_sleeve_height-1.4);
        translate([0,0,camera_sleeve_height-.36]) cylinder(r=4.85,h=.36);
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

module phoenix2_cradle() {
    difference() {
        union() {
            for (hand=[-1,1]) scale([hand,1,1]) camera_side();
            hull() for (hand=[-1,1])
                translate([hand*camera_post_pitch/2,0,0]) cylinder(r=3.75,h=3.25);
        }
        for (hand=[-1,1]) translate([hand*camera_post_pitch/2,0,0]) {
            chamfered_post_hole(camera_post_bore,camera_sleeve_height);
            translate([0,0,camera_sleeve_height-e]) cylinder(d=camera_post_bore,h=5);
        }
        // One common axis through the two side walls sets the camera tilt.
        translate([-17,-camera_pivot_setback,camera_pivot_height])
            pointed_screw_hole(camera_screw_d,34);
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
// The tape sole is on the print bed and on the arm in use.
function arm_low(x) = -4.53-0.0044*x;
function arm_high(x) = 2.83-0.0553*x;

function arm_mid(x) = (arm_low(x)+arm_high(x))/2;

// Each section lies on the taper centerline. Only the full, smooth sole touches tape.
module wire_station(x) {
    translate([x,arm_mid(x),0]) rotate([90,0,90])
        linear_extrude(.06,center=true) children();
}

module wire_outer(x,relief=0) {
    foot=(arm_high(x)-arm_low(x))/2-.27;
    shoulder=max(5.2,foot+.65);
    wire_station(x) rounded_polygon([
        [-foot+.24,0],[foot-.24,0],[foot+.54,.50],[shoulder,1.30],
        [shoulder,3.6],[shoulder-.4,4.45-relief/2],[1.7,7.55-relief],
        [.85,7.8-relief],[-.85,7.8-relief],[-1.7,7.55-relief],
        [-shoulder+.4,4.45-relief/2],[-shoulder,3.6],[-shoulder,1.30],
        [-foot-.54,.50]],.25);
}

module wire_cavity(x,flare=0) {
    // The pitched shoulders meet at a short bridge over the straight bore.
    wire_station(x) offset(r=flare,$fn=32) rounded_polygon([
        [-3.36,wire_floor],[3.36,wire_floor],[3.72,wire_floor+.36],
        [3.72,3.28],[1.04,5.95],[-1.04,5.95],[-3.72,3.28],
        [-3.72,wire_floor+.36]],.27);
}

module wire_guard() {
    // The shallow saddle accepts the existing shoe tie, 34 mm inboard of the motor.
    stations=[[wire_start+.03,.20],[wire_start+2.3,0],[-37,0],
              [-36.2,.47],[-31.8,.47],[-31,0],[wire_end-2.3,0],[wire_end-.03,.20]];
    bore=[[wire_start-e,wire_mouth_flare],[wire_start+1.5,0],
          [wire_end-1.5,0],[wire_end+e,wire_mouth_flare]];
    difference() {
        union() for(i=[0:len(stations)-2])
            hull() for(k=[i,i+1]) wire_outer(stations[k][0],stations[k][1]);
        for(i=[0:len(bore)-2])
            hull() for(k=[i,i+1]) wire_cavity(bore[k][0],bore[k][1]);
    }
}

// Open saddle for a molded horizontal receiver-antenna hub.
antenna_seat_width = 16.8;
antenna_seat_depth = 8.8;
antenna_seat_station = 16.6;
module antenna() {
    difference() {
        union() {
            intersection() {
                rear_base(22,6.6,10.2);
                translate([-18,-4.3,-e]) cube([36,12,7]);
            }
            slab([[-11,0],[11,0],[11,3.5],[antenna_seat_width/2,9.2],
                  [antenna_seat_width/2,antenna_seat_station+antenna_seat_depth/2],
                  [-antenna_seat_width/2,antenna_seat_station+antenna_seat_depth/2],
                  [-antenna_seat_width/2,9.2],[-11,3.5]],4.35);
        }
        post_holes(22,6.6);
        // The pitched roof leaves a short bridge over the transverse tie tunnel.
        translate([-antenna_seat_width/2-e,antenna_seat_station,0])
            rotate([90,0,90]) linear_extrude(antenna_seat_width+2*e)
                polygon([[-2.05,.85],[2.05,.85],[2.05,2.05],
                         [.75,3.35],[-.75,3.35],[-2.05,2.05]]);
    }
}

if(part=="phoenix2-cradle") phoenix2_cradle();
if(part=="camera-tilt-gauge") camera_tilt_gauge();
if(part=="sma") sma();
if(part=="elrs") receiver();
if(part=="wire_right") translate([47.5,0,0]) wire_guard();
if(part=="wire_left") translate([47.5,0,0]) mirror([0,1,0]) wire_guard();
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

// Installed frame coordinates, millimeters. Each solid flank receives two
// separate cuts: a framed service window and an oblique forward intake.
module flank_section(y,inner,outer,low) {
    translate([0,y,0]) rotate([90,0,0]) linear_extrude(.04,center=true)
        rounded_polygon([[inner,low+.85],[inner+1,low],[outer-1.4,low],
                         [outer,low+2.55],[outer,24.7],[outer-1.75,shroud_top],
                         [inner+.75,shroud_top],[inner,shroud_top-1]],.5);
}

module flank() {
    // Taper both ends around the arm roots and the propeller sweeps.
    rows=[[shroud_tail+.02,18.4,23.6,12.1],[-40,18.1,25.4,9.4],
          [-29,20.0,27.15,8.05],[-22.45,23.85,29.1,7.68],
          [21.9,23.85,29.5,7.68],[28,18.45,30.8,8.25],
          [35.9,16.75,29.85,10.2]];
    for(i=[0:len(rows)-2]) hull() for(k=[i,i+1])
        flank_section(rows[k][0],rows[k][1],rows[k][2],rows[k][3]);
}

module shroud_usb() {
    translate([16,0,0]) rotate([90,0,90]) linear_extrude(18)
        rounded_polygon([[-9.8,10.45],[9.8,10.45],[13.0,11.65],
                         [18.15,17.3],[18.15,21.7],[12.65,28.2],
                         [-12.65,28.2],[-18.15,21.7],[-18.15,17.3],
                         [-13.0,11.65]],1.15);
}

module inlet_station(y,x,z,w,h) {
    translate([x,y,z]) rotate([90,0,0]) linear_extrude(.10,center=true)
        rounded_polygon([[-w/2,-h/2],[w/2,-h/2],[w/2,h*.04],
                         [w*.16,h/2],[-w*.33,h/2],[-w/2,h*.22]],1.05);
}

module scoop_airway() {
    // The outer face and its USB surround stay intact. The passage turns
    // diagonally inward and opens into the stack bay behind the front posts.
    stations=[[36.8,23.05,20.55,7.25,12.0],[33,22.6,20.25,7.6,12.1],
              [28.7,20,19.7,7.2,11.7],[23.2,15.3,19.1,7.4,11.2]];
    for(i=[0:len(stations)-2]) hull() for(k=[i,i+1])
        inlet_station(stations[k][0],stations[k][1],stations[k][2],
                      stations[k][3],stations[k][4]);
}

module upper_node(x,y,r) {
    translate([x,y,shroud_top-4.1]) cylinder(r=r,h=4.1);
}

module cross_braces() {
    // The flat rear edge is also the bed face. The swept front brace
    // converges at the nose as it grows in the tail-down print orientation.
    translate([0,0,shroud_top-4.85]) linear_extrude(4.85)
        rounded_polygon([[-22.7,shroud_tail],[22.7,shroud_tail],[24.2,-41.1],
                         [21.7,-37.65],[-21.7,-37.65],[-24.2,-41.1]],1.05);
    for(hand=[-1,1]) scale([hand,1,1]) {
        hull() { upper_node(24.05,18.35,4.7); upper_node(9.5,32.883,5.1); }
        hull() { upper_node(9.5,32.883,5.1); upper_node(0,42.6,3.6); }
    }
}

// The nose side walls overlap the outside of the camera cheeks. The inward
// returns follow the carbon plates along the harness between camera and stack.
module nose_wall_section(row,section) {
    y=row[0]; inner=row[1]; outer=row[2]; lip=row[3]; low=row[4]; high=row[5];
    wall=[[inner,low+.7],[inner+.5,low],[outer-1.05,low],[outer,low+1.7],
          [outer,high-1.9],[outer-.7,high],[inner+.5,high],[inner,high-.7]];
    foot=[[lip,0],[inner+1.2,0],[inner+1.2,3.05],[inner,3.05],[lip,1.7]];
    profile=section==0 ? wall :
        [for(p=foot) [p[0],section==1 ? low+p[1] : high-p[1]]];
    translate([0,y,0]) rotate([90,0,0]) linear_extrude(.06,center=true)
        rounded_polygon(profile,section==0 ? .45 : .22);
}

module harness_wall() {
    stations=[[27.2,16.8,21.1,12.4,9.69,shroud_top],
              [33.3,15.85,19.6,11.3,9.69,shroud_top],
              [36.0,15.15,18.65,11.1,9.69,shroud_top],
              [44.8,12.5,16.45,10.9,9.69,shroud_top],
              [49.3,12.45,16.4,11.2,9.69,shroud_top],
              [51.4,13.52,16.65,13.46,9.69,shroud_top],
              [66.1,13.52,16.65,13.46,9.69,shroud_top],
              [68.65,13.52,16.42,13.46,10.35,31.7],
              [69.95,13.52,16.12,13.46,11.65,30.3],
              [70.35,13.52,15.95,13.46,12.5,29.3]];
    for (i=[0:len(stations)-2],section=[0:2]) hull() for(k=[i,i+1])
        nose_wall_section(stations[k],section);
}

module camera_driver_access() {
    // The large entry ends against the solid camera cheek and exposes its M2 screw.
    translate([12,76.883-camera_pivot_setback,9.55+camera_pivot_height])
        rotate([0,90,0]) cylinder(d=6.5,h=7);
}

module front_post_web() {
    // Both front feet seat on the nose plate, setting the USB window height.
    hull() {
        translate([9.5,32.883,9.55]) cylinder(r=4.72,h=shroud_top-9.55);
        translate([24.8,21.8,9.55]) cube([2.3,3.4,shroud_top-9.55]);
    }
}

module stack_shroud() {
    difference() {
        union() {
            cross_braces();
            for (hand=[-1,1]) scale([hand,1,1]) difference() {
                union() { flank(); front_post_web(); harness_wall(); }
                shroud_usb();
                scoop_airway();
                camera_driver_access();
            }
        }
        for(hand=[-1,1],pos=[[9.5,32.883,shroud_top-9.55],[10,-42.883,4.85]])
            translate([hand*pos[0],pos[1],shroud_top-pos[2]])
                chamfered_post_hole(shroud_post_bore,pos[2]);
    }
}

module print_shroud() {
    translate([0,20,-shroud_tail]) rotate([90,0,0]) stack_shroud();
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
if(part=="stack-shroud") print_shroud();
if(part=="arm-right16") arm_bumper(16);
if(part=="arm-left16") mirror([0,1,0]) arm_bumper(16);
if(part=="arm-right19") arm_bumper(19);
if(part=="arm-left19") mirror([0,1,0]) arm_bumper(19);

if(part=="arm-strap-right") arm_strap_bumper();
if(part=="arm-strap-left") mirror([0,1,0]) arm_strap_bumper();
