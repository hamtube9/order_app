import 'package:flutter/cupertino.dart';
import 'package:order_app/bloc/pizza_order_bloc.dart';

class PizzaOrderProvider extends InheritedWidget {
  final PizzaOrderBloc? bloc;
  final Widget child;

  const PizzaOrderProvider({
    Key? key,
     this.bloc,
    required this.child,
  }) : super(key: key, child: child);

  static PizzaOrderBloc? of(BuildContext context) => context.findAncestorWidgetOfExactType<PizzaOrderProvider>()?.bloc;

  @override
  bool updateShouldNotify(covariant PizzaOrderProvider oldWidget) => true;
}
