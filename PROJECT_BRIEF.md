# 3AM Club App — Project Brief

## MVP Direction Update

The first release is a **personal, local-only MVP**, not the pod/partner product described in the original vision below. Based on the reality that most people need to build the habit of waking first:

- The wake time is **user-chosen between 03:00 and 05:00**, not fixed at 3am.
- The morning is built from **user-defined promises** (title, description, duration, in built-in or custom categories) that must fit before 06:00.
- Users **sign the promise** by holding a button, are guided through **night reminder, wake, focus and timer** screens, and see progress on a rewarding **dashboard**.
- Features that need other members (pods, partner escalation, sync) are **on hold**. See the PRD v0.2 for scope.

The sections below remain as the long-term vision and market context.

## 1. Background

**3 am club** is an existing WhatsApp group whose agenda is for members to wake each other up together at 3am, using texts and calls in the group to keep everyone accountable. It's inspired by *The 5 AM Club* by Robin Sharma, adapted to an earlier wake time and a personal-development routine.

**Current group agenda:**

1. Wake up + du'a — 5 min
2. Toilet, personal reflection/prayer — 20 min
3. Personal agenda time, until the early-morning call
4. Exercise, hobbies, cooking, house cleaning
5. Done by 6am

**Goal:** turn this manual, WhatsApp-based accountability system into a dedicated app — positioned as a **tool/friend that helps people build the habit**, not just another alarm clock.

## 2. Why this is buildable (market context)

There's a proven category here, with several direct references worth studying:

| App | Core mechanic |
| --- | --- |
| A private wake-up accountability app in this space | Real wake-up call, confirmation you're awake, a trusted partner steps in if you don't respond, private post-routine proof, structured multi-week challenge |
| Wake: The Social Alarm | Friends record voice alarms for each other; group alarms; reactions/comments on wake-up moments |
| Sleepy Family | Friends/family wake each other remotely; photo or math challenge to confirm you're up; monthly leaderboard |
| Erly | Alarm won't stop until a "mission" is done; streaks; locked deadlines once close to wake time |
| Snoozed | Loss-aversion pledge system (money forfeited if you don't get up); real-world photo verification |
| uRoutine | Social habit tracker; follow others' routines; shared accountability |

**Key insight from this landscape:** the common failure point isn't the alarm — it's that a louder alarm alone doesn't fix inconsistency. What works is *layered accountability*: your own alarm first, then escalation to a real person if that fails.

## 3. Feature Set

### A. Core wake mechanic

- **Layered alarm** — device-native alarm first (not just a push notification, which can be delayed or suppressed), so it fires reliably even locked/on Do Not Disturb.
- **Proof-of-wake** — a photo, voice note, or short interactive challenge required before the alarm can be dismissed. Prevents "tap to dismiss and fall back asleep."
- **Escalation to a human** — if proof isn't submitted within a set window, the assigned accountability partner is notified to call/check in.

### B. Accountability layer

- **Rotating partner/buddy system** rather than one fixed partner, so the same person isn't repeatedly woken at 3am for someone else's missed mornings.
- **Small pods (3–5 people)** within the larger club — small enough that responsibility doesn't diffuse the way it can in a large group chat.

### C. Habit-building layer

- **Streaks + visible history**, framed supportively — an easy, non-judgmental way to resume after a missed day rather than a punitive "streak broken" message.
- **Program structure** (e.g. a 21- to 66-day arc) with phase awareness shown in-app, so users expect the first few weeks to feel hard rather than assuming something's wrong.

### D. Routine-specific layer (the differentiator vs. generic wake apps)

- **Time-based scheduling anchored to the group's actual routine steps**, not just a fixed clock — since the ideal window for the early prayer/reflection period shifts with season and location.
- **Structured routine checklist** matching the 5 steps (du'a → reflection/prayer → personal agenda → exercise/hobby/chores → done by 6am), with each step logged.
- **Private reflection/journal** for personal notes after the early routine — the "reflect" component.

### E. Non-functional requirements

- Reliable background alarm delivery (native alarm APIs, not just push notifications).
- Privacy-respecting design — a partner sees only a wake confirmation, never personal reflections/journal entries.
- Backend for partner assignment/rotation, streak state, and escalation timing.
- Accurate location-based time calculation for the routine's key checkpoints.

## 4. Open Questions for Design

1. **Scope**: build this as a companion tool for the existing WhatsApp group (smaller, focused), or as a standalone public product for a wider audience (bigger scope — onboarding, partner-matching, discovery)?
2. **Partner assignment**: manual (pick your own) or app-assigned/rotated automatically?
3. **Escalation UX**: what does it look like *for the partner* at 3am when they're asked to step in? Needs a burnout safeguard (cap how often one person can be called on).
4. **Tone**: how strict vs. supportive should streak-breaking feel? This affects retention significantly.
5. **Platform**: iOS/Android native (needed for reliable native alarms) vs. cross-platform (Flutter) trade-offs.

## 5. Inspiration Reference

- *The 5 AM Club* by Robin Sharma — 20/20/20 formula (Move / Reflect / Grow) and the 66-day habit installation arc (Destruction → Installation → Integration), which underpins the phase-awareness feature above.