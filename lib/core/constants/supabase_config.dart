class SupabaseConfig {
  SupabaseConfig._();

  /// Supabase Project URL
  /// Injected at build time via: --dart-define=SUPABASE_URL=https://your-project.supabase.co
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  /// Supabase Anonymous / Publishable API Key
  /// Injected at build time via: --dart-define=SUPABASE_ANON_KEY=your-anon-key
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-publishable-key-here',
  );
}
