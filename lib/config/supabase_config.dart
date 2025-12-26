class SupabaseConfig {
  // Netlify 환경 변수에서 읽어오거나 기본값 사용
  static String get supabaseUrl => 
      const String.fromEnvironment('SUPABASE_URL', 
        defaultValue: 'https://fvsopfpucczexsbeaods.supabase.co');
  
  static String get supabaseAnonKey => 
      const String.fromEnvironment('SUPABASE_ANON_KEY',
        defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2c29wZnB1Y2N6ZXhzYmVhb2RzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY3NDcwMzAsImV4cCI6MjA4MjMyMzAzMH0.IU5pXrk4YZ5DtvnlhRI2tWDU02dg050VYz0hk69uXKk');
}
