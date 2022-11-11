import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy_admin_panel/consts/consts.dart';
import 'package:growy_admin_panel/widgets/text_widget.dart';

import '../services/utils.dart';
import 'orders_widget.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({Key? key, this.isInDashboard = true}) : super(key: key);
  final bool isInDashboard;

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: isInDashboard && snapshot.data!.docs.length > 5
                      ? 5
                      : snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        OrdersWidget(
                          price: snapshot.data!.docs[index]['price'],
                          totalPrice: snapshot.data!.docs[index]['totalPrice'],
                          productId: snapshot.data!.docs[index]['productId'],
                          userId: snapshot.data!.docs[index]['userId'],
                          quantity: snapshot.data!.docs[index]['quantity'],
                          orderDate: snapshot.data!.docs[index]['orderDate'],
                          imageUrl: snapshot.data!.docs[index]['imageUrl'],
                          userName: snapshot.data!.docs[index]['userName'],
                        ),
                        const Divider(
                          thickness: 3,
                        ),
                      ],
                    );
                  }),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextWidget(
                    text: "Your store is empty", color: color, textSize: 16),
              ),
            );
          }
        }
        return Center(
          child: TextWidget(
            text: "Something went wrong",
            color: color,
            textSize: 30,
            isTitle: true,
          ),
        );
      },
    );
  }
}
