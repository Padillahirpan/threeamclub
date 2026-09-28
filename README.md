# 3AM Club App

A personal wake-up habit app. Choose a wake time between 03:00 and 05:00, plan your sleep, build a list of morning promises, sign your commitment, and let the app guide you from bedtime to a focused, rewarding morning.

Inspired by *The 5 AM Club* by Robin Sharma, and grown out of an existing WhatsApp group ("3 am club") where members wake each other up by text and call.

## Current Focus: Personal MVP

The first version is **personal and local-only**: no accounts, no server, data stays on the device. Features that need other members (pods, partner escalation, sync) are on hold until the personal habit loop is proven.

## The Flow

1. **Sleep plan:** bedtime, wake time (03:00-05:00), pre-sleep checklist
2. **Promise builder:** pick or create categories, add promises (title, description, duration) that fit before 06:00
3. **Sign:** review, then hold for 3 seconds to sign your promise
4. **Night reminder:** calm night-wave page, tonight's checklist, wake time
5. **Wake:** alarm, sunrise animation, hold for 5 seconds to get up
6. **Focus:** your promise list, checked off one by one
7. **Promise timer:** locked countdown so you stay with the promise; Start, then Complete when time is up
8. **Dashboard:** streak, 66-day journey, milestones and stats designed to make progress feel good

## Documentation

| Document | What's inside |
|---|---|
| [3am-club-app-brief.md](./3am-club-app-brief.md) | Background, market context, feature rationale, MVP direction update |
| [3am-club-design-system.md](./3am-club-design-system.md) | Principles, tokens, motion, 8 screen specs, components, copy, accessibility, research notes |
| [3am-club-prd.md](./3am-club-prd.md) | MVP goals, scope, requirements with acceptance criteria, business rules, release plan |
| [architecture.md](./architecture.md) | Flutter architecture: Riverpod, go_router, drift, native alarm, DayPhase routing |

Suggested reading order: Brief, PRD, Design System, Architecture.

## Tech Stack (MVP)

Flutter, Riverpod (code-gen), go_router, drift (SQLite), freezed, local notifications, native alarm via platform channel. Android first.

## Status

Planning and design. No code yet. First milestone is a native alarm reliability spike on real Android devices.

## Key Open Decisions

- Android-only pilot or iOS from the start
- Alarm implementation (package vs. custom native)
- Alarm re-ring policy and late-wake rule
- Whether "Kept" requires 1 promise or all promises (proposal: 1, with "Full" as bonus)

See the PRD (section 12) and Architecture (section 19).

## On Hold

Pods, partner matching, escalation, accounts, cloud sync. The architecture keeps repository interfaces, UUIDs and `updatedAt` so these can be added later without rewriting the core.