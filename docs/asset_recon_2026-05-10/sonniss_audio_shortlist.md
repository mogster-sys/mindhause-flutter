# Sonniss Audio Shortlist — Per Missing SFX Slot

**Source:** Sonniss GDC 2024 Game Audio Bundle (605 WAVs, 28 GB at `godot_palace/audio/sonniss/`, gitignored)
**Compiled:** 2026-05-27 from a per-slot keyword scan of the full filename listing

**Honest coverage:** Sonniss 2024 leans heavily toward vehicle/weapon/foley + tech/sci-fi categories. It has minimal cat content (one real cat sound) and no Westminster-style clock chimes. **Of the 13 missing SFX slots, ~7 have strong Sonniss candidates, 2 need editing/isolation work, and 4 need Freesound or similar.**

When auditioning:
- All files are uncompressed 24-bit/48k or 96k WAV. Convert chosen file to OGG at 160 kbps for the project.
- Use Audacity / Reaper: trim silence, fade in/out, normalise to ~-6 dB peak, export.
- Place the converted `.ogg` at `godot_palace/audio/sfx/<slot_name>.ogg`.

---

## CAT SOUNDS — Sonniss covers 1 of 4

### ✅ `cat_meow.ogg` — STRONG match
**Best**: `Mechanical Wave - Sound Effects Collection/ANMLCat_Cat Moew_ 03_MWSFX_SEC.wav` *(yes, "Moew" is the actual filename typo)*
- The ONLY direct cat sound in Sonniss 2024. Generic friendly meow.
- Trim to ~0.6–0.8s, fade ends.

### ❌ `cat_purr.ogg` — NOT IN SONNISS
**Use Freesound instead.** Search terms: "cat purr loop", "cat purring close". Recommended URLs to audition were noted earlier in `decisions.md`.

### ❌ `cat_hiss.ogg` — NOT IN SONNISS
**Use Freesound instead.** Search: "cat hiss", "feline hiss aggressive".

### ❌ `cat_chirp.ogg` — NOT IN SONNISS
**Use Freesound instead.** Search: "cat chirp", "cat trill greeting". (Specifically the short chirpy "brrrt" sound cats make.)

---

## MONSTER SOUNDS — Sonniss covers monster_chase strongly

### ✅ `monster_chase.ogg` — STRONG, layered approach
This is best as a **layered loop**: heavy footsteps + creature growl + tension drone underneath. Sonniss has all three components:

**Footsteps layer**:
- `DavidDumais - Robotic Creatures Sound FX/CREAMisc_Heavy Mechanical Footsteps 03_DDUMAIS_MCSFX.wav`

**Growl/roar layer** (pick one):
- `DavidDumais - Robotic Creatures Sound FX/CREAMisc_Creature 05 Long Growl 31_DDUMAIS_MCSFX.wav` — longer rumbling growl
- `Chupapsound - Essential Scifi/GRWL ROAR ANGRY.wav` — sharper angry roar accent

**Tension bed layer** (pick one):
- `Doex Studio - Qantum UI/UI_BACKGROUND_LOW_DarkDrone_01.wav` — dark drone, perfect undertone
- `InMotionAudio - GEODRONE/DSGNDron_Geofon24_InMotionAudio_GEODRONE.wav` — geofon-recorded dread drone

**Workflow**: in Audacity, stack the three on separate tracks, mix to taste (-3 dB footsteps, -6 dB growl, -12 dB drone), 3–5s seamless loop, export as `monster_chase.ogg`.

---

## CHIME SOUNDS — Sonniss covers 5 of 8

### ✅ `chime_water_drip.ogg` — STRONG (3 candidates)
- `InMotionAudio - Cave Design/WATRDrip_SingleDripDesign05_InMotionAudio_CaveDesign.wav` — designed cave drip
- `InMotionAudio - Cave Design/WATRDrip_SingleDrip03_InMotionAudio_CaveDesign.wav` — natural cave drip
- `Justsoundeffects - Water in Motion/WATRDrip_Dripping Water On Metal Pot Lid_JSE_WIM_Mono.wav` — drip onto metal basin (perfect for clepsydra)

Audition all three; the metal-pot-lid one may suit a Greco-Roman clepsydra best.

### ✅ `chime_digital.ogg` — STRONG (2 candidates)
- `BluezoneCorp - Futuristic User Interface/Bluezone_BC0303_futuristic_user_interface_high_tech_beep_038.wav` — clean digital tone
- `UberDuo - The Mountain Townhouse Audio Playset/BEEPAppl_Microwave, Beeps_UberDuo_TOWN.wav` — domestic microwave beep (more "homely" if the digital clock is in Cottage Kitchen)

### ❌ `chime_westminster.ogg` — NOT IN SONNISS
**Use Freesound instead.** Search: "Westminster chime", "grandfather clock quarter hour". This one is well-stocked on Freesound.

### ✅ `chime_holo_pulse.ogg` — STRONG (3 candidates)
- `BluezoneCorp - Alien Interface/Bluezone_BC0300_alien_interface_sci_fi_transition_004.wav` — sci-fi pulse transition
- `BluezoneCorp - Alien Interface/Bluezone_BC0300_alien_interface_sci_fi_transition_008.wav` — alt take
- `BluezoneCorp - Futuristic User Interface/Bluezone_BC0303_futuristic_user_interface_transition_006.wav` — UI transition pulse

All read as holographic pulse tones. Sci-Fi Gymnasium / Treasury fit.

### 🟡 `chime_cathedral_bell.ogg` — WEAK in Sonniss, editing required
- `Mechanical Wave - Sound Effects Collection/BELLHand_Metallic Bell_ 22_MWSFX_SEC.wav` — handbell, too small without pitch-shift + heavy reverb to read as "cathedral"
- `Bolt - Berlin Vignettes - Ambiences and Sonic Curiosities/AMBUrbn_Berlin Balcony Late Afternoon Walla Ambulance Public Transport Church Bells_BOLT_Berlin Vignettes_H1 9624.wav` — REAL church bells, but buried in a city ambience (Berlin street walla + ambulance siren in the same file)

**Recommendation: use Freesound.** Search "church bell toll", "cathedral bell ring". Many clean isolated samples.

### ✅ `chime_incense_clink.ogg` — STRONG (2 candidates, ideal match)
- `BluezoneCorp - Tiny Gears - Small Mechanism/Bluezone_BC0301_tiny_gears_small_mechanism_click_003.wav` — small mechanical click
- `BluezoneCorp - Tiny Gears - Small Mechanism/Bluezone_BC0301_tiny_gears_small_mechanism_click_complex_011.wav` — complex click sequence

These read perfectly as a small weight clinking onto wood/bronze — exactly what an incense clock would sound like when a weight drops through to mark an hour. (The Bluezone "Tiny Gears" pack is genuinely the right kind of source for this niche.)

### 🟡 `chime_cuckoo.ogg` — WEAK in Sonniss, isolation required
- `Sonik Sound Library - Spatial Countryside/AMBBird_Ambience, Rural, Residencial, Birds Chorus, Cuckoo, Light Human Activity_KS_Spatial Counstryside-Surround_KSL_KS011.wav` — cuckoo IS in this file but it's in a 5–10 min countryside ambience with other birds and traffic

**Recommendation: use Freesound.** Search "cuckoo bird call clean", "cuckoo clock". Plentiful isolated samples; Sonniss isolation work isn't worth the time.

### ✅ `chime_bunker_static.ogg` — STRONG (2 candidates)
- `Pole Position - Electric Guitar Pickup Interference/Interference - Cable - Buzz Hum - Swells to Sputtering Noise.wav` — buzzy interference (perfect for broken bunker radio)
- `Bolt - ARP 2600- Droids, Blips, Drones & more/SCICmpt_Retro Computer Glitches Sawtooth Chaotic_BOLT_ARP2600.wav` — retro computer glitch noise (Fallout bunker-tech vibe)

The ARP 2600 retro-computer one fits the "salvaged bunker tech" brief best.

---

## Coverage summary

| Slot | Sonniss coverage | Best workflow |
|---|---|---|
| cat_meow | ✅ direct match | Sonniss → trim → OGG |
| cat_purr | ❌ none | Freesound |
| cat_hiss | ❌ none | Freesound |
| cat_chirp | ❌ none | Freesound |
| monster_chase | ✅ layered (3 packs) | Sonniss → layer in Audacity → loop → OGG |
| chime_water_drip | ✅ 3 strong | Sonniss → trim → OGG |
| chime_digital | ✅ 2 strong | Sonniss → trim → OGG |
| chime_westminster | ❌ none | Freesound |
| chime_holo_pulse | ✅ 3 strong | Sonniss → trim → OGG |
| chime_cathedral_bell | 🟡 buried | Freesound (easier) |
| chime_incense_clink | ✅ 2 ideal | Sonniss → trim → OGG |
| chime_cuckoo | 🟡 buried | Freesound (easier) |
| chime_bunker_static | ✅ 2 strong | Sonniss → trim → OGG |

**7 of 13 → directly from Sonniss.** **4 of 13 → Freesound** (cat_purr, cat_hiss, cat_chirp, chime_westminster). **2 of 13 → easier on Freesound than isolating from Sonniss** (chime_cathedral_bell, chime_cuckoo).

So a focused Freesound run only needs to find **6 specific sounds**, all of which are abundantly available there.

---

## Quick audition workflow

For each Sonniss-sourced sound:

```bash
# Play the Sonniss WAV directly (any audio player; or in WSL with mpv/ffplay)
mpv "/home/mogie/projects/mindhause/godot_palace/audio/sonniss/<path>"

# In Audacity:
# 1. Import the WAV
# 2. Trim to length per shopping list spec
# 3. Fade in/out (10–50ms)
# 4. Normalise to -6 dB peak
# 5. File → Export → Export as OGG → 160 kbps stereo
# 6. Save as godot_palace/audio/sfx/<slot_name>.ogg

# In Godot, the import is automatic on next project open;
# .ogg files just work in AudioStreamPlayer3D/AudioStreamPlayer.
```

Time estimate to finish all 7 Sonniss-sourced SFX (assuming you like the candidates): **~45 minutes**. The monster_chase layer takes most of it.
