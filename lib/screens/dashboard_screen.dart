import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy_admin_panel/consts/consts.dart';
import 'package:growy_admin_panel/inner_screens/all_products.dart';
import 'package:growy_admin_panel/services/global_methods.dart';
import 'package:growy_admin_panel/widgets/buttons_widget.dart';
import 'package:provider/provider.dart';

import '../controllers/menu_controller.dart';
import '../inner_screens/add_product.dart';
import '../inner_screens/all_orders.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/orders_list.dart';
import '../widgets/products_widget.dart';
import '../widgets/text_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding), //defaultPadding
        child: Column(
          children: [
            Header(
              ftc: () {
                context.read<MenuController>().controlDashboardMenu();
              },
              title: 'Dashboard',
            ),
            const SizedBox(
              height: 20,
            ),
            TextWidget(
              text: "Latest Products",
              color: color,
              textSize: 14,
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ButtonsWidget(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllProductsScreen(),
                        ),
                      );
                    },
                    text: "View all",
                    icon: Icons.store,
                    backgroundColor: Colors.green,
                  ),
                  Spacer(),
                  ButtonsWidget(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadProductForm(),
                        ),
                      );
                    },
                    text: "Add product",
                    icon: Icons.add,
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
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
                      //
                      const OrdersList(),

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
