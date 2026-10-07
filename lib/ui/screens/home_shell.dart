import 'package:flutter/material.dart';

import '../../models.dart';
import '../../planejo_controller.dart';
import '../app_theme.dart';
import '../widgets.dart';
import 'auth_screen.dart';
import 'entry_screen.dart';
import 'transactions_screen.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';
import 'reports_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;

  Future<bool> _authenticate() async {
    if (PlanejoScope.of(context).user != null) return true;
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        ) ??
        false;
  }

  Future<void> _select(int index) async {
    if (index != 0 && !await _authenticate()) return;
    if (mounted) setState(() => _tab = index);
  }

  Future<void> _addEntry() async {
    if (!await _authenticate() || !mounted) return;
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const EntryScreen()),
    );
    if (saved == true && mounted) {
      setState(() => _tab = 1);
      showMessage(context, 'Lançamento salvo com sucesso!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = PlanejoScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: switch (_tab) {
          1 => TransactionsScreen(onAdd: _addEntry),
          2 => const GoalsScreen(),
          3 => ProfileScreen(onHome: () => setState(() => _tab = 0)),
          _ => _home(state),
        },
      ),
      floatingActionButton: _tab <= 1
          ? FloatingActionButton(
              onPressed: _addEntry,
              tooltip: 'Novo lançamento',
              backgroundColor: AppTheme.green,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add, size: 30),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.green,
        unselectedItemColor: AppTheme.muted,
        backgroundColor: Colors.white,
        onTap: _select,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Lançamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_outlined),
            activeIcon: Icon(Icons.flag),
            label: 'Metas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _home(PlanejoController state) {
    final guest = state.user == null;
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Brand(),
              if (guest)
                OutlinedButton(
                  onPressed: _authenticate,
                  child: const Text('Entrar'),
                )
              else
                IconButton(
                  tooltip: 'Meu perfil',
                  onPressed: () => _select(3),
                  icon: const CircleAvatar(
                    radius: 17,
                    backgroundColor: Color(0xFFDDF4EC),
                    child: Icon(
                      Icons.person_outline,
                      color: AppTheme.green,
                      size: 21,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Tag(
            guest
                ? 'Sem cadastro para explorar'
                : state.user!.isDemo
                ? 'Modo demonstração'
                : 'Seu dinheiro, no seu controle',
          ),
          const SizedBox(height: 10),
          Text(
            guest
                ? 'Organize seu dinheiro\nsem complicação'
                : 'Olá, ${state.user!.name}!\nVamos planejar?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          const Text(
            'Acompanhe gastos, crie metas e veja para onde seu dinheiro vai — tudo em um só lugar.',
            style: TextStyle(color: AppTheme.muted, fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 22),
          SummaryCard(
            entries: guest ? exampleEntries() : state.data.entries,
            month: DateTime.now(),
            example: guest,
          ),
          const SizedBox(height: 18),
          const Text(
            'O que você pode fazer',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _feature(
                  constraints.maxWidth,
                  Icons.payments_outlined,
                  'Registrar gastos',
                  'Em segundos',
                  const Color(0xFFDFF5ED),
                  _addEntry,
                ),
                _feature(
                  constraints.maxWidth,
                  Icons.track_changes,
                  'Criar metas',
                  'Junte dinheiro',
                  const Color(0xFFE8ECFF),
                  () => _select(2),
                ),
                _feature(
                  constraints.maxWidth,
                  Icons.bar_chart_rounded,
                  'Relatórios',
                  'Veja padrões',
                  const Color(0xFFFFF0D9),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReportsScreen()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          Surface(
            padding: 16,
            color: const Color(0xFFF0FBF7),
            borderColor: const Color(0xFFBCE6D8),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFFE1AD1C),
                  size: 30,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dica do dia',
                        style: TextStyle(
                          color: AppTheme.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Reserve 20% da renda antes de gastar. Seu “eu do futuro” agradece.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _feature(
    double width,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) => SizedBox(
    width: width < 290 ? width : (width - 20) / 3,
    child: Semantics(
      button: true,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.line),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 23, color: AppTheme.green),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: AppTheme.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
