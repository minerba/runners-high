# Runners High 🏃‍♂️

런너들을 위한 크로스 플랫폼 모바일 앱

## 주요 기능

- ✅ 크로스 플랫폼 지원 (Android & iOS)
- 🔐 다양한 로그인 방식 (이메일, 카카오, 구글, 페이스북, 인스타그램)
- 📋 대회 정보 게시판
- 👔 관리자 페이지
- 🛍️ 런닝 용품 광고 및 제품 소개
- 🎨 Flutter를 사용한 아름다운 UI
- 🗄️ Supabase 백엔드

## 기술 스택

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase
- **Authentication**: Supabase Auth + OAuth
- **Database**: PostgreSQL (Supabase)
- **Storage**: Supabase Storage

## 시작하기

### 필수 조건

- Flutter SDK (3.0 이상)
- Dart SDK
- iOS 개발: Xcode, CocoaPods
- Android 개발: Android Studio
- Supabase 계정

### 설치

1. 저장소 클론 또는 다운로드

2. 의존성 설치:
```bash
flutter pub get
```

3. iOS 의존성 설치:
```bash
cd ios
pod install
cd ..
```

4. `.env` 파일 생성 및 Supabase 키 설정:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 실행

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── config/                   # 설정 파일
│   └── supabase_config.dart
├── models/                   # 데이터 모델
│   ├── user_model.dart
│   ├── event_model.dart
│   └── product_model.dart
├── screens/                  # 화면
│   ├── auth/
│   ├── home/
│   ├── events/
│   └── admin/
├── widgets/                  # 재사용 가능한 위젯
├── services/                 # 비즈니스 로직
│   ├── auth_service.dart
│   ├── event_service.dart
│   └── product_service.dart
└── utils/                    # 유틸리티
    └── constants.dart
```

## Supabase 데이터베이스 설정

아래 SQL을 Supabase SQL Editor에서 실행하세요:

```sql
-- 프로필 테이블
CREATE TABLE profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  is_admin BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 대회 정보 테이블
CREATE TABLE events (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  event_url TEXT,
  image_url TEXT,
  event_date TIMESTAMP WITH TIME ZONE,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 제품 테이블
CREATE TABLE products (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  product_url TEXT,
  price DECIMAL(10, 2),
  is_featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Row Level Security 활성화
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- 정책 설정
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Events are viewable by everyone"
  ON events FOR SELECT USING (true);

CREATE POLICY "Admins can insert events"
  ON events FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() AND is_admin = true
    )
  );

CREATE POLICY "Products are viewable by everyone"
  ON products FOR SELECT USING (true);

CREATE POLICY "Admins can manage products"
  ON products FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() AND is_admin = true
    )
  );
```

## OAuth 설정

### 카카오 로그인
1. [Kakao Developers](https://developers.kakao.com/)에서 앱 생성
2. Redirect URI: `https://your-project.supabase.co/auth/v1/callback`

### 구글 로그인
1. [Google Cloud Console](https://console.cloud.google.com/)에서 프로젝트 생성
2. OAuth 클라이언트 ID 생성

### 페이스북 로그인
1. [Facebook for Developers](https://developers.facebook.com/)에서 앱 생성
2. Facebook Login 제품 추가

### 인스타그램 로그인
- 페이스북 로그인을 통해 인스타그램 계정 연동 가능

## 라이선스

MIT
