import 'package:flutter/material.dart';

import '../../models.dart';
import '../../planejo_controller.dart';
import '../app_theme.dart';
import '../formatters.dart';
import '../widgets.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = PlanejoScope.of(context);
    return PageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Minhas metas', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text(
            'Um passo de cada vez para realizar seus planos.',
            style: TextStyle(color: AppTheme.muted),
          ),
          const SizedBox(height: 24),
          if (state.data.goals.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Surface(
                child: Text(
                  'Você ainda não tem metas. Que tal começar sua reserva?',
                ),
              ),
            ),
          for (var i = 0; i < state.data.goals.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _goal(context, state.data.goals[i], i),
            ),
          FilledButton.icon(
            onPressed: () => _edit(context),
            icon: const Icon(Icons.add),
            label: const Text('Criar meta'),
          ),
        ],
      ),
    );
  }

  Future<void> _edit(
    BuildContext context, [
    SavingsGoal? goal,
    int? index,
  ]) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => GoalEditScreen(goal: goal, index: index),
      ),
    );
    if (saved == true && context.mounted) {
      showMessage(context, 'Meta salva com sucesso!');
    }
  }

  Widget _goal(BuildContext context, SavingsGoal goal, int index) => Surface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.track_changes, color: AppTheme.green, size: 32),
        const SizedBox(height: 12),
        Text(goal.name, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 14),
        LinearProgressIndicator(
          value: (goal.saved / goal.target).clamp(0, 1),
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: AppTheme.line,
        ),
        const SizedBox(height: 10),
        Text(
          '${money(goal.saved)} de ${money(goal.target)}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          goal.saved >= goal.target
              ? 'Meta alcançada! Parabéns.'
              : '${(goal.saved / goal.target * 100).round()}% do caminho',
          style: const TextStyle(color: AppTheme.muted, fontSize: 12),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => _edit(context, goal, index),
            child: const Text('Atualizar meta'),
          ),
        ),
      ],
    ),
  );
}

class GoalEditScreen extends StatefulWidget {
  const GoalEditScreen({super.key, this.goal, this.index});
  final SavingsGoal? goal;
  final int? index;
  @override
  State<GoalEditScreen> createState() => _GoalEditScreenState();
}

class _GoalEditScreenState extends State<GoalEditScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.goal?.name);
  late final _target = TextEditingController(
    text: widget.goal == null ? '' : _amount(widget.goal!.target),
  );
  late final _saved = TextEditingController(
    text: _amount(widget.goal?.saved ?? 0),
  );
  String _amount(int cents) =>
      '${cents ~/ 100},${(cents % 100).toString().padLeft(2, '0')}';
  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _saved.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.goal == null ? 'Criar meta' : 'Atualizar meta'),
    ),
    body: SafeArea(
      child: PageBody(
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                maxLength: 60,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nome da meta',
                  hintText: 'Ex.: Minha próxima viagem',
                ),
                validator: (value) => (value?.trim().isNotEmpty ?? false)
                    ? null
                    : 'Dê um nome à sua meta.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _target,
                onChanged: (_) => setState(() {}),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Quanto quer juntar?',
                  prefixText: 'R\$ ',
                ),
                validator: (value) => parseCents(value ?? '') == null
                    ? 'Informe um valor maior que zero.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _saved,
                onChanged: (_) => setState(() {}),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Quanto já guardou?',
                  prefixText: 'R\$ ',
                ),
                validator: (value) =>
                    ['0', '0,00'].contains(value?.trim()) ||
                        parseCents(value ?? '') != null
                    ? null
                    : 'Informe um valor válido.',
              ),
              const SizedBox(height: 16),
              if (parseCents(_target.text) case final int target) ...[
                const Text('Ajuste seu progresso'),
                Slider(
                  value: ((parseCents(_saved.text) ?? 0) / target).clamp(0, 1),
                  divisions: 100,
                  label:
                      '${(((parseCents(_saved.text) ?? 0) / target) * 100).round()}%',
                  onChanged: (value) => setState(
                    () => _saved.text = _amount((value * target).round()),
                  ),
                ),
              ],
              const Text(
                'O valor guardado é informado por você e não altera seu saldo de lançamentos.',
                style: TextStyle(color: AppTheme.muted, fontSize: 12),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (!_form.currentState!.validate()) return;
                  PlanejoScope.of(context).saveGoal(
                    SavingsGoal(
                      name: _name.text.trim(),
                      target: parseCents(_target.text)!,
                      saved: parseCents(_saved.text) ?? 0,
                    ),
                    index: widget.index,
                  );
                  Navigator.pop(context, true);
                },
                child: const Text('Salvar meta'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
