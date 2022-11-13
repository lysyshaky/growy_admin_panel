import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy_admin_panel/inner_screens/edit_product.dart';
import 'package:growy_admin_panel/widgets/text_widget.dart';

import '../services/global_methods.dart';
import '../services/utils.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  String title = '';
  String productCat = '';
  String? imageUrl;
  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPiece = false;
  @override
  void initState() {
    getProductsData();
    super.initState();
  }

  Future<void> getProductsData() async {
    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      if (productsDoc == null) {
        return;
      } else {
        //_email = userDoc.get('email');
        setState(() {
          title = productsDoc.get('title');
          productCat = productsDoc.get('productCategoryName');
          imageUrl = productsDoc.get('imageUrl');
          price = productsDoc.get('price');
          salePrice = productsDoc.get('salePrice');
          isOnSale = productsDoc.get('isOnSale');
          isPiece = productsDoc.get('isPiece');
        });
      }
    } catch (error) {
      GlobalMethods.errorDialog(
          subtitle: 'Something went wrong, please try again later',
          context: context);
    } finally {}
  }

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
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditProductScreen(
                      id: widget.id,
                      title: title,
                      price: price,
                      salePrice: salePrice,
                      imageUrl: imageUrl == null
                          ? "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png"
                          : imageUrl!,
                      isOnSale: isOnSale,
                      isPiece: isPiece,
                      productCat: productCat,
                    )));
          },
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
                        imageUrl == null
                            ? "https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png"
                            : imageUrl!,
                        fit: BoxFit.fill,
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton(
                      itemBuilder: ((context) => []),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Row(
                  children: [
                    TextWidget(
                      text: isOnSale
                          ? '\$${salePrice.toStringAsFixed(2)}'
                          : '\$${price}',
                      textSize: 18,
                      color: color,
                    ),
                    const SizedBox(
                      width: 7.0,
                    ),
                    Visibility(
                      visible: isOnSale,
                      child: Text(
                        '\$$price',
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: color),
                      ),
                    ),
                    const Spacer(),
                    TextWidget(
                        text: isPiece ? 'Piece' : '1Kg',
                        color: color,
                        textSize: 18),
                  ],
                ),
                const SizedBox(
                  height: 2.0,
                ),
                TextWidget(
                  text: title,
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
