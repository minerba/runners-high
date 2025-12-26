# 🔐 소셜 로그인 설정 가이드

## 📋 목차
1. [구글 로그인](#1-구글-로그인)
2. [카카오 로그인](#2-카카오-로그인)
3. [페이스북 로그인](#3-페이스북-로그인)

---

## 1. 구글 로그인

### Step 1: Google Cloud Console 설정

1. **Google Cloud Console 접속**
   - https://console.cloud.google.com/ 방문
   - Google 계정으로 로그인

2. **새 프로젝트 생성**
   - "프로젝트 선택" → "새 프로젝트"
   - 프로젝트 이름: `Runners High`

3. **OAuth 동의 화면 설정**
   - 좌측 메뉴 → "API 및 서비스" → "OAuth 동의 화면"
   - 사용자 유형: **외부** 선택
   - 앱 이름: `Runners High`
   - 사용자 지원 이메일: 본인 이메일
   - 개발자 연락처: 본인 이메일
   - "저장 후 계속"

4. **사용자 인증 정보 만들기**
   - 좌측 메뉴 → "사용자 인증 정보"
   - "+ 사용자 인증 정보 만들기" → "OAuth 클라이언트 ID"
   - 애플리케이션 유형: **웹 애플리케이션**
   - 이름: `Runners High Web`
   - 승인된 자바스크립트 원본:
     ```
     https://magenta-vacherin-fd5593.netlify.app
     http://localhost:53295
     ```
   - 승인된 리디렉션 URI:
     ```
     https://fvsopfpucczexsbeaods.supabase.co/auth/v1/callback
     ```
   - "만들기" 클릭

5. **클라이언트 ID와 Secret 복사**
   - 생성된 클라이언트 ID와 클라이언트 보안 비밀번호 복사

### Step 2: Supabase 설정

1. **Supabase Dashboard 접속**
   - https://supabase.com/dashboard
   - 프로젝트 선택

2. **Google Provider 활성화**
   - 좌측 메뉴 → "Authentication" → "Providers"
   - "Google" 찾아서 클릭
   - "Enable Google provider" 토글 켜기
   - Client ID: (Step 1에서 복사한 것)
   - Client Secret: (Step 1에서 복사한 것)
   - "Save" 클릭

✅ **완료!** 이제 구글 로그인이 작동합니다!

---

## 2. 카카오 로그인

### Step 1: Kakao Developers 설정

1. **Kakao Developers 가입**
   - https://developers.kakao.com/ 방문
   - 카카오 계정으로 로그인

2. **애플리케이션 추가**
   - "내 애플리케이션" → "애플리케이션 추가하기"
   - 앱 이름: `Runners High`
   - 사업자명: 본인 이름
   - "저장" 클릭

3. **앱 키 확인**
   - 생성된 앱 클릭
   - "요약 정보"에서 **REST API 키** 복사

4. **플랫폼 설정**
   - 좌측 메뉴 → "플랫폼"
   - "Web 플랫폼 등록"
   - 사이트 도메인:
     ```
     https://magenta-vacherin-fd5593.netlify.app
     http://localhost:53295
     ```

5. **Redirect URI 설정**
   - 좌측 메뉴 → "카카오 로그인" → "활성화 설정" ON
   - "Redirect URI" → "Redirect URI 등록"
   - URI 추가:
     ```
     https://fvsopfpucczexsbeaods.supabase.co/auth/v1/callback
     ```

6. **동의항목 설정**
   - 좌측 메뉴 → "동의항목"
   - "닉네임" - 필수 동의
   - "카카오계정(이메일)" - 필수 동의

### Step 2: Supabase에 카카오 설정

카카오는 Supabase에서 직접 지원하지 않으므로, 코드에서 직접 처리해야 합니다.
아래 환경 변수를 Netlify에 추가하세요:

```
KAKAO_REST_API_KEY=<복사한 REST API 키>
```

✅ **완료!** 카카오 로그인 준비 완료!

---

## 3. 페이스북 로그인

### Step 1: Facebook Developer 설정

1. **Meta for Developers 가입**
   - https://developers.facebook.com/ 방문
   - Facebook 계정으로 로그인

2. **앱 만들기**
   - "내 앱" → "앱 만들기"
   - 사용 사례: "소비자"
   - 앱 유형: "비즈니스"
   - 앱 이름: `Runners High`
   - 앱 연락처 이메일: 본인 이메일
   - "앱 만들기" 클릭

3. **Facebook 로그인 제품 추가**
   - 대시보드에서 "Facebook 로그인" 제품 추가
   - 플랫폼: **웹** 선택
   - 사이트 URL: `https://magenta-vacherin-fd5593.netlify.app`

4. **OAuth 리디렉션 URI 설정**
   - 좌측 메뉴 → "Facebook 로그인" → "설정"
   - "유효한 OAuth 리디렉션 URI"에 추가:
     ```
     https://fvsopfpucczexsbeaods.supabase.co/auth/v1/callback
     ```
   - "변경 내용 저장"

5. **앱 ID와 Secret 확인**
   - 좌측 메뉴 → "설정" → "기본 설정"
   - **앱 ID** 복사
   - **앱 시크릿 코드** → "표시" 클릭 후 복사

6. **앱 모드 전환 (중요!)**
   - 상단의 앱 모드를 "개발 모드"에서 **"라이브 모드"**로 전환
   - (실제 사용자가 로그인하려면 라이브 모드여야 함)

### Step 2: Supabase 설정

1. **Supabase Dashboard 접속**
   - Authentication → Providers → "Facebook" 클릭

2. **Facebook Provider 활성화**
   - "Enable Facebook provider" 토글 켜기
   - Facebook Client ID: (Step 1에서 복사한 앱 ID)
   - Facebook Client Secret: (Step 1에서 복사한 시크릿 코드)
   - "Save" 클릭

✅ **완료!** 페이스북 로그인이 작동합니다!

---

## 🚀 최종 확인

### 1. Netlify 환경 변수 설정
Netlify Dashboard → Site settings → Environment variables에 추가:

```
KAKAO_REST_API_KEY=<카카오 REST API 키>
```

### 2. 코드 배포
모든 설정이 완료되면 자동으로 작동합니다!

### 3. 테스트
1. 앱에서 "Google로 로그인" 클릭 → Google 로그인 팝업
2. "카카오로 로그인" 클릭 → 카카오 로그인 페이지
3. "Facebook으로 로그인" 클릭 → Facebook 로그인 팝업

---

## ⚠️ 주의사항

1. **개발 모드 vs 라이브 모드**
   - 실제 사용자가 로그인하려면 모든 앱이 "라이브/프로덕션" 모드여야 합니다

2. **도메인 확인**
   - 모든 OAuth 설정에서 정확한 도메인을 사용하세요
   - Netlify URL: `https://magenta-vacherin-fd5593.netlify.app`
   - Supabase URL: `https://fvsopfpucczexsbeaods.supabase.co`

3. **HTTPS 필수**
   - 프로덕션 환경에서는 HTTPS가 필수입니다 (Netlify는 자동으로 제공)

---

## 🆘 문제 해결

### "redirect_uri_mismatch" 오류
→ OAuth 설정에서 Redirect URI가 정확한지 확인

### "invalid_client" 오류
→ Client ID와 Secret이 올바른지 확인

### 카카오 로그인 안 됨
→ 카카오 앱이 "서비스 ON" 상태인지 확인

### 페이스북 로그인 안 됨
→ 앱이 "라이브 모드"인지 확인
