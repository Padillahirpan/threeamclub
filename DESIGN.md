# 3AM Club App — Design System (v0.2, MVP)

> v0.2 updates the original design system for the **personal, local-only MVP**: user-chosen wake time (03:00–05:00), user-built "promises", and the 8-screen flow. Pod/partner components from v0.1 are on hold and listed at the end.

## 1. Design Principles

- **Habit first, ambition second.** Most people need to build the habit of waking before they can hold a demanding routine. The UI makes small, doable promises feel good to keep, and gently discourages over-committing.
- **Right cognition for the right hour.** Waking at 03:00–05:00 means sleep inertia (grogginess, impaired complex thinking, strongest in the early-morning circadian low). Wake-flow screens ask for simple motor actions only (hold, tap), never reading-heavy or puzzle interactions.
- **Calm, not alarming.** Warm and reassuring at night and dawn. No harsh red anywhere in the core flow.
- **Dawn as the visual story.** The day moves through the palette: deep night (bedtime) → first light (wake) → warm focus (promises) → golden celebration (dashboard).
- **Celebrate immediately.** The feeling of success right after a behavior is what wires a habit in. Every kept promise gets an instant, small celebration.
- **Supportive, never punitive.** Missed days invite a fresh start; they are never shown as failure.

## 2. Color System

### Core palette (unchanged from v0.1)

| Token | Hex | Use |
| --- | --- | --- |
| `night-900` | #0B1026 | Primary dark background |
| `night-700` | #1B2140 | Cards/surfaces on dark |
| `dawn-500` | #F4A261 | Primary accent, CTAs, active states |
| `dawn-300` | #FBC89A | Secondary accent, highlights |
| `sky-100` | #FDF6EC | Light background |
| `sky-300` | #EDE3D3 | Light surface |
| `success-500` | #6FCF97 | Completed step / kept promise |
| `warn-500` | #E0A458 | Gentle warning (never red) |
| `ink-900` | #1A1A1A | Text on light |
| `mist-200` | #C9CEDB | Secondary text on dark |

### New tokens (v0.2)

| Token | Hex / value | Use |
| --- | --- | --- |
| `night-950` | #060A1A | Night reminder page base (darkest, OLED-friendly) |
| `wave-1` | #22305E @ 60% | Back wave layer |
| `wave-2` | #2F4A8A @ 45% | Mid wave layer |
| `wave-3` | #4A6FB5 @ 30% | Front wave layer |
| `dawn-glow` | #FF9E6B → #FFD8A8 | Sunrise icon glow, wake page |
| `focus-wave` | dawn-500 @ 35% on night-700 | Countdown timer wave |
| `gold-400` | #FFC857 | Celebration, milestones, dashboard hero |
| `gold-glow` | #FFC857 @ 25% | Achievement halo |

### Page gradients

| Screen | Gradient (top → bottom) |
| --- | --- |
| Plan / Promise builder | night-900 → night-700 |
| Night reminder | night-950 → night-900 (+ animated waves) |
| Wake | night-900 → #3B2A4F → dawn-glow (bottom, subtle) |
| Focus | night-900 → night-700 |
| Promise timer | night-900, wave fills upward in focus-wave |
| Dashboard | night-900 → #2A2340, with gold-glow accents |

### Rules

- Dark theme is default for the entire MVP (every screen is used pre-dawn or at night). A light theme is optional for dashboard review later.
- No red for missed days, late wake, or incomplete promises. Use `warn-500` sparingly and neutral wording.
- Full-saturation `dawn-500` and `gold-400` are reserved for completed or earned states.

## 3. Typography

- **UI typeface:** rounded humanist sans (Inter / Nunito Sans).
- **Editorial accent typeface:** a warm serif (e.g. Lora or Fraunces, both OFL) used only for the wake page headline and the "Your why" line, to give the words a written, personal feel.

| Style | Size | Weight | Use |
| --- | --- | --- | --- |
| Time Display | 56px | Light | Wake time on night/wake pages |
| Display | 32px | Bold | Big states, celebration titles |
| Wake Headline | 28px | Serif Medium | Wake page message |
| H1 | 24px | Semibold | Screen titles |
| H2 | 18px | Semibold | Section headers, promise titles |
| Body | 16px | Regular | Default text, descriptions |
| Timer | 64px | Light, tabular figures | Countdown |
| Caption | 13px | Regular | Metadata, small links |

- Tabular (monospaced) numerals for timers and clocks so digits don't jitter.
- Line height 1.4 minimum. No all-caps beyond very short labels.

## 4. Spacing & Layout

- 4px grid (4, 8, 12, 16, 24, 32, 48). 20px screen margins. 16px card radius.
- **Touch targets:** 48x48px minimum. The "small" dashboard link on the night page is visually small (13px caption) but keeps a 48px invisible hit area.
- One primary action per screen. Everything else is visually secondary.
- Wake-flow screens use large, centered layouts; nothing interactive within 24px of the screen edge (reduces accidental touches while half-asleep).

## 5. Motion

Motion carries the emotional story, so it is specified, not decorative.

| Motion | Spec |
| --- | --- |
| **Night waves** | 3 layered sine waves, slow horizontal drift, 14–22s per cycle at different speeds; amplitude 8–16px; ease-in-out only. Optional subtle "breathing" scale on the reminder text (about 4s in / 6s out). |
| **Sunrise icon (wake)** | Sun rises from a horizon line over \~3s, then pulses gently (scale 1.0 to 1.04, 2.5s loop) with soft dawn-glow rays. |
| **Hold button** | Progress ring fills linearly over the hold duration. Haptic tick each second; stronger haptic on completion. Releasing early drains the ring back in 300ms (no error state). |
| **Timer wave** | Wave fill level equals remaining/total time, rising or falling smoothly; surface ripples slowly. Updates once per second, wave animation runs independently. |
| **Check / celebration** | Promise complete: checkmark draws in 300ms, soft gold pulse, light haptic. Full morning complete: sun bursts into gold particles (max 1.5s). Milestone: larger confetti-like glow, max 2s. |
| **Screen transitions** | 300–400ms cross-fade with slight vertical shift. No abrupt cuts, no fast slides. |

**Constraints**

- Respect the OS "reduce motion" setting: replace waves and particles with static gradients and simple fades.
- Battery: cap animations at 30fps on night and timer screens; stop or dim the night animation after about 2 minutes of inactivity and let the screen sleep.
- Night page uses `night-950` (near-black) and low luminance overall to stay comfortable in a dark room.

## 6. Iconography & Imagery

- Line icons, 2px stroke, rounded caps.
- Sunrise / moon-phase motifs instead of alarm bells.
- Category icons (see Categories): simple, single-color line icons.
- No photorealistic imagery on core flow screens.

## 7. Screen Specifications

### 7.1 Sleep Plan (Step 1)

- Elements: bedtime picker, wake time picker (03:00–05:00), computed **sleep duration** chip, pre-sleep checklist editor.
- Sleep duration chip shows e.g. "7h 30m of sleep". If under about 7 hours, show a soft `warn-500` hint: "Earlier bedtime = easier mornings." Never blocking.
- Pre-sleep checklist: add/remove/reorder items (title only), with a few suggestions (e.g. "Put phone on charge", "Set out prayer clothes", "Lay out workout clothes", "Brush teeth and wudu").
- CTA: "Next: choose your morning promises".

### 7.2 Promise Builder (Step 2)

- **Time budget bar** at top: wake time to 06:00, filled by the promises added so far (segments colored by category). Over budget turns `warn-500` with "Trim 10 min to fit before 6:00".
- Category chips (built-in + user-created): Spiritual, Mind, Body, Home, Create, Plan, and "+ New category".
- Add promise sheet: Category, Title, Description (optional), Duration (presets 5/10/15/20/30/45/60 + custom stepper).
- Promise list: drag to reorder, tap to edit, swipe to delete.
- Hint when more than 4 promises: "Starting small helps habits stick. You can add more later." (non-blocking)
- Suggestion: put low-thinking promises first (du'a, prayer, movement) because thinking is still slow right after waking.
- CTA: "Review my promise".

### 7.3 Sign Promise (Step 3)

- Summary card: wake time, sleep duration, bedtime, pre-sleep checklist recap, ordered promise list with durations and finish time.
- Optional field: **"Why am I doing this?"** (one or two sentences). It appears on the wake page.
- **Hold-to-sign button** (3s, HoldButton). On completion: gold pulse, "Promise signed", then transition to the night page.
- Editing after signing is allowed for future days from Settings; today's plan is edited via "Unsign and edit" (with confirmation).

### 7.4 Night Reminder (Step 4)

- Full-screen night waves (Section 5), `night-950` background.
- Content (top to bottom): reminder title (H1, e.g. "Tonight, you keep your promise"), wake time (Time Display), "7h 30m of sleep", tonight's pre-sleep checklist (tap to tick, optional), one line: "Keep your phone charging and close to you."
- **Dashboard link:** small caption-size text button at the bottom ("View progress"), low emphasis but contrast still at least 4.5:1.
- No other buttons. The screen dims and sleeps on its own after inactivity.
- Bedtime reminder notification (local) opens this page.

### 7.5 Wake (Step 5)

- Triggered by the alarm (full-screen over lock screen on Android).
- Layout: sunrise icon animation (upper third), **headline** (serif, e.g. "Good morning. You said you would."), description (the user's "why", or a rotating default line), current time, **hold-5-seconds button** (large, bottom third).
- Alarm sound ramps up gradually (about 30s) and stops only when the hold completes.
- Success: sun brightens, haptic, soft chime, then to Focus.
- Hold uses the simplest possible gesture: no puzzles, no typing.

### 7.6 Focus (Step 6)

- Header: greeting, remaining time until 06:00, and the "why" line (serif).
- Progress: "1 of 4 promises kept" with a segmented sun/arc.
- Promise cards in order: category icon, title, duration, status (Not started / In progress / Kept). Tap opens detail. Kept promises show a check and are dimmed.
- When all promises are kept: full-morning celebration, then a "See your progress" button to the dashboard.
- If an in-progress promise exists, its card is highlighted and the screen redirects there on launch.

### 7.7 Promise Timer (Step 7)

- Content: category icon, title, description, big countdown, wave fill animation, one primary button.
- Button states: **Start** (enabled) → **Complete** (disabled, with subtle "N min left" caption) → **Complete** (enabled, gold glow) when the timer ends.
- **Locked mode:** back gesture and system back are blocked while running; no tab bar, no other navigation.
- **Safety exit:** a very small "End early" text button (long press, then confirm). It marks the promise "Not finished today" (neutral wording), never "Failed". Exists so the app can never trap someone in an emergency.
- Timer survives app restart or phone call: based on stored start timestamp, not an in-memory counter.
- A local notification and gentle chime fire when time is up, even if the screen is off.
- Complete: check draws in, small celebration, return to Focus.

### 7.8 Dashboard (Step 8)

Designed to make the user feel good about progress.

1. **Hero:** today's result with celebration when kept ("Promise kept. 4 of 4."). On a not-yet-started or missed day: encouraging, forward-looking line.
2. **Streak Sun:** a sun that grows and glows with the streak, showing current streak and best streak. Rest day and "fresh start" states shown gently.
3. **66-day journey:** progress arc with three phases (Break the old pattern, Build the new one, Make it yours), current phase highlighted, plain language about what to expect.
4. **Next milestone:** "2 days to your 7-day sun" (progress gets stronger as the milestone nears). Milestones at 3, 7, 14, 21, 30, 44, 66 days.
5. **Week strip:** 7 dots/suns for the last 7 days (kept, full, rest, not yet). No red, no empty-shaming.
6. **Wins:** total minutes spent on promises ("You've spent 6h 20m on what matters"), earliest wake, most-kept promise.
7. **Promise list:** each promise with its kept rate for the last 30 days.
8. **Tonight card:** wake time, bedtime, quick access to plan.

- Empty/new-user state is welcoming ("Day 1 starts tonight"), never a wall of zeros.

## 8. Components

| Component | Notes |
| --- | --- |
| `HoldButton` | Params: duration (3s sign / 5s wake), label, onCompleted. Progress ring, haptics, early release drains gently. Accessibility alternative below. |
| `WaveBackground` | Layered animated waves, configurable palette, speed, reduce-motion fallback. |
| `TimerWave` | Fill-level wave driven by remaining/total; independent ripple animation. |
| `SunriseIcon` | Rising and pulsing sun with glow; static variant for reduced motion. |
| `TimeBudgetBar` | Segmented bar from wake time to 06:00; over-budget state. |
| `PromiseCard` | States: not started, in progress, kept, not finished. |
| `CategoryChip` | Icon + label; built-in and custom; selectable. |
| `StreakSun` | Size/glow scale with streak; rest and fresh-start variants. |
| `MilestoneBadge` | Locked/next/earned states; earned uses gold-400. |
| `WeekStrip` | 7-day status dots. |
| `StatTile` | Big number, label, optional delta phrased positively. |
| `ChecklistItem` | Tap to tick, used for pre-sleep list. |
| `TimeWheelPicker` | Large, one-hand friendly; wake picker constrained to 03:00–05:00. |

### Built-in categories (editable, users can add their own)

| Category | Example templates (default duration) |
| --- | --- |
| Spiritual | Du'a on waking (5), Tahajud prayer (20), Dzikir (10), Quran reading (15) |
| Mind | Reading (20), Journaling (10), Study (30) |
| Body | Exercise (30), Stretching (10), Walk (20) |
| Home | Cooking (30), Tidy the house (20) |
| Create | Hobby (30), Writing (20), Side project (45) |
| Plan | Plan the day (10) |

Custom categories: name + icon + color. Templates are suggestions only; title, description and duration are always editable.

## 9. Voice & Tone

- Warm, first-person plural or gentle second person. Short sentences. No guilt.
- Calm at night, bright at dawn, proud at the end.
- Written in Bahasa Indonesia and English from day one (strings in ARB files).

**Copy library (originals, easy to extend)**

| Moment | English | Bahasa Indonesia |
| --- | --- | --- |
| Sign | "A promise made quietly, kept bravely." | "Janji yang dibuat pelan-pelan, ditepati dengan berani." |
| Night title | "Tonight, you keep your promise." | "Malam ini, kamu menepati janji." |
| Night line | "Rest well. Morning is already on your side." | "Istirahatlah. Pagi sudah berpihak padamu." |
| Wake headline | "Good morning. You said you would." | "Selamat pagi. Kamu sudah berjanji." |
| Wake line (default) | "The hardest part is this one minute. Hold on." | "Bagian tersulit hanya satu menit ini. Tahan sebentar." |
| Focus | "One promise at a time." | "Satu janji, satu per satu." |
| Timer | "Just this. Nothing else." | "Cukup ini saja." |
| Promise kept | "Kept. That counts." | "Ditepati. Itu berarti." |
| Full morning | "Every promise kept. Look at that sun." | "Semua janji ditepati. Lihat matahari itu." |
| Missed day | "New morning, fresh start." | "Pagi baru, awal baru." |

If the user wrote a "why", it always replaces the default wake line.

## 10. Accessibility

- Contrast at least 4.5:1 for all text, including the small dashboard link and captions on dark backgrounds.
- **Hold gestures need an alternative:** expose a semantic long-press action and, for screen-reader/switch users, an accessible "confirm" alternative (double-tap then confirm dialog) so the wake and sign flows are usable.
- Font scaling must not break the wake and timer screens.
- Haptics are supplementary, never the only feedback. Sounds have visual equivalents.
- All motion respects reduce-motion.
- Locked timer mode must always keep the safety exit reachable by assistive tech.

## 11. Research Notes (behind the design choices)

Confidence varies: some sources are peer-reviewed, others are explainers. These are inputs to validate in the pilot, not guarantees.

| Decision | Rationale | Source |
| --- | --- | --- |
| Simple motor action on wake (hold, no puzzles) | Sleep inertia typically lasts 15–60 minutes after waking; complex cognitive tasks are impaired more than simple motor ones; it is strongest in the early-morning circadian low (about 4–5am). | [SKYbrary: Sleep inertia](https://skybrary.aero/articles/sleep-inertia), [Wikipedia: Sleep inertia](https://en.wikipedia.org/wiki/Sleep_inertia), [Circadian rhythm in sleep inertia (J Biol Rhythms, 2008)](https://journals.sagepub.com/doi/10.1177/0748730408318081) |
| Promise put lower-thinking tasks first | Same as above: prefrontal function comes online last. | Same sources; ordering advice is a design inference |
| Instant celebration after each kept promise | Feeling of success right after the behavior ("shine") is what wires in habits, more than repetition alone. | [BJ Fogg, Tiny Habits](https://www.nike.com/a/best-way-to-create-new-habits) |
| Start small, few promises | Tiny Habits: make behaviors small enough that ability isn't a barrier; scale up later. | Same |
| Streak sun and next-milestone progress | Streaks raise perceived commitment and motivation; motivation rises as a milestone nears (goal-gradient). | [Silverman & Barasch summary](https://www.earth.com/news/streaks-can-be-a-powerful-tool-for-motivation), [Weathers on streaks](https://scientificamerican.com/article/why-keeping-a-streak-boosts-your-motivation/), [Habit streak overview](https://lifewheel.us/glossary/habit-streak/) |
| Rest day + fresh-start framing, no red on breaks | Streaks are fragile: one break can collapse motivation, and the number can replace the habit as the goal. Temporal "fresh start" landmarks help people recommit. | Same as above; [ICWSM 2024 commitment-platform study](https://ojs.aaai.org/index.php/ICWSM/article/download/31440/33600) |
| Hold-to-sign ritual | A deliberate, effortful act makes the commitment feel real. Design judgment, related to pre-commitment and if-then planning research. | Design judgment, to validate in pilot |
| Night page: dark, slow, minimal | Design judgment for a wind-down surface (low luminance, slow rhythm, few choices). Not backed by a specific study here. | Design judgment, to validate in pilot |

## 12. On Hold (needs other members)

Pod/partner card, escalation banner, on-call rotation and any shared-status UI from v0.1 are deferred until after the personal MVP.

## 13. Open Items

- Confirm typeface licenses (UI sans + editorial serif).
- Illustration style for category icons (custom vs. licensed set).
- Final copy review in Bahasa Indonesia with native readers from the club.
- Decide alarm re-ring policy and late-wake rules with the PRD (see PRD open questions).