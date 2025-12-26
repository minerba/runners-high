#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting Flutter build for Netlify..."

# Flutter 버전 설정 (환경 변수 또는 기본값 stable)
FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
echo "📦 Using Flutter version: $FLUTTER_VERSION"

# 기존 Flutter SDK 제거 (캐시 문제 방지)
if [ -d "flutter" ]; then
  echo "🗑️ Removing existing Flutter SDK..."
  rm -rf flutter
fi

# Flutter SDK 다운로드 (shallow clone으로 빠르게)
echo "⬇️ Downloading Flutter SDK..."
git clone --depth 1 -b "$FLUTTER_VERSION" https://github.com/flutter/flutter.git flutter

# Flutter PATH 설정
export PATH="$(pwd)/flutter/bin:$PATH"
echo "✅ Flutter added to PATH"

# Flutter 웹 활성화 및 사전 캐시
echo "🌐 Enabling Flutter web support..."
flutter config --enable-web --no-analytics
flutter precache --web

# 의존성 설치
echo "📚 Installing dependencies..."
flutter pub get

# 웹 빌드 (셰이더 컴파일 오류 우회)
echo "🔨 Building for web..."
flutter build web --release --no-tree-shake-icons

echo "✅ Build completed successfully!"
