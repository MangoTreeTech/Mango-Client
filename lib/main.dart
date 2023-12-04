import 'package:flutter/material.dart';
import 'package:mango/pages/main_page.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'app_state/account.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemTheme.accentColor.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: SystemTheme.accentColor.accent,
          brightness: Brightness.dark),
      useMaterial3: true,
    );
    return OKToast(
      child: MaterialApp(
        title: 'Mango',
        theme: theme,
        home: Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: ChangeNotifierProvider(
            create: (context) => Account(),
            child: const MainPage(),
          ),
        ),
      ),
    );
  }
}
