#!/bin/bash
cd "$(dirname "$0")"
netlify deploy --dir=. --prod
echo "✅ Netlifyに反映しました"
