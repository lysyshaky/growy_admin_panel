import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  // final Widget? tablet;
  final Widget desktop;

  const Responsive({Key? key, required this.mobile, required this.desktop})
      : super(key: key);

  static bool isMoble(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= 1200) {
      return desktop;
    } else {
      return mobile;
    }
  }
}
