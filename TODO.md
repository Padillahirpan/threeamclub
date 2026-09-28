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

- [ ] Flutter project setup: flavors (`dev`, `prod`), `very_good_analysis`/`flutter_lints`, CI-friendly
- [ ] Theme: design tokens as `ThemeExtension`s (dark default, night/dawn/gold palette)
- [ ] Typography: rounded sans + serif accent; tabular numerals for timers
- [ ] Localizations scaffold: ARB `id` + `en` from day one, no hardcoded strings
- [ ] drift schema: `plans`, `pre_sleep_items`, `categories`, `promises`, `mornings`, `promise_logs`, `pre_sleep_logs`, `settings` (UUID ids, `createdAt`/`updatedAt`, minutes-from-midday times)
- [ ] Seed built-in categories (Spiritual, Mind, Body, Home, Create, Plan) + templates
- [ ] `clockProvider` (fakeable `DateTime.now()`)
- [ ] Time helpers: time budget, minute-of-day (pure Dart, unit-tested)
- **Sleep Plan (FR-1.x)**
  - [ ] Bedtime + wake time pickers (wake constrained 03:00–05:00, 5-min steps)
  - [ ] Sleep duration chip; gentle non-blocking hint if < 7h
  - [ ] Pre-sleep checklist editor (add/edit/delete/reorder, suggestions)
- **Promise Builder (FR-2.x)**
  - [ ] Promise CRUD: category, title, description, duration (presets + custom 1–180)
  - [ ] Custom categories (name, icon, color; edit/archive own)
  - [ ] Drag reorder, swipe delete
  - [ ] `TimeBudgetBar`: wake→06:00, segments by category, over-budget state with "Trim N min" message
  - [ ] Block signing while over budget; require ≥1 promise; "start small" hint > 4 promises
- **Sign (FR-3.x)**
  - [ ] Review screen: wake time, bedtime, sleep duration, checklist recap, ordered promises + finish time
  - [ ] Optional "Why am I doing this?" (~140 chars)
  - [ ] `HoldButton` (3s, ring progress, haptics, early-release drain, a11y alternative)
  - [ ] On sign: activate plan, schedule alarm + bedtime reminder, copy promises into tomorrow's `promise_logs`
- [ ] Local notifications: bedtime reminder (bedtime − lead, default 30 min) → opens `/night`
- [ ] Onboarding: permissions with plain-language explanations (exact alarm, notifications, battery exemption)

---

## M2 — DayPhase, Router, Night & Wake & Focus

- [ ] `DayPhase.resolve` pure function + full unit tests with fake clock
  (`noPlan / day / windDown / ringing / focus / done`)
- [ ] `dayPhaseProvider` re-evaluation: app resume, alarm events, boundary timers (bedtime lead, wake, 06:00), DB changes
- [ ] go_router setup + redirect rules (locked timer session → noPlan → ringing → phase default)
- [ ] Deep links: `/wake`, `/night`, `/focus` from notifications and alarm intent
- **Night Reminder (FR-4.x)**
  - [ ] `night-950` background, `WaveBackground` (3 layered waves, 14–22s, 30fps cap, reduce-motion fallback)
  - [ ] Title, wake time (Time Display), sleep duration, pre-sleep checklist (optional ticks → next morning's logs)
  - [ ] Small dashboard link (48px hit area, ≥4.5:1 contrast), charging line
  - [ ] Dim + let device sleep after inactivity; pause animation when dimmed
- **Wake (FR-5.x)**
  - [ ] `SunriseIcon` (~3s rise, gentle pulse, glow; static variant)
  - [ ] Serif headline + user's "why" or default line + current time
  - [ ] Hold 5s to stop alarm (`wakeControllerProvider`, haptics per second)
  - [ ] On confirm: record `wakeConfirmedAt`, → Focus
  - [ ] Re-ring policy (proposal: ring 10 min, then every 5 min, max 3) *(Open Decision #3)*
  - [ ] Late wake before 06:00 recorded with delay
- **Focus (FR-6.x)**
  - [ ] Greeting, time left to 06:00, "why" line, "1 of N promises kept" progress
  - [ ] `PromiseCard` list with statuses (Not started / In progress / Kept / Not finished); kept = dimmed + check
  - [ ] Tap promise → timer page; any order
  - [ ] 06:00 morning close: unfinished → "Not finished today" (neutral), → Dashboard state

---

## M3 — Promise Timer (locked, persistent) & Morning Result

- **Promise Timer (FR-7.x)**
  - [ ] Timer page: category, title, description, big countdown, `TimerWave` fill
  - [ ] Button states: Start → Complete (disabled, "N min left") → Complete (enabled, gold)
  - [ ] Persistence: remaining = `plannedSec − (now − startedAt)`; survives kill/restart/backgrounding/phone call
  - [ ] Reopening with active session → forced back to timer page (router lock + `PopScope`)
  - [ ] Completion notification + gentle chime with screen off
  - [ ] Safety exit: long-press + confirm → "Not finished today", back to Focus (always a11y reachable)
  - [ ] Wall-clock-change edge case: never negative remaining (tested)
  - [ ] Optional wakelock while timer visible (setting)
  - [ ] Celebration on Complete (check draws in 300ms, gold pulse, haptic)
- **Morning Result & Streak domain (FR-8 prerequisites)**
  - [ ] `CloseMorning` use case at 06:00 + stale-morning catch-up on app open
  - [ ] Result rules: `full` / `kept` / `missed` / `rest` (P1)
  - [ ] `ComputeStreak` use case: consecutive kept/full, rest neutral, best streak, milestones (3/7/14/21/30/44/66), 66-day journey phases

---

## M4 — Dashboard, Rest Day, Backup

- **Dashboard (FR-8.x)**
  - [ ] Hero: today's result + encouraging copy
  - [ ] `StreakSun` (grows/glows with streak), current + best
  - [ ] 66-day journey arc, 3 phases, current highlighted
  - [ ] Next milestone progress ("2 days to your 7-day sun")
  - [ ] `WeekStrip` last 7 days (kept/full/rest/upcoming; no red)
  - [ ] Wins: total minutes, earliest wake, most-kept promise
  - [ ] Promise list with 30-day kept rates
  - [ ] `MilestoneBadge` locked/next/earned (gold-400)
  - [ ] Celebrations: milestone + full morning (sun burst ≤1.5s, confetti glow ≤2s)
  - [ ] Welcoming empty state ("Day 1 starts tonight")
  - [ ] Tonight card: wake time, bedtime, plan access
- **Rest Day & Fresh Start (P1, FR-9.x)**
  - [ ] Mark upcoming morning as rest day (cancels alarm; 1 per rolling 7 days)
  - [ ] Fresh-start framing after a break (tomorrow / Monday / 1st)
- **Backup (P1, FR-10.x)**
  - [ ] Export all tables to versioned JSON (`exportVersion`), share via system sheet
  - [ ] Import: validate, preview counts, replace strategy, re-schedule alarms

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
