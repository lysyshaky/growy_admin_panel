import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:growy_admin_panel/consts/theme_data.dart';
import 'package:growy_admin_panel/l10n/l10n.dart';
import 'package:growy_admin_panel/provider/dart_theme_provider.dart';
import 'package:growy_admin_panel/provider/locale_provider.dart';
import 'package:growy_admin_panel/screens/dashboard_screen.dart';
import 'package:growy_admin_panel/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'controllers/menu_controller.dart';
import 'inner_screens/add_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCzErGIqYGNhTZJbh4DK7jgfCNYYcUvD7o",
        authDomain: "growy-185cf.firebaseapp.com",
        projectId: "growy-185cf",
        storageBucket: "growy-185cf.appspot.com",
        messagingSenderId: "390146175797",
        appId: "1:390146175797:web:b270b566151f4486be527c",
        measurementId: "G-6DFE3TJ9JX"),
    //     //options: DefaultFirebaseOptions.currentPlatform,
  );
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

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    bool _isDark = true;
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // return const MaterialApp(
            //   home: Scaffold(
            //     body: Center(
            //       child: Text("An error occured"),
            //     ),
            //   ),
            // );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => MenuController(),
              ),
              ChangeNotifierProvider(
                create: (_) {
                  return themeChangeProvider;
                },
              ),
              ChangeNotifierProvider(
                create: (context) => LocaleProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
                final localeProvider = Provider.of<LocaleProvider>(context);
                return MaterialApp(
                    locale: localeProvider.locale,
                    supportedLocales: L10n.all,
                    //fix locale change
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    debugShowCheckedModeBanner: false,
                    title: 'Growy',
                    theme:
                        Styles.themeData(themeProvider.getDarkTheme, context),
                    home: const MainScreen(),
                    routes: {
                      UploadProductForm.routeName: (context) =>
                          const UploadProductForm(),
                    });
              },
            ),
          );
        });
  }
}
