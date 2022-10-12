import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../controllers/menu_controller.dart';
import '../widgets/header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8), //defaultPadding
        child: Column(
          children: [
            Header(
              ftc: () {
                context.read<MenuContoller>().controlDashboardMenu();
              },
            ),
            const SizedBox(
              height: 8,
            ), //defaultPadding
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 5,
                    child: Column(
                      children: const [
                        //MyProductHome()
                        //const SizedBox(height: defaultPadding),
                        //OrderScreen(),
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
