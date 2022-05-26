import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:order_app/model/order/item_order.dart';
import 'package:path_provider/path_provider.dart';

@injectable
class LocalStorage {
  final String key_box = "ORDER_APP_NGAOSCHOS";
  final String key_list_order = "ORDER_LIST";

  List<ItemOrder>? listItem;

  ini() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    Hive.init(appDocPath);
    var box = await Hive.openBox(key_box);
  }

  Future<List<ItemOrder>?> getListOrder() async {
    var box = await Hive.openBox(key_box);
    String? list = box.get(key_list_order);
    if (list == null) {
      listItem = [];
    } else {
      listItem = List<ItemOrder>.from(jsonDecode(list).map((x) => ItemOrder.fromJson(x)));
    }
    return listItem;
  }

  Future<int> addOrder(ItemOrder item) async {
    var box = await Hive.openBox(key_box);
    String? list = box.get(key_list_order);
    if (list == null) {
      listItem = [];
    } else {
      var a = jsonDecode(list);
      listItem = List<ItemOrder>.from(jsonDecode(list).map((x) => ItemOrder.fromJson(x)));
    }
    listItem!.add(item);
    await box.put(key_list_order, jsonEncode(listItem));
    return listItem != null ? listItem!.length : 0;
  }

  Future<void> reset() async {
    var box = await Hive.openBox(key_box);
    await box.delete(key_list_order);
  }

  Future<int> totalItem() async {
    var box = await Hive.openBox(key_box);
    String? list = box.get(key_list_order);
    if (list == null) {
      listItem = [];
    } else {
      listItem = List<ItemOrder>.from(jsonDecode(list).map((x) => ItemOrder.fromJson(x)));
    }
    return listItem != null ? listItem!.length : 0;
  }

  void dispose() async {
    await Hive.close();
  }

  void updateListCart(List<ItemOrder> list) async {
    var box = await Hive.openBox(key_box);
    await box.put(key_list_order, jsonEncode(list));
  }
}
