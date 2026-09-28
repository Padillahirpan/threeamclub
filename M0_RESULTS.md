# M0 — Native Alarm Spike: Results & Decisions

Status: **implemented, pending on-device validation.**
Scope: PRD §11 M0 / ARCHITECTURE.md §10, §17. Everything below follows the project docs.

## Decisions

### D1 — Custom native channel (not the `alarm` package) — ARCHITECTURE Open Decision #2

**Chosen: fully custom Kotlin implementation behind the `AlarmScheduler` interface.**

Rationale:
- `AlarmManager.setAlarmClock()` is used, which is the highest-priority exact alarm type: fires in Doze/battery saver, shows the stock status-bar alarm icon, and **is exempt from `SCHEDULE_EXACT_ALARM`** — one less permission to fight OEMs over.
- We need custom behaviors the package doesn't give us cleanly: ~30s native volume ramp via `MediaPlayer` (FR-5.2), foreground ringing service, `CATEGORY_ALARM` full-screen-intent notification, boot/time-change re-registration, and a single-alarm policy.
- Dart never owns the alarm (ARCHITECTURE §2); the interface (`lib/core/platform/alarm_scheduler.dart`) matches the doc's contract, so the data/domain/presentation layers in M1 depend only on it.

### D2 — Minimum Android API level: 26 (Android 8.0) — ARCHITECTURE Open Decision #4

Rationale: notification channels (required for the alarm's full-screen-intent channel) exist from API 26; covers effectively all pilot-era devices. Recorded in `android/app/build.gradle.kts`.

## What was built

```
lib/
├── main.dart                                  # spike harness UI + wake screen (5s hold)
└── core/
    ├── platform/
    │   ├── alarm_scheduler.dart               # AlarmScheduler contract (ARCHITECTURE §10)
    │   └── method_channel_alarm_scheduler.dart# Android implementation
    └── widgets/
        └── hold_button.dart                   # HoldButton (DESIGN §5: ring, haptics, 300ms drain)

android/app/src/main/kotlin/club/threeam/subuhan/
├── MainActivity.kt                            # channels, showWhenLocked/turnScreenOn, wake route
└── alarm/
    ├── AlarmApi.kt                            # MethodChannel/EventChannel handler + permissions
    ├── NativeAlarmScheduler.kt                # AlarmManager.setAlarmClock
    ├── AlarmStore.kt                          # persisted alarm state (survives process death)
    ├── AlarmEvents.kt                         # native events -> Dart (+ cold-start cache)
    ├── AlarmFiredReceiver.kt                  # alarm trigger -> ringing service
    ├── BootReceiver.kt                        # BOOT / TIME_SET / TIMEZONE_CHANGED / MY_PACKAGE_REPLACED
    └── AlarmRingingService.kt                 # FSI notification, 30s ramp, vibration, wake lock
```

Behavior implemented:
- **Exact alarm** — `setAlarmClock` fires the `AlarmFiredReceiver`, which starts `AlarmRingingService` (foreground, `mediaPlayback` type).
- **Full-screen intent** — `CATEGORY_ALARM` + `VISIBILITY_PUBLIC` notification launches `MainActivity` (route `wake`) with `setShowWhenLocked`/`setTurnScreenOn`, so the wake screen shows over the lock screen.
- **Volume ramp** — default alarm sound via `MediaPlayer` on `USAGE_ALARM`, looping, 0 → 100% over ~30s.
- **5s hold to stop** (FR-5.3) — HoldButton on the wake screen; a11y alternatives: notification "Stop alarm" action + a tap-to-stop button (DESIGN §10).
- **Re-registration** — `BootReceiver` re-registers the stored alarm on boot/time change/timezone change/app update; if the time passed while off, it clears and reports.
- **Health check** — on app open/resume: read stored alarm, re-register if in the future, clear if in the past (ARCHITECTURE §10).
- **One alarm at a time** — every `schedule` cancels the previous registration.

## How to run the spike

1. `flutter run` (or `flutter build apk --debug` and install the APK) on a **real device**.
2. Tap **"1. Check & request permissions"** — grant notifications; if full-screen intent is off (Android 14+), enable it in the settings screen; optionally grant the battery-optimization exemption (per-OEM notes below).
3. Tap **"2. Schedule alarm in 1 minute"**, lock the screen, wait.
4. Expected: alarm rings with ramping volume + vibration, wake screen appears over the lock screen, 5s hold stops it.
5. The **event log** records everything (fired / stopped / rescheduled / openWake).

## On-device test matrix (fill in per device)

Test with a 1-minute alarm for quick cycles; repeat each row per device:

| # | Scenario | Expectation | Result |
|---|---|---|---|
| 1 | Screen locked | Alarm fires on time, FSI shows over lock screen | |
| 2 | Do Not Disturb on | Alarm rings (FSI channel may be limited by DND settings — document) | |
| 3 | Battery saver on | Alarm fires on time | |
| 4 | Reboot with alarm scheduled | Alarm re-registered (log: `rescheduled:BOOT_COMPLETED`) | |
| 5 | App force-stopped, then alarm time | OS cancels alarms of force-stopped apps — document actual behavior | |
| 6 | App swiped from recents | Alarm still fires (expected: yes) | |
| 7 | Timezone/time changed manually | `rescheduled:TIME_SET` / `TIMEZONE_CHANGED` in log | |
| 8 | Cold start from FSI | Wake screen shows; log has `openWake (cached launch)` | |
| 9 | Volume ramp | Audible gradual increase over ~30s | |
| 10 | 5s hold + a11y exits | Hold stops alarm; "Stop alarm" action works | |
| 11 | Health check after each scenario | Re-opens app: alarm state correct | |

Devices to cover (PRD §9 / ARCHITECTURE §10: at least 3 OEM skins):
- [ ] Stock/Pixel-ish Android (e.g. Xiaomi A-series, Motorola, Sony)
- [ ] Samsung One UI
- [ ] Xiaomi MIUI/HyperOS
- [ ] (optional) Oppo/Realme/Vivo — historically the most aggressive

OEM guidance (to be expanded into the M5 settings help page):
- Xiaomi: enable Autostart; set Battery saver = No restrictions.
- Samsung: remove from Sleeping/Deep sleeping apps.
- Oppo/Realme/Vivo: allow Auto-start + lock in recents.

## Known limitations of the spike (intentional, out of M0 scope)

- Re-ring policy (ring 10 min → re-fire ×3) is an M2 feature; the service currently rings until stopped.
- No notification permission onboarding flow polish (M1).
- `android.R.drawable.ic_lock_idle_alarm` used as the status icon; the real app ships a proper icon.
- Default system alarm sound is used; the real app bundles a chime.
- `AlarmEvents` sink is a static singleton — acceptable for the spike; M1 moves wiring into a proper plugin/lifecycle-aware form if needed.
