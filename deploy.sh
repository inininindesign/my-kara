#!/bin/bash
cd "$(dirname "$0")"

# デプロイ時刻をHTMLに埋め込む
TIMESTAMP=$(date +%s)
sed -i '' "s/<!-- deploy:[0-9]* -->/<!-- deploy:$TIMESTAMP -->/" index.html 2>/dev/null
if ! grep -q "<!-- deploy:" index.html; then
  sed -i '' "s|</head>|<!-- deploy:$TIMESTAMP --></head>|" index.html
fi

git add index.html deploy.sh
git commit -m "update"
git push --set-upstream origin main

echo "⏳ デプロイ待機中..."

URL="https://inininindesign.github.io/my-kara/"
for i in $(seq 1 40); do
  sleep 5
  LIVE=$(curl -s "$URL" | grep -o "deploy:[0-9]*" | head -1)
  if [ "$LIVE" = "deploy:$TIMESTAMP" ]; then
    echo "✅ サイトに反映されました！ $URL"
    exit 0
  fi
  echo "  確認中... ($((i*5))秒経過)"
done

echo "⚠️ タイムアウト。サイトを直接確認: $URL"
