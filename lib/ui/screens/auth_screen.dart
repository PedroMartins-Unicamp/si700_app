import 'package:flutter/material.dart';

import '../../planejo_controller.dart';
import '../app_theme.dart';
import '../widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidden = true;
  bool _register = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _enter([String? email]) {
    PlanejoScope.of(context).enterDemo(email ?? 'gabriel@exemplo.com');
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Brand()),
    body: SafeArea(
      child: PageBody(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                _register ? 'Crie sua conta' : 'Entrar na sua conta',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Conheça seus lançamentos e metas em um só lugar.',
                style: TextStyle(color: AppTheme.muted),
              ),
              const SizedBox(height: 24),
              const Tag('Protótipo de interface'),
              const SizedBox(height: 12),
              const Text(
                'O acesso é simulado. Use dados fictícios; sua senha não é armazenada.',
                style: TextStyle(color: AppTheme.muted, fontSize: 12),
              ),
              const SizedBox(height: 20),
              const Text(
                'E-MAIL',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'voce@email.com',
                  prefixIcon: Icon(Icons.mail_outline, size: 20),
                ),
                validator: (value) =>
                    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                        .hasMatch(value?.trim() ?? '')
                    ? null
                    : 'Informe um e-mail válido.',
              ),
              const SizedBox(height: 18),
              const Text(
                'SENHA',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _password,
                obscureText: _hidden,
                decoration: InputDecoration(
                  hintText: 'Pelo menos 6 caracteres',
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  suffixIcon: IconButton(
                    tooltip: _hidden ? 'Mostrar senha' : 'Ocultar senha',
                    onPressed: () => setState(() => _hidden = !_hidden),
                    icon: Icon(
                      _hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                  ),
                ),
                validator: (value) => (value?.length ?? 0) >= 6
                    ? null
                    : 'Use pelo menos 6 caracteres.',
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _info(
                    'Recuperar senha',
                    'Na versão final, enviaremos um link de recuperação para o seu e-mail.',
                  ),
                  child: const Text('Esqueci a senha'),
                ),
              ),
              FilledButton(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    _enter(_email.text.trim());
                  }
                },
                child: Text(_register ? 'Criar conta' : 'Entrar'),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'ou continue com',
                      style: TextStyle(color: AppTheme.muted, fontSize: 12),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _providerInfo('Google'),
                      icon: const Text(
                        'G',
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      label: const Text('Google'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _providerInfo('Apple'),
                      icon: const Icon(Icons.apple, size: 21),
                      label: const Text('Apple'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _register = !_register),
                  child: Text(
                    _register
                        ? 'Já tem conta? Entre aqui'
                        : 'Não tem conta? Cadastre-se grátis',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _enter,
                icon: const Icon(Icons.explore_outlined),
                label: const Text('Explorar demonstração'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
  );

  void _providerInfo(String provider) => _info(
    'Entrar com $provider',
    'Na versão final, o Planejo permitirá entrar com sua conta $provider. Por enquanto, explore a demonstração.',
  );

  void _info(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }
}
