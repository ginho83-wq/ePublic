import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final SupabaseClient _supabase = Supabase.instance.client;

  User? get usuarioAtual => _supabase.auth.currentUser;

  Session? get sessaoAtual => _supabase.auth.currentSession;

  bool get estaAutenticado => usuarioAtual != null;

  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }

  Future<AuthResponse> loginComEmail({
    required String email,
    required String senha,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: senha,
    );
  }

  Future<AuthResponse> cadastrar({
    required String email,
    required String senha,
  }) async {
    return await _supabase.auth.signUp(
      email: email.trim(),
      password: senha,
    );
  }

  Future<bool> loginComGoogle() async {
    final response = await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'http://localhost:8080/auth/callback',
    );

    return response;
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
