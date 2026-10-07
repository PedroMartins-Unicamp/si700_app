import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'planejo_controller.dart';
import 'ui/app_theme.dart';
import 'ui/screens/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');
  runApp(const PlanejoApp());
}

class PlanejoApp extends StatefulWidget {
  const PlanejoApp({super.key});
  @override
  State<PlanejoApp> createState() => _PlanejoAppState();
}

class _PlanejoAppState extends State<PlanejoApp> {
  final _controller = PlanejoController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PlanejoScope(
    controller: _controller,
    child: MaterialApp(
      title: 'Planejo',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: AppTheme.theme,
      home: const HomeShell(),
    ),
  );
}
