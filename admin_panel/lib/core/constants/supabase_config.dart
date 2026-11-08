class SupabaseConfig {
  SupabaseConfig._();

  /// Supabase Project URL
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://ermftqdpmbwzoykfpfpo.supabase.co',
  );

  /// Supabase Anonymous / Publishable API Key
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_YfZmLiXUhkO2fqu1_utxkw_5sO9XDfB',
  );
}
