import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/auth_callback_page.dart';
import '../pages/cadastro_page.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),

  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final logado = session != null;

    final location = state.matchedLocation;

    final estaNoInicio = location == '/';
    final estaNoLogin = location == '/login';
    final estaNoCadastro = location == '/cadastro';
    final estaNoCallback = location == '/auth/callback';

    // ---------------------------------------------------------
    // CALLBACK DO GOOGLE
    // ---------------------------------------------------------
    // O callback precisa ser acessível para que o Supabase
    // consiga concluir o login com Google.
    if (estaNoCallback) {
      return null;
    }

    // ---------------------------------------------------------
    // UTILIZADOR NÃO AUTENTICADO
    // ---------------------------------------------------------
    if (!logado) {
      // A raiz "/" será a tela de Login.
      if (estaNoInicio) {
        return null;
      }

      // Permite acessar a tela de login.
      if (estaNoLogin) {
        return null;
      }

      // Permite acessar a tela de cadastro.
      if (estaNoCadastro) {
        return null;
      }

      // Qualquer outra rota exige login.
      return '/';
    }

    // ---------------------------------------------------------
    // UTILIZADOR AUTENTICADO
    // ---------------------------------------------------------
    // Depois de autenticado, "/" mostra o Home.
    if (estaNoInicio) {
      return null;
    }

    // Se estiver no Login ou Cadastro depois de autenticar,
    // manda para o Home.
    if (estaNoLogin || estaNoCadastro) {
      return '/';
    }

    return null;
  },

  routes: [
    // =========================================================
    // ROTA PRINCIPAL
    // =========================================================
    GoRoute(
      path: '/',
      builder: (context, state) {
        final session =
            Supabase.instance.client.auth.currentSession;

        // Sem sessão = Login
        if (session == null) {
          return const LoginPage();
        }

        // Com sessão = Home
        return const HomePage();
      },
    ),

    // =========================================================
    // LOGIN
    // =========================================================
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),

    // =========================================================
    // CADASTRO
    // =========================================================
    GoRoute(
      path: '/cadastro',
      builder: (context, state) {
        return const CadastroPage();
      },
    ),

    // =========================================================
    // CALLBACK GOOGLE
    // =========================================================
    GoRoute(
      path: '/auth/callback',
      builder: (context, state) {
        return const AuthCallbackPage();
      },
    ),

    // =========================================================
    // ACERVO
    // =========================================================
    GoRoute(
      path: '/acervo',
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: Text('Acervo'),
          ),
        );
      },
    ),
  ],
);

// =============================================================
// ATUALIZA O GOROUTER QUANDO O ESTADO DE AUTENTICAÇÃO MUDA
// =============================================================

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
          (_) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

