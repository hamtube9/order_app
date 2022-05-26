import 'package:flutter/material.dart';
import 'package:order_app/bloc/coffee_order_bloc.dart';

class CoffeeOrderProvider extends InheritedWidget {
  final CoffeeOrderBloc? bloc;
  final Widget child;

  const CoffeeOrderProvider({
    Key? key,
    this.bloc,
    required this.child,
  }) : super(key: key, child: child);

  static CoffeeOrderBloc? of(BuildContext context) => context.findAncestorWidgetOfExactType<CoffeeOrderProvider>()?.bloc;

  @override
  bool updateShouldNotify(covariant CoffeeOrderProvider oldWidget) => true;
}