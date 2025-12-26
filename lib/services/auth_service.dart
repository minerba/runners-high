import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  SupabaseClient get _supabase => Supabase.instance.client;
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated {
    try {
      return _supabase.auth.currentUser != null;
    } catch (e) {
      debugPrint('Auth check error: $e');
      return false;
    }
  }

  AuthService() {
    _initAuthListener();
  }

  void _initAuthListener() {
    try {
      _supabase.auth.onAuthStateChange.listen((data) {
        final session = data.session;
        if (session != null) {
          _loadUserProfile();
        } else {
          _currentUser = null;
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint('Auth listener init error: $e');
    }
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

      // Supabase OAuth를 사용한 Google 로그인
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'https://magenta-vacherin-fd5593.netlify.app',
      );

      if (!response) {
        return '로그인이 취소되었습니다';
      }

      return null; // 성공
    } catch (e) {
      debugPrint('Google login error: $e');
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 카카오 로그인
  Future<String?> signInWithKakao() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Supabase OAuth를 사용한 Kakao 로그인
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.kakao,
        redirectTo: 'https://magenta-vacherin-fd5593.netlify.app',
      );

      if (!response) {
        return '로그인이 취소되었습니다';
      }

      return null; // 성공
    } catch (e) {
      debugPrint('Kakao login error: $e');
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

      // Supabase OAuth를 사용한 Facebook 로그인
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'https://magenta-vacherin-fd5593.netlify.app',
      );

      if (!response) {
        return '로그인이 취소되었습니다';
      }

      return null; // 성공
    } catch (e) {
      debugPrint('Facebook login error: $e');
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
