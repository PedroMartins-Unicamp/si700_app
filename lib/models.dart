enum EntryType { expense, income }

enum Category {
  food('Alimentação', 'food'),
  transport('Transporte', 'transport'),
  home('Moradia', 'home'),
  leisure('Lazer', 'leisure'),
  health('Saúde', 'health'),
  income('Receita', 'income');

  const Category(this.label, this.asset);
  final String label;
  final String asset;
}

class FinancialEntry {
  const FinancialEntry({
    required this.id,
    required this.type,
    required this.cents,
    required this.category,
    required this.date,
    required this.payment,
    required this.description,
    this.recurring = false,
  });
  final String id;
  final EntryType type;
  final int cents;
  final Category category;
  final DateTime date;
  final String payment;
  final String description;
  final bool recurring;
}

class SavingsGoal {
  const SavingsGoal({required this.name, required this.target, this.saved = 0});
  final String name;
  final int target;
  final int saved;
}

class AccountData {
  const AccountData({this.entries = const [], this.goals = const []});
  final List<FinancialEntry> entries;
  final List<SavingsGoal> goals;
}

class AppUser {
  const AppUser({required this.id, required this.email, this.isDemo = false});
  final String id;
  final String email;
  final bool isDemo;
  String get name => isDemo ? 'Gabriel' : email.split('@').first;
}

List<FinancialEntry> exampleEntries([DateTime? month]) {
  final now = month ?? DateTime.now();
  FinancialEntry entry(
    String id,
    String title,
    int cents,
    Category category,
    String payment,
    int day, [
    EntryType type = EntryType.expense,
  ]) => FinancialEntry(
    id: id,
    type: type,
    cents: cents,
    category: category,
    date: DateTime(now.year, now.month, day),
    payment: payment,
    description: title,
  );
  return [
    entry('lunch', 'Almoço no trabalho', 8990, Category.food, 'Cartão', 2),
    entry('uber', 'Uber para reunião', 2450, Category.transport, 'Pix', 2),
    entry(
      'salary',
      'Salário',
      520000,
      Category.income,
      'Transferência',
      2,
      EntryType.income,
    ),
    entry(
      'streaming',
      'Assinatura streaming',
      3990,
      Category.leisure,
      'Cartão',
      1,
    ),
    entry('pharmacy', 'Farmácia', 6230, Category.health, 'Dinheiro', 1),
    entry('rent', 'Aluguel', 230000, Category.home, 'Pix', 1),
    entry('groceries', 'Supermercado', 20340, Category.food, 'Cartão', 1),
  ];
}
