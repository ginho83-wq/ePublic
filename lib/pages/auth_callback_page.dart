import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  StreamSubscription<AuthState>? _subscription;

  @override
  void initState() {
    super.initState();

    _verificarSessao();

    _subscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
          final session = data.session;

          if (session != null && mounted) {
            context.go('/');
          }
        });
  }

  void _verificarSessao() {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/');
        }
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
