import 'package:flutter/material.dart';
import 'package:order_app/bloc/cart_bloc.dart';

class CartProvider extends InheritedWidget {
  final CartBloc? bloc;
  final Widget child;

  const CartProvider({
    Key? key,
    this.bloc,
    required this.child,
  }) : super(key: key, child: child);

  static CartBloc? of(BuildContext context) => context.findAncestorWidgetOfExactType<CartProvider>()?.bloc;

  @override
  bool updateShouldNotify(covariant CartProvider oldWidget) => true;
}
