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
    translate([camera_width/2,0,0]) rotate([90,0,90]) intersection() {
        // Bound the bevel to the concave profile so it cannot form a thin fin.
        linear_extrude(camera_rail_thickness) cheek_profile();
        union() {
            linear_extrude(camera_rail_thickness-.55) cheek_profile();
            hull() {
                translate([0,0,camera_rail_thickness-.6])
                    linear_extrude(.08) cheek_profile();
                translate([0,0,camera_rail_thickness-.06])
                    linear_extrude(.06) offset(delta=-.48) cheek_profile();
            }
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
            hull() for(side=[-1,1])
                rear_blend_node(side*11,0,0,4.45,4.5,.65);
            for(side=[-1,1])
                rear_blend_node(side*11,0,0,12,5.7,.7);
            hull() {
                for(side=[-1,1])
                    rear_blend_node(side*9.6,3.45,.3,5.3,3.35,.6);
                // Wider boss with radiused lips and the stock panel thickness.
                sma_face() rotate([-90,0,0])
                    rear_blend_node(0,0,0,sma_panel,9.4,.7);
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
            // The washer bears on the flat back of the SMA face.
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

// Closed eyelets hold the two stems of a single centered T antenna.
antenna_eye_bore = 3.55;
antenna_eye_spacing = 27;
antenna_station = 24.6;
antenna_height = 7.12;
antenna_eye_width = 4.65;

module antenna_eye(cut=false) {
    translate([antenna_eye_spacing/2,antenna_station,antenna_height])
        rotate([0,90,0])
            cylinder(d=cut ? antenna_eye_bore : 7.55,
                     h=antenna_eye_width+(cut ? 2*e : 0),center=true);
}

module antenna_branch() {
    stations=[[11,0,3.55],[12.25,5.3,2.8],[14.55,11.5,2.5],
              [15.2,17,2.5],[14.45,21.45,2.65],
              [antenna_eye_spacing/2,antenna_station,2.8]];
    linear_extrude(4.35)
        for(i=[0:len(stations)-2]) hull() for(k=[i,i+1])
            translate([stations[k][0],stations[k][1]])
                circle(r=stations[k][2],$fn=40);
}

module antenna() {
    difference() {
        union() {
            intersection() {
                rear_base(22,6.6,10.2);
                translate([-18,-4.3,-e]) cube([36,12,7]);
            }
            for(side=[-1,1]) scale([side,1,1]) {
                antenna_branch();
                antenna_eye();
            }
        }
        post_holes(22,6.6);
        for(side=[-1,1]) scale([side,1,1]) antenna_eye(true);
        // Leave room under the existing VTX pigtail.
        translate([-6,-4.35,3.15]) cube([3.3,5.65,2.35]);
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
        rounded_polygon([[-9.5,19.1],[-7.4,17.05],[7.4,17.05],[9.5,19.1],
                         [9.5,27.9],[7.4,29.95],[-7.4,29.95],[-9.5,27.9]],.85);
}

module shroud_wire_exits() {
    // Each motor bundle gets a low notch so the USB opening stays covered.
    for (end=[-1,1])
        translate([16,end*14.9,0]) rotate([90,0,90]) linear_extrude(18)
            rounded_polygon([[-5.15,6.0],[5.15,6.0],[5.15,11.45],
                             [3,13.75],[-3,13.75],[-5.15,11.45]],.75);
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

rear_brace_base = 7.0;
rear_brace_height = 4.85;

module rear_blend_node(x,y,bottom,top,radius,roundover=.65) {
    translate([x,y,bottom+roundover]) rotate_extrude($fn=36)
        intersection() {
            offset(r=roundover,$fn=16)
                square([radius-roundover,top-bottom-2*roundover]);
            translate([0,-roundover])
                square([radius+e,top-bottom+e]);
        }
}

module rear_post_boss() {
    rear_blend_node(10,-42.883,rear_brace_base,
                    rear_brace_base+rear_brace_height,5.15);
}

module lower_rear_brace() {
    // Rounded lofts enlarge the wing roots. The low crosspiece still gives
    // the upper power leads a clear path and grows from both sides of the bed.
    intersection() {
        union() for(hand=[-1,1]) scale([hand,1,1]) {
            hull() {
                rear_blend_node(22.0,-46.1,10.7,13.22,1.7,.48);
                rear_blend_node(22.7,-41.6,8.5,13.02,2.65);
                rear_blend_node(22.65,-37.2,8.65,13.02,2.75);
                rear_post_boss();
            }
            hull() {
                rear_post_boss();
                rear_blend_node(5.6,-39.1,7.0,11.85,3.2);
            }
            hull() {
                rear_blend_node(5.6,-39.1,7.0,11.85,3.2);
                rear_blend_node(0,-35.85,7.0,11.85,3.45);
            }
        }
        translate([-30,shroud_tail,6.5]) cube([60,19,10]);
    }
}

module cross_braces() {
    lower_rear_brace();
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
                shroud_wire_exits();
                scoop_airway();
                camera_driver_access();
            }
        }
        // The FT800 case occupies the center immediately behind the brace.
        translate([0,0,5.5]) linear_extrude(8.5)
            rounded_polygon([[-12.9,-50],[12.9,-50],[12.9,-46.65],[-12.9,-46.65]],.7);
        for(hand=[-1,1]) {
            translate([hand*9.5,32.883,9.55])
                chamfered_post_hole(shroud_post_bore,shroud_top-9.55);
            translate([hand*10,-42.883,rear_brace_base]) {
                chamfered_post_hole(shroud_post_bore,rear_brace_height);
                translate([0,0,rear_brace_height-e])
                    cylinder(d=shroud_post_bore,h=2);
            }
        }
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

// Rail sections follow the outside envelope of the carbon motor-pad lobes.
// The opening faces the arm, allowing the shoe to slide in from the motor end.
module motor_slide_rail_section(x,wall,lip,section) {
    // Separate rounded lofts keep the sliding cavity open where the hooks
    // turn inward. The footing widens toward the tread.
    points=section==2 ?
        [[wall-.08,14.41],[wall+2.45,14.41],[wall+2.30,16.45],
         [wall+1.55,17.16],[lip+.52,17.16],[lip,16.61],[lip,14.96]]
        : section==1 ?
        [[wall,7.9],[wall+2.8,8.15],[wall+2.75,14.2],
         [wall+2.03,15.12],[wall,15.12]]
        : [[wall-1.7,6.05],[wall+.95,6.05],[wall+2.75,8.15],
           [wall+2.48,8.82],[wall-.72,8.82]];
    translate([x,0,0]) rotate([90,0,90]) linear_extrude(.08,center=true)
        rounded_polygon(points,.37);
}

module motor_slide_rails() {
    stations=[[7.15,15.22,14.5],[8.4,15.17,13.0],
              [10.75,15.05,12.80],[12.7,14.1,12.46],[13.55,13.9,12.82]];
    for (side=[-1,1]) scale([1,side,1])
        for(i=[0:len(stations)-2],section=[0:2])
            hull() for(k=[i,i+1])
                motor_slide_rail_section(stations[k][0],stations[k][1],stations[k][2],section);
}

module arm_strap_bumper() {
    contact=9;
    slide_travel=7.2;
    difference() {
        union() {
            bumper_tread();
            hull() {
                strap_saddle_section(-36.7,.65,0,.2);
                strap_saddle_section(-38.9,1.72,2.5,contact-2.5);
            }
            motor_slide_rails();
            // The small nose wall stops against the end of the carbon pad.
            translate([0,0,contact-.12]) linear_extrude(4.7)
                intersection() {
                    difference() {
                        nose_outline(3.42);
                        offset(r=.55,$fn=32) polygon(arm_outline);
                    }
                    translate([14.35,-9.2]) square([6,18.4]);
                }
        }
        // Preserve the driver pocket and clear overlapping screw-head paths
        // while the shoe travels from its lift-in position to the nose stop.
        translate([0,0,4.35]) cylinder(d=26.6,h=contact+7);
        for (s=[-1,1],t=[-1,1],pattern=[16,19])
            hull() for(travel=[0,slide_travel])
                translate([s*pattern/sqrt(8)-travel,t*pattern/sqrt(8),4.35])
                    cylinder(d=7.4,h=contact+7);
        hull() for(travel=[0,slide_travel])
            translate([-travel,0,-e]) cylinder(d=8.2,h=4.4);
        // Thread a single tie at the wire shield's motor-side tie band.
        translate([-34,0,0]) rotate([90,0,0]) linear_extrude(22,center=true)
            rounded_polygon([[-2.4,4.85],[2.4,4.85],[2.4,6.15],
                             [1.45,7.05],[-1.45,7.05],[-2.4,6.15]],.45);
        // Side recess at the tunnel exit for a compact zip-tie head.
        translate([-34,8,0]) rotate([90,0,0]) linear_extrude(2.9)
            rounded_polygon([[-3.05,3.95],[3.05,3.95],[3.05,6.45],
                             [2.25,7.65],[-2.25,7.65],[-3.05,6.45]],.55);
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
