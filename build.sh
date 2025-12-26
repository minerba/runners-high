#!/bin/bash

# Flutter SDK 다운로드 및 설치
if [ ! -d "flutter" ]; then
  echo "Downloading Flutter SDK..."
  git clone https://github.com/flutter/flutter.git -b stable
fi

# Flutter PATH 설정
export PATH="$PATH:`pwd`/flutter/bin"

# Flutter 설정 확인
flutter doctor -v

# Flutter 웹 활성화
flutter config --enable-web

# 의존성 설치
flutter pub get

# 웹 빌드
flutter build web --release
