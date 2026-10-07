import 'package:flutter/material.dart';

import '../../planejo_controller.dart';
import '../app_theme.dart';
import '../widgets.dart';
import 'premium_screen.dart';
import 'reports_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.onHome});
  final VoidCallback onHome;
  @override
  Widget build(BuildContext context) => Builder(
    builder: (context) {
      final state = PlanejoScope.of(context);
      final user = state.user;
      if (user == null) return const SizedBox.shrink();
      return PageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meu perfil', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Surface(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFFDDF4EC),
                    child: Icon(
                      Icons.person_outline,
                      color: AppTheme.green,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Tag(user.isDemo ? 'Conta de demonstração' : 'Conta pessoal'),
            const SizedBox(height: 16),
            Text(
              user.isDemo
                  ? 'Este protótipo usa dados de exemplo. Suas alterações ficam disponíveis enquanto o aplicativo estiver aberto.'
                  : 'Interface demonstrativa do Planejo.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            Surface(
              padding: 0,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.bar_chart_outlined,
                      color: AppTheme.green,
                    ),
                    title: const Text('Meus relatórios'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const ReportsScreen(),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.workspace_premium_outlined,
                      color: AppTheme.green,
                    ),
                    title: const Text('Conheça o Premium'),
                    subtitle: const Text('Veja a demonstração do plano'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final goHome = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PremiumScreen(),
                        ),
                      );
                      if (goHome == true) onHome();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            OutlinedButton.icon(
              onPressed: () {
                state.signOut();
                onHome();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair da conta'),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Planejo · Seu futuro começa com um plano.',
                style: TextStyle(color: AppTheme.muted, fontSize: 11),
              ),
            ),
          ],
        ),
      );
    },
  );
}
