# 💸 Spend Summary

A modern, fully responsive Flutter spend-tracking app built as a take-home assignment. Features a clean dark UI, animated charts, category filtering, and a proper Riverpod state management architecture — all scaling pixel-perfectly across every device using `flutter_screenutil`.

<br/>

## 📸 Screenshots

> **Add your screenshots here before pushing to GitHub.**  
> Run the app → take screenshots → save them in a `/screenshots` folder at the project root → replace the placeholders below.

<br/>

<!-- ─── Replace these paths with your real screenshots ─────────────────────── -->
<p align="center">
  <img src="screenshots/home.png" width="220" alt="Home Screen" />
  &nbsp;&nbsp;&nbsp;
  <img src="screenshots/categories.png" width="220" alt="Category Filter" />
  &nbsp;&nbsp;&nbsp;
  <img src="screenshots/add_expense.png" width="220" alt="Add Expense Sheet" />
</p>

<p align="center">
  <img src="screenshots/transaction_detail.png" width="220" alt="Transaction Detail" />
  &nbsp;&nbsp;&nbsp;
  <img src="screenshots/filtered_list.png" width="220" alt="Filtered List" />
</p>
<!-- ─────────────────────────────────────────────────────────────────────────── -->

<br/>

> 💡 **How to take screenshots:**
> - **iOS Simulator** — `Cmd + S` or Device menu → Screenshot
> - **Android Emulator** — camera icon in the emulator side toolbar
> - **Physical Android** — Power + Volume Down
> - **Physical iPhone** — Side button + Volume Up
>
> Create a `screenshots/` folder at the project root and name them exactly as shown above, or update the `src` paths to match what you saved.

<br/>

---

## ✨ Features

- **Header card** — animated count-up total spend, % change badge vs last month, live animated budget bar, mini stats row (transactions · avg per day · last month)
- **Spend donut chart** — custom `CustomPainter` with smooth draw-in animation and category legend
- **Category horizontal scroll** — 7 categories with staggered spring entrance; tap to filter transactions live
- **57 transactions** — grouped by date with section headers, press-highlight effect, tap for detail bottom sheet
- **Add Expense sheet** — full validated form, animated category chip picker, loading + success state via `StateNotifier`
- **Collapsing FAB** — expands to "Add Expense" label when at top, shrinks to icon-only as you scroll down
- **Fully responsive** — every size, font, radius, and gap adapts to any screen using `flutter_screenutil`

<br/>

---

## 📱 Responsive Design — ScreenUtil

Design baseline: **390 × 844 px** (iPhone 14 Pro). Every measurement in the entire codebase uses a ScreenUtil suffix — no hardcoded pixel values anywhere.

| Suffix | Applied to |
|--------|------------|
| `.w`   | Horizontal padding, margin, width |
| `.h`   | Vertical padding, margin, height |
| `.sp`  | Every single `fontSize` |
| `.r`   | Border radii, icon sizes, square containers |

Scales cleanly on small Android phones (360 px wide), large iPhones, and tablets.

<br/>

---

## 🏗️ Project Structure

```
lib/
├── main.dart                          # ProviderScope + ScreenUtilInit + MaterialApp
│
├── models/
│   ├── transaction.dart               # Transaction data class
│   ├── category.dart                  # SpendCategory data class
│   └── spend_summary.dart             # Aggregate model with computed properties
│
├── data/
│   └── spend_repository.dart          # Mock data — swap fetchSummary() for real API
│
├── providers/
│   └── spend_providers.dart           # All 6 Riverpod providers (single file)
│
├── theme/
│   └── app_theme.dart                 # AppColors, AppGradients, AppText styles
│
├── screens/
│   └── spend_summary_screen.dart      # Main scaffold, AppBar, FAB
│
└── widgets/
    ├── header_card.dart               # Monthly spend card + animations
    ├── spend_donut.dart               # Animated CustomPainter donut
    ├── category_scroll.dart           # Horizontal chips + stagger animation
    ├── transaction_list.dart          # Grouped list + detail sheet
    └── add_expense_sheet.dart         # Add expense form (StateNotifier)
```

<br/>

---

## 🔁 State Management — Riverpod

All state and logic lives in `lib/providers/spend_providers.dart`. Widgets only read and display — no business logic in the UI layer.

| Provider | Type | What it does |
|----------|------|--------------|
| `spendSummaryProvider` | `FutureProvider` | Fetches data; exposes loading / error / data states |
| `selectedCategoryIndexProvider` | `StateProvider<int>` | Tracks active category chip (-1 = All) |
| `filteredTransactionsProvider` | `Provider` *(derived)* | Auto-filters transactions when category changes |
| `groupedTransactionsProvider` | `Provider` *(derived)* | Groups filtered list by date for section headers |
| `showFabLabelProvider` | `StateProvider<bool>` | FAB expand/collapse based on scroll offset |
| `addExpenseProvider` | `StateNotifierProvider` | Full form state — amount, note, category, submit, reset |

<br/>

---

## 🚀 Getting Started

**Requirements:** Flutter 3.10+ · Dart 3.0+

```bash
# Clone
git clone https://github.com/your-username/spend-summary.git
cd spend-summary

# Install
flutter pub get

# Run
flutter run
```

<br/>

---

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.4.9 | State management |
| `flutter_screenutil` | ^5.9.0 | Responsive layout on all screen sizes |
| `google_fonts` | ^6.1.0 | Inter + JetBrains Mono typography |
| `intl` | ^0.18.1 | Indian number formatting (₹ with commas) |

<br/>

---

## 🤖 AI Usage — Honest Note

I used **Claude (Anthropic)** during this project, but in a specific and limited way.

**Where AI actually helped me:**

- **Color combinations** — I had a rough idea of a dark fintech aesthetic and used Claude to quickly compare a few palette options (background darkness, accent hues, success/danger colors) rather than spending time clicking around in a color tool. This saved maybe 20–30 minutes.

- **File and folder structure** — I asked Claude how a clean mid-size Flutter project should organise models, providers, theme, screens, and widgets. It gave me a starting point; I read it, changed a few things, and used it as my own structure.

- **Riverpod type lookup** — When I wasn't 100% sure whether a specific piece of state needed a `StateProvider` or `StateNotifierProvider`, I asked Claude the same way I'd use the official docs or a Stack Overflow answer. Quick confirmation, moved on.

**What I did myself:**

Everything else — the widget code, layout logic, animation choreography, UX decisions (what goes in the header, how the FAB should behave, how filtering feels), all the debugging and iteration during the 2–3 hour build window.

AI was useful in the same way Google or the Flutter docs are useful — for quick lookups and exploration, not for writing the actual product.

<br/>

---

## 📝 Notes

- All transaction data is hardcoded mock data — no backend needed
- The Add Expense form simulates an 800 ms network save but does not persist data
- Monthly budget is hardcoded at ₹1,00,000 for the progress bar

<br/>

---

*Built as a take-home assignment. Not licensed for redistribution.*