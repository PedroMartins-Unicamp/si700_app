import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models.dart';
import '../../planejo_controller.dart';
import '../app_theme.dart';
import '../formatters.dart';
import '../widgets.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});
  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _description = TextEditingController();
  EntryType _type = EntryType.expense;
  Category _category = Category.food;
  DateTime _date = DateTime.now();
  String _payment = 'Cartão';
  bool _recurring = false;

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && mounted) setState(() => _date = date);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Novo lançamento',
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          tooltip: 'Cancelar',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    ),
    body: SafeArea(
      child: PageBody(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<EntryType>(
                  segments: const [
                    ButtonSegment(
                      value: EntryType.expense,
                      label: Text('− Despesa'),
                    ),
                    ButtonSegment(
                      value: EntryType.income,
                      label: Text('+ Receita'),
                    ),
                  ],
                  selected: {_type},
                  showSelectedIcon: false,
                  onSelectionChanged: (value) => setState(() {
                    _type = value.single;
                    _category = _type == EntryType.income
                        ? Category.income
                        : Category.food;
                  }),
                ),
              ),
              const SizedBox(height: 28),
              const Center(
                child: Text(
                  'VALOR',
                  style: TextStyle(
                    color: AppTheme.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amount,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                ],
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.navy,
                ),
                decoration: const InputDecoration(
                  prefixText: 'R\$ ',
                  hintText: '0,00',
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                validator: (value) => parseCents(value ?? '') != null
                    ? null
                    : 'Informe um valor válido, como 89,90.',
              ),
              const SizedBox(height: 22),
              const Text(
                'CATEGORIA',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 9),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final category in Category.values.where(
                    (c) => _type == EntryType.income
                        ? c == Category.income
                        : c != Category.income,
                  ))
                    ChoiceChip(
                      label: Text(
                        category.label,
                        style: const TextStyle(fontSize: 12),
                      ),
                      avatar: CategoryImage(category, size: 22),
                      selected: _category == category,
                      showCheckmark: false,
                      selectedColor: const Color(0xFFDDF4EC),
                      onSelected: (_) => setState(() => _category = category),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Surface(
                padding: 0,
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_month_outlined,
                    color: AppTheme.muted,
                  ),
                  title: const Text(
                    'DATA',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    dateLabel(_date),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.navy,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: _selectDate,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _payment,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Pagamento',
                  prefixIcon: Icon(Icons.credit_card, color: AppTheme.muted),
                ),
                items: ['Cartão', 'Pix', 'Dinheiro', 'Transferência']
                    .map(
                      (value) =>
                          DropdownMenuItem(value: value, child: Text(value)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _payment = value!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Ex.: Almoço no trabalho',
                  prefixIcon: Icon(Icons.edit_note, color: AppTheme.muted),
                  counterText: '',
                ),
                validator: (value) => (value?.trim().isNotEmpty ?? false)
                    ? null
                    : 'Descreva seu lançamento.',
              ),
              const SizedBox(height: 12),
              Surface(
                padding: 0,
                child: SwitchListTile(
                  title: const Text(
                    'Repetir mensalmente',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    _recurring ? 'Marcado como recorrente' : 'Não recorrente',
                    style: const TextStyle(fontSize: 12),
                  ),
                  value: _recurring,
                  onChanged: (value) => setState(() => _recurring = value),
                ),
              ),
              if (_recurring)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Esta versão identifica o lançamento como recorrente, sem criar cobranças futuras.',
                    style: TextStyle(fontSize: 11, color: AppTheme.muted),
                  ),
                ),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: () {
                  if (!_form.currentState!.validate()) return;
                  PlanejoScope.of(context).addEntry(
                    FinancialEntry(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      type: _type,
                      cents: parseCents(_amount.text)!,
                      category: _category,
                      date: _date,
                      payment: _payment,
                      description: _description.text.trim(),
                      recurring: _recurring,
                    ),
                  );
                  Navigator.pop(context, true);
                },
                child: const Text('Salvar lançamento'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}
