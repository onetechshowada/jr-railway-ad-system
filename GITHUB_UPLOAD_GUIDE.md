# GitHub共有手順

このリポジトリをGitHubにアップロードして共有する手順です。

## 📋 前提条件
- GitHubアカウントを持っていること
- GitHubへのアクセス権限があること

## 🚀 アップロード手順

### 方法1: GitHub Web UI（最も簡単）

1. **GitHubにログイン**
   - https://github.com にアクセス

2. **新しいリポジトリを作成**
   - 右上の「+」→「New repository」をクリック
   - Repository name: `jr-railway-ad-system`
   - Description: `JR Railway × Weather Advertising System - 鉄道データ×気象データ広告配信システム`
   - Public または Private を選択
   - 「Create repository」をクリック

3. **ローカルリポジトリをプッシュ**
   
   ターミナルで以下のコマンドを実行:

   ```bash
   cd /mnt/user-data/outputs/jr-railway-ad-system
   
   # GitHubリポジトリをリモートに追加（YOUR_USERNAMEを自分のユーザー名に変更）
   git remote add origin https://github.com/YOUR_USERNAME/jr-railway-ad-system.git
   
   # ブランチ名をmainに変更（推奨）
   git branch -M main
   
   # プッシュ
   git push -u origin main
   ```

4. **認証**
   - GitHubのユーザー名を入力
   - パスワード欄には**Personal Access Token**を入力
     - トークンの作成: GitHub → Settings → Developer settings → Personal access tokens → Generate new token
     - 必要なスコープ: `repo` (全権限)

---

### 方法2: GitHub CLI（推奨・自動化）

```bash
cd /mnt/user-data/outputs/jr-railway-ad-system

# GitHub CLIで認証（初回のみ）
gh auth login

# リポジトリを作成＆プッシュ（一発完了）
gh repo create jr-railway-ad-system --public --source=. --remote=origin --push

# またはプライベートにする場合
gh repo create jr-railway-ad-system --private --source=. --remote=origin --push
```

---

### 方法3: ZIPダウンロード → 手動アップロード

1. **ZIPファイル作成**
   ```bash
   cd /mnt/user-data/outputs
   zip -r jr-railway-ad-system.zip jr-railway-ad-system -x "*.git*"
   ```

2. **GitHubで新規リポジトリ作成**
   - https://github.com/new にアクセス
   - リポジトリ名を入力して作成

3. **ファイルをアップロード**
   - 「uploading an existing file」をクリック
   - ZIPを解凍してファイルをドラッグ＆ドロップ

---

## 🔗 共有URL

プッシュ後、以下の形式のURLで共有できます:

```
https://github.com/YOUR_USERNAME/jr-railway-ad-system
```

### HTMLモックアップのライブプレビュー

GitHub Pagesを有効化すると、HTMLモックアップをブラウザで直接表示できます:

1. リポジトリの「Settings」→「Pages」
2. Source: `main` ブランチ、`/ (root)` フォルダを選択
3. 「Save」をクリック

ライブURL（数分後に有効化）:
```
https://YOUR_USERNAME.github.io/jr-railway-ad-system/jr_data_extraction_mockup.html
```

---

## 📦 リポジトリ内容

```
jr-railway-ad-system/
├── README.md                          # プロジェクト概要・使い方
├── .gitignore                         # Git除外設定
├── jr_data_extraction_mockup.html     # インタラクティブHTMLモックアップ
├── requirements_document_v2.md        # 詳細要件定義書（64KB）
├── system_flowchart.md                # 5フェーズシステムフロー（27KB）
├── technical_checklist.md             # 技術検証チェックリスト（12KB）
└── requirements_document.md           # 初期要件定義書（30KB）
```

---

## 🎯 次のステップ

### リポジトリ公開後:

1. **README.mdにバッジ追加**（オプション）
   ```markdown
   ![License](https://img.shields.io/badge/license-Proprietary-red)
   ![Status](https://img.shields.io/badge/status-Requirements-blue)
   ```

2. **GitHub Pagesを有効化**（HTMLモックアップのライブデモ）

3. **Issuesでタスク管理**
   - 各実装フェーズをIssueとして登録
   - マイルストーン設定（Phase 1, 2, 3）

4. **Wiki作成**（詳細ドキュメント）
   - 技術仕様
   - API設計
   - データベーススキーマ

---

## ⚠️ セキュリティ注意事項

- **機密情報を含めない**: パスワード、APIキー、個人情報は絶対にコミットしない
- **Privateリポジトリ推奨**: 社内プロジェクトの場合はPrivate設定を推奨
- **.gitignoreの確認**: 環境変数ファイル（.env）などが除外されていることを確認

---

## 📞 サポート

プッシュ時にエラーが発生した場合:

1. **認証エラー**
   - Personal Access Tokenを再生成
   - 正しいスコープ（repo）が付与されているか確認

2. **プッシュ失敗**
   ```bash
   git pull origin main --rebase
   git push origin main
   ```

3. **リモートURL変更**
   ```bash
   git remote set-url origin https://github.com/YOUR_USERNAME/jr-railway-ad-system.git
   ```

---

**作成日**: 2026年2月20日  
**Git コミットID**: (初回コミット完了)  
**ファイル数**: 6ファイル  
**総サイズ**: 約180KB
