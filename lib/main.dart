import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:growy_admin_panel/consts/theme_data.dart';
import 'package:growy_admin_panel/provider/dart_theme_provider.dart';
import 'package:growy_admin_panel/screens/dashboard_screen.dart';
import 'package:growy_admin_panel/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'controllers/menu_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MenuContoller(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Growy',
            theme: Styles.themeData(themeProvider.getDarkTheme, context),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
