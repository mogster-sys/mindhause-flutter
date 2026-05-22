# Asset Recon — 2026-05-10

Systematic asset gathering pass for MindHause Godot project. This folder is the consolidated, in-project artifact set replacing the loose Manus drop in `docs/_manus_drop_2026-05-09/`.

## Read in this order

1. **[requirements.md](requirements.md)** — what we need and why (the contract)
2. **[recon_free.md](recon_free.md)** — verified audit of free CC0 sources (Quaternius, Kenney, Poly Haven, AmbientCG, Sonniss, Godot Shaders, OpenGameArt)
3. **[recon_premium.md](recon_premium.md)** — verified audit of paid sources (Synty, KitBash3D, itch.io shaders/music, Sketchfab/Fab)
4. **[decisions.md](decisions.md)** — consolidated tier list (A/B/C/D), theme × category matrix, sequencing
5. **[tracking.md](tracking.md)** — live ledger; update as assets are downloaded and integrated

## Methodology
Two parallel `general-purpose` Claude subagents did the recon: one for free vendors, one for paid. Both visited actual product/asset pages (not category lists), captured real URLs/prices/licenses, and scored visual fit against the Journey/ABZÛ/Ghibli target on a 1–5 scale. Findings explicitly call out where the prior Manus pass was wrong (mostly: fabricated URLs, guessed prices, charitable fit scoring).

## Key findings at a glance

- **Materials gap** — solved by Poly Haven + AmbientCG (free CC0 PBR for every theme)
- **Shader/VFX gap** — solved by Godot Shaders + optional $26 Binbun bundle (everything Manus said was paid has a free equivalent)
- **Architecture geometry gap** — only partially solvable for free; forces a Path A/B/C decision (free low-poly vs. cheap Synty vs. premium KitBash3D)
- **Music gap** — no good free option; PixelLoops at $4.49/pack is the cheap fix
- **Manus errors** — multiple fabricated URLs, wrong prices, retired products (Gothic kit, Synty Victorian) — see `decisions.md` "Skip / corrections" section before chasing any Manus link
