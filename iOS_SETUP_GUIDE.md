# iOS 설정 가이드

## 1. 환경 설정

### 필수 요구사항
- macOS
- Xcode 14.0 이상
- CocoaPods
- Flutter SDK

## 2. 프로젝트 설정

### CocoaPods 설치 (미설치 시)
```bash
sudo gem install cocoapods
```

### iOS 의존성 설치
```bash
cd ios
pod install
cd ..
```

## 3. Xcode 설정

### 번들 ID 변경
1. `ios/Runner.xcworkspace`를 Xcode로 열기
2. Runner 프로젝트 선택
3. General 탭에서 Bundle Identifier 변경
   - 예: `com.yourcompany.runnershigh`

### 서명 설정
1. Signing & Capabilities 탭
2. Team 선택 (Apple Developer 계정 필요)
3. Automatically manage signing 체크

### 최소 배포 타겟
- iOS 12.0 이상으로 설정

## 4. 권한 설정

`ios/Runner/Info.plist`에 다음 권한 추가:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>런닝 기록을 위해 위치 정보가 필요합니다</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>백그라운드에서 런닝 기록을 위해 위치 정보가 필요합니다</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>프로필 사진 업로드를 위해 사진 라이브러리 접근이 필요합니다</string>

<key>NSCameraUsageDescription</key>
<string>프로필 사진 촬영을 위해 카메라 접근이 필요합니다</string>
```

## 5. OAuth 설정

### Google 로그인
1. Google Cloud Console에서 iOS OAuth 클라이언트 ID 생성
2. `ios/Runner/Info.plist`에 URL Scheme 추가:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
    </array>
  </dict>
</array>
```

### 카카오 로그인
1. [Kakao Developers](https://developers.kakao.com/)에서 iOS 앱 등록
2. Native App Key 발급
3. `ios/Runner/Info.plist`에 추가:
```xml
<key>KAKAO_APP_KEY</key>
<string>YOUR_NATIVE_APP_KEY</string>

<key>LSApplicationQueriesSchemes</key>
<array>
  <string>kakaokompassauth</string>
  <string>kakaolink</string>
</array>

<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>kakao${KAKAO_APP_KEY}</string>
    </array>
  </dict>
</array>
```

## 6. 실행 및 테스트

### 시뮬레이터에서 실행
```bash
flutter run -d ios
```

### 실제 디바이스에서 실행
1. iPhone을 Mac에 연결
2. Xcode에서 디바이스 선택
3. 실행:
```bash
flutter run -d [device-id]
```

### 디바이스 목록 확인
```bash
flutter devices
```

## 7. 빌드

### Debug 빌드
```bash
flutter build ios --debug
```

### Release 빌드
```bash
flutter build ios --release
```

## 8. 문제 해결

### Pod install 오류
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install --repo-update
cd ..
```

### 빌드 오류
```bash
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter build ios
```

### CocoaPods 버전 업데이트
```bash
sudo gem install cocoapods
```

## 9. 배포 준비

### App Store Connect 설정
1. [App Store Connect](https://appstoreconnect.apple.com/) 접속
2. 새 앱 생성
3. 번들 ID 등록

### 아카이브 생성
1. Xcode에서 Product > Archive
2. Organizer에서 Distribute App
3. App Store Connect에 업로드

### TestFlight 베타 테스트
1. App Store Connect에서 TestFlight 탭
2. 내부/외부 테스터 추가
3. 빌드 제출

## 10. 주의사항

- Apple Developer 계정이 필요합니다 (연간 $99)
- 실제 디바이스 테스트를 위해서는 유료 계정 필요
- 소셜 로그인은 각 플랫폼별 개발자 등록 필요
- App Store 심사 가이드라인 준수 필요

## 추가 참고 자료

- [Flutter iOS 배포 가이드](https://docs.flutter.dev/deployment/ios)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Supabase iOS 가이드](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)
