import 'dart:io';

import 'package:flutter/material.dart';
import 'package:order_app/bloc/cart_bloc.dart';
import 'package:order_app/bloc/cart_provider.dart';
import 'package:order_app/model/order/item_order.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = CartProvider.of(context)!;
    bloc.getAllLocalItemCart();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.brown,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(8),
            child: ValueListenableBuilder<List<ItemOrder>?>(
                valueListenable: bloc.notifierListItem,
                builder: (context, list, _) {
                  if (list == null) {
                    return const Center(
                      child: Text('No Item'),
                    );
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final item = list[index];

                      return ItemCartView(
                        width: width,
                        item: item,
                        onDelete: () {
                          list.remove(item);
                          bloc.onDeleteItem(item);
                          setState(() {});
                        },
                      );
                    },
                    shrinkWrap: true,
                    itemCount: list.length,
                  );
                }),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(bottomLeft: const Radius.circular(24), bottomRight: const Radius.circular(24)),
                color: Colors.grey.shade200),
          )),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Total'),
                      ValueListenableBuilder<double>(
                          valueListenable: bloc.notifierPrice,
                          builder: (context, value, _) {
                            return Text(
                              '\$' + value.toString(),
                              style: const TextStyle(fontSize: 20),
                            );
                          })
                    ],
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Colors.white),
                    child: Row(
                      children: const [
                        Text(
                          'Place Order',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    margin: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ItemCartView extends StatelessWidget {
  final ItemOrder item;
  final double width;
  final VoidCallback onDelete;

  ItemCartView({Key? key, required this.width, required this.item, required this.onDelete}) : super(key: key);
  ValueNotifier<double> notifierDrag = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (item.imagesByte != null) {
      image = Image(image: FileImage(File(item.imagesByte!)));
    } else {
      image = Image(image: AssetImage(item.image!));
    }

    return GestureDetector(
      onHorizontalDragUpdate: (detail) {
        notifierDrag.value = detail.primaryDelta!;
      },
      child: Container(
        height: 120,
        child: ValueListenableBuilder<double>(
          valueListenable: notifierDrag,
          builder: (context, d, _) {
            return Stack(
              children: [
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      onDelete();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: width * 0.3,
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  left: 8,
                  top: 8,
                  bottom: 8,
                ),
                AnimatedPositioned(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          child: image,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Text(item.name),
                            Text(
                              '\$' + item.total.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(_textSubTitle())
                          ],
                        ))
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [BoxShadow(blurRadius: 2.0, offset: const Offset(0, 0), color: Colors.grey.shade100)]),
                  ),
                  duration: const Duration(milliseconds: 200),
                  top: 8,
                  left: d > 0.0 ? width * 0.15 : 8,
                  right: d > 0.0 ? -width * 0.15 : 8,
                  bottom: 8,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _textSubTitle() {
    if (item.subItem == null) {
      return '';
    }
    String t = '';
    for (var i = 0; i < item.subItem!.length; i++) {
      if (i + 1 == item.subItem!.length) {
        t += item.subItem![i].itemName!;
      } else {
        t += item.subItem![i].itemName! + ', ';
      }
    }

    return t;
  }
}
