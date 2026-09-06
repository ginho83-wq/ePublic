import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final email = _emailController.text.trim();
      final senha = _senhaController.text;

      // =====================================================
      // URL PARA ONDE O SUPABASE VOLTA APÓS A CONFIRMAÇÃO
      // =====================================================
      final redirectUrl = '${Uri.base.origin}/auth/callback';

      final response =
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: senha,
        emailRedirectTo: redirectUrl,
      );

      if (!mounted) return;

      // =====================================================
      // SE JÁ EXISTIR SESSÃO
      // =====================================================

      if (response.session != null) {
        context.go('/');
        return;
      }

      // =====================================================
      // CONFIRMAÇÃO DE E-MAIL NECESSÁRIA
      // =====================================================

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A conta foi criada. '
                'Verifique o seu e-mail e confirme a sua conta.',
          ),
          duration: Duration(seconds: 5),
        ),
      );

      context.go('/login');
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro ao criar a conta. Tente novamente.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Criar conta no Epublic',
                    style:
                    Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 30),

                  // =================================================
                  // E-MAIL
                  // =================================================

                  TextFormField(
                    controller: _emailController,
                    keyboardType:
                    TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Digite o seu e-mail';
                      }

                      if (!value.contains('@')) {
                        return 'Digite um e-mail válido';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // PALAVRA-PASSE
                  // =================================================

                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Palavra-passe',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite uma palavra-passe';
                      }

                      if (value.length < 6) {
                        return 'Use pelo menos 6 caracteres';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // CONFIRMAR PALAVRA-PASSE
                  // =================================================

                  TextFormField(
                    controller:
                    _confirmarSenhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText:
                      'Confirmar palavra-passe',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme a palavra-passe';
                      }

                      if (value != _senhaController.text) {
                        return 'As palavras-passe não coincidem';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // BOTÃO CRIAR CONTA
                  // =================================================

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed:
                      _carregando ? null : _cadastrar,
                      child: _carregando
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                        CircularProgressIndicator(),
                      )
                          : const Text('Criar conta'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // VOLTAR PARA LOGIN
                  // =================================================

                  TextButton(
                    onPressed: _carregando
                        ? null
                        : () {
                      context.go('/login');
                    },
                    child: const Text(
                      'Já tenho uma conta',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

