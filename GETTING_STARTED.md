# 시작 가이드 - Runners High 앱

이 문서는 Runners High 앱을 처음 실행하는 방법을 단계별로 안내합니다.

## 📋 사전 준비물

### 필수 설치
1. **Flutter SDK** (3.0 이상)
   ```bash
   # Flutter 설치 확인
   flutter --version
   ```

2. **Dart SDK** (Flutter와 함께 설치됨)

3. **개발 환경**
   - iOS 개발: Xcode, CocoaPods
   - Android 개발: Android Studio

4. **Supabase 계정**
   - https://supabase.com 에서 무료 계정 생성

## 🚀 빠른 시작 (5단계)

### 1단계: 프로젝트 열기
VS Code 또는 선호하는 IDE에서 `Runners_high` 폴더를 엽니다.

### 2단계: Supabase 설정
1. [SUPABASE_SETUP.md](SUPABASE_SETUP.md) 문서를 열어 자세한 설정 확인
2. Supabase 프로젝트 생성
3. SQL Editor에서 데이터베이스 스키마 생성
4. API 키 복사

### 3단계: 환경 변수 설정
1. `.env.example` 파일을 복사하여 `.env` 파일 생성:
   ```bash
   copy .env.example .env
   ```

2. `.env` 파일을 열고 Supabase 정보 입력:
   ```env
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   ```

### 4단계: 의존성 설치
```bash
# Flutter 패키지 설치
flutter pub get

# iOS 의존성 설치 (Mac에서만)
cd ios
pod install
cd ..
```

### 5단계: 앱 실행

#### iPhone에서 실행 (Mac 필요)
```bash
# 연결된 디바이스 확인
flutter devices

# iOS 시뮬레이터에서 실행
flutter run -d ios

# 실제 iPhone에서 실행
flutter run -d [device-id]
```

#### Android에서 실행
```bash
# Android 에뮬레이터나 실제 디바이스에서 실행
flutter run -d android
```

## 🔧 추가 설정 (선택사항)

### iOS 전용 설정
자세한 내용은 [iOS_SETUP_GUIDE.md](iOS_SETUP_GUIDE.md) 참조

주요 사항:
- Xcode에서 Bundle ID 변경
- Apple Developer 계정으로 서명
- OAuth URL Scheme 설정

### 소셜 로그인 설정

#### Google 로그인
1. [Google Cloud Console](https://console.cloud.google.com/)에서 프로젝트 생성
2. OAuth 2.0 클라이언트 ID 생성
3. iOS/Android용 클라이언트 ID 각각 생성
4. Supabase에 클라이언트 정보 등록

#### 카카오 로그인
1. [Kakao Developers](https://developers.kakao.com/)에서 앱 생성
2. 플랫폼 설정 (iOS/Android)
3. REST API 키 발급
4. Redirect URI 설정

#### Facebook 로그인
1. [Facebook for Developers](https://developers.facebook.com/)에서 앱 생성
2. Facebook Login 제품 추가
3. iOS/Android 플랫폼 추가
4. App ID와 Secret 발급

## 📱 첫 실행 후 할 일

### 1. 회원가입 테스트
1. 앱 실행
2. "회원가입" 버튼 클릭
3. 이메일, 이름, 비밀번호 입력
4. 가입 완료

### 2. 관리자 계정 설정
첫 번째 사용자를 관리자로 설정하려면 Supabase SQL Editor에서 실행:
```sql
UPDATE profiles
SET is_admin = true
WHERE email = 'your-email@example.com';
```

### 3. 테스트 데이터 추가
관리자 계정으로 로그인 후:
1. 상단 오른쪽 관리자 아이콘 클릭
2. 대회 정보 또는 제품 등록
3. 메인 화면에서 확인

## ❓ 문제 해결

### "Supabase URL not found" 오류
- `.env` 파일이 존재하는지 확인
- `SUPABASE_URL`과 `SUPABASE_ANON_KEY`가 올바르게 설정되었는지 확인
- `flutter clean` 후 다시 실행

### iOS 빌드 오류
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

### Android 빌드 오류
```bash
flutter clean
flutter pub get
flutter run
```

### 로그인이 안 됨
- Supabase Authentication이 활성화되어 있는지 확인
- Email Auth가 켜져 있는지 확인
- 네트워크 연결 확인

### 이미지가 표시되지 않음
- 이미지 URL이 올바른지 확인
- Supabase Storage 권한 설정 확인
- 공개 이미지 URL인지 확인

## 📚 더 알아보기

- [README.md](README.md) - 프로젝트 전체 개요
- [SUPABASE_SETUP.md](SUPABASE_SETUP.md) - Supabase 상세 설정
- [iOS_SETUP_GUIDE.md](iOS_SETUP_GUIDE.md) - iOS 빌드 및 배포
- [Flutter 공식 문서](https://docs.flutter.dev/)
- [Supabase 공식 문서](https://supabase.com/docs)

## 🎯 다음 단계

앱이 성공적으로 실행되었다면:
1. UI/UX 커스터마이징
2. 추가 기능 구현
3. 성능 최적화
4. App Store / Play Store 배포 준비

## 💬 도움이 필요하신가요?

- Flutter 커뮤니티: https://flutter.dev/community
- Supabase Discord: https://discord.supabase.com
- GitHub Issues에서 문제 보고

즐거운 개발 되세요! 🏃‍♂️💨
