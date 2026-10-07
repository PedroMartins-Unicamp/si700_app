import 'package:intl/intl.dart';

String money(int cents) =>
    NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(cents / 100);
String monthLabel(DateTime date) =>
    DateFormat('MMMM yyyy', 'pt_BR').format(date);
String dateLabel(DateTime date) =>
    DateFormat("dd 'de' MMMM, yyyy", 'pt_BR').format(date);

/// Parse BRL as cents without floating point, accepting 89,90 and 1.234,56.
int? parseCents(String input) {
  final value = input.trim().replaceAll(RegExp(r'R\$\s*'), '');
  if (!RegExp(r'^(\d+|\d{1,3}(\.\d{3})+)(,\d{1,2})?$').hasMatch(value)) {
    return null;
  }
  final parts = value.replaceAll('.', '').split(',');
  final whole = int.tryParse(parts.first);
  if (whole == null) return null;
  final fraction = parts.length == 2 ? int.parse(parts[1].padRight(2, '0')) : 0;
  final cents = whole * 100 + fraction;
  return cents > 0 && cents <= 99999999999 ? cents : null;
}
