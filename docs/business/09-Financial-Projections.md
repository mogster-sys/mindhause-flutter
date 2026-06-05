# MindHause — Financial Projections

## 1. What this document is

Three-year illustrative scenarios — conservative, expected, optimistic. The **cost side is grounded** (real obligations and rounded contractor estimates). The **revenue side is modelled** from publicly reported benchmarks for mobile productivity + indie one-time-purchase apps, until launch data exists to replace assumption with fact.

> The cost projections are real (rounded). The revenue projections are illustrative.

All figures in USD unless noted. Founder is currently in Australia; some costs originate AUD and convert.

---

## 2. Revenue model

| Source | Price (USD) | Notes |
|---|---|---|
| Full house unlock | $5.99 — $7.99 | One-time IAP. Single price point for v1. |
| Theme pack (individual) | $1.99 each | One-time IAP, 7 packs (default Greco-Roman is free) |
| Theme bundle (all 7) | $9.99 | Discount on individual; typical purchase pattern |
| Subscription | — | Not in v1 plan. Could be revisited post-launch for a Pro tier alongside the free+IAP base app. |
| Ads | — | **Never.** Structural commitment. |
| Data sale | — | **Never.** Structural commitment. |

### 2.1 ARPU per converted (paid) user

Modelled lifetime values, assuming a user who converts past the free tier:

| Scenario | Unlock | Themes purchased | Blended ARPU |
|---|---|---|---|
| Low (minimum conversion) | $5.99 | 0 themes (rare; many converters stop at unlock) | $5.99 |
| Typical | $6.99 | Avg 2 themes ($3.98) | $10.97 |
| High (engaged collector) | $6.99 | Theme bundle $9.99 | $16.98 |

**Modelled blended ARPU per paid user (gross, before platform cut)**: ~$10-12.
**Net to MindHause** (after Apple/Google IAP take of 15-30%, depending on platform + Apple Small Business Program eligibility): ~$7-10 per paid user.

> All revenue figures in the scenarios below are GROSS unless stated. To convert to net: multiply by ~0.70-0.85.

[FILL: validate against actual cohort data once launched. Confirm Apple Small Business Program eligibility — qualifies if annual proceeds < $1M, drops Apple's cut to 15% from 30%.]

### 2.2 Conversion funnel assumptions

Industry benchmarks for mobile productivity (from RevenueCat State of Subscriptions, Sensor Tower, App Annie reports — not directly cited; ranges represent observed bands):

| Stage | Conservative | Expected | Optimistic |
|---|---|---|---|
| Download → first session | 60% | 75% | 85% |
| First session → returning week-1 | 25% | 40% | 55% |
| Returning week-1 → returning week-4 | 30% | 50% | 65% |
| Returning week-4 → paid conversion | 3% | 8% | 15% |
| Free → Paid (compound) | ~0.7% | ~2.4% | ~5.8% |

The **paid conversion rate is the most sensitive variable** in the model. ADHD-targeted apps and apps with strong "no subscription" framing have shown above-band conversion in adjacent categories — but we don't have proof in this specific intersection. Treat optimistic as a stretch; expected as the working assumption; conservative as the floor we must beat to survive.

---

## 3. Cost structure

### 3.1 Pre-launch one-time costs (real)

| Item | Cost |
|---|---|
| Apple Developer Program (annual) | $99 |
| Google Play Developer (one-time) | $25 |
| Domain registration | ~$15 |
| Trademark filings (AU + US + UK/EU via Madrid) | ~$3,000-5,500 |
| Solicitor review (privacy + ToS + initial trademark) | ~$2,000 |
| Custom Blender hero pieces (7 timepieces + ionic column + bust) | $0-3,500 (DIY vs contractor at $40-80/hr × ~50 hrs) |
| Audio production (8 themes if not Suno-only) | $0-2,000 |
| App icon + store creative | $0-1,500 (DIY vs designer) |
| Optional paid asset upgrades (Binbun bundle minimum) | $26 |
| **Total one-time** | **~$6,000-15,500** |

### 3.2 Monthly recurring costs (real, pre-revenue)

| Item | Monthly |
|---|---|
| Email + Workspace | ~$6 |
| CI/CD (Codemagic free tier or GitHub Actions free) | $0 |
| Sentry crash reporting (free tier) | $0 |
| Apple Developer (amortised $99/12) | ~$8 |
| Domain (amortised) | ~$1.25 |
| **Monthly subtotal (solo, no salary draw)** | **~$15-20** |

Add founder cost-of-living separately: $[FILL — varies by jurisdiction + lifestyle]. Pre-revenue runway requires this to be supplied by raise / personal savings / part-time income.

### 3.3 Marketing spend (post-launch)

| Phase | Monthly |
|---|---|
| T+0 to T+30 (organic only) | $0 |
| T+30 to T+90 (paid acquisition test) | ~$500-2,000 |
| T+90 to T+180 (scale or pause) | ~$1,000-10,000 depending on CAC payback validation |

### 3.4 Post-launch hires (if validated)

Hires only if revenue or runway supports them.

| Role | Compensation range (AUD) | When |
|---|---|---|
| 3D artist (contractor) | $5,000-15,000 per theme pack | Per-pack basis as themes ship |
| Marketing / community manager (part-time contractor) | $3,000-6,000/month | After paid CAC validated |
| Backend engineer | NEVER (no backend planned) | — |
| iOS / Android specialist | $8,000-15,000/month | Only if platform-specific issues block growth |

---

## 4. Three-year scenarios

### 4.1 Conservative (downside protection)

Assumes: slow audience pickup, low conversion, no viral lift, no influencer breakthroughs.

| Year | Downloads | Free → Paid (0.7%) | Paid users | Revenue (ARPU $8) | Costs | Net |
|---|---|---|---|---|---|---|
| Y1 | 25,000 | 175 | 175 | $1,400 | $20,000 | -$18,600 |
| Y2 | 75,000 | 525 | 700 cum | $5,600 | $30,000 | -$24,400 |
| Y3 | 150,000 | 1,050 | 1,750 cum | $14,000 | $45,000 | -$31,000 |

**Implication**: lifestyle-business viability requires >25k downloads/year + finding the right cohort. Below this, app is a portfolio piece, not a business. **Survival floor in this scenario requires part-time founder income elsewhere or sustained raise reserve.**

### 4.2 Expected (working assumption)

Assumes: ADHD audience reach via 2-3 ADHD podcast / coach partnerships in year 1; organic content compounds; conversion rate at expected benchmark.

| Year | Downloads | Free → Paid (2.4%) | Paid users | Revenue (ARPU $11) | Costs | Net |
|---|---|---|---|---|---|---|
| Y1 | 80,000 | 1,920 | 1,920 | $21,120 | $30,000 (incl small marketing) | -$8,880 |
| Y2 | 250,000 | 6,000 | 7,920 cum | $87,120 | $55,000 (theme contractors + small ad spend) | $32,120 |
| Y3 | 500,000 | 12,000 | 19,920 cum | $219,120 | $90,000 (one part-time hire) | $129,120 |

**Implication**: profitable around month 18; sustainable lifestyle business by year 3; positive trajectory.

### 4.3 Optimistic (stretch — requires a hit)

Assumes: a viral moment (TikTok, Reddit, podcast); ADHD audience converts at 5%+; theme bundle attach rate is high.

| Year | Downloads | Free → Paid (5.8%) | Paid users | Revenue (ARPU $15) | Costs | Net |
|---|---|---|---|---|---|---|
| Y1 | 250,000 | 14,500 | 14,500 | $217,500 | $50,000 | $167,500 |
| Y2 | 1,000,000 | 58,000 | 72,500 cum | $1,087,500 | $200,000 (multiple hires) | $887,500 |
| Y3 | 2,500,000 | 145,000 | 217,500 cum | $3,262,500 | $400,000 | $2,862,500 |

**Implication**: founder takes meaningful salary year 2; team grows to 4-6; meaningful platform-builder territory. **This requires breaks we can't predict; not the base case.**

---

## 5. Sensitivity analysis — what drives the model

The expected scenario's profitability hinges on three variables:

| Variable | Range | Impact on Y3 net |
|---|---|---|
| Free→Paid conversion | 0.7% → 5.8% | -$31k → +$2.8M |
| ARPU | $8 → $15 | -2× → +2× revenue |
| Annual downloads Y3 | 150k → 2.5M | -$31k → +$2.8M |

The biggest lever is **reaching the right audience efficiently**. Marketing plan focuses on this asymmetry: cheap organic reach to the specific ADHD audience that converts above industry average.

---

## 6. Cash flow + runway

[FILL: actual current cash position + raise expectation.]

Indicative runway scenarios with a hypothetical $250k raise:
- **All-in monthly burn (one part-time hire + ~$2k/mo marketing + founder cost-of-living)**: ~$15-25k/month
- **Runway from $250k**: 10-16 months
- **Milestone target during runway**: ship v1, hit expected Y1 download trajectory, validate paid CAC, ship 2 theme packs

[FILL: founder's specific runway model; this is illustrative.]

---

## 7. Unit economics

Per converted user (post-launch, expected scenario):

| Metric | Value |
|---|---|
| LTV (lifetime value, conservative) | $8 |
| LTV (expected, with 2-theme attach) | $11 |
| LTV (high, with bundle attach) | $17 |
| CAC (organic — content/community) | ~$0 effective, attributing only marketing time |
| CAC (paid acquisition target) | <$2 for sustainable model with $8 LTV; <$4 with $11 |
| LTV:CAC target | 3:1 or better |
| Payback period (paid channels) | <12 months for sustainability |

**The honest framing**: at one-time-purchase pricing with no recurring revenue, paid acquisition has a hard ceiling. Above ~$2-3 CAC the unit economics break. This forces organic-first marketing — which is actually the founder's strength (content, founder story, ADHD-audience authenticity), not a constraint.

---

## 8. The "no subscription" question (the VC pushback)

Investors will ask: "Why not subscription? The LTV is structurally higher."

**Honest answers**:

1. **Audience-specific**: the ADHD / productivity-refugee segment has explicit subscription fatigue documented in qualitative feedback across competitor reviews. The "I'd pay $50 for this if I owned it but won't pay $5/mo" pattern is repeatedly observed.
2. **Privacy tension**: a subscription typically requires recurring authentication / receipt verification. The base app's "no accounts" stance and a subscription tier would need to be cleanly separated, not impossible but adds complexity.
3. **Honest LTV math**: a subscription app needs higher retention to clear the same revenue as a one-time unlock + 2 theme packs ($11). At our audience's known churn pattern, the math is closer than VC instinct suggests.
4. **Theme pack model substitutes**: ongoing theme releases (~quarterly) create natural re-engagement and revenue moments without the subscription emotional cost.
5. **Optionality preserved**: future "MindHause Pro" (cloud sync, multi-device, household features) COULD be subscription-priced for a different user segment without breaking the core promise. Not in v1 plan; explicitly available as an evolution if model proves out.

The position is reasoned, not dogmatic. We can show the math.

---

## 9. Key assumptions to validate post-launch

1. ADHD audience converts above industry-average free-to-paid for productivity apps
2. Theme pack attach rate sits at 2 per paid user lifetime average
3. Organic acquisition (content + community + founder story) can deliver 50%+ of downloads at <$1 effective CAC
4. App Store / Google Play visibility for a novel paradigm is achievable through ASO + content
5. Privacy positioning materially affects conversion (we predict yes; data will tell)

**Each assumption has a hypothesis-test plan in the marketing plan (`04`).**

---

## 10. What this section will look like in 6 months

Today this is a modelled scenario. By the time it's needed for a Series A or strategic acquisition discussion:
- Year 1 actual download + conversion + ARPU data
- Cohort retention curves
- CAC by channel
- LTV trajectory (early indication only since v1 launches with limited theme inventory)
- Revised projection model anchored on actual signal

That's the section we'll write then.
