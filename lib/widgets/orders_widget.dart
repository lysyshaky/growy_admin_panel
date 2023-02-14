import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy_admin_panel/widgets/text_widget.dart';

import '../services/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget(
      {Key? key,
      required this.price,
      required this.totalPrice,
      required this.quantity,
      this.productId,
      this.userName,
      this.imageUrl,
      this.userId,
      this.orderId,
      required this.orderDate})
      : super(key: key);
  final double price, totalPrice, quantity;
  final productId, userName, imageUrl, userId, orderId;
  final Timestamp orderDate;

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late String oderDateStr;

  @override
  void initState() {
    var posDate = widget.orderDate.toDate();
    oderDateStr = '${posDate.day}/${posDate.month}/${posDate.year}';
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.green.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: "${widget.quantity} X "
                          "${widget.price.toStringAsFixed(2)}\₴",
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: AppLocalizations.of(context)!.client,
                            color: Colors.green,
                            textSize: 16,
                            isTitle: true,
                          ),
                          TextWidget(
                            text: " ${widget.userName}",
                            color: color,
                            textSize: 14,
                            isTitle: true,
                          ),
                        ],
                      ),
                    ),
                    Text(oderDateStr),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
