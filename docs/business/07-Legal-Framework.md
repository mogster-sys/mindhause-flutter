# MindHause — Legal Framework

## 1. What this document is

Scaffolding for the legal documents the app needs to ship + the compliance posture across major privacy regimes. **Not a substitute for solicitor review.** Templates and structure live here; final wording requires sign-off by qualified counsel in at least one jurisdiction (typically the founder's home jurisdiction — Australia — plus US review before App Store / Google Play submission).

The good news: MindHause's "no data collected, no cloud, no accounts" stance makes most privacy-regime compliance dramatically simpler than for a typical cloud app. The hard work is **making the legal documents reflect that simplicity honestly and verifiably**.

---

## 2. Required documents for store submission

### 2.1 Privacy Policy (REQUIRED by Apple App Store + Google Play)

**Must address**:
- What personal data is collected → **None.** (Honest, plain English. The killer line: "MindHause does not collect, transmit, or store any personal data on any server.")
- What data stays on-device → tasks, notes, settings, decisions (when DecisionLens integrated), all in local SQLite
- Third-party SDKs → **None.** No analytics. No advertising SDK. No crash-reporting SDK that exfiltrates user content (consider: Sentry can be configured to NOT report user data — if used, document this).
- IAP payment processing → handled by Apple StoreKit / Google Play Billing; payment data is theirs, not ours
- Children's privacy → if not designed for under-13 (which we aren't): explicit statement to that effect (COPPA compliance)
- Data export & deletion → users can export all their data at any time via the in-app export; uninstalling removes all data (which is true since there's no cloud copy)
- Contact for privacy questions → email + response time commitment

**Draft outline**:
```
PRIVACY POLICY
Last updated: [date]

The Short Version
=================
MindHause does not collect your data. There are no accounts. There is no cloud.
Your tasks, notes, and settings live only on your device. When you uninstall the
app, that data is gone. We have no copy.

What we don't collect: any personal information, any usage analytics, any
crash data containing user content, your contacts, your location, anything.

What stays on your device: your tasks, projects, notes, habits, settings,
themes, decisions (if you use the DecisionLens module). All in a local SQLite
database. You can export it at any time from Settings > Data > Export.

What payment processors handle: when you buy the full-house unlock or a
theme pack, Apple or Google handles the transaction. They have their own
privacy policies for that. We receive only the confirmation that you purchased.

Children's privacy: MindHause is not directed at children under 13. If you
believe a child has used the app and provided information, please contact us.

How to reach us: privacy@mindhause.app [FILL email]

Detailed Version
================
[Standard sections covering each point above in legal-but-still-readable language]
```

[FILL: solicitor review pass; finalised before store submission.]

### 2.2 Terms of Service / EULA (REQUIRED)

**Must address**:
- Grant of licence (use, not ownership)
- Permitted use (personal, non-commercial)
- Prohibitions (reverse engineering, redistribution, etc.)
- IAP terms (one-time unlock is perpetual; theme packs are perpetual; no auto-renewal)
- Disclaimer of warranties (the standard "as is")
- Limitation of liability (cap typically at amount paid)
- Governing law (Australia, with NSW or WA jurisdiction depending on founder location)
- Dispute resolution
- Modifications notice
- Termination

**Special case for "no subscription" framing**: legal docs must explicitly state that one-time unlock is perpetual within the lifetime of the app on the user's device. Set realistic expectations: we cannot guarantee the app will run on every future iOS/Android release forever, but we will not revoke unlocks for users on supported OS versions.

### 2.3 End-User Licence Agreement details

If presented separately from ToS (Apple's standard EULA is the default; we may use it):
- Use of standard Apple EULA + standard Google Play EULA is fastest
- A custom EULA adds friction; default works for most cases
- **Decision**: use platform-default EULAs at launch; revisit if positioning requires custom (e.g. if our perpetuity claims need legal force beyond standard EULA grants)

### 2.4 Acceptable Use / Community Standards

Not strictly required for a non-social app, but recommended:
- No prohibition needed for typical use
- For the optional cat behaviour and in-app text fields: standard "don't use the app to do illegal things on the device" boilerplate suffices

---

## 3. Privacy regime compliance

### 3.1 GDPR (EU + UK-GDPR)

Most onerous regime; sets the bar.

- **Article 5 — Lawful basis for processing**: we don't process personal data, so most articles don't apply. Where IAP receipts touch personal data, Apple/Google are the processors; we are not.
- **Article 13/14 — Information to data subjects**: covered by privacy policy
- **Article 15 — Right of access**: trivially satisfied (the data IS on the user's device; they have full access)
- **Article 17 — Right to erasure**: trivially satisfied (uninstalling deletes everything)
- **Article 20 — Right to data portability**: ensured via Settings > Data > Export (standard format — JSON or SQLite dump)
- **Article 25 — Data protection by design and by default**: this is literally our architecture
- **Article 33 — Breach notification**: there's no centralised store to breach
- **No DPO required** (no large-scale processing, no special category data)

**The honest privacy compliance posture**: GDPR is straightforward when you collect nothing. The hard part is making sure the privacy policy *says so accurately* and the app behaviour matches the claim.

### 3.2 CCPA / CPRA (California)

- Disclosure requirements satisfied by privacy policy
- "Do Not Sell My Personal Information" — N/A (we don't sell what we don't have)
- Consumer rights to access/delete/portability — same trivial satisfaction as GDPR

### 3.3 Australia Privacy Act 1988 / Notifiable Data Breaches scheme

- Australian Privacy Principles (APPs) apply if entity revenue > AUD $3M annually OR processes health data
- Below the threshold: voluntary best-practice compliance recommended for the trust signal even if not legally required
- **Action**: follow APP-aligned privacy policy regardless of threshold

### 3.4 UK Data Protection Act 2018 / UK-GDPR

- Essentially mirrors EU-GDPR post-Brexit; same compliance posture

### 3.5 PIPEDA (Canada), LGPD (Brazil), POPIA (South Africa), etc.

- All satisfied by the same architecture: no data collection means most provisions don't apply
- Privacy policy should mention general compliance posture rather than enumerate every regime

### 3.6 Children's Online Privacy Protection Act (COPPA, US)

- We are not directed at under-13
- App Store / Play Console age rating: 4+ on iOS / Everyone on Android (no objectionable content) but with explicit "not designed for children" stance to avoid COPPA application
- No child-specific features, no marketing to children

---

## 4. App Store / Google Play specific requirements

### 4.1 Apple App Store

- **App Privacy nutrition labels** (required since iOS 14): we declare "no data collected" — this becomes a *visible asset* on the store listing (rare for productivity apps, valuable for trust)
- **App Tracking Transparency (ATT)**: we don't track, so no prompt is shown — itself a trust signal
- **Subscription disclosure rules**: N/A (no subscriptions)
- **IAP description requirements**: clearly describe what the unlock and each theme pack contains, with screenshots
- **App Review Guidelines compliance**:
  - 1.0 Safety: no objectionable content, no user-generated content moderation needed
  - 2.0 Performance: comprehensive testing on iOS 16+ devices required pre-submission
  - 3.0 Business: pricing clearly disclosed; IAP only for unlocks/themes (no consumables)
  - 4.0 Design: native iOS feel where it matters (organiser mode), distinctive 3D otherwise
  - 5.0 Legal: privacy policy linked from app and store listing

### 4.2 Google Play

- **Data Safety section** (required since 2022): mirror of Apple's nutrition labels — "no data collected" disclosed
- **Permissions justification**: only request what's actually needed (e.g. notifications if used; otherwise none)
- **Content rating**: complete IARC questionnaire honestly; targeting all-ages content
- **Subscription disclosure rules**: N/A
- **In-app purchase setup**: configure unlock and theme packs in Play Console with clear descriptions

### 4.3 Both stores

- **Accessibility statement** — Recommended; the app should support OS-level accessibility (large text, VoiceOver/TalkBack for the organiser mode at minimum; 3D layer is harder to make accessible — be honest about this in the statement)
- **Refund handling**: refer users to the platform's standard refund processes; do not promise direct refunds we can't process

---

## 5. Intellectual property declarations within the app

- **Credits screen** (in Settings): list third-party asset attributions (Poly Haven, Quaternius, Kenney, Sonniss, font OFL notices, MIT shader notices)
- **Open-source licences screen** (if any FOSS dependencies require it): standard Flutter packages include licences; surface via the standard Flutter licence page
- **Copyright notice**: "© 2026 [FILL legal entity]" in About screen

---

## 6. Insurance considerations

For a pre-launch software business:
- **Public liability**: minimal exposure (no physical product, no premises)
- **Professional indemnity / errors & omissions**: consider once handling user data or providing professional services advice (not currently applicable; revisit if therapist/coach partnership model develops)
- **Cyber liability**: minimal (we don't hold data centrally); revisit if architecture changes
- **Director & Officer insurance**: only if external investors join the board (typically a Series A consideration)

[FILL: insurance broker engagement; basic policies if needed.]

---

## 7. Pre-launch legal checklist

| Item | Owner | Status |
|---|---|---|
| Privacy policy drafted (template here) | Founder | [FILL] |
| Privacy policy reviewed by solicitor | External | [FILL] |
| ToS / EULA decision (custom vs platform default) | Founder + solicitor | [FILL] |
| App Store privacy nutrition labels accurate | Founder | [FILL — completed at submission] |
| Google Play Data Safety section accurate | Founder | [FILL — completed at submission] |
| Trademark clearance complete (see 06) | External | [FILL] |
| First trademark filing submitted | External | [FILL] |
| Domain registered + secured | Founder | [FILL] |
| Email infrastructure (privacy@, support@, hello@) | Founder | [FILL] |
| Accessibility statement drafted | Founder | [FILL] |
| Credits / third-party attributions screen built | Founder | [FILL] |
| Refund policy documented | Founder | [FILL] |
| App Store EULA decision (default vs custom) | Founder | [FILL] |
| GDPR Article 30 record of processing (even if minimal) | Founder | [FILL — light-touch given no data] |

---

## 8. Ongoing legal posture

### Annual review
- Trademark renewals (10-year cycle in most jurisdictions; first renewal years out)
- Privacy policy update if architecture changes
- ToS update if monetisation model changes
- Insurance review if scale changes

### Triggered review
- Any change that affects what data is processed
- Entry into new geographic markets (Brazil, Russia, China bring specific compliance demands)
- Acquisition of user data through any new feature
- Cloud sync feature (would fundamentally change privacy posture and require comprehensive rewrite)

---

## 9. The legal posture in plain language

We collect nothing. We send nothing to servers. We have no accounts. The data on your device belongs to you, full stop. When you delete the app, that data is gone — including from us, because we never had a copy.

This isn't a clever positioning trick. It's the architecture. The legal documents reflect that architecture accurately. **That's the legal strategy.**
