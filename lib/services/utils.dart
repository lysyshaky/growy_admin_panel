import 'package:flutter/material.dart';
import 'package:growy_admin_panel/provider/dart_theme_provider.dart';
import 'package:provider/provider.dart';

class Utils {
  BuildContext context;
  Utils(this.context);
  bool get getTheme => Provider.of<DarkThemeProvider>(context).getDarkTheme;
  get appBarcolor => getTheme ? Colors.green : Colors.white;
  get color => getTheme ? Colors.white : Colors.black;
  get dropDownColor => getTheme ? Colors.green : Colors.white;
  Size get getScreenSize => MediaQuery.of(context).size;
}
