import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:order_app/bloc/cart_bloc.dart';
import 'package:order_app/bloc/cart_provider.dart';
import 'package:order_app/utils/hive_services.dart';
import 'package:order_app/views/cart/cart_view.dart';

class AppBarView extends StatelessWidget {
  final int? totalItem;
  final Brightness brightness;
  final VoidCallback? onTapBack;
  final VoidCallback onTapCart;

  const AppBarView({Key? key, this.brightness = Brightness.dark, this.onTapBack, this.totalItem = 0, required this.onTapCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isDardBrightness = brightness == Brightness.dark;
    final colorIcon = _isDardBrightness ? Colors.brown : Colors.white;
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTapBack ??
                () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                },
            child: Icon(
              Icons.arrow_back_ios,
              color: colorIcon,
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.brown,
                ),
                onPressed: () => navigateToCartScreen(context),
              ),
              Positioned(
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.red,
                  child: Text(
                    totalItem.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                top: 6,
                right: 6,
              )
            ],
          )
        ],
      ),
    ));
  }

  navigateToCartScreen(context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CartProvider(child: const CartScreen(), bloc: CartBloc(GetIt.instance.get<LocalStorage>())),
    ));
    onTapCart();
  }
}
