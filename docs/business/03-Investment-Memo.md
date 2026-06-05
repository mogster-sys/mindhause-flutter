# MindHause — Investment Memo

**For:** Prospective investors / strategic partners
**Stage:** [FILL — pre-seed / seed]
**Raising:** [FILL amount, e.g., "AUD $X for Y% equity"]
**Use of funds horizon:** [FILL months runway]

---

## 1. The opportunity in one paragraph

Mobile productivity is a multi-billion-dollar market saturated with apps that all converge on the same flat-list paradigm — and abandon their users at >90% within 30 days. The audience this hurts most (ADHD / executive-function challenges, ~5-6% of adults globally) is acutely underserved. MindHause is the first productivity app to make the **memory palace technique** literal — your tasks become physical objects in a 3D house you walk through. It is built on a defensible positioning that established competitors find hard to follow: **100% on-device, no accounts, free base + theme IAPs (no subscription planned)**. A working engine exists today.

---

## 2. Why now

- **Mobile hardware** (mid-range phones from ~2021 onward) can render a stylised 3D environment at a fluid frame rate. The technical floor has dropped.
- **Godot 4** matured to a production-ready engine with proper mobile profile, enabling small teams to ship 3D mobile content that previously required Unity/Unreal-class teams.
- **Privacy regulation tightening** (GDPR, CCPA, UK-DPA, Apple's ATT, Google's Privacy Sandbox) has reshaped what users expect — "no data collection" went from quirky to genuinely valuable as a purchasing signal. App Store reviews increasingly cite privacy.
- **Subscription fatigue** is real and quantifiable [FILL: cite recent State of Subscriptions report from RevenueCat or similar]. The "one-time purchase, owned forever" model has a re-emerging cohort of users who actively seek it.
- **ADHD diagnosis rates** have risen significantly in the past decade [FILL recent CDC/APA data]; awareness of the productivity-app graveyard among this audience is high; willingness to pay for a tool that *finally* feels different is documented in adjacent app categories (Brilliant, Headspace pre-subscription era).

These don't add up to "couldn't have built this 5 years ago" — they add up to "now is when the audience is most ready."

---

## 3. What gives us the right to win

| Factor | What we have | Why competitors can't copy |
|---|---|---|
| **Spatial paradigm** | A working 3D engine + 10 rooms + theme system | Established players' user base expects lists; a redesign would alienate it. Smaller players don't have the engineering bandwidth. |
| **Privacy positioning** | True on-device, no cloud, no accounts | VC-funded incumbents depend on telemetry/cloud for retention metrics and monetisation. Switching would cannibalise their model. |
| **One-time + IAP pricing** | Free tier + one-time unlock + theme IAPs | Public market expectations + ARR-obsessed investor logic push incumbents toward subscriptions. Hard to follow without revenue-mix impact. |
| **ADHD-first design** | Built from the ground up for this brain | Most productivity apps treat ADHD as a "support" feature; we treat it as the primary user. |
| **Engine-as-platform** | Architecture supports adjacent layers (decision tools, journal, meditation) | The engine took real time to build. Without it, "spatial" is shallow gimmicks. |

---

## 4. Traction (current)

[FILL with actual numbers as they exist. Honest framing — pre-launch, so:]
- Repo state: 60-70% structurally complete; first room kit at production grade; pitch video pipeline working; asset acquisition pipeline operational and documented
- No live users yet — pre-launch by deliberate choice; v1 launches at quality bar, not at MVP urgency
- DecisionLens (sister app) is a complementary product also at pre-launch; signals platform direction

The honest framing: this is a **product investment**, not a metrics investment. The bet is on the paradigm + the team + the engineering substrate, not on a J-curve already started.

---

## 5. Business model recap

- **Free tier**: Foyer + 2 rooms, basic cat, default Greco-Roman theme
- **One-time unlock** (~$5-8): full house, all object types, full cat behaviours, focus mode
- **Theme packs** ($1-3 each, or discounted bundle): 8 themes
- **Not in v1 plan**: subscriptions
- **Never**: ads, data sale

LTV per user [FILL]: at unlock + average 2-3 theme packs over lifetime, blended ARPU is approximately $8-15. See `09-Financial-Projections.md` for sensitivity ranges.

---

## 6. Use of funds

[FILL with actual breakdown. Indicative structure:]

| Category | % | Purpose |
|---|---|---|
| Engineering | ~40% | Flutter↔Godot embedding, SQLite integration, remaining theme kits to production grade |
| Content | ~25% | Custom Blender hero pieces (7 timepieces + ionic column + statue), audio production for 8 themes, app icon + store assets |
| Marketing | ~20% | Organic content + paid acquisition test; ASO; influencer / community seeding in ADHD + productivity spaces |
| Operations / legal | ~10% | Trademark filings, privacy/legal review, accounting |
| Reserve | ~5% | Buffer |

**Runway target**: [FILL months — typically 12-18 for a pre-seed round].

**Milestones unlocked with this round**:
1. Ship v1 to App Store + Google Play
2. Reach [FILL] paid conversions (the primary KPI for round 2)
3. Ship 2 theme packs as IAP (proves the post-launch monetisation cadence)
4. Demonstrable retention curve at 30/60/90 days

---

## 7. Exit thesis

Honest answers for an investor's "how do we get out":

**Most likely**: acquisition by a productivity-platform incumbent (Notion, Todoist parent Doist, Microsoft for Teams adjacency, Apple for first-party Reminders enhancement, or Anthropic / Apple / Google as part of an "on-device intelligence" play). Multiple of MAU + IAP revenue, or strategic premium for the engine/IP.

**Possible**: independent profitable lifestyle business at modest scale (~$1-5M annual revenue, lean team) — explicitly fine; the founder is aligned on this as a happy outcome.

**Less likely**: IPO trajectory — would require expanding to platform-of-platforms positioning. Not the v1-3 plan.

**Important**: the **no-data-collection commitment is non-negotiable** under any exit. A buyer who wants to turn the user base into a data product is not a buyer we sell to. This narrows the exit space slightly but is core to the product's defensibility.

---

## 8. What could go wrong (top three)

(Full risk treatment in `11-Risk-Assessment.md`.)

1. **App store discoverability is brutal for novel paradigms** — "memory palace organiser" is not a search term anyone types. ASO and content marketing have to do heavy lifting; paid acquisition for a $5-8 one-time-purchase product needs careful CAC discipline.
2. **The 3D layer adds engineering complexity that flat-list competitors don't carry** — bugs in the 3D layer affect the whole product's perception. Mitigation: organiser mode is fully functional standalone, so 3D issues degrade gracefully.
3. **Hypothesis about ADHD audience willingness-to-pay needs validation** — we believe this audience converts above average for a tool that genuinely fits them. The pre-launch hypothesis test is documented in the marketing plan.

---

## 9. Why this team

[FILL: founder bio — relevant background, why ADHD/spatial cognition is personal, prior shipped work, why this problem now. VCs invest in people more than ideas. The honest answer here is the most important section of this memo.]

---

## 10. Terms

[FILL: indicative terms — valuation cap / discount for SAFE, or priced round terms; pro-rata rights; board structure if any; founder vesting; option pool.]

[FILL: timeline expectations for close.]

---

## 11. Read-on-from-here

For the operating plan: **02-Business-Plan.md**
For the technical depth: **08-Technical-Specifications.md**
For the market & positioning: **04-Marketing-Plan.md** + **05-Competitor-Analysis.md**
For the numbers: **09-Financial-Projections.md**
For risks: **11-Risk-Assessment.md**
