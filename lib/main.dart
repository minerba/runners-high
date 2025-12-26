import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/supabase_config.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Supabase 초기화
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
    
    runApp(const MyApp());
  } catch (e) {
    // 초기화 실패 시 에러 앱 표시
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 80, color: Colors.red),
                const SizedBox(height: 24),
                const Text(
                  '앱을 시작할 수 없습니다',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  '에러: $e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // 페이지 새로고침
                    // ignore: avoid_web_libraries_in_flutter
                    // html.window.location.reload();
                  },
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: '달려라 방방',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00D9FF),
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.notoSansTextTheme(),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        
        final session = snapshot.data?.session;
        
        if (session != null) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
