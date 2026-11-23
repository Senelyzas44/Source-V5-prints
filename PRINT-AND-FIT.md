# TBS Source One V5 · Dark blue FPV print kit

The kit illustrates dark-blue prints and camera housing, graphite motor bells, and a black Axisflying Argus ECO F405/60A stack on the graphite frame. The hardware in the renders and GLB is a visual approximation. The actual motor and camera colors depend on the hardware you own.

Open `dark-blue-print-plate.3mf` for the arranged, 17-piece print set with the four-position camera holder, tilt gauge, and 16 × 16 mm motor-end guards. Load **dark-blue 95A TPU** and select your TPU profile in the slicer. The 3MF carries a dark-blue material swatch and the STLs contain geometry. `dark-blue-assembly.glb` is a separate color preview model for viewing the fitted design. See `underside-preview.jpg` for skid placement and `cutaway-preview.jpg` for the rear lower bay.

| STL | Print | Fit |
|---|---:|---|
| `phoenix2.stl` | 1 | Recessed 19 mm Phoenix 2 holder with four matched screw-hole pairs |
| `camera-tilt-gauge.stl` | 1 | Loose 15° setup gauge |
| `sma.stl` | 1 | 30° upward rear SMA bulkhead, 6.55 mm bore with one flat, 3.2 mm panel |
| `elrs.stl` | 1 | Tie-down tray for a heat-shrunk 2.4 GHz ELRS receiver, up to 14.5 × 24 mm |
| `wire_right.stl` and `wire_left.stl` | 2 each | Open-ended motor-wire covers with 4.2 mm of space above the arm |
| `arm-right16.stl` and `arm-left16.stl` | 2 each | Wraparound landing bumpers for 16 × 16 mm M3 motor patterns |
| `arm-right19.stl` and `arm-left19.stl` | Alternate | Wraparound bumpers for 19 × 19 mm M3 motor patterns |
| `front-skid.stl` and `rear-skid.stl` | 1 each | Low nose and tail protection on the existing lower post screw locations |
| `duct-right.stl` and `duct-left.stl` | 1 each | Faceted stack protectors with forward-facing intake scoops and open rear outlets |
| `antenna.stl` | 1 optional | Low rear tab for a horizontal 2.4 GHz T antenna |

## Print

- Start with **95A TPU**, a 0.4 mm nozzle, 0.2 mm layers, four walls, and 20–30% infill. Use your filament’s TPU temperature and speed profile. Print the STLs in their supplied orientation.
- The wire guards print roof-down. Keep support out of the guard channel. Check the angled SMA hole and washer seat after printing. Use localized removable support if your slicer needs it. On the first bumper, verify that the screw heads enter the 6.4 mm recesses and that the recess roofs printed cleanly. Add localized removable support there if your TPU profile needs it.
- Use the 16 × 16 mm bumpers for the EMAX ECO II 2306 motors represented here. Print and dry-fit one of each selected part before printing multiples. Each wraparound guard is about 10.4 g at full solid density for 1.2 g/cm³ TPU, before slicer infill savings. The tall side ducts may benefit from a brim and localized support under the ring tabs.

## Install

1. **Camera.** Remove the top plate and slide the holder onto the two 19 mm-spaced nose posts, with the slotted side panels pointing inward. Seat it above the lower nose plate and capture it vertically with split 5 mm-ID tubing as needed. Use the same hole on each side. The four hole pairs provide 3.3 mm increments of setback. Start with the forward-most holes for the least obstructed view. Install one M2 screw per side through the 3.3 mm panels, using suitable thread engagement. With the frame level, use the loose gauge as a side-on reference to set 15° up-tilt, then tighten according to the camera’s hardware requirements. Check that the camera holds position and verify the live view and cable clearance. The stock posts leave about 14 mm for the lens barrel.
2. **SMA.** Slide the angled mount onto the outer 22 mm-spaced tail posts. The SMA connector points aft and 30° up. Set the mount’s underside about 14.5 mm above the lower tail plate, and capture it vertically with tubing or split spacers. Check the connector body and flat, washer seating, and thread engagement through the 3.2 mm panel. The outer face accepts a straight SMA antenna. Leave slack in the pigtail and verify clearance to the battery and straps. Check the assembled video link in your usual flight attitude, since signal quality depends on antenna orientation and the receiving setup.
3. **ELRS receiver.** Install the tray facing aft on the inner 20 mm-spaced tail posts. Set its underside about 10.5 mm above the lower tail plate. The illustrated BETAFPV Nano 2.4 GHz receiver has a 12 × 19 mm footprint. Thread the ties before placing the receiver. Check your heat shrink and plug exit, and leave slack at the U.FL connector.
4. **2.4 GHz T antenna.** Slide the low tab onto the outer rear posts, directly beneath the SMA holder, with the tab facing aft. Set its underside about 3.3 mm above the lower tail plate. Pass one slim zip tie through the 2.5 × 1.3 mm slot and around the molded center of the antenna. Keep the 60 mm crossbar level and centered. Route the 80 mm coax past the SMA bracket, with slack by the U.FL connector. The ends overlap the rear 5-inch prop disks in plan view and rely on vertical separation. The modeled clearance is about 10.7 mm below an assumed lower blade envelope at Z=22 mm. With the battery unplugged, rotate the actual props by hand and flex the antenna upward to verify clearance before flying. A shorter compatible T antenna with a measured crossbar of about 40 mm keeps the tips outside the nominal 5-inch disks in this layout. The VTX antenna shown in the assembly is a visual placeholder.
5. **Wire guards.** Use the right version on the front-right and rear-left arms, and the left version on the front-left and rear-right. Turn each guard over about its long axis and position its midpoint about 47.5 mm inboard of the motor center. The wider end faces the frame. Loop two small zip ties around the guard and arm at the recessed bands. Route the motor wires under the cover and check that neither lip pinches the insulation.
6. **Motor-end bumpers.** Use the right version on the front-right and rear-left, and the left version on the other diagonal. Use the 16 mm pattern with the modeled ECO II 2306. Fit the wraparound lip around the carbon outline with its opening facing inboard. The tread sits about 6.5 mm below the central underside. The pad adds a nominal 2.6 mm under the motor screw heads. Measure actual thread engagement and ensure the screw ends clear the windings and that the center opening clears the shaft clip.
7. **Front and rear skids.** Seat each skid against the underside of its end plate. It uses the two existing lower screws on the 19 mm front or 22 mm rear posts. The recessed screw seats add about 2.6 mm to the required length. Verify thread engagement and that screws do not bottom in the posts. The skid bottoms sit slightly above the motor-foot landing plane so the four feet take a level landing.
8. **Stack protectors and scoops.** With the top plate off, slide the handed parts onto the inner front and rear posts, with the flared mouths facing the nose. Set their bottom edges about 7.5 mm above the upper face of the lower tail plate. The rings sit just under the top plate and can be captured with split spacers. Leave the intake, rear exhaust, and inboard openings clear. The shells clear the nominal 5-inch prop disks by at least 3.1 mm in the modeled layout. With the battery unplugged, check the actual blade sweep and flex, and confirm USB and plug access. Airflow, cooling and drag performance were not tested.

## Installed FT800 VTX

The assembly shows the T-Motor FT800 5.8 GHz VTX, rated up to 800 mW, in the rear lower bay beneath the ELRS tray. The approximate 23.5 × 21 mm case envelope, with separate mounting ears, cleared the frame and tray in CAD. The supplied stock frame CAD does not show a full 20 × 20 mm hole pattern in this bay. The model shows the VTX in its existing rear position using an assumed placement, with the mounting hardware omitted because its exact arrangement was unspecified. The short MMCX-to-SMA route to the 30° tail bulkhead is schematic. Use your installed lead with a gentle bend and enough slack at both connectors. [T-Motor FT800 specifications](https://www.t-hobby.com/products/tmotor-ft800-vtx)

## Hardware shown in the assembly

- **EMAX ECO II 2306**, four motors. The 16 × 16 mm pattern matches the inner square of the frame’s motor mounting slots. [EMAX specifications](https://shop.emaxmodel.com/products/emax-eco-ii-series-2306-1700kv-1900kv-2400kv-brushless-motor-for-rc-drone-fpv-racing)
- **Axisflying Argus ECO F405 and 60A ESC**, centered on the frame’s 30.5 × 30.5 mm M3 pattern. The nominal board envelopes cleared the frame in CAD. Check the installed power leads, plugs, capacitor and soft-mount height with your actual stack. [Axisflying specifications](https://www.axisflying.com/products/argus-eco-60a-55a-f405-stack)
- **BETAFPV Nano ELRS 2.4 GHz receiver and 2.4 GHz dipole T antenna**, modeled with the 60 mm antenna crossbar and 80 mm U.FL lead option. [Receiver specifications](https://betafpv.com/products/elrs-nano-receiver) · [Dipole specifications](https://betafpv.com/products/betafpv-t-antenna-for-receiver)
- **Standard RunCam Phoenix 2**, illustrated with a dark-blue housing. The mount uses the 19 mm case width and M2 side mounting shown in the RunCam dimensional drawing. [RunCam Phoenix 2 manual](https://isdb-t.com/wp-content/uploads/2024/11/Phoenix_2-Manual.pdf)

## Edit the parts

Keep `arm-outline.scad` beside `sourceone-v5-kit.scad`, then open the kit file in OpenSCAD. Choose the part in Customizer, change the relevant dimensions at the top, render with **F6**, then export an STL. The camera hole layout and tilt-gauge angle, receiver pocket, SMA bore, flat and up-tilt, wire channel height, and bumper hardware clearances are editable. Test-fit any changed part.

The frame interfaces were checked against the supplied STEP and a mesh assembly using the supplied STL. The 15 STL files each passed a single-solid, closed-mesh check. The hardware geometry was checked through nominal envelopes where described. Physical fit and the live camera image still need verification.
