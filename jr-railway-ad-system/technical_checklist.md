# 【重要】鉄道データ連携 - 技術的確認事項チェックシート

## 📋 目的
システム実装前に、データ構造とテーブル連携の詳細を確認し、技術的課題を解消する

---

## ✅ 確認事項一覧

### 【最優先】★★★ 実装の前提となる必須確認事項

#### ❶ Popinfo ID（広告ID）の取得方法

**現状の理解**:
- WESTERサーバ保有データテーブルに Popinfo ID が保存されている
- 2026年2月までに、Popinfo IDと広告IDの紐付け開発が完了予定
- カバー予定: 約674万ID

**確認が必要な項目**:

| No | 確認内容 | 回答欄 | 備考 |
|---|---|---|---|
| 1-1 | WESTERサーバ保有データテーブルの正式なテーブル名は？ |  | 例: `WESTER_SERVER_DATA` |
| 1-2 | テーブルに `KAIIN_ID` カラムは存在するか？ | □ はい □ いいえ | 会員情報との紐付けキー |
| 1-3 | テーブルに `POPINFO_ID` カラムは存在するか？ | □ はい □ いいえ | 広告IDの取得元 |
| 1-4 | `POPINFO_ID` の形式は？ | | 例: `POP123456ABC` |
| 1-5 | 現在のレコード数（ID数）は？ | | 目標: 約674万 |
| 1-6 | WESTERアプリをインストールしていないユーザーの `POPINFO_ID` はどうなっている？ | □ NULL □ 空文字 □ レコード自体が存在しない | メール/電話番号ハッシュ化の必要性判断 |
| 1-7 | 広告ID連携の開発は予定通り2026年2月に完了見込みか？ | □ はい □ 遅延あり（_月） | リリース計画への影響 |

**SQLサンプルで確認**:
```sql
-- テーブル構造の確認
DESCRIBE TABLE WESTER_SERVER_DATA;  -- ★正式なテーブル名に置き換え

-- データサンプルの確認
SELECT * FROM WESTER_SERVER_DATA LIMIT 10;

-- レコード数の確認
SELECT COUNT(*) FROM WESTER_SERVER_DATA;
SELECT COUNT(DISTINCT POPINFO_ID) FROM WESTER_SERVER_DATA WHERE POPINFO_ID IS NOT NULL;
```

---

#### ❷ ICOCA IDと会員IDの連携方法

**現状の理解**:
- ICOCA利用実績テーブルから会員IDを特定する必要がある
- 連携方法が不明確（直接KAIIN_IDがあるのか、中間テーブル経由か）

**確認が必要な項目**:

| No | 確認内容 | 回答欄 | 備考 |
|---|---|---|---|
| 2-1 | `ICOCA一件明細（収入系）`テーブルに `KAIIN_ID` カラムは存在するか？ | □ はい □ いいえ | 直接連携できるか |
| 2-2 | `ICカード出改札ID管理 一件明細`テーブルに `KAIIN_ID` カラムは存在するか？ | □ はい □ いいえ | 直接連携できるか |
| 2-3 | ICOCA_ID ⇔ KAIIN_ID の紐付けテーブルは存在するか？ | □ はい □ いいえ | 存在する場合、テーブル名: |
| 2-4 | SMART ICOCA会員のみが会員IDと紐付いているか？ | □ はい（会員のみ） □ いいえ（全ICOCA） | カバー率への影響 |
| 2-5 | SMART ICOCA会員数（推定）は？ | | 全会員数に対する割合 |
| 2-6 | 通常のICOCAカード（非会員）のデータは含まれているか？ | □ はい □ いいえ | 含まれる場合、除外が必要 |

**SQLサンプルで確認**:
```sql
-- ICOCAテーブルの構造確認
DESCRIBE TABLE ICOCA_IKKEN_MEISAI_SHUNYU;  -- ★正式なテーブル名
DESCRIBE TABLE ICCARD_DEKAISATSU_IKKEN_MEISAI;  -- ★正式なテーブル名

-- KAIIN_IDカラムの存在確認
SELECT KAIIN_ID, COUNT(*) 
FROM ICCARD_DEKAISATSU_IKKEN_MEISAI 
GROUP BY KAIIN_ID 
LIMIT 10;

-- 紐付けテーブルの確認
SHOW TABLES LIKE '%ICOCA%KAIIN%';
```

---

#### ❸ e5489予約テーブルの会員ID（KAIIN_A_KEY）

**現状の理解**:
- 予約確定テーブルには `KAIIN_A_KEY`（会員分析キー）が存在
- 「J-WEST IDの代替キー」と記載されているが、KAIIN_IDとの関係が不明

**確認が必要な項目**:

| No | 確認内容 | 回答欄 | 備考 |
|---|---|---|---|
| 3-1 | `KAIIN_A_KEY` = `KAIIN_ID` か？ | □ はい（同一） □ いいえ（別の識別子） | 同一の場合、そのまま使用可能 |
| 3-2 | 別の識別子の場合、`KAIIN_A_KEY` ⇔ `KAIIN_ID` の変換テーブルは存在するか？ | □ はい □ いいえ | 存在する場合、テーブル名: |
| 3-3 | 予約確定テーブルに `KAIIN_ID` カラムも存在するか？ | □ はい □ いいえ | 両方存在する場合の使い分け |
| 3-4 | `KAIIN_A_KEY` の形式は？ | | 例: `A0001234567` or `ABC123...` |

**SQLサンプルで確認**:
```sql
-- テーブル構造の確認
DESCRIBE TABLE E5489_YOYAKU_KAKUTEI;

-- KAIIN_A_KEY と KAIIN_ID の関係確認（両方存在する場合）
SELECT 
    KAIIN_A_KEY,
    KAIIN_ID,  -- このカラムが存在するか確認
    COUNT(*)
FROM 
    E5489_YOYAKU_KAKUTEI
GROUP BY 
    KAIIN_A_KEY, KAIIN_ID
LIMIT 10;

-- 変換テーブルの確認
SHOW TABLES LIKE '%KAIIN%KEY%';
```

---

### 【高優先度】★★☆ 配信条件の実装に影響

#### ❹ 定期券種別の判定方法

**現状の理解**:
- 通勤定期/通学定期を条件に使いたい
- 定期券フラグの存在が不明

**確認が必要な項目**:

| No | 確認内容 | 回答欄 | 備考 |
|---|---|---|---|
| 4-1 | ICOCA出改札テーブルに定期券フラグは存在するか？ | □ はい □ いいえ | カラム名: |
| 4-2 | 存在する場合、通勤定期と通学定期の区別は可能か？ | □ はい □ いいえ | 区分コード: |
| 4-3 | 定期券の発着駅情報は取得できるか？ | □ はい □ いいえ | カラム名: |
| 4-4 | 定期券の有効期限情報は取得できるか？ | □ はい □ いいえ | カラム名: |
| 4-5 | 定期券フラグが存在しない場合、利用頻度から推定する方法で問題ないか？ | □ はい □ いいえ | 推定精度は中程度 |

**SQLサンプルで確認**:
```sql
-- 定期券フラグの確認
SELECT DISTINCT
    TEIKI_FLG,      -- ★存在するか確認
    TEIKI_KBN,      -- ★通勤/通学の区分
    KENSHU_CD,      -- 券種コード
    COUNT(*)
FROM 
    ICCARD_DEKAISATSU_IKKEN_MEISAI
GROUP BY 
    TEIKI_FLG, TEIKI_KBN, KENSHU_CD
LIMIT 50;
```

---

#### ❺ カード決済データの店舗カテゴリ

**現状の理解**:
- 購買履歴から特定カテゴリ（ジム、ガソスタ、航空券等）を抽出したい
- 店舗カテゴリのコード体系が不明

**確認が必要な項目**:

| No | 確認内容 | 回答欄 | 備考 |
|---|---|---|---|
| 5-1 | カード事業テーブルに店舗カテゴリのカラムは存在するか？ | □ はい □ いいえ | カラム名: |
| 5-2 | 店舗カテゴリのコード体系は？ | | 例: コード/名称のマスタ |
| 5-3 | 主要なカテゴリ一覧を教えてください | | ガソスタ、ジム、航空券、ホテル、デパート、etc. |
| 5-4 | 店舗名（加盟店名）は取得できるか？ | □ はい □ いいえ | 競合店舗の特定に使用 |
| 5-5 | 店舗カテゴリが存在しない場合、店舗名から推定する方法で問題ないか？ | □ はい □ いいえ | 文字列マッチング処理が必要 |

**SQLサンプルで確認**:
```sql
-- カード決済テーブルの構造確認
DESCRIBE TABLE CARD_JIGYOU_RIYO_YM_KAIIN;

-- 店舗カテゴリのサンプル
SELECT DISTINCT
    RIYO_TENPO_CATEGORY,  -- ★カラム名を確認
    COUNT(*)
FROM 
    CARD_JIGYOU_RIYO_YM_KAIIN
GROUP BY 
    RIYO_TENPO_CATEGORY
ORDER BY 
    COUNT(*) DESC
LIMIT 50;

-- 店舗名のサンプル
SELECT DISTINCT
    RIYO_TENPO_NAME,  -- ★カラム名を確認
    COUNT(*)
FROM 
    CARD_JIGYOU_RIYO_YM_KAIIN
GROUP BY 
    RIYO_TENPO_NAME
ORDER BY 
    COUNT(*) DESC
LIMIT 50;
```

---

### 【中優先度】★☆☆ 機能拡張時に確認

#### ❻ WESTERアプリイベントテーブルの連携

**確認が必要な項目**:

| No | 確認内容 | 回答欄 | 備考 |
|---|---|---|---|
| 6-1 | WESTERアプリイベントテーブルに `KAIIN_ID` は存在するか？ | □ はい □ いいえ | |
| 6-2 | `POPINFO_ID` で連携する必要があるか？ | □ はい □ いいえ | |
| 6-3 | イベント種別のコード一覧は？ | | 画面閲覧、ボタンタップ、etc. |

---

#### ❼ データ更新頻度とタイムラグ

**確認が必要な項目**:

| No | 確認内容 | 回答欄 | 備考 |
|---|---|---|---|
| 7-1 | ICOCA出改札データは統合DWHに何時頃投入されるか？ | | 例: 翌日AM 2:00 |
| 7-2 | e5489予約データは統合DWHに何時頃投入されるか？ | | 例: リアルタイム or 1時間毎 |
| 7-3 | カード決済データは統合DWHに何時頃投入されるか？ | | 例: 翌日AM 3:00 |
| 7-4 | 各テーブルの更新頻度は？ | | 日次/1時間毎/リアルタイム |

---

## 📊 確認後のアクション

### ✅ 確認完了後に実施すること

1. **データ取得SQLの最終化**
   - 正式なテーブル名・カラム名への置き換え
   - 連携キーの確定
   - 推定ロジックの実装（定期券判定等）

2. **対象者抽出バッチ処理の実装**
   - 日次バッチスクリプトの作成
   - 集計・分析処理の実装
   - Popinfo ID紐付け処理

3. **広告媒体API連携の実装**
   - Customer Match / Custom Audiences への送信処理
   - メール/電話番号のハッシュ化処理

4. **UI/UXモックアップの作成**
   - 配信条件設定画面
   - 駅名検索サジェスト
   - 配信対象者プレビュー

---

## 📝 確認方法

### ステップ1: データベースアクセス

統合DWHへの接続情報を取得し、SQLクライアントで接続

### ステップ2: SQLサンプルの実行

本チェックシートに記載されたSQLサンプルを実行し、結果を記録

### ステップ3: 結果の共有

確認結果をこのチェックシートに記入し、開発チームと共有

---

## 🚀 次のステップ

✅ **ステップ4完了**: 配信条件の要件定義（フローチャート対応版）

⏳ **データ構造確認**: 本チェックシートの確認事項を実施

▶️ **ステップ5**: UI/UXモックアップの作成

---

**📌 確認事項への回答をいただければ、すぐに次のフェーズに進めます！**

---

## 付録: テーブル名・カラム名の推定リスト

### 【推定】統合DWHのテーブル名

| カテゴリ | 推定テーブル名 | 確認済み名称 |
|---|---|---|
| 会員情報 | `KAIIN` |  |
| WESTERサーバ | `WESTER_SERVER_DATA` or `WESTER_APP_USER` |  |
| 予約確定(e5489) | `E5489_YOYAKU_KAKUTEI` |  |
| 行程確定(e5489) | `E5489_KOTEI_KAKUTEI` |  |
| 列車確定(e5489) | `E5489_RESSHA_KAKUTEI` |  |
| ICOCA一件明細 | `ICOCA_IKKEN_MEISAI_SHUNYU` |  |
| ICOCA出改札 | `ICCARD_DEKAISATSU_IKKEN_MEISAI` |  |
| カード事業（利用） | `CARD_JIGYOU_RIYO_YM_KAIIN` |  |
| カード事業（締め） | `CARD_JIGYOU_SHIME_YM_KAIIN` |  |
| WESTERイベント | `WESTER_APP_EVENT` |  |

### 【推定】主要カラム名

| カテゴリ | 推定カラム名 | 確認済み名称 |
|---|---|---|
| 共通会員ID | `KAIIN_ID` |  |
| Popinfo ID | `POPINFO_ID` |  |
| 会員分析キー | `KAIIN_A_KEY` |  |
| ICOCA ID | `ICOCA_ID` |  |
| 入場駅コード | `NYUJO_EKI_CD` |  |
| 出場駅コード | `SHUTSUJO_EKI_CD` |  |
| 入場時刻 | `NYUJO_JIKOKU` |  |
| 出場時刻 | `SHUTSUJO_JIKOKU` |  |
| 利用日 | `RIYO_YMD` |  |
| 定期券フラグ | `TEIKI_FLG` |  |
| 定期券区分 | `TEIKI_KBN` |  |
| 店舗カテゴリ | `RIYO_TENPO_CATEGORY` |  |
| 店舗名 | `RIYO_TENPO_NAME` |  |
