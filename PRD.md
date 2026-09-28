# 3AM Club App — Product Requirements Document (v0.2, Personal MVP)

> v0.2 narrows the product to a **personal, local-only MVP**. Everything that needs other members (pods, partner escalation, sync) is on hold. Companion docs: [Project Brief](./3am-club-app-brief.md), [Design System](./3am-club-design-system.md), [Architecture](./architecture.md).

## 1. Overview

**Product:** A personal wake-up habit app. The user chooses a wake time between 03:00 and 05:00, plans their sleep, builds a list of morning "promises" (activities with a duration), signs the promise, and is guided through the night, the wake-up, and each promise with focus timers. A dashboard celebrates progress.

**Why personal first:** Most people need to build the habit of waking before they can benefit from social accountability. A local-only MVP removes backend, auth and privacy complexity so we can test the riskiest assumptions: does the alarm reliably work, and do people keep their promises for the first 3 weeks?

**Problem:** A phone alarm alone doesn't build a habit. People lack a plan for the morning, a meaningful commitment, a focused way to spend the time, and a rewarding sense of progress.

## 2. Goals & Success Metrics

| Goal | Metric (pilot, local + survey) |
| --- | --- |
| Alarm works every time | 100% of scheduled alarms fire in the pilot device matrix (locked, DND, reboot, battery saver) |
| People actually wake | % of scheduled mornings with wake confirmed (hold completed) |
| Promises get done | % of promises completed per morning; % of mornings with at least 1 promise kept |
| Habit survives the hard weeks | Pilot users still active at day 7, day 22 |
| Plans are realistic | % of users who edit/trim their plan in week 1 (signal of over-commitment) |
| Users feel rewarded | Pilot survey: "The dashboard makes me feel proud of my progress" (1–5) |

No server analytics in the MVP. Metrics come from an on-device stats view, an export file, and a short pilot survey with club members.

## 3. Target Users

Primary: members of the existing 3 am club and similar people who want to build an early-wake habit and use the early hours for prayer, personal growth, exercise, hobbies or home tasks. Beginners are the design center, which is why the wake time is flexible (03:00–05:00) instead of fixed at 3am.

## 4. Scope

### In MVP

- Plan: bedtime, wake time (03:00–05:00), pre-sleep checklist
- Promise builder with categories (built-in + custom), title, description, duration
- Hold-to-sign commitment (3s) with recap
- Night reminder page (wave animation)
- Native alarm and wake page (hold 5s)
- Focus page (promise list, status)
- Promise timer page (locked countdown, start/complete)
- Dashboard (streak, journey, milestones, stats)
- Local storage (drift/SQLite), local notifications, export/import backup
- Bahasa Indonesia and English

### On hold (needs other members)

Pods, partner matching and rotation, escalation calls/pushes, on-call status, shared streaks, accounts, cloud sync, server analytics.

### Later (post-MVP candidates)

Share "I'm up" to WhatsApp group, gradual wake-time shifting suggestions ("try 15 min earlier next week"), location-based prayer-time anchoring, iOS AlarmKit polish, home-screen widget, light theme.

## 5. User Flow

```
Plan (sleep) → Promise Builder → Sign (hold 3s) → Night Reminder
                                                     │  (bedtime notification / opens at night)
                                                     ▼
                                            Alarm → Wake (hold 5s)
                                                     ▼
                                            Focus (promise list)
                                                     ▼
                                     Promise Timer (Start → Complete) ↺ back to Focus
                                                     ▼
                                                Dashboard
```

Returning users skip planning and land on the page matching the time of day (see Section 7).

## 6. Functional Requirements

Priority: **P0** = required for MVP, **P1** = should have, aims for MVP if time allows.

### 6.1 Sleep Plan (P0)

- FR-1.1 User sets **bedtime** and **wake time**. Wake time is limited to **03:00–05:00**, in 5-minute steps.
- FR-1.2 App shows computed **sleep duration**. If under 7 hours, show a gentle, non-blocking hint.
- FR-1.3 User creates a **pre-sleep checklist** (title only; add, edit, delete, reorder). Provide suggestions.
- FR-1.4 Bedtime and wake time can be changed later; changes apply from the next night.

**Acceptance:** Selecting 21:00 bedtime and 04:00 wake time shows "7h". Wake times outside 03:00–05:00 cannot be selected.

### 6.2 Promise Builder (P0)

- FR-2.1 User adds one or more **promises**, each with: **category**, **title** (required), **description** (optional), **duration** in minutes (required, 1–180; presets 5/10/15/20/30/45/60 plus custom).
- FR-2.2 Built-in categories: Spiritual, Mind, Body, Home, Create, Plan. Users can **create custom categories** (name, icon, color) and edit or archive their own.
- FR-2.3 Templates prefill title and duration but remain fully editable.
- FR-2.4 Promises can be **reordered**, edited and deleted.
- FR-2.5 A **time budget bar** shows total promise duration against the time from wake time to **06:00**. If the total exceeds the budget, the plan **cannot be signed** until trimmed, with a clear message of how many minutes to remove.
- FR-2.6 If more than 4 promises, show a non-blocking "start small" hint.
- FR-2.7 At least 1 promise is required to sign.

**Acceptance:** Wake 04:30 gives a 90-minute budget; adding promises totaling 100 minutes disables signing and shows "Trim 10 min to fit before 6:00".

### 6.3 Sign the Promise (P0)

- FR-3.1 A review screen shows: wake time, bedtime, sleep duration, pre-sleep checklist recap, ordered promise list with durations and expected finish time.
- FR-3.2 Optional **"Why am I doing this?"** text (max \~140 characters), shown later on the wake and focus pages.
- FR-3.3 User signs by **holding the sign button for 3 seconds**. Releasing early resets progress without error.
- FR-3.4 On signing: the plan becomes active, the alarm and bedtime reminder are scheduled, and the app opens the Night Reminder page.
- FR-3.5 Accessibility alternative to the hold gesture must exist (see Design System).

**Acceptance:** A 2.9s hold does not sign; a 3s hold signs, schedules the alarm, and navigates to the night page.

### 6.4 Night Reminder (P0)

- FR-4.1 A **local bedtime notification** fires at a configurable lead time before bedtime (default 30 min) and opens the Night page.
- FR-4.2 The Night page shows: night wave animation, reminder title, wake time, sleep duration, and the pre-sleep checklist (tap to tick; ticks are optional and never required).
- FR-4.3 One small, low-emphasis link to the Dashboard; no other prominent actions.
- FR-4.4 The screen dims and allows the device to sleep after a short inactivity period; animation pauses when dimmed.
- FR-4.5 Show a one-line reminder to keep the phone charging.

### 6.5 Alarm & Wake (P0)

- FR-5.1 A **native alarm** fires at the wake time even if the phone is locked, in Do Not Disturb (where the OS allows), or after reboot.
- FR-5.2 Alarm volume **ramps up gradually** (about 30 seconds).
- FR-5.3 The Wake page shows a sunrise icon animation, a headline, a description (the user's "why" or a default line), and a **hold-for-5-seconds** button. The alarm stops only when the hold completes.
- FR-5.4 On completion: record wake confirmed with timestamp, then open the Focus page.
- FR-5.5 If not confirmed within the ring window, the alarm re-rings (see Open Questions for policy). The user can still confirm late until 06:00; a late wake is recorded with its delay.
- FR-5.6 Required permissions (exact alarms, notifications, battery optimization exemption where needed) are requested during onboarding with plain-language explanations.

**Acceptance:** On the pilot device matrix, the alarm fires at the scheduled time with the screen locked and after a reboot.

### 6.6 Focus Page (P0)

- FR-6.1 Shows greeting, time left until 06:00, the "why" text, progress ("1 of 4 promises kept") and the ordered promise list.
- FR-6.2 Each promise shows category, title, duration and status: Not started, In progress, Kept, Not finished.
- FR-6.3 Tapping a promise opens its timer page. Promises can be done in any order.
- FR-6.4 When all promises are kept, show the full-morning celebration and a path to the Dashboard.
- FR-6.5 At 06:00 the morning closes: unfinished promises become "Not finished today" (neutral), and the app moves to the Dashboard state.

### 6.7 Promise Timer (P0)

- FR-7.1 Shows category, title, description, countdown timer with wave animation, and one button.
- FR-7.2 Button flow: **Start** → becomes **Complete** (disabled) → enabled only when the countdown reaches zero.
- FR-7.3 **Locked mode** while running: system back and in-app navigation are blocked; the user stays on this page.
- FR-7.4 **Persistence:** the timer is based on stored start time and duration; it survives app restart, phone calls and backgrounding. Reopening the app during an active timer returns to this page.
- FR-7.5 A local notification and gentle chime fire at completion even with the screen off.
- FR-7.6 **Safety exit (P0 for safety):** a small "End early" control (long press + confirm) that marks the promise "Not finished today" (never "Failed") and returns to Focus.
- FR-7.7 On Complete: mark Kept with timestamp, play the celebration, return to Focus.

**Acceptance:** Kill the app mid-timer and reopen: the remaining time is correct and the user lands on the timer page. Complete stays disabled until time is up.

### 6.8 Dashboard (P0)

- FR-8.1 **Hero** with today's result and an encouraging message.
- FR-8.2 **Streak** (current and best) shown as the Streak Sun.
- FR-8.3 **66-day journey** with three phases and current position.
- FR-8.4 **Next milestone** progress (milestones at 3, 7, 14, 21, 30, 44, 66 days).
- FR-8.5 **Week strip** of the last 7 days (kept, full, rest, upcoming).
- FR-8.6 **Wins:** total minutes spent on promises, earliest wake time, most-kept promise.
- FR-8.7 **Promise list** with 30-day kept rate for each.
- FR-8.8 Celebration animation on milestone days and full mornings.
- FR-8.9 New-user empty state is welcoming, not a page of zeros.

### 6.9 Rest Day & Fresh Start (P1)

- FR-9.1 The user can mark an upcoming morning as a **rest day** (cancels that alarm). Rest days keep the streak alive without increasing it. Limit: 1 per rolling 7 days.
- FR-9.2 After a break in the streak, the dashboard offers a "fresh start" framing (e.g. from tomorrow, next Monday, or the 1st of the month) with supportive copy.

### 6.10 Data Safety (P0/P1)

- FR-10.1 (P1) **Export/import** all data as a JSON file, since local-only data is lost on uninstall or phone change.
- FR-10.2 (P0) All data stays on the device; no network access is required for any feature.

## 7. Business Rules

**Day model:** a "morning" is identified by the date of the wake time. The pre-sleep checklist ticked on the evening of Monday belongs to Tuesday's morning.

**App phase by time of day** (decides which page opens):

| Phase | Condition | Page |
| --- | --- | --- |
| No plan | No signed plan | Plan flow |
| Day | After morning closes (06:00) until bedtime lead time | Dashboard |
| Wind-down | From bedtime lead time until the alarm | Night Reminder |
| Ringing | Alarm fired, wake not confirmed | Wake |
| Focus | Wake confirmed, before 06:00, promises remaining | Focus (or active timer) |
| Done | All promises kept, or 06:00 reached | Dashboard |

**Morning result:**

- **Kept:** wake confirmed **and** at least 1 promise completed.
- **Full:** wake confirmed and all promises completed (bonus celebration).
- **Missed:** anything else (shown neutrally).
- **Rest:** rest day used (P1).

**Streak:** counts consecutive Kept/Full mornings; rest days pause it without adding. **Best streak** is stored. A missed morning resets the current streak and triggers the fresh-start framing.

**66-day journey:** starts at signing. Phase 1 (days 1–22): break the old pattern. Phase 2 (23–44): build the new one. Phase 3 (45–66): make it yours. After day 66 the user can renew or continue.

**Time budget:** sum of promise durations must be at most (06:00 − wake time).

**Late wake:** a hold-confirmed wake before 06:00 still counts; the delay is recorded as a stat. (Open question whether to keep this.)

## 8. Data (local)

Entities (all with UUID ids and `updatedAt`, to keep a future sync path open): `Plan`, `PreSleepItem`, `Category`, `Promise`, `Morning` (per date: alarm time, wake confirmed at, result), `PromiseLog` (per morning per promise: status, started at, completed at, planned/actual duration), `PreSleepLog`, `Settings`. Details in the Architecture doc.

## 9. Non-Functional Requirements

- **Reliability:** alarms are scheduled natively and do not depend on network or on the Dart isolate; alarms are re-registered after reboot, time change, and app update; a health check on app open verifies the next alarm is registered.
- **Privacy:** all data on-device; no analytics SDKs in MVP; export is user-initiated.
- **Performance:** wake hold and timer screens open instantly; no loading spinners on the wake path.
- **Battery:** animations capped (30fps), paused when dimmed; night page uses near-black background.
- **Accessibility:** per the Design System (contrast, font scaling, hold alternative, reduce motion).
- **Platform:** **Android first** for the club pilot (native alarm control is more flexible; faster distribution via APK/internal testing). iOS follows after the alarm approach is validated. (Open question below.)
- **Localization:** Bahasa Indonesia and English.

## 10. Risks

| Risk | Mitigation |
| --- | --- |
| Alarm doesn't fire on some Android OEMs (aggressive battery management) | Device-matrix spike first; guided permission/battery onboarding; app-open health check |
| Locked timer traps users | Safety exit; timer persistence; a11y access to exit |
| Users over-commit and give up | Time budget validation, "start small" hint, 66-day expectations |
| Local-only data loss | Export/import; clear messaging |
| Streak pressure feels bad | Rest day, fresh start framing, supportive copy, no red |
| Sleep too short at 3am wake | Sleep duration display and gentle hint, flexible 3–5am range |
| iOS alarm limitations | Defer iOS; validate approach later |

## 11. Release Plan

| Phase | Scope |
| --- | --- |
| **M0 Spike** | Native alarm reliability on real Android devices (locked, DND, reboot, battery saver) |
| **M1** | Plan, promise builder, signing, local DB, notifications |
| **M2** | Night page, wake page + alarm integration, focus page |
| **M3** | Promise timer (locked, persistent), morning result logic |
| **M4** | Dashboard, streaks, milestones, celebrations, rest day (P1), export/import (P1) |
| **M5 Pilot** | Install with club members, run 3 weeks, collect metrics and survey |
| **After** | Decide: pods/sync, WhatsApp share, iOS, gradual wake shifting |

## 12. Open Questions

1. Alarm re-ring policy: ring continuously for N minutes, then re-fire every X minutes up to Y times? Proposal: ring 10 min, then every 5 min, max 3 times.
2. Keep "late wake counts if before 06:00", or require confirmation within a strict window?
3. Should "Kept" require at least 1 promise, or the whole plan? (Proposal: 1, with "Full" as a bonus.)
4. Android-only pilot, or iOS from the start?
5. Are promises the same every day, or should users be able to vary by weekday? (Proposal: same every day in MVP.)
6. Should the pre-sleep checklist affect the morning result? (Proposal: no, informational only.)
7. Final date/phase names for the 66-day journey in Bahasa Indonesia.

## 13. References

- Project Brief (background and market context)
- Design System v0.2 (screens, components, research notes)
- Architecture (Flutter, Riverpod, go_router, drift)