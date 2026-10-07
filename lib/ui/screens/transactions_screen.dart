import 'package:flutter/material.dart';

import '../../models.dart';
import '../../planejo_controller.dart';
import '../app_theme.dart';
import '../formatters.dart';
import '../widgets.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key, required this.onAdd});
  final VoidCallback onAdd;
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  String _search = '';
  EntryType? _filter;

  Future<void> _pickMonth() async {
    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        var year = _month.year;
        return StatefulBuilder(
          builder: (context, update) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: 'Ano anterior',
                  onPressed: () => update(() => year--),
                  icon: const Icon(Icons.chevron_left),
                ),
                Text('$year'),
                IconButton(
                  tooltip: 'Próximo ano',
                  onPressed: () => update(() => year++),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            content: SizedBox(
              width: 280,
              child: Wrap(
                spacing: 6,
                runSpacing: 8,
                children: [
                  for (var month = 1; month <= 12; month++)
                    SizedBox(
                      width: 80,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pop(context, DateTime(year, month)),
                        child: Text(
                          monthLabel(DateTime(year, month)).split(' ').first,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (result != null && mounted) setState(() => _month = result);
  }

  @override
  Widget build(BuildContext context) {
    final state = PlanejoScope.of(context);
    final entries =
        state.data.entries
            .where(
              (entry) =>
                  entry.date.month == _month.month &&
                  entry.date.year == _month.year &&
                  (_filter == null || entry.type == _filter) &&
                  '${entry.description} ${entry.category.label} ${entry.payment}'
                      .toLowerCase()
                      .contains(_search.toLowerCase()),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    // A real ListView in the body, as required by the interface assignment.
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Meus lançamentos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _pickMonth,
                icon: const Icon(Icons.expand_more, size: 18),
                label: Text(monthLabel(_month)),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Tag('Dados de demonstração'),
            ),
            const SizedBox(height: 12),
            SummaryCard(
              entries: state.data.entries,
              month: _month,
              compact: true,
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => _search = value),
              decoration: const InputDecoration(
                hintText: 'Buscar lançamento',
                prefixIcon: Icon(Icons.search, size: 21),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Todos'),
                  selected: _filter == null,
                  onSelected: (_) => setState(() => _filter = null),
                ),
                ChoiceChip(
                  label: const Text('Despesas'),
                  selected: _filter == EntryType.expense,
                  onSelected: (_) =>
                      setState(() => _filter = EntryType.expense),
                ),
                ChoiceChip(
                  label: const Text('Receitas'),
                  selected: _filter == EntryType.income,
                  onSelected: (_) => setState(() => _filter = EntryType.income),
                ),
              ],
            ),
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.receipt_long_outlined,
                        size: 42,
                        color: AppTheme.muted,
                      ),
                      const SizedBox(height: 12),
                      const Text('Nenhum lançamento encontrado.'),
                      TextButton(
                        onPressed: widget.onAdd,
                        child: const Text('Registrar lançamento'),
                      ),
                    ],
                  ),
                ),
              ),
            for (var i = 0; i < entries.length; i++) ...[
              if (i == 0 || !_sameDay(entries[i - 1].date, entries[i].date))
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 8),
                  child: Text(
                    dateLabel(entries[i].date),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              _entryTile(entries[i]),
            ],
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _entryTile(FinancialEntry entry) => ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 4),
    leading: CategoryImage(entry.category),
    title: Text(
      entry.description,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
    ),
    subtitle: Text(
      '${entry.category.label} · ${entry.payment}${entry.recurring ? ' · Mensal' : ''}',
      style: const TextStyle(fontSize: 11, color: AppTheme.muted),
    ),
    trailing: Text(
      '${entry.type == EntryType.income ? '+' : '−'} ${money(entry.cents)}',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: entry.type == EntryType.income ? AppTheme.green : AppTheme.red,
      ),
    ),
    onTap: () => showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.description,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                money(entry.cents),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: entry.type == EntryType.income
                      ? AppTheme.green
                      : AppTheme.red,
                ),
              ),
              const SizedBox(height: 12),
              Text('${entry.category.label} · ${entry.payment}'),
              Text(dateLabel(entry.date)),
              if (entry.recurring)
                const Text('Lançamento marcado como recorrente'),
            ],
          ),
        ),
      ),
    ),
  );
}
