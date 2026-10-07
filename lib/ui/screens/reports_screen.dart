import 'package:flutter/material.dart';

import '../../models.dart';
import '../../planejo_controller.dart';
import '../app_theme.dart';
import '../formatters.dart';
import '../widgets.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Relatórios')),
    body: SafeArea(
      child: Builder(
        builder: (context) {
          final state = PlanejoScope.of(context);
          final month = DateTime.now();
          final entries = state.user == null
              ? exampleEntries()
              : state.data.entries;
          final expenses = entries.where(
            (e) =>
                e.type == EntryType.expense &&
                e.date.year == month.year &&
                e.date.month == month.month,
          );
          final total = expenses.fold(0, (sum, e) => sum + e.cents);
          return PageBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.user == null) ...[
                  const Tag('Resumo ilustrativo'),
                  const SizedBox(height: 16),
                ],
                Text(
                  'Para onde vai seu dinheiro?',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  monthLabel(month),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                SummaryCard(entries: entries, month: month, compact: true),
                const SizedBox(height: 24),
                const Text(
                  'Despesas por categoria',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                if (total == 0)
                  const Surface(
                    child: Text(
                      'Registre uma despesa para visualizar seu relatório.',
                    ),
                  ),
                for (final category in Category.values.where(
                  (c) => c != Category.income,
                ))
                  if (expenses.any((e) => e.category == category))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _category(
                        category,
                        expenses
                            .where((e) => e.category == category)
                            .fold(0, (sum, e) => sum + e.cents),
                        total,
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    ),
  );
  Widget _category(Category category, int amount, int total) => Surface(
    child: Column(
      children: [
        Row(
          children: [
            CategoryImage(category, size: 32),
            const SizedBox(width: 12),
            Expanded(child: Text(category.label)),
            Text(
              money(amount),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: amount / total,
          minHeight: 7,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: AppTheme.line,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${(amount / total * 100).round()}% das despesas',
            style: const TextStyle(fontSize: 11, color: AppTheme.muted),
          ),
        ),
      ],
    ),
  );
}
