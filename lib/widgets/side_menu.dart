import 'package:flutter/material.dart';
import 'package:growy_admin_panel/provider/dart_theme_provider.dart';
import 'package:growy_admin_panel/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../screens/main_screen.dart';
import '../services/utils.dart';

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
            child: Image.asset(
                '/Users/yuralysyshak/growy_admin_panel/assets/images/groceries.png'),
          ),
          DrawerListTile(
            title: "Main",
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
            title: "View all products",
            press: () {},
            icon: Icons.store,
          ),
          DrawerListTile(
            title: "View all products",
            press: () {},
            icon: IconlyBold.bag_2,
          ),
          SwitchListTile(
            title: const Text(
              'Theme',
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
          )
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
