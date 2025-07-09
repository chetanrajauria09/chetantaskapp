# 📊 Chetan Task App Assignment

The app displays a user's portfolio holdings with a summary view, including profit & loss calculations. Built using clean MVVM architecture, programmatic UIKit, and modern Swift best practices.

---

## ✅ Features Implemented

- ✅ Portfolio list with `UITableView` and custom cells
- ✅ Expandable summary view showing:
  - Current Value
  - Total Investment
  - Today's P&L
  - Total P&L
- ✅ Dynamic P&L coloring based on values
- ✅ Shimmer loading placeholder during API fetch
- ✅ Unit test coverage > 92%
- ✅ Fully responsive and crash-free UI

---

## 🧠 Architecture

- `MVVM` architecture with loose coupling between View and ViewModel
- Repository pattern for abstracting data layer
- Uses `async/await` for networking (no third-party dependencies)
- Fully programmatic UI using `UIKit` (no Storyboards)

---

## 🧪 Testing

- Used XCTest for unit testing
- Covered edge cases like:
  - Zero quantity
  - Negative P&L
  - No holdings
- Mock repository for isolated testing
- Code coverage: **92%+**  

---

## 📲 Requirements

- Xcode 16.4
- Swift 6.2
- iOS 15+

---

## 📌 Notes

- **TabBar** and **Segment Control** were skipped per the instructions mentioned in the assignment email.
- **Offline mode** not implemented as the task did not specify offline expectations. Please share specific requirements if you'd like this feature.
- Used a clean and scalable folder structure with modular components to support future feature additions.
