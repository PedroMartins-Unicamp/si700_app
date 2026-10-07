import 'package:flutter/material.dart';

import '../../planejo_controller.dart';
import '../app_theme.dart';
import '../widgets.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Brand()),
    body: SafeArea(
      child: PageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Tag('Planejo Premium'),
            const SizedBox(height: 20),
            Text(
              'Mais espaço para\nseus planos.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            const Text(
              'Conheça o plano apresentado no projeto do Planejo.',
              style: TextStyle(color: AppTheme.muted),
            ),
            const SizedBox(height: 26),
            const Surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.insights, color: AppTheme.green),
                    title: Text('Relatórios ilimitados'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.flag_outlined, color: AppTheme.green),
                    title: Text('Mais metas de economia'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.file_download_outlined,
                      color: AppTheme.green,
                    ),
                    title: Text('Exportação de dados'),
                  ),
                  Divider(),
                  Text(
                    'R\$ 99,90 / ano',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Recursos propostos para o plano futuro.',
                    style: TextStyle(color: AppTheme.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                final goHome = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const ConfirmationScreen()),
                );
                if (goHome == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Simular assinatura'),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Demonstração sem cobrança ou contratação.',
                style: TextStyle(color: AppTheme.muted, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = PlanejoScope.of(context).user;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: PageBody(
          padding: 30,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.green, Color(0xFF08A6AA)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.green.withValues(alpha: .25),
                      blurRadius: 35,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Obrigado, ${user?.name ?? 'visitante'}!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.favorite,
                    color: Color(0xFF3284CF),
                    size: 27,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Sua simulação do Premium foi concluída.\nObrigado por conhecer o Planejo!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.muted, height: 1.7),
              ),
              const SizedBox(height: 30),
              const Surface(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Plano Premium · Anual',
                            style: TextStyle(
                              color: AppTheme.muted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Tag('Simulado'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total ilustrativo',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'R\$ 99,90',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Divider(height: 28),
                    Text(
                      'Nenhuma cobrança foi realizada. Este é um recibo de demonstração.',
                      style: TextStyle(color: AppTheme.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Voltar ao início'),
              ),
              TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Plano Premium · Anual'),
                    content: const Text(
                      'Valor proposto: R\$ 99,90 por ano. Inclui relatórios ilimitados, metas e exportação de dados. Esta simulação não ativa uma assinatura.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fechar'),
                      ),
                    ],
                  ),
                ),
                child: const Text('Ver detalhes do meu plano'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
