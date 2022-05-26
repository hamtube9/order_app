import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/rendering/proxy_box.dart';
import 'package:order_app/model/order/item_order.dart';
import 'package:order_app/model/pizza/ingredient.dart';
import 'package:order_app/model/pizza/pizza_meta_data.dart';
import 'package:order_app/model/pizza/pizza_model.dart';
import 'package:order_app/model/pizza/pizza_size.dart';
import 'package:order_app/utils/hive_services.dart';
import 'package:path_provider/path_provider.dart';

class PizzaOrderBloc extends ChangeNotifier {
  final LocalStorage storage;
  final PizzaModel? pizza;

  PizzaOrderBloc({required this.storage,  this.pizza});

  final List<Ingredient> ingredients = [];
  final price = ValueNotifier(15.0);
  final notifierDeleteIngredient = ValueNotifier<Ingredient?>(null);
  final ValueNotifier<bool> focusNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> animationPizzaBox = ValueNotifier<bool>(false);
  final ValueNotifier<PizzaSizeState> notifierPizzaSize = ValueNotifier<PizzaSizeState>(PizzaSizeState(PizzaSize.m));
  final ValueNotifier<PizzaMetaData?> notifierPizzaMetaData = ValueNotifier<PizzaMetaData?>(null);
  final ValueNotifier<int> notifierCartItemAnimation = ValueNotifier(0);

  void addIngredient(Ingredient ingredient) {
    ingredients.add(ingredient);
    price.value += ingredient.price;
    notifyListeners();
  }

  bool containsIngredient(Ingredient ingredient) {
    return ingredients.where((element) => element.id == ingredient.id).isEmpty;
  }

  void removeIngredient(Ingredient ingredient) {
    if (!containsIngredient(ingredient)) {
      price.value -= ingredient.price;
      notifierDeleteIngredient.value = ingredient;
      ingredients.remove(ingredient);
      notifyListeners();
    }
  }


  void refresh() {
    notifierDeleteIngredient.value = null;
  }

  void reset() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    File file = await File('${appDocPath}/image_${pizza!.name!.replaceAll(' ', '')}.png').create();
    file.writeAsBytesSync(notifierPizzaMetaData.value!.imagesByte);
    var itemOrder = ItemOrder(
        imagesByte: file.path,
        image: pizza?.image,
        name: 'pizza something',
        total: price.value,
        subItem: ingredients.map((e) => SubItem(itemName: e.nameItem)).toList());

    var totalItem = await storage.addOrder(itemOrder);

    animationPizzaBox.value = false;
    notifierPizzaMetaData.value = null;
    price.value = 15;
    ingredients.clear();
    notifierCartItemAnimation.value = totalItem;
  }

  void startAnimationPizzaBox() {
    animationPizzaBox.value = true;
  }

  void transformToImage(RenderRepaintBoundary boundary) async {
    final position = boundary.localToGlobal(Offset.zero);
    final size = boundary.size;
    final image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    notifierPizzaMetaData.value = PizzaMetaData(byteData!.buffer.asUint8List(), position, size);
  }

  void checkTotalItem() async {
    var total =  await storage.totalItem();
    notifierCartItemAnimation.value =total;
  }

  void disposeStorage(){
    storage.dispose();
  }
}
