import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy_admin_panel/widgets/orders_list.dart';
import 'package:provider/provider.dart';

import '../consts/consts.dart';
import '../controllers/menu_controller.dart' as prefix;
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;
    return Scaffold(
      key: context.read<prefix.MenuController>().getGridScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Header(
                        ftc: () {
                          context
                              .read<prefix.MenuController>()
                              .controlProductsMenu();
                        },
                        title: AppLocalizations.of(context)!.all_products,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Responsive(
                        mobile: ProuductGridWidget(
                          isInMain: false,
                          crossAxisCount: size.width < 700 ? 2 : 4,
                          childAspectRatio:
                              size.width < 700 && size.width > 350 ? 1.1 : 0.8,
                        ),
                        desktop: ProuductGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          isInMain: false,
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
