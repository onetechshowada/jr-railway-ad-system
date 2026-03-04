#!/bin/bash

# JR Railway Ad System - GitHub Push Script
# このスクリプトはGitHubへのプッシュをガイドします

echo "============================================"
echo "  JR Railway × Weather Ad System"
echo "  GitHub Push Helper"
echo "============================================"
echo ""

# 現在のGit状態確認
echo "📊 現在のGit状態:"
git status
echo ""

# リモートリポジトリ確認
echo "🔗 設定済みリモートリポジトリ:"
git remote -v
echo ""

# まだリモートが設定されていない場合
if ! git remote | grep -q "origin"; then
    echo "⚠️  リモートリポジトリが設定されていません"
    echo ""
    echo "以下の手順でGitHubにプッシュしてください:"
    echo ""
    echo "【ステップ1】GitHubで新規リポジトリ作成"
    echo "  1. https://github.com/new にアクセス"
    echo "  2. Repository name: jr-railway-ad-system"
    echo "  3. Description: JR Railway × Weather Advertising System"
    echo "  4. Public または Private を選択"
    echo "  5. 「Initialize this repository with」は全てチェックを外す"
    echo "  6. 「Create repository」をクリック"
    echo ""
    echo "【ステップ2】リモートリポジトリを追加"
    echo "  以下のコマンドを実行してください（YOUR_USERNAMEを自分のユーザー名に変更）:"
    echo ""
    echo "  git remote add origin https://github.com/YOUR_USERNAME/jr-railway-ad-system.git"
    echo ""
    echo "【ステップ3】ブランチ名を変更（推奨）"
    echo "  git branch -M main"
    echo ""
    echo "【ステップ4】プッシュ"
    echo "  git push -u origin main"
    echo ""
    echo "【認証情報】"
    echo "  Username: あなたのGitHubユーザー名"
    echo "  Password: Personal Access Token（通常のパスワードではない）"
    echo ""
    echo "【Personal Access Token取得方法】"
    echo "  1. GitHub → Settings → Developer settings"
    echo "  2. Personal access tokens → Tokens (classic)"
    echo "  3. Generate new token (classic)"
    echo "  4. Note: 'JR Railway Ad System'"
    echo "  5. Expiration: 適切な期限を選択"
    echo "  6. スコープ: 'repo' にチェック（全権限）"
    echo "  7. Generate token → トークンをコピー（一度しか表示されない）"
    echo ""
else
    echo "✅ リモートリポジトリが設定されています"
    echo ""
    echo "プッシュするには以下のコマンドを実行してください:"
    echo ""
    echo "  git push -u origin main"
    echo ""
fi

# GitHub Pages設定
echo ""
echo "============================================"
echo "  GitHub Pages 設定（オプション）"
echo "============================================"
echo ""
echo "HTMLモックアップをライブデモとして公開できます:"
echo ""
echo "【設定手順】"
echo "  1. リポジトリの「Settings」タブをクリック"
echo "  2. 左メニューから「Pages」を選択"
echo "  3. Source: 'Deploy from a branch'"
echo "  4. Branch: 'main' / Folder: '/ (root)' を選択"
echo "  5. 「Save」をクリック"
echo ""
echo "【公開URL】（5-10分後に有効化）"
echo "  https://YOUR_USERNAME.github.io/jr-railway-ad-system/jr_data_extraction_mockup.html"
echo ""

# ファイル一覧
echo ""
echo "============================================"
echo "  含まれるファイル"
echo "============================================"
echo ""
ls -lh | grep -v "^d" | grep -v "^total"
echo ""
echo "合計: $(ls -1 | wc -l) ファイル"
echo ""

echo "✅ 準備完了！上記の手順に従ってGitHubにプッシュしてください"
