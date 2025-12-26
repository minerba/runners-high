import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  AuthService() {
    _initAuthListener();
  }

  void _initAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _loadUserProfile();
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      _currentUser = UserModel.fromJson(response);
      notifyListeners();
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  // 이메일/비밀번호 회원가입
  Future<String?> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user != null) {
        // 프로필 생성
        await _supabase.from('profiles').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
        });
      }

      return null; // 성공
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 이메일/비밀번호 로그인
  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return null; // 성공
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 구글 로그인
  Future<String?> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: 'YOUR_GOOGLE_CLIENT_ID', // Google Cloud Console에서 발급
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return '로그인이 취소되었습니다';
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        return '인증 토큰을 가져올 수 없습니다';
      }

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return null; // 성공
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 카카오 로그인 (추가 설정 필요)
  Future<String?> signInWithKakao() async {
    try {
      _isLoading = true;
      notifyListeners();

      // 카카오 SDK 사용
      // kakao_flutter_sdk_user 패키지 사용
      // 구현 예정
      
      return '카카오 로그인은 추가 설정이 필요합니다';
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 페이스북 로그인
  Future<String?> signInWithFacebook() async {
    try {
      _isLoading = true;
      notifyListeners();

      // flutter_facebook_auth 패키지 사용
      // 구현 예정
      
      return '페이스북 로그인은 추가 설정이 필요합니다';
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // 비밀번호 재설정
  Future<String?> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return null; // 성공
    } catch (e) {
      return e.toString();
    }
  }
}
