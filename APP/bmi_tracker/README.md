# BMI 健康追蹤 App

一款使用 Flutter + Dart 製作的 BMI 計算與追蹤應用程式，介面以深色主題設計，支援繁體中文。

---

## 功能

| 功能 | 說明 |
|------|------|
| BMI 計算 | 輸入身高（cm）與體重（kg），即時計算 BMI |
| 視覺化儀表板 | 半圓形量表顯示當前 BMI 落在哪個區間 |
| 日期記錄 | 每次計算結果連同日期時間、備註一起儲存 |
| 歷史記錄 | 列表瀏覽所有歷史資料，可左滑或點擊刪除 |
| 趨勢圖表 | BMI 與體重折線圖，顯示健康變化趨勢 |
| 統計摘要 | 顯示最新、平均、最高、最低 BMI |
| 本地儲存 | 使用 `shared_preferences` 永久儲存，不需網路 |

---

## 專案結構

```
lib/
├── main.dart                  # App 入口點、底部導覽列
├── theme.dart                 # 全域主題設定（顏色、字體）
├── models/
│   └── bmi_record.dart        # BMI 資料模型
├── services/
│   └── storage_service.dart   # 本地儲存邏輯
├── screens/
│   ├── home_screen.dart       # 計算頁面
│   ├── history_screen.dart    # 歷史記錄頁面
│   └── chart_screen.dart      # 趨勢圖表頁面
└── widgets/
    └── bmi_gauge.dart         # 半圓形 BMI 量表 Widget
```

---

## 快速開始

### 1. 確認環境

```bash
flutter doctor
```

需要 Flutter 3.10+ 和 Dart 3.0+。

### 2. 安裝依賴

```bash
flutter pub get
```

### 3. 執行 App

```bash
# Android 模擬器或實機
flutter run

# iOS（需 macOS + Xcode）
flutter run -d ios

# 網頁版
flutter run -d chrome
```

---

## 使用說明

1. **計算 BMI**：在「計算」頁面輸入身高與體重，可加備註，點擊「計算 BMI」。
2. **儲存記錄**：計算結果顯示後，點擊「儲存這次記錄」。
3. **查看記錄**：切換到「記錄」頁面，可看到所有歷史紀錄；左滑或點擊「刪除」可移除。
4. **查看趨勢**：切換到「趨勢」頁面，查看 BMI 與體重折線圖及統計摘要。

---

## BMI 標準（衛生福利部，台灣）

| 分類 | BMI 範圍 |
|------|---------|
| 體重過輕 | < 18.5 |
| 正常體重 | 18.5 – 23.9 |
| 體重過重 | 24.0 – 26.9 |
| 輕度肥胖 | 27.0 – 29.9 |
| 中度肥胖 | 30.0 – 34.9 |
| 重度肥胖 | ≥ 35.0 |

---

## 使用套件

- [`shared_preferences`](https://pub.dev/packages/shared_preferences) – 本地儲存
- [`fl_chart`](https://pub.dev/packages/fl_chart) – 折線圖表
- [`intl`](https://pub.dev/packages/intl) – 日期格式化（中文）
