# 3AM Club App — Build TODO

Tracks the MVP build order from the [PRD](./PRD.md) (§11 Release Plan) and [Architecture](./ARCHITECTURE.md) (§17 Build Order). Check items off as they complete.

---

## M0 — Native Alarm Reliability Spike (highest risk, do first)

Goal: prove the alarm fires before building any UI on top of it.

- [x] Scaffold minimal Flutter app (Android only)
- [x] Decide: `alarm` package vs. custom native channel *(Open Decision #2 → **custom**; see M0_RESULTS.md D1)*
- [x] Implement exact alarm via AlarmManager (interface: `AlarmScheduler`) — `setAlarmClock()`, exempt from exact-alarm permission
- [x] Full-screen intent opens the wake screen over the lock screen (`CATEGORY_ALARM` + `showWhenLocked`/`turnScreenOn`)
- [x] Gradual volume ramp (~30s), native side (foreground ringing service + `MediaPlayer` on `USAGE_ALARM`)
- [x] Re-register on boot / time change / timezone change / app update (`BootReceiver`)
- [ ] Works after app force-stop (document actual behavior) — **needs on-device run**
- [ ] Test matrix: screen locked, DND, battery saver, reboot, ≥3 OEM skins — **needs on-device run (matrix in M0_RESULTS.md)**
- [x] Health-check concept: verify next alarm is registered on app open (re-register / clear stale)
- [x] Decide minimum Android API level *(Open Decision #4 → **minSdk 26**; see M0_RESULTS.md D2)*
- [x] Record results + final alarm approach decision → [M0_RESULTS.md](./M0_RESULTS.md) (device results pending)

---

## M1 — App Shell, Plan & Promise Builder, Sign

- [x] Flutter project setup: flavors (`dev`/`prod` via `--flavor`), `flutter_lints` — *note: riverpod **codegen** was dropped for manual providers (analyzer version conflict on this SDK); `riverpod_lint` deferred*
- [x] Theme: design tokens as `ThemeExtension`s (dark default, night/dawn/gold palette) + `AppPalette` const tokens
- [x] Typography: tokenized styles incl. serif accent + tabular numerals — *bundled font files pending licensing (DESIGN §13); system defaults used, no network fonts (FR-10.2)*
- [x] Localizations scaffold: ARB `id` + `en` from day one, no hardcoded strings (debug spike screen exempt)
- [x] drift schema: `plans`, `pre_sleep_items`, `categories`, `promises`, `mornings`, `promise_logs`, `pre_sleep_logs`, `settings` (UUID ids, `createdAt`/`updatedAt`, minutes-from-midnight times)
- [x] Seed built-in categories (Spiritual, Mind, Body, Home, Create, Plan) + templates (fixed ids, `promiseTemplates`)
- [x] `clockProvider` (fakeable `DateTime.now()`)
- [x] Time helpers: time budget, minute-of-day, next occurrence, bedtime-reminder time (pure Dart, unit-tested)
- **Sleep Plan (FR-1.x)**
  - [x] Bedtime + wake time pickers (custom `TimeWheelPicker`; wake constrained 03:00–05:00, 5-min steps)
  - [x] Sleep duration chip; gentle non-blocking hint if < 7h (warn-500)
  - [x] Pre-sleep checklist editor (add/rename/delete/reorder + 4 suggestions)
- **Promise Builder (FR-2.x)**
  - [x] Promise CRUD sheet: category, title, description, duration (presets 5–60 + custom stepper 1–180) + template chips
  - [x] Custom categories (name, icon, color; edit/archive own via long-press)
  - [x] Drag reorder + swipe delete (with confirm)
  - [x] `TimeBudgetBar`: wake→06:00, segments by category, over-budget warn state with "Trim N min" message
  - [x] Block signing while over budget / no promises (button disabled + helper); "start small" hint > 4 promises
- **Sign (FR-3.x)**
  - [x] Review screen: wake time, bedtime, sleep duration, checklist recap, ordered promises + "finishes around" time
  - [x] Optional "Why am I doing this?" (140 chars, persisted to plan + used as alarm body)
  - [x] `HoldButton` 3s (ring progress, haptics, early-release drain) + a11y "sign without holding" alternative
  - [x] On sign: activate plan (deactivate previous), schedule M0 native alarm + bedtime reminder, copy promises into `promise_logs`; re-sign for the same wake date replaces that morning
- [x] Local notifications: bedtime reminder (bedtime − lead 30 min, alarmClock exactness) → payload opens `/night`
- [x] Onboarding: permission cards with plain-language explanations + request flow (skip allowed)
- Tests: 24 passing (time/budget rules, HoldButton 2.9s vs 3s, TimeBudgetBar, drift sign flow incl. seeds & re-sign, app smoke)

---

## M2 — DayPhase, Router, Night & Wake & Focus

- [x] `DayPhase.resolve` pure function + full unit tests with fake clock
  (`noPlan / day / windDown / ringing / focus / done`) — `lib/core/time/day_phase.dart`
- [x] `dayPhaseProvider` re-evaluation: 30s tick + app resume + alarm events + DB streams (`phaseTickProvider`, `SubuhanApp` observer)
- [x] go_router setup + redirect rules (onboarding → noPlan → ringing → phase default; `/focus/promise/:id` stubbed for M3)
- [x] Deep links: bedtime notification payload → `/night`; FSI/`openWake` → `/wake`; phase redirect validates targets
- **Night Reminder (FR-4.x)**
  - [x] `night-950` background, `WaveBackground` (3 layered sine waves, 18s loop, reduce-motion static fallback, pauses when dimmed)
  - [x] Title, wake time (Time Display), sleep duration, pre-sleep checklist (tap to tick → `pre_sleep_logs` of the next morning, optional)
  - [x] Small dashboard link (48px hit area) + charging line
  - [x] Dim (≈92% night-950 overlay) + animation pause after 2 min inactivity; any touch undims
- **Wake (FR-5.x)**
  - [x] `SunriseIcon` (~3s rise from horizon, gentle 1.0→1.04 pulse, dawn-glow + rays; static variant under reduce-motion)
  - [x] Serif headline + user's "why" or default line + ticking clock
  - [x] Hold 5s stops the alarm (`stopRinging` → `confirmWake`); a11y tap alternative
  - [x] Re-ring policy *(Open Decision #3 → implemented proposal: ring 10 min, 5-min gaps, 3 cycles, then give-up event)*
  - [x] Late wake before 06:00 recorded with delay (time-based `ringing` rule)
- **Focus (FR-6.x)**
  - [x] "Why" line (serif), time left until 06:00 (ticking), "N of M promises kept" + progress bar
  - [x] Promise cards in plan order with statuses (Not started / In progress / Kept / Not finished); kept = dimmed + check, tap opens timer stub
  - [x] 06:00 morning close: `closeMorning` (pending/inProgress → `notFinished`, result = full/kept/missed) + app-open `syncAfterOpen` catch-up + `rollover` arms the next alarm & reminder
  - [x] All-kept state: gold celebration card + "See your progress" → dashboard
- Tests: 48 passing (day_phase 17 cases; morning loop: confirm/fire/ticks/close/rollover/sync cold-start; prior suites)

---

## M3 — Promise Timer (locked, persistent) & Morning Result

- **Promise Timer (FR-7.x)**
  - [x] Timer page: category, title, description, big countdown, `TimerWave` fill
  - [x] Button states: Start → Complete (disabled, "N min left") → Complete (enabled, gold)
  - [x] Persistence: remaining = `plannedSec − (now − startedAt)`; survives kill/restart/backgrounding/phone call
  - [x] Reopening with active session → forced back to timer page (router lock + `PopScope`)
  - [x] Completion notification + gentle chime with screen off
  - [x] Safety exit: long-press + confirm → "Not finished today", back to Focus (always a11y reachable)
  - [x] Wall-clock-change edge case: never negative remaining (tested)
  - [x] Optional wakelock while timer visible (default on; the settings toggle lands with the M4 settings screen)
  - [x] Celebration on Complete (check draws in 300ms, gold pulse, haptic)
- **Morning Result & Streak domain (FR-8 prerequisites)**
  - [x] `CloseMorning` use case at 06:00 + stale-morning catch-up on app open (M2)
  - [x] Result rules: `full` / `kept` / `missed` / `rest` (P1) (M2)
  - [x] `ComputeStreak` use case: consecutive kept/full, rest neutral, best streak, milestones (3/7/14/21/30/44/66), 66-day journey phases

---

## M4 — Dashboard, Rest Day, Backup

- **Dashboard (FR-8.x)**
  - [x] Hero: today's result + encouraging copy
  - [x] `StreakSun` (grows/glows with streak), current + best
  - [x] 66-day journey arc, 3 phases, current highlighted
  - [x] Next milestone progress ("2 days to your 7-day sun")
  - [x] `WeekStrip` last 7 days (kept/full/rest/upcoming; no red)
  - [x] Wins: total minutes, earliest wake, most-kept promise
  - [x] Promise list with 30-day kept rates (upcoming/rest mornings excluded from the denominator)
  - [x] `MilestoneBadge` locked/next/earned (gold-400)
  - [x] Celebrations: milestone + full morning (sun burst ≤1.5s, confetti glow ≤2s, once/day, reduce-motion fallback)
  - [x] Welcoming empty state ("Day 1 starts tonight")
  - [x] Tonight card: wake time, bedtime, plan access
- **Rest Day & Fresh Start (P1, FR-9.x)**
  - [x] Mark upcoming morning as rest day (cancels alarm + reminder; 1 per rolling 7 days; arms the day after so the chain never breaks; `syncAfterOpen` never re-arms a rest morning; DayPhase shows the dashboard, never ringing)
  - [x] Fresh-start framing after a break (tomorrow / Monday / 1st)
- **Backup (P1, FR-10.x)**
  - [x] Export all tables to versioned JSON (`exportVersion`), share via system sheet
  - [x] Import: validate, preview counts, replace strategy, re-schedule alarms
- Settings screen (wakelock toggle, bedtime-lead chips, backup entry) + `/settings`, `/settings/backup` routes

---

## M5 — Hardening & Pilot

- [ ] a11y audit: contrast ≥4.5:1, font scaling on wake/timer, hold alternatives, reduce-motion everywhere, safety exit reachable by assistive tech
- [ ] OEM battery-management guidance page (settings help)
- [ ] Alarm health check on app open (re-register + warn on revoked permissions)
- [ ] i18n review with native Bahasa Indonesia readers; final 66-day phase names *(PRD Open Q7)*
- [ ] Performance pass: no spinners on wake path; animations capped 30fps, paused when dimmed
- [ ] Integration test: plan → sign → simulated alarm → hold → focus → timer → dashboard
- [ ] Device-lab test: kill mid-timer, reboot, timezone change
- [ ] Pilot build (APK / internal testing) with club members, 3 weeks, metrics + survey

---

## Cross-cutting (ongoing)

- [ ] Unit tests alongside every rule: DayPhase, time budget, streak, morning result, milestones
- [ ] drift migration tests; export/import round trip
- [ ] Widget tests: HoldButton (2.9s vs 3s), TimeBudgetBar, timer button states, Focus list, Dashboard empty state
- [ ] No personal content in logs; debug-only logging
