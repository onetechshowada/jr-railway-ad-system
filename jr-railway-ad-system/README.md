# JR Railway × Weather Advertising System

**鉄道データ × 気象データ広告配信システム 要件定義・設計ドキュメント**

## 📋 プロジェクト概要

JR西日本の鉄道データ（e5489予約、ICOCA利用、定期券、カード決済）と気象データを組み合わせた、高度なターゲティング広告配信システムの要件定義・設計資料です。

### 主要機能
- 🚄 **鉄道データ活用**: 駅利用、定期券、予約データ、購買履歴
- 🌤️ **気象連動配信**: 温度、降水量、湿度、風速などのリアルタイム制御
- 🎯 **精密ターゲティング**: 20+の配信条件による細かいセグメント抽出
- 📊 **マルチプラットフォーム**: Google広告、Meta、Yahoo!、geoLogic連携

---

## 📁 プロジェクト構成

```
jr-railway-ad-system/
├── README.md                          # このファイル
├── jr_data_extraction_mockup.html     # JRデータ抽出画面 HTMLモックアップ
├── requirements_document_v2.md        # 詳細要件定義書（配信条件20+項目、SQL例）
├── system_flowchart.md                # 5フェーズシステムフローチャート
├── technical_checklist.md             # 技術検証チェックリスト
└── requirements_document.md           # 初期要件定義書（ベースライン）
```

---

## 🎨 HTMLモックアップ

### **📱 [jr_data_extraction_mockup.html](./jr_data_extraction_mockup.html)**

完全に機能するインタラクティブなUI/UXモックアップ。

#### 主要機能:
- ✅ **初期状態（条件未設定）**: 空状態メッセージ＆CTAボタン
- ✅ **条件設定モーダル**: 5カテゴリ（駅・区間、定期券・予約、時間帯、属性、購買）
- ✅ **データテーブル**: 広告ID（36桁マスク表示）、氏名、メール、TEL
- ✅ **ロケーションタブ**: すべて / 大阪 / 京都 / 神戸 / 金沢
- ✅ **ページング**: 件数表示＆切替（10/25/50/100件）
- ✅ **ステータスバー**: DWH更新日時、抽出条件更新、抽出件数

#### 使い方:
```bash
# ローカルで開く
open jr_data_extraction_mockup.html

# または、ブラウザに直接ドラッグ＆ドロップ
```

**デモ操作:**
1. 「条件を設定する」クリック → モーダル表示
2. 条件入力（駅名、期間、回数、曜日）
3. 「適用する」→ データテーブル表示
4. タブ切替・ページング・条件編集・削除が可能

---

## 📖 ドキュメント

### **1. [requirements_document_v2.md](./requirements_document_v2.md)** (64 KB)
詳細要件定義書。主要内容:

#### **配信条件（20+項目）**
| カテゴリ | 条件例 | 実装難易度 |
|---------|-------|-----------|
| **駅・区間** | 特定駅利用者、マイステーション、特定路線区間 | ✔️ 簡単 〜 🔺 外部API |
| **定期券・予約** | 通勤定期、学生定期、乗車券予約者 | ✔️〜⭕ 集計必要 |
| **時間帯** | 帰宅時間帯、リアルタイム駅利用 | ⭕〜🔺 |
| **属性** | ビジネスパーソン、学生、利用頻度 | ✔️〜⭕ |
| **購買履歴** | カテゴリ購買、競合店訪問、自社商品購入 | ✔️〜⭕ |

#### **SQL実装例**
```sql
-- 特定駅利用者（大阪駅、過去30日、5回以上）
SELECT DISTINCT k.KAIIN_ID
FROM ICOCA_ICHIKENMEISAI i
JOIN KAIIN_INFO k ON i.IC_ID = k.IC_ID
WHERE (i.NYUGAI_KBN = '1' AND i.EKI_CD = 'OSK001')
   OR (i.NYUGAI_KBN = '2' AND i.EKI_CD = 'OSK001')
  AND i.TORIHIKI_DATE >= CURRENT_DATE - 30
GROUP BY k.KAIIN_ID
HAVING COUNT(*) >= 5;
```

#### **推定リーチ数（セグメント別）**
- 大阪駅利用者: 約50万人
- 通勤定期ビジネスパーソン: 約120万人
- 乗車券予約者（直近30日）: 約8万人
- ジム購買者: 約15万人

---

### **2. [system_flowchart.md](./system_flowchart.md)** (27 KB)
5フェーズシステムフロー図。

#### **Phase 1: オーディエンス抽出**
- 日次バッチ（04:00）
- DWH（会員、e5489、ICOCA、カード）から抽出
- 出力: KAIIN_ID / Popinfo ID / ハッシュメール・TEL

#### **Phase 2: キャンペーン同期**
- 手動 → 自動化（API連携）
- Google Ads / Meta / Yahoo! / geoLogic

#### **Phase 3: カスタムオーディエンス登録**
- 日次バッチ（06:00）
- Popinfo ID（60-80%マッチ）＋ハッシュ連絡先（30-60%）

#### **Phase 4: 気象条件制御**
- 時間単位リアルタイム制御
- 例: 雨天 → タクシーアプリ、猛暑 → デリバリー

#### **Phase 5: レポーティング**
- リアルタイム / 日次 / 週次
- パフォーマンス、ROI集計

---

### **3. [technical_checklist.md](./technical_checklist.md)** (12 KB)
技術検証項目。

#### **最優先確認事項:**
1. ✅ Popinfo ID マッピング（目標674万ID）
2. ✅ ICOCA ↔ 会員紐付
3. ✅ e5489予約 → 会員ID
4. ✅ 定期券種別フラグ（通勤 vs. 学生）
5. ✅ カード決済 店舗カテゴリコード

#### **検証SQL例:**
```sql
-- Popinfo IDカバレッジ確認
SELECT 
  COUNT(DISTINCT KAIIN_ID) as total_members,
  COUNT(DISTINCT CASE WHEN POPINFO_ID IS NOT NULL THEN KAIIN_ID END) as with_popinfo,
  ROUND(COUNT(DISTINCT CASE WHEN POPINFO_ID IS NOT NULL THEN KAIIN_ID END) * 100.0 / COUNT(DISTINCT KAIIN_ID), 2) as coverage_percent
FROM KAIIN_INFO;
```

---

## 🚀 実装ロードマップ

### **Phase 1（2-3ヶ月、HIGH優先度）**
実装条件（7項目）:
- ✅ 特定駅利用者
- ✅ マイステーション
- ✅ 特定路線区間
- ✅ 乗車券予約者
- ✅ ビジネスパーソン
- ✅ 学生
- ✅ カテゴリ購買

**推定リーチ**: 約400万人

### **Phase 2（3-4ヶ月、MEDIUM優先度）**
実装条件（7項目）:
- ⭕ マイ区間
- ⭕ 通勤定期・学生定期
- ⭕ 帰宅時間帯
- ⭕ 利用頻度
- ⭕ 競合店訪問者
- ⭕ 自社商品購入者

**追加リーチ**: +200万人

### **Phase 3（4-6ヶ月、LOW優先度）**
実装条件（3項目）:
- 🔺 路線上駅利用者（外部API）
- 🔺 リアルタイム駅利用
- 🔺 時刻表連携（外部API）

**追加リーチ**: +100万人

---

## 📊 想定パフォーマンス

### **配信規模**
- **総会員数**: 約674万人（Popinfo ID紐付後）
- **ハッシュ連絡先**: +20-30%（約200万人）
- **総リーチ**: 約800-900万人

### **セグメント精度**
- **単一条件**: 5-50万人
- **気象×鉄道組合せ**: 3-5万人/条件
- **マッチ率**: 
  - Popinfo ID: 60-80%
  - ハッシュメール: 30-60%
  - ハッシュTEL: 40-70%

---

## 🎯 主要ユースケース（31件分析済み）

### **リアル店舗（16件）**
- 🍽️ 飲食店: 駅最寄り×天候別メニュー
- 🏋️ ジム: 雨天日×通勤定期
- 🏡 不動産: 駅利用者×天候メッセージ変更
- ⛽ ガソリンスタンド: 出張予約者×給油促進

### **ネットビジネス（15件）**
- 🚗 自動車ディーラー: 定期購買×ブランディング
- 🏥 保険: 通勤パス×属性ターゲティング
- ✈️ 旅行: 予約履歴×気象連動
- 🎓 教育: 学生定期×気象条件

---

## 🛠️ 技術スタック（推奨）

### **フロントエンド**
- React 18+ または Vue 3+
- TypeScript
- Tailwind CSS（デザインシステム）
- Axios（API通信）

### **バックエンド**
- Node.js / Python (FastAPI)
- PostgreSQL / Oracle（DWH接続）
- Redis（キャッシュ）
- REST API / GraphQL

### **インフラ**
- AWS / GCP
- Docker + Kubernetes
- CI/CD: GitHub Actions

### **外部API連携**
- Google Ads API
- Meta Marketing API
- Yahoo! Ads API
- geoLogic API
- 気象データAPI（OpenWeatherMap / 気象庁）

---

## 📞 お問い合わせ

プロジェクトに関するご質問・ご要望は、以下までお気軽にお問い合わせください。

---

## 📄 ライセンス

このドキュメントは Weather Marketing Inc. の内部資料です。無断転載・複製を禁じます。

---

**作成日**: 2026年2月20日  
**バージョン**: 1.0  
**作成者**: Genspark AI Assistant  
**プロジェクト名**: JR Railway × Weather Advertising System
