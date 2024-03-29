import 'dart:developer';
import 'dart:io';

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growy_admin_panel/widgets/header.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:growy_admin_panel/controllers/menu_controller.dart' as prefix;
import 'package:uuid/uuid.dart';
import 'package:firebase/firebase.dart' as fb;
import '../consts/consts.dart';
import '../responsive.dart';
import '../screens/loading_manager.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/buttons_widget.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen(
      {Key? key,
      required this.id,
      required this.title,
      required this.price,
      required this.salePrice,
      required this.productCat,
      required this.imageUrl,
      required this.isOnSale,
      required this.isPiece,
      required this.titleuk})
      : super(key: key);
  final String id, title, titleuk, price, productCat, imageUrl;
  final bool isPiece, isOnSale;
  final double salePrice;
  static const routeName = 'EditProductScreen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  // Title and price controllers
  late final TextEditingController _titleController,
      _titleUkController,
      _priceController;
  // Category
  late String _catValue;
  // Sale
  String? _salePercent;
  late String percToShow;
  late double _salePrice;
  late bool _isOnSale;
  // Image
  File? _pickedImage;
  Uint8List webImage = Uint8List(10);
  late String _imageUrl;
  // kg or Piece,
  late int val;
  late bool _isPiece;
  // while loading
  bool _isLoading = false;
  @override
  void initState() {
    // set the price and title initial values and initialize the controllers
    _priceController = TextEditingController(text: widget.price);
    _titleController = TextEditingController(text: widget.title);
    _titleUkController = TextEditingController(text: widget.titleuk);

    // Set the variables
    _salePrice = widget.salePrice;
    _catValue = widget.productCat;
    _isOnSale = widget.isOnSale;
    _isPiece = widget.isPiece;
    val = _isPiece ? 2 : 1;
    _imageUrl = widget.imageUrl;
    // Calculate the percentage
    percToShow = (100 -
                (_salePrice * 100) /
                    double.parse(
                        widget.price)) // WIll be the price instead of 1.88
            .round()
            .toStringAsFixed(1) +
        '%';
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the controllers
    _priceController.dispose();
    _titleController.dispose();
    _titleUkController.dispose();
    super.dispose();
  }

  void _updateProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        Uri? imageUri;
        setState(() {
          _isLoading = true;
        });
        if (_pickedImage != null) {
          fb.StorageReference storageRef = fb
              .storage()
              .ref()
              .child('productIamges')
              .child(widget.id + '.jpg');
          final fb.UploadTaskSnapshot uploadTaskSnapshot =
              await storageRef.put(kIsWeb ? webImage : _pickedImage).future;
          imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
        }
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.id)
            .update({
          'title': _titleController.text,
          'title_uk': _titleUkController.text,
          'price': _priceController.text,
          'salePrice': _salePrice,
          'imageUrl':
              _pickedImage == null ? widget.imageUrl : imageUri.toString(),
          'productCategoryName': _catValue,
          'isOnSale': _isOnSale,
          'isPiece': _isPiece,
          'UpdatedAt': Timestamp.now(),
        });
        await Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.product_has_been_updated,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          // backgroundColor: ,
          // textColor: ,
          // fontSize: 16.0
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      key: context.read<prefix.MenuController>().getEditProductscaffoldKey,
      drawer: const SideMenu(),
      body: Row(
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: SideMenu(),
            ),
          Expanded(
            flex: 5,
            child: LoadingManager(
              isLoading: _isLoading,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: size.width > 650 ? 650 : size.width,
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.all(16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextWidget(
                                  textSize: 16,
                                  text: AppLocalizations.of(context)!
                                      .product_title,
                                  color: color,
                                  isTitle: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _titleController,
                                  key: ValueKey('Title'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .valid_title;
                                    }
                                    return null;
                                  },
                                  decoration: inputDecoration,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  textSize: 16,
                                  text: AppLocalizations.of(context)!
                                      .uk_product_title,
                                  color: color,
                                  isTitle: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _titleUkController,
                                  key: ValueKey('TitleUk'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .valid_title;
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
                                      flex: 1,
                                      child: FittedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .price_usd,
                                              color: color,
                                              textSize: 16,
                                              isTitle: true,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: TextFormField(
                                                controller: _priceController,
                                                key: ValueKey('Price \₴'),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return AppLocalizations.of(
                                                            context)!
                                                        .valid_price;
                                                  }
                                                  return null;
                                                },
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9.]')),
                                                ],
                                                decoration: inputDecoration,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            TextWidget(
                                              textSize: 16,
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .product_category,
                                              color: color,
                                              isTitle: true,
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              color: _scaffoldColor,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: catDropDownWidget(color),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextWidget(
                                              textSize: 16,
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .measure_unit,
                                              color: color,
                                              isTitle: true,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                    textSize: 16,
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .kg,
                                                    color: color),
                                                Radio(
                                                  value: 1,
                                                  groupValue: val,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      val = 1;
                                                      _isPiece = false;
                                                    });
                                                  },
                                                  activeColor: Colors.green,
                                                ),
                                                TextWidget(
                                                    textSize: 16,
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .piece,
                                                    color: color),
                                                Radio(
                                                  value: 2,
                                                  groupValue: val,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      val = 2;
                                                      _isPiece = true;
                                                    });
                                                  },
                                                  activeColor: Colors.green,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                  activeColor: Colors.green,
                                                  checkColor: Colors.white,
                                                  value: _isOnSale,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _isOnSale = newValue!;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                TextWidget(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .sale,
                                                  textSize: 16,
                                                  color: color,
                                                  isTitle: true,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            AnimatedSwitcher(
                                              duration:
                                                  const Duration(seconds: 1),
                                              child: !_isOnSale
                                                  ? Container()
                                                  : Row(
                                                      children: [
                                                        TextWidget(
                                                            textSize: 16,
                                                            text: "\ ₴" +
                                                                _salePrice
                                                                    .toStringAsFixed(
                                                                        2),
                                                            color: color),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        salePourcentageDropDownWidget(
                                                            color),
                                                      ],
                                                    ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          height: size.width > 650
                                              ? 350
                                              : size.width * 0.45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            child: _pickedImage == null
                                                ? Image.network(_imageUrl)
                                                : (kIsWeb)
                                                    ? Image.memory(
                                                        webImage,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Image.file(
                                                        _pickedImage!,
                                                        fit: BoxFit.fill,
                                                      ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            FittedBox(
                                              child: TextButton(
                                                onPressed: () {
                                                  _pickImage();
                                                },
                                                child: TextWidget(
                                                  textSize: 16,
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .image_update,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ButtonsWidget(
                                        onPressed: () async {
                                          GlobalMethods.warningDialog(
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .delete_warn,
                                              subtitle:
                                                  AppLocalizations.of(context)!
                                                      .confirn_btn,
                                              fct: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('products')
                                                    .doc(widget.id)
                                                    .delete();
                                                await Fluttertoast.showToast(
                                                  msg: AppLocalizations.of(
                                                          context)!
                                                      .product_has_been_deleted,
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  // backgroundColor: ,
                                                  // textColor: ,
                                                  // fontSize: 16.0
                                                );
                                                while (
                                                    Navigator.canPop(context)) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              context: context);
                                        },
                                        text: AppLocalizations.of(context)!
                                            .delete_btn,
                                        icon: IconlyBold.danger,
                                        backgroundColor: Colors.red.shade700,
                                      ),
                                      ButtonsWidget(
                                        onPressed: () {
                                          _updateProduct();
                                        },
                                        text: AppLocalizations.of(context)!
                                            .update_btn,
                                        icon: IconlyBold.setting,
                                        backgroundColor: Colors.green,
                                      ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownButtonHideUnderline salePourcentageDropDownWidget(Color color) {
    final color = Utils(context).color;
    final dropDownColor = Utils(context).dropDownColor;
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: dropDownColor,
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem<String>(
            child: Text('10%'),
            value: '10',
          ),
          DropdownMenuItem<String>(
            child: Text('15%'),
            value: '15',
          ),
          DropdownMenuItem<String>(
            child: Text('25%'),
            value: '25',
          ),
          DropdownMenuItem<String>(
            child: Text('50%'),
            value: '50',
          ),
          DropdownMenuItem<String>(
            child: Text('75%'),
            value: '75',
          ),
        ],
        onChanged: (value) {
          if (value == '0') {
            return;
          } else {
            setState(() {
              _salePercent = value;
              _salePrice = double.parse(widget.price) -
                  (double.parse(value!) * double.parse(widget.price) / 100);
            });
          }
        },
        hint: Text(_salePercent ?? percToShow),
        value: _salePercent,
      ),
    );
  }

  DropdownButtonHideUnderline catDropDownWidget(Color color) {
    final color = Utils(context).color;
    final dropDownColor = Utils(context).dropDownColor;
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: dropDownColor,
        style:
            TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: color),
        items: [
          DropdownMenuItem<String>(
            child: Text(
              AppLocalizations.of(context)!.vegetables,
            ),
            value: 'Vegetables',
          ),
          DropdownMenuItem<String>(
            child: Text(
              AppLocalizations.of(context)!.fruits,
            ),
            value: 'Fruits',
          ),
          DropdownMenuItem<String>(
            child: Text(
              AppLocalizations.of(context)!.grains,
            ),
            value: 'Grains',
          ),
          DropdownMenuItem<String>(
            child: Text(
              AppLocalizations.of(context)!.nuts,
            ),
            value: 'Nuts',
          ),
          DropdownMenuItem<String>(
            child: Text(
              AppLocalizations.of(context)!.herbs,
            ),
            value: 'Herbs',
          ),
          DropdownMenuItem<String>(
            child: Text(
              AppLocalizations.of(context)!.spices,
            ),
            value: 'Spices',
          ),
        ],
        onChanged: (value) {
          setState(() {
            _catValue = value!;
          });
        },
        hint: Text(
          AppLocalizations.of(context)!.select_category,
        ),
        value: _catValue,
      ),
    );
  }

  Future<void> _pickImage() async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _pickedImage = selected;
        });
      } else {
        log(
          AppLocalizations.of(context)!.no_file_selected,
        );
        // showToast("No file selected");
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _pickedImage = File("a");
          webImage = f;
        });
      } else {
        log(
          AppLocalizations.of(context)!.no_file_selected,
        );
      }
    } else {
      log(
        AppLocalizations.of(context)!.perm_not_granted,
      );
    }
  }
}
