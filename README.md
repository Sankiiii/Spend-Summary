# Spend Summary

A modern, fully responsive Flutter spend-tracking app built as a take-home assignment. It features a clean dark UI, smooth animations, category filtering, and a scalable Riverpod architecture — designed to feel like a real fintech product, not just a demo.

---

## Screenshots

> Place your images inside a `screenshots/` folder and rename them properly.

---

### Home Screen

<p align="center">
  <img src="lib\screenshot\home.jpeg" width="250" />
</p>

---

### Category Filter Screen

<p align="center">
  <img src="lib\screenshot\categories.jpeg" width="250" />
</p>

---

### Add Expense Screen

<p align="center">
  <img src="lib\screenshot\add_expense.jpeg" width="250" />
</p>

---

### Transaction Details Screen

<p align="center">
  <img src="lib\screenshot\transaction.jpeg" width="250" />
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

Design baseline: **390 × 844 (iPhone 14 Pro)**

- `.w` → Width
- `.h` → Height
- `.sp` → Font size
- `.r` → Radius

No hardcoded values.

---

## Project Structure

```
lib/
├── models/
├── data/
├── providers/
├── theme/
├── screens/
└── widgets/
```

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

```bash
flutter pub get
flutter run
```

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

All development work was done by me.

---

## Notes

- Mock data only
- No backend
- Simulated API delay

---

## Final

Built as a take-home assignment focusing on:

- Clean UI
- Real-world architecture
- Smooth UX
- Scalable code
