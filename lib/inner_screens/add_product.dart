import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy_admin_panel/consts/consts.dart';
import 'package:growy_admin_panel/controllers/menu_controller.dart';
import 'package:growy_admin_panel/responsive.dart';
import 'package:growy_admin_panel/widgets/buttons_widget.dart';
import 'package:growy_admin_panel/widgets/header.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../services/utils.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = "/UploadProudctForm";
  const UploadProductForm({Key? key}) : super(key: key);

  @override
  State<UploadProductForm> createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController, _priceController;

  @override
  void initState() {
    _priceController = TextEditingController();
    _titleController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
      ),
    );

    return Scaffold(
        key: context.read<MenuContoller>().getAddProductsScaffoldKey,
        drawer: const SideMenu(),
        body: Row(
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Header(
                      ftc: () {
                        context.read<MenuContoller>().controlAddProductsMenu();
                      },
                    ),
                    Container(
                      width: size.width > 650 ? 650 : size.width,
                      color: Colors.green.withOpacity(0.1),
                      padding: const EdgeInsets.all(defaultPadding),
                      margin: const EdgeInsets.all(defaultPadding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              text: "Product Title",
                              color: color,
                              isTitle: true,
                              textSize: 16,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _titleController,
                              key: const ValueKey("Title"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a Title';
                                }
                                return null;
                              },
                              decoration: inputDecoration,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: "Price in \$*",
                                          color: color,
                                          isTitle: true,
                                          textSize: 14,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: TextFormField(
                                            controller: _priceController,
                                            key: const ValueKey("Price \$"),
                                            keyboardType: TextInputType.number,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Price is missed';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9.]')),
                                            ],
                                            decoration: inputDecoration,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextWidget(
                                          text: "Product category*",
                                          color: color,
                                          isTitle: true,
                                          textSize: 14,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        //DropDown menu
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextWidget(
                                          text: "Measure unit*",
                                          color: color,
                                          isTitle: true,
                                          textSize: 14,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        //Radio Buttons
                                      ],
                                    ),
                                  ),
                                ),
                                //Image to be picked here
                                Expanded(
                                  flex: 4,
                                  child: Container(color: Colors.red),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FittedBox(
                                      child: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: TextWidget(
                                          text: 'Clear',
                                          color: Colors.red,
                                          textSize: 12,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: TextWidget(
                                          text: 'Update image',
                                          color: Colors.green,
                                          textSize: 12,
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ButtonsWidget(
                                      onPressed: () {},
                                      text: 'Clear form',
                                      icon: IconlyBold.danger,
                                      backgroundColor: Colors.red),
                                  ButtonsWidget(
                                      onPressed: () {
                                        _uploadForm();
                                      },
                                      text: 'Upload',
                                      icon: IconlyBold.upload,
                                      backgroundColor: Colors.green),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
