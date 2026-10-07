import 'package:flutter/material.dart';

import '../models.dart';
import 'app_theme.dart';
import 'formatters.dart';

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'P',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(width: 10),
      const Text(
        'Planejo',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          letterSpacing: -.6,
        ),
      ),
    ],
  );
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.child, this.padding = 22});
  final Widget child;
  final double padding;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    ),
  );
}

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    required this.child,
    this.padding = 18,
    this.color,
    this.borderColor,
  });
  final Widget child;
  final double padding;
  final Color? color;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: borderColor ?? AppTheme.line),
      boxShadow: [
        BoxShadow(
          color: AppTheme.navy.withValues(alpha: .035),
          blurRadius: 22,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    ),
  );
}

class Tag extends StatelessWidget {
  const Tag(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
    decoration: BoxDecoration(
      color: AppTheme.green.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: AppTheme.green,
        fontWeight: FontWeight.w700,
        fontSize: 11,
      ),
    ),
  );
}

class CategoryImage extends StatelessWidget {
  const CategoryImage(this.category, {super.key, this.size = 44});
  final Category category;
  final double size;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(13),
    child: Image.asset(
      'assets/categories/${category.asset}.png',
      width: size,
      height: size,
      semanticLabel: category.label,
    ),
  );
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.entries,
    required this.month,
    this.example = false,
    this.compact = false,
  });
  final List<FinancialEntry> entries;
  final DateTime month;
  final bool example;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final selected = entries.where(
      (e) => e.date.year == month.year && e.date.month == month.month,
    );
    final income = selected
        .where((e) => e.type == EntryType.income)
        .fold(0, (sum, e) => sum + e.cents);
    final expense = selected
        .where((e) => e.type == EntryType.expense)
        .fold(0, (sum, e) => sum + e.cents);
    if (compact) {
      return Surface(
        child: Row(
          children: [
            _number('Saldo', income - expense, AppTheme.navy),
            _number('Receitas', income, AppTheme.green),
            _number('Despesas', expense, AppTheme.red),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.navy, Color(0xFF16394B)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  example ? 'RESUMO DO MÊS · EXEMPLO' : 'SEU RESUMO DO MÊS',
                  style: const TextStyle(
                    color: Color(0xFFB1C4D7),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                monthLabel(month).split(' ').first,
                style: const TextStyle(color: Color(0xFFB1C4D7), fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            money(income - expense),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              height: 1.2,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const Text(
            'Saldo disponível',
            style: TextStyle(
              color: Color(0xFF78E8C0),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _bar(
                'Receitas',
                income,
                const Color(0xFF65E3B1),
                income,
                expense,
              ),
              const SizedBox(width: 22),
              _bar(
                'Despesas',
                expense,
                const Color(0xFFFF858C),
                income,
                expense,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _number(String label, int cents, Color color) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.muted),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            money(cents),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
      ],
    ),
  );
  Widget _bar(String label, int cents, Color color, int income, int expense) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Color(0xFFB1C4D7), fontSize: 11),
            ),
            Text(
              money(cents),
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: income + expense == 0 ? 0 : cents / (income + expense),
              color: color,
              backgroundColor: Colors.white12,
              minHeight: 6,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      );
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
