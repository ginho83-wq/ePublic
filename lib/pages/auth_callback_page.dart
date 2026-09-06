import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() =>
      _AuthCallbackPageState();
}

class _AuthCallbackPageState
    extends State<AuthCallbackPage> {
  StreamSubscription<AuthState>? _subscription;

  bool _processando = true;
  bool _redirecionando = false;

  @override
  void initState() {
    super.initState();

    _inicializarCallback();
  }

  Future<void> _inicializarCallback() async {
    final supabase = Supabase.instance.client;

    // =====================================================
    // ESCUTAR ALTERAÇÕES DE AUTENTICAÇÃO
    // =====================================================

    _subscription =
        supabase.auth.onAuthStateChange.listen(
              (AuthState data) {
            final session = data.session;

            if (session != null) {
              _irParaHome();
            }
          },
        );

    // =====================================================
    // VERIFICAR SE JÁ EXISTE UMA SESSÃO
    // =====================================================

    final sessaoAtual =
        supabase.auth.currentSession;

    if (sessaoAtual != null) {
      _irParaHome();
      return;
    }

    // =====================================================
    // DAR TEMPO PARA O SUPABASE PROCESSAR O CALLBACK
    // =====================================================

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted || _redirecionando) {
      return;
    }

    // =====================================================
    // VERIFICAR NOVAMENTE A SESSÃO
    // =====================================================

    final sessaoDepois =
        supabase.auth.currentSession;

    if (sessaoDepois != null) {
      _irParaHome();
    } else {
      _irParaLogin();
    }
  }

  // =======================================================
  // IR PARA HOME
  // =======================================================

  void _irParaHome() {
    if (!mounted || _redirecionando) {
      return;
    }

    _redirecionando = true;

    setState(() {
      _processando = false;
    });

    context.go('/');
  }

  // =======================================================
  // IR PARA LOGIN
  // =======================================================

  void _irParaLogin() {
    if (!mounted || _redirecionando) {
      return;
    }

    _redirecionando = true;

    setState(() {
      _processando = false;
    });

    context.go('/login');
  }

  // =======================================================
  // DISPOSE
  // =======================================================

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // =======================================================
  // INTERFACE
  // =======================================================

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'A confirmar a sua conta...',
            ),
          ],
        ),
      ),
    );
  }
}

