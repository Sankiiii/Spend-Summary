# Spend Summary

A modern, fully responsive Flutter spend-tracking app built as a take-home assignment. It features a clean dark UI, smooth animations, category filtering, and a scalable Riverpod architecture — designed to feel like a real fintech product, not just a demo.

---

## 📸 Screenshots

> Add your screenshots before pushing to GitHub.

<p align="center">
  <img src="lib\screenshot\WhatsApp Image 2026-05-06 at 2.34.23 PM.jpeg" width="220" alt="Home Screen" />
  &nbsp;&nbsp;&nbsp;
  <img src="lib\screenshot\WhatsApp Image 2026-05-06 at 2.34.23 PM (3).jpeg" width="220" alt="Category Filter" />
  &nbsp;&nbsp;&nbsp;
  <img src="lib\screenshot\WhatsApp Image 2026-05-06 at 2.34.23 PM (1).jpeg" width="220" alt="Add Expense Sheet" />
</p>

<p align="center">
  <img src="lib\screenshot\WhatsApp Image 2026-05-06 at 2.34.24 PM.jpeg" width="220" alt="Transaction Detail" />
  </p>

---

## Features

- Header Card with animated spend + stats
- Custom animated donut chart
- Category filtering with smooth UI
- 50+ grouped transactions
- Add Expense bottom sheet
- Smart collapsing FAB
- Fully responsive using ScreenUtil

---

## Responsive Design — ScreenUtil

Design baseline: 390 × 844 (iPhone 14 Pro)

- `.w` → Width
- `.h` → Height
- `.sp` → Font size
- `.r` → Radius

No hardcoded values.

---

## Project Structure

lib/
├── models/
├── data/
├── providers/
├── theme/
├── screens/
└── widgets/

---

## State Management — Riverpod

- Clean separation of UI and logic
- Reactive updates
- Scalable structure

---

## Architecture

- Models → Data → Providers → UI
- Easy to scale
- Maintainable

---

## Getting Started

flutter pub get  
flutter run

---

## Dependencies

- flutter_riverpod
- flutter_screenutil
- google_fonts
- intl

---

## AI Usage

Used Claude and ChatGPT for:

- README structure
- Architecture validation
- Minor wording improvements

All development work done by me.

---

## Notes

- Mock data only
- No backend
- Simulated API delay

---

Built as a take-home assignment.
