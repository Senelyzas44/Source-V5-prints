# TBS Source One V5 · Reinforced dark-blue print kit

The kit illustrates dark-blue prints and camera housing, graphite motor bells, and a black Axisflying Argus ECO F405/60A stack on the graphite frame. The hardware in the renders and GLB is a visual approximation. The actual motor and camera colors depend on the hardware you own.

Open `dark-blue-print-plate.3mf` for the arranged, 17-piece print set with the four-position camera holder, tilt gauge, and zip-tie motor-end bumpers. Load **dark-blue 95A TPU** and select your TPU profile in the slicer. The 3MF carries a dark-blue material swatch and the STLs contain geometry. `dark-blue-assembly.glb` is a separate color preview model for viewing the fitted design. See `arm-detail-preview.jpg` for the bumpers and wire shields, `nose-preview.jpg` for the camera and scoop details, `underside-preview.jpg` for skid placement, and `cutaway-preview.jpg` for the rear lower bay.

| STL | Print | Fit |
|---|---:|---|
| `phoenix2.stl` | 1 | Recessed 19 mm Phoenix 2 holder with tall collars and four matched M2 screw-hole pairs |
| `camera-tilt-gauge.stl` | 1 | Loose 15° setup gauge |
| `sma.stl` | 1 | 30° upward rear SMA bulkhead, 6.55 mm bore with one flat, 3.2 mm panel |
| `elrs.stl` | 1 | Tie-down tray for a heat-shrunk 2.4 GHz ELRS receiver, up to 14.5 × 24 mm |
| `wire_right.stl` and `wire_left.stl` | 2 each | Tapered 3.8 mm-roof wire shields with 4.2 mm of space above the arm |
| `arm-strap-right.stl` and `arm-strap-left.stl` | 2 each | Bolt-free TPU shoes that share the outer wire-shield tie |
| `arm-right16.stl` and `arm-left16.stl` | Alternate | Faceted wraparound landing bumpers for 16 × 16 mm M3 motor patterns |
| `arm-right19.stl` and `arm-left19.stl` | Alternate | Wraparound bumpers for 19 × 19 mm M3 motor patterns |
| `front-skid.stl` and `rear-skid.stl` | 1 each | Low nose and tail protection on the existing lower post screw locations |
| `duct-right.stl` and `duct-left.stl` | 1 each | Faceted stack protectors with deep triangular intakes, open rear outlets, and a right-side USB opening |
| `antenna.stl` | 1 optional | Low rear tab for a horizontal 2.4 GHz T antenna |

## Print

- Start with **95A TPU**, a 0.4 mm nozzle, 0.2 mm layers, four walls, and 20–30% infill. Use your filament’s TPU temperature and speed profile. Print the STLs in their supplied orientation.
- Print the wire shields roof-down and the bolt-free shoes tread-down. Keep the wire channels and screw-head cavities open. Clear any print strands from the transverse tie tunnel before assembly. Localized support may help at the angled SMA seat, tall duct tabs, or the screw pockets on the bolt-on alternatives.
- Dry-fit one handed shoe, its matching shield, and a 3.6 mm zip tie before printing multiples. The included 3MF arranges the bolt-free version. The separate 16 × 16 mm and 19 × 19 mm bolt-on STLs are also included.

## Install

1. **Camera.** Remove the top plate and slide the tall collars onto the two nose posts at 19 mm spacing, with the side panels pointing inward. Seat the holder above the lower nose plate. Use the same hole on each side. The four pairs step back by 4.2 mm per position. Start with the forward-most pair for the least obstructed view. Install one M2 screw per side through the 4.5 mm panels and 2.4 mm clearance bores. Check screw length against your camera’s thread depth. With the frame level, use the loose gauge as a side-on reference to set 15° up-tilt and tighten the screws. Check that the camera holds its angle, then verify the live view and cable clearance. The carbon frame’s stock front posts leave about 14 mm for the lens barrel.
2. **SMA.** Slide the angled mount onto the outer 22 mm-spaced tail posts. The SMA connector points aft and 30° up. Set the mount’s underside about 14.5 mm above the lower tail plate, and capture it vertically with tubing or split spacers. Check the connector body and flat, washer seating, and thread engagement through the 3.2 mm panel. The outer face accepts a straight SMA antenna. Leave slack in the pigtail and verify clearance to the battery and straps. Check the assembled video link in your usual flight attitude, since signal quality depends on antenna orientation and the receiving setup.
3. **ELRS receiver.** Install the tray facing aft on the inner 20 mm-spaced tail posts. Set its underside about 10.5 mm above the lower tail plate. The illustrated BETAFPV Nano 2.4 GHz receiver has a 12 × 19 mm footprint. Thread the ties through the larger rounded slots before placing the receiver. Check your heat shrink and plug exit, and leave slack at the U.FL connector.
4. **2.4 GHz T antenna.** Slide the low tab onto the outer rear posts, directly beneath the SMA holder, with the tab facing aft. Set its underside about 3.3 mm above the lower tail plate. Pass one slim zip tie through the 3.15 × 1.65 mm slot and around the molded center of the antenna. Keep the 60 mm crossbar level and centered. Route the 80 mm coax past the SMA bracket, with slack by the U.FL connector. The ends overlap the rear 5-inch prop disks in plan view and rely on vertical separation. The modeled clearance is about 10.7 mm below an assumed lower blade envelope at Z=22 mm. With the battery unplugged, rotate the actual props by hand and flex the antenna upward to verify clearance before flying. A shorter compatible T antenna with a measured crossbar of about 40 mm keeps the tips outside the nominal 5-inch disks in this layout. The VTX antenna shown in the assembly is a visual placeholder.
5. **Wire guards.** Use the right version on the front-right and rear-left arms, and the left version on the front-left and rear-right. Turn each guard over about its long axis and position its midpoint about 45 mm inboard of the motor center. The wider end faces the frame. Use two ties at the recessed bands. For the bolt-free shoes, the band nearest the motor shares its tie with the shoe as described below. The wide center recess has a continuous backing over the wires. Route the motor wires under the cover and check that neither lip pinches the insulation.
6. **Bolt-free motor-end bumpers.** Use the right shoe on the front-right and rear-left and the left shoe on the other diagonal. With the battery disconnected and props removed, seat the shoe from below so its lip follows the carbon motor end. Put the saddle under the arm with the transverse tunnel aligned with the wire shield’s band nearest the motor. Thread a 3.6 mm zip tie through the tunnel and over that band to retain the shoe and shield together. Keep the tie head low on the side and trim the tail flush. Keep the shield’s second tie in its inboard band. The shoe has a 26.6 mm recess with about 4.6 mm of depth for the installed screw heads. Check that the shoe seats fully and that the shaft and case clear the TPU. Confirm that the shoe cannot slide or twist by hand, and rotate the actual props by hand after reinstalling them to verify clearance. Inspect the shoe and tie after a hard landing.

   For the **bolt-on alternatives**, match the motor’s 16 mm or 19 mm square pattern. These versions add a nominal 3.1 mm under the motor screw heads. Verify thread engagement, motor winding clearance, and shaft-clip clearance.

7. **Front and rear skids.** Seat each skid against the underside of its end plate. It uses the two existing lower screws on the 19 mm front or 22 mm rear posts. The recessed screw seats add about 2.9 mm to the required length. The recesses are 7.2 mm across, with flared entrances. Verify thread engagement and that screws do not bottom in the posts. The skid bottoms sit slightly above the motor-foot landing plane so the four feet take a level landing.
8. **Stack protectors and scoops.** With the top plate off, slide the handed parts onto the inner front and rear posts, with the wider triangular intakes facing the nose. Set their bottom edges about 7.5 mm above the upper face of the lower tail plate. The attachment rings sit just under the top plate. Leave the intakes, rear outlets, and inboard openings clear. The right protector has a service opening for the USB-C port shown in the assembly. Check plug fit against your actual stack orientation. The modeled scoops and mounts clear the nominal 5-inch prop disks by about 3 mm in plan view. With the battery unplugged, check the actual blade sweep and flex. Cooling and drag performance remain untested.

## Installed FT800 VTX

The assembly shows the T-Motor FT800 5.8 GHz VTX, rated up to 800 mW, in the rear lower bay beneath the ELRS tray. The approximate 23.5 × 21 mm case envelope, with separate mounting ears, cleared the frame and tray in CAD. The supplied stock frame CAD does not show a full 20 × 20 mm hole pattern in this bay. The model shows the VTX in its existing rear position using an assumed placement, with the mounting hardware omitted because its exact arrangement was unspecified. The short MMCX-to-SMA route to the 30° tail bulkhead is schematic. Use your installed lead with a gentle bend and enough slack at both connectors. [T-Motor FT800 specifications](https://www.t-hobby.com/products/tmotor-ft800-vtx)

## Hardware shown in the assembly

- **EMAX ECO II 2306**, four motors. The 16 × 16 mm pattern matches the inner square of the frame’s motor mounting slots. [EMAX specifications](https://shop.emaxmodel.com/products/emax-eco-ii-series-2306-1700kv-1900kv-2400kv-brushless-motor-for-rc-drone-fpv-racing)
- **Axisflying Argus ECO F405 and 60A ESC**, centered on the frame’s 30.5 × 30.5 mm M3 pattern. The nominal board envelopes cleared the frame in CAD. Check the installed power leads, plugs, capacitor and soft-mount height with your actual stack. [Axisflying specifications](https://www.axisflying.com/products/argus-eco-60a-55a-f405-stack)
- **BETAFPV Nano ELRS 2.4 GHz receiver and 2.4 GHz dipole T antenna**, modeled with the 60 mm antenna crossbar and 80 mm U.FL lead option. [Receiver specifications](https://betafpv.com/products/elrs-nano-receiver) · [Dipole specifications](https://betafpv.com/products/betafpv-t-antenna-for-receiver)
- **Standard RunCam Phoenix 2**, illustrated with a dark-blue housing. The mount uses the 19 mm case width and M2 side mounting shown in the RunCam dimensional drawing. [RunCam Phoenix 2 manual](https://isdb-t.com/wp-content/uploads/2024/11/Phoenix_2-Manual.pdf)

## Edit the parts

Keep `arm-outline.scad` beside `sourceone-v5-kit.scad`, then open the kit file in OpenSCAD. Choose the part in Customizer, change the relevant dimensions at the top, render with **F6**, then export an STL. The camera hole layout and tilt-gauge angle, receiver pocket, SMA bore, flat and up-tilt, wire channel height, and bumper hardware clearances are editable. Test-fit any changed part.

The frame interfaces were checked against the supplied STEP and a mesh assembly using the supplied STL. The 17 STL files each passed a single-solid, closed-mesh check. The hardware geometry was checked through nominal envelopes where described. Physical fit and the live camera image still need verification.
