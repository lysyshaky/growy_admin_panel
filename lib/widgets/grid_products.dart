import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy_admin_panel/widgets/products_widget.dart';
import 'package:growy_admin_panel/widgets/text_widget.dart';

import '../consts/consts.dart';
import '../services/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProuductGridWidget extends StatelessWidget {
  const ProuductGridWidget(
      {Key? key,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1,
      this.isInMain = true})
      : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;
  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return snapshot.data!.docs.length == 0
                ? Center(
                    child: TextWidget(
                        text: AppLocalizations.of(context)!.any_products_error,
                        color: color,
                        textSize: 16),
                  )
                : GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: isInMain && snapshot.data!.docs.length > 4
                        ? 4
                        : snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: defaultPadding,
                        mainAxisSpacing: defaultPadding),
                    itemBuilder: (context, index) {
                      return ProductWidget(id: snapshot.data!.docs[index].id);
                    },
                  );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextWidget(
                    text: AppLocalizations.of(context)!.store_empty,
                    color: color,
                    textSize: 16),
              ),
            );
          }
        }
        return Center(
          child: TextWidget(
            text: AppLocalizations.of(context)!.something_went_wrong,
            color: color,
            textSize: 30,
            isTitle: true,
          ),
        );
      },
    );
  }
}
