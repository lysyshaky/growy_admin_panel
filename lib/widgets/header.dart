import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy_admin_panel/consts/consts.dart';
import 'package:growy_admin_panel/services/utils.dart';

import '../responsive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.ftc,
    required this.title,
    this.showTextField = true,
  }) : super(key: key);
  final Function ftc;
  final String title;
  final bool showTextField;
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;

    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            onPressed: () {
              ftc();
            },
            icon: const Icon(Icons.menu),
          ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        if (Responsive.isDesktop(context))
          Spacer(
            flex: Responsive.isDesktop(context) ? 2 : 1,
          ),
        !showTextField
            ? Container()
            : Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.search,
                      fillColor: Colors.green.withOpacity(0.1),
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(
                              defaultPadding * 0.75), //defaultPadding
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0), // defaultPadding/2
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ),
              ),
      ],
    );
  }
}
