import 'package:flutter/foundation.dart';
import 'package:order_app/model/order/item_order.dart';
import 'package:order_app/utils/hive_services.dart';

class CartBloc extends ChangeNotifier {
  final LocalStorage localStorage;

  CartBloc(this.localStorage);
  ValueNotifier<List<ItemOrder>?> notifierListItem = ValueNotifier<List<ItemOrder>?>(null);
  ValueNotifier<double> notifierPrice = ValueNotifier<double>(0.0);

  void getAllLocalItemCart() async {
    double price  = 0;
    var list = await localStorage.getListOrder();
    if (list != null) {
      notifierListItem.value = list;
      list.forEach((element) {
        price += element.total;
      });
      notifierPrice.value = price;
    }
  }

  void onDeleteItem(ItemOrder item){
    var list = notifierListItem.value;
    list!.remove(item);
    localStorage.updateListCart(list);
    notifierListItem.value = list;
  }
}
