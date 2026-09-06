import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final autenticado = user != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Epublic'),
        actions: [
          TextButton(
            onPressed: () {
              context.push('/acervo');
            },
            child: const Text('Acervo'),
          ),
          const SizedBox(width: 8),

          if (autenticado)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'logout') {
                  await Supabase.instance.client.auth.signOut();

                  if (context.mounted) {
                    context.go('/');
                  }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'logout',
                    child: Text('Sair'),
                  ),
                ];
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: Text(
                    user.email ?? 'Utilizador',
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Entrar'),
            ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Epublic',
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              const SizedBox(height: 12),

              const Text(
                'Encontre conhecimento.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: 600,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Pesquisar...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'Obras recentes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
