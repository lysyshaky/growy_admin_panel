import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy_admin_panel/consts/consts.dart';
import 'package:provider/provider.dart';

import '../controllers/menu_controller.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/orders_list.dart';
import '../widgets/products_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding), //defaultPadding
        child: Column(
          children: [
            Header(
              ftc: () {
                context.read<MenuContoller>().controlDashboardMenu();
              },
            ),
            const SizedBox(
              height: defaultPadding,
            ), //defaultPadding
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Responsive(
                        mobile: ProuductGridWidget(
                          isInMain: true,
                          crossAxisCount: size.width < 700 ? 2 : 4,
                          childAspectRatio:
                              size.width < 700 && size.width > 350 ? 1.1 : 0.8,
                        ),
                        desktop: ProuductGridWidget(
                          isInMain: true,
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: OrdersList(),
                      ),
                      //MyProductHome()
                      //const SizedBox(height: defaultPadding),
                      //OrderScreen(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
