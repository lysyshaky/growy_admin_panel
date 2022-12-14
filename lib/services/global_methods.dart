import 'package:flutter/material.dart';
import 'package:growy_admin_panel/inner_screens/add_product.dart';

import '../widgets/text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GlobalMethods {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, UploadProductForm.routeName);
  }

  static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset('assets/images/warning-sign.png',
                    height: 24, width: 24, fit: BoxFit.fill),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  AppLocalizations.of(context)!.error,
                ),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.green,
                  text: AppLocalizations.of(context)!.ok_btn,
                  textSize: 18,
                  isTitle: true,
                ),
              ),
            ],
          );
        });
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset('assets/images/warning-sign.png',
                    height: 24, width: 24, fit: BoxFit.fill),
                const SizedBox(
                  width: 8,
                ),
                Text(title),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.green,
                  text: AppLocalizations.of(context)!.cancel_btn,
                  textSize: 18,
                  isTitle: true,
                ),
              ),
              TextButton(
                onPressed: () {
                  fct();
                },
                child: TextWidget(
                  color: Colors.red,
                  text: AppLocalizations.of(context)!.ok_btn,
                  textSize: 18,
                  isTitle: true,
                ),
              ),
            ],
          );
        });
  }
}
