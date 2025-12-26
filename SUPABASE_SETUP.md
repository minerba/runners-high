# Supabase 데이터베이스 설정 가이드

## 1. Supabase 프로젝트 생성

1. [Supabase](https://supabase.com)에 로그인
2. "New Project" 클릭
3. 프로젝트 이름, 데이터베이스 비밀번호, 리전 설정
4. 프로젝트 생성 완료

## 2. API 키 확인

1. 프로젝트 대시보드의 Settings > API
2. `Project URL`과 `anon public` 키 복사
3. `.env` 파일에 저장:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

## 3. 데이터베이스 스키마 생성

SQL Editor에서 다음 SQL 실행:

```sql
-- UUID 확장 활성화
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 프로필 테이블
CREATE TABLE profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  is_admin BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
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
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스 생성
CREATE INDEX events_created_at_idx ON events(created_at DESC);
CREATE INDEX events_event_date_idx ON events(event_date DESC);
CREATE INDEX products_created_at_idx ON products(created_at DESC);
CREATE INDEX products_is_featured_idx ON products(is_featured);

-- Row Level Security (RLS) 활성화
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Profiles 정책
CREATE POLICY "프로필은 누구나 조회 가능"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "사용자는 자신의 프로필 수정 가능"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "사용자는 자신의 프로필 삽입 가능"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Events 정책
CREATE POLICY "대회 정보는 누구나 조회 가능"
  ON events FOR SELECT
  USING (true);

CREATE POLICY "관리자만 대회 정보 추가 가능"
  ON events FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );

CREATE POLICY "관리자만 대회 정보 수정 가능"
  ON events FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );

CREATE POLICY "관리자만 대회 정보 삭제 가능"
  ON events FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );

-- Products 정책
CREATE POLICY "제품 정보는 누구나 조회 가능"
  ON products FOR SELECT
  USING (true);

CREATE POLICY "관리자만 제품 추가 가능"
  ON products FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );

CREATE POLICY "관리자만 제품 수정 가능"
  ON products FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );

CREATE POLICY "관리자만 제품 삭제 가능"
  ON products FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );

-- 자동 타임스탬프 업데이트 함수
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at
  BEFORE UPDATE ON events
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at
  BEFORE UPDATE ON products
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- 회원가입 시 프로필 자동 생성 함수
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 회원가입 트리거
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();
```

## 4. 테스트 데이터 삽입 (선택사항)

```sql
-- 테스트 이벤트
INSERT INTO events (title, description, event_url, event_date) VALUES
('2024 서울 마라톤 대회', '서울 한강공원에서 개최되는 마라톤 대회입니다.', 'https://example.com/event1', '2024-04-15 09:00:00+09'),
('춘천 마라톤 축제', '춘천 의암호를 달리는 아름다운 코스', 'https://example.com/event2', '2024-05-20 08:00:00+09');

-- 테스트 제품
INSERT INTO products (name, description, price, is_featured) VALUES
('나이키 줌 플라이', '마라톤 전용 런닝화', 189000, true),
('아디다스 울트라부스트', '편안한 쿠셔닝의 런닝화', 220000, true),
('런닝 암밴드', '스마트폰 고정용 암밴드', 25000, false);
```

## 5. Storage 설정 (이미지 업로드용)

1. Storage 섹션으로 이동
2. New Bucket 클릭
3. 이름: `event-images` (공개 버킷)
4. 정책 설정:
   - SELECT: 누구나 가능
   - INSERT: 인증된 사용자
   - UPDATE: 인증된 사용자
   - DELETE: 관리자만

## 6. Authentication 설정

### 이메일 인증
1. Authentication > Settings
2. Email Auth 활성화
3. Confirm email 설정 (선택)

### OAuth 제공자 설정

#### Google
1. Authentication > Providers > Google
2. Enable 체크
3. Google Cloud Console에서 OAuth 클라이언트 ID 생성
4. Client ID와 Secret 입력
5. Redirect URL: `https://your-project.supabase.co/auth/v1/callback`

#### 카카오
1. Authentication > Providers에서 Custom 추가
2. [Kakao Developers](https://developers.kakao.com/)에서 REST API 키 발급
3. 리다이렉트 URI 설정

#### Facebook
1. Authentication > Providers > Facebook
2. [Facebook Developers](https://developers.facebook.com/)에서 앱 생성
3. App ID와 Secret 입력

## 7. 관리자 계정 설정

첫 사용자를 관리자로 설정:

```sql
-- 회원가입 후 해당 사용자의 ID로 업데이트
UPDATE profiles
SET is_admin = true
WHERE email = 'admin@example.com';
```

## 8. 보안 설정

1. Database > Settings에서 SSL 연결 활성화
2. RLS 정책 확인
3. API 키는 환경 변수로 관리
4. `.env` 파일을 `.gitignore`에 추가

## 9. 모니터링

- Logs 섹션에서 API 요청 모니터링
- Database > Query Performance에서 성능 확인
- Auth > Users에서 사용자 관리

## 10. 백업

- Database > Backups에서 자동 백업 설정
- 정기적으로 데이터 백업 수행

## 문제 해결

### RLS 정책 테스트
```sql
-- 현재 사용자 확인
SELECT auth.uid();

-- 프로필 조회 테스트
SELECT * FROM profiles WHERE id = auth.uid();
```

### 연결 문제
- Supabase URL과 API 키 확인
- 네트워크 방화벽 설정 확인
- Supabase 프로젝트 상태 확인

## 참고 자료

- [Supabase 공식 문서](https://supabase.com/docs)
- [PostgreSQL 문서](https://www.postgresql.org/docs/)
- [Row Level Security 가이드](https://supabase.com/docs/guides/auth/row-level-security)
