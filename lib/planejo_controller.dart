import 'package:flutter/material.dart';

import 'models.dart';

/// Shared, in-memory state for the interface assignment. No backend is needed.
class PlanejoController extends ChangeNotifier {
  AppUser? _user;
  AccountData _data = AccountData(
    entries: exampleEntries(),
    goals: const [
      SavingsGoal(
        name: 'Reserva de emergência',
        target: 1000000,
        saved: 248000,
      ),
    ],
  );
  AppUser? get user => _user;
  AccountData get data => _data;

  void enterDemo([String email = 'gabriel@exemplo.com']) {
    _user = AppUser(id: 'demo', email: email, isDemo: true);
    notifyListeners();
  }

  void signOut() {
    _user = null;
    notifyListeners();
  }

  void addEntry(FinancialEntry entry) {
    _data = AccountData(
      entries: List.unmodifiable([..._data.entries, entry]),
      goals: _data.goals,
    );
    notifyListeners();
  }

  void saveGoal(SavingsGoal goal, {int? index}) {
    final goals = [..._data.goals];
    if (index == null) {
      goals.add(goal);
    } else {
      goals[index] = goal;
    }
    _data = AccountData(
      entries: _data.entries,
      goals: List.unmodifiable(goals),
    );
    notifyListeners();
  }
}

/// Native Flutter widget that makes the same controller available to all routes.
class PlanejoScope extends InheritedNotifier<PlanejoController> {
  const PlanejoScope({
    super.key,
    required PlanejoController controller,
    required super.child,
  }) : super(notifier: controller);
  static PlanejoController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PlanejoScope>()!.notifier!;
}
