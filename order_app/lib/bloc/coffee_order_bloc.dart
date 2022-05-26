import 'package:flutter/cupertino.dart';
import 'package:order_app/model/coffee/coffee_model.dart';
import 'package:order_app/model/order/item_order.dart';
import 'package:order_app/utils/hive_services.dart';

class CoffeeOrderBloc extends ChangeNotifier {
  final LocalStorage localStorage;
  final Coffee? coffee;

  CoffeeOrderBloc({
    this.coffee,
    required this.localStorage,
  });

  final ValueNotifier<SizeItem> notifierSize = ValueNotifier(SizeItem.m);
  final ValueNotifier<TypeUtility> notifierTypeUtil = ValueNotifier(TypeUtility.hot);
  final ValueNotifier<double> notifierItemSizePrice = ValueNotifier(0.0);
  final ValueNotifier<int> notifierCartItemAnimation = ValueNotifier(0);

  void getSizePricePercent(SizeItem coffeeSize) {
    notifyListeners();
    switch (coffeeSize) {
      case SizeItem.s:
        notifierItemSizePrice.value = 0.8;
        return;
      case SizeItem.m:
        notifierItemSizePrice.value = 1.0;
        return;
      case SizeItem.l:
        notifierItemSizePrice.value = 1.2;
        return;
      default:
        notifierItemSizePrice.value = 1.0;
        return;
    }
  }

  void changeTypeUtility(TypeUtility type) {
    notifierTypeUtil.value = type;
  }

  void checkTotalItem() async {
    var total = await localStorage.totalItem();
    notifierCartItemAnimation.value = total;
  }

  addItem() async {
    var itemOrder = ItemOrder(
        imagesByte: null,
        image: coffee!.image,
        name: coffee!.name,
        total: coffee!.price * notifierItemSizePrice.value,
        subItem: [SubItem(itemName: notifierTypeUtil.value.name)]);

    var totalItem = await localStorage.addOrder(itemOrder);

    notifierCartItemAnimation.value = totalItem;
  }
}
