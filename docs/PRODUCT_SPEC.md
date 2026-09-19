# Incr&ly — V1 Product Specification

## Core concept

Incr&ly is a generic event journal built around customizable counters. Each normal increment creates one event with the exact date and time.

## Counter

Each counter contains a unique identifier, name, emoji, color, creation date, initial value, event history, and active/archived state.

Displayed total = initial value + number of recorded events.

The initial value does not create historical events.

## Incrementing

- Tap the emoji/action: record one event immediately.
- Add past clicks manually: choose a quantity and optionally a date/time.
- With a date/time: create that many historical events at the selected date/time.
- Without a date/time: add the quantity to the initial value, without creating historical events.

This distinction preserves the difference between a known historical event and a previously accumulated total whose exact date is unknown.

## Home screen

Active counters appear as colorful rounded cards. Each card shows emoji, name, total, elapsed time since the latest event, and an emoji-shaped increment action.

- Tap the emoji/action: record an event immediately.
- Tap the rest of the card: open details.
- Small + action: add past clicks.
- Context menu/long press: edit, archive or delete.
- +: create a new counter.

## Details

Provide total, latest occurrence, primary increment action, chronological history, calendar view, and basic statistics.

Initial statistics: total; events today/week/month; average events per day; average interval; longest interval; latest occurrence.

## Creation and editing

A counter can be created with name, emoji, color, and initial value. The initial value may be any supported integer. Editing must not fabricate historical events.

## Widgets

V1 targets interactive Home Screen widgets. Small widgets show one selected counter; larger layouts can show multiple selected counters, with the main multi-counter layout supporting up to four. Each displayed counter exposes an increment action and elapsed time since its latest occurrence.

## Data principles

V1 is local-first: no account, backend, or mandatory network connection. Data is stored locally on the device. iCloud/CloudKit is deferred.

## Out of scope for V1

Accounts, backend services, social features, Android, subscriptions/ads, complex goals, AI, and cloud synchronization.
