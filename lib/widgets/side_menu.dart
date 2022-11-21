import 'package:flutter/material.dart';
import 'package:growy_admin_panel/inner_screens/all_orders.dart';
import 'package:growy_admin_panel/provider/dart_theme_provider.dart';
import 'package:growy_admin_panel/widgets/language_picker_widget.dart';
import 'package:growy_admin_panel/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import '../inner_screens/all_products.dart';
import '../l10n/l10n.dart';
import '../provider/locale_provider.dart';
import '../screens/main_screen.dart';
import '../services/utils.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'language_widget.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = Utils(context).color;

    var _isDark = themeState.getDarkTheme;
    ;
    return Drawer(
      backgroundColor: _isDark ? Colors.black12 : Colors.green,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset('assets/images/groceries.png'),
          ),
          DrawerListTile(
            title: AppLocalizations.of(context)!.main,
            press: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            },
            icon: Icons.home_filled,
          ),
          DrawerListTile(
            title: AppLocalizations.of(context)!.view_all_products,
            press: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AllProductsScreen()));
            },
            icon: Icons.store,
          ),
          DrawerListTile(
            title: AppLocalizations.of(context)!.view_all_orders,
            press: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AllOrdersScreen()));
            },
            icon: IconlyBold.bag_2,
          ),
          SwitchListTile(
            title: Text(
              AppLocalizations.of(context)!.theme,
              style: TextStyle(color: Colors.white),
            ),
            secondary: Icon(
              themeState.getDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: Colors.white,
            ),
            value: theme,
            onChanged: (value) {
              setState(() {
                themeState.setDarkTheme = value;
              });
            },
          ),
          LanguagePickerWidget(),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LanguageWidget(),
              Text(
                AppLocalizations.of(context)!.language,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key, required this.title, required this.press, required this.icon})
      : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;

    return ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          size: 18,
          color: Colors.white,
        ),
        title: TextWidget(
          text: title,
          color: Colors.white,
          textSize: 16,
        ));
  }
}
