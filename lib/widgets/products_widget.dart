import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy_admin_panel/widgets/text_widget.dart';

import '../services/utils.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({Key? key}) : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.green.withOpacity(0.3),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.network(
                        "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png",
                        fit: BoxFit.fill,
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton(
                      itemBuilder: ((context) => [
                            PopupMenuItem(
                              child: Text('Edit'),
                              onTap: () {},
                              value: 1,
                            ),
                            PopupMenuItem(
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onTap: () {},
                              value: 1,
                            ),
                          ]),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Row(
                  children: [
                    TextWidget(
                      text: '\$1.99',
                      textSize: 18,
                      color: color,
                    ),
                    const SizedBox(
                      width: 7.0,
                    ),
                    Visibility(
                      visible: true,
                      child: Text(
                        '\$3.89',
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: color),
                      ),
                    ),
                    const Spacer(),
                    TextWidget(text: '1Kg', color: color, textSize: 18),
                  ],
                ),
                const SizedBox(
                  height: 2.0,
                ),
                TextWidget(
                  text: 'Title',
                  color: color,
                  textSize: 24,
                  isTitle: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
