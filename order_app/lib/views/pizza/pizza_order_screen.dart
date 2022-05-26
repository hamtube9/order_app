import 'package:flutter/material.dart';
import 'package:order_app/bloc/pizza_order_bloc.dart';
import 'package:order_app/bloc/pizza_order_provider.dart';
import 'package:order_app/views/pizza/icon_cart_view.dart';
import 'package:order_app/views/pizza/pizza_detail_view.dart';
import 'package:order_app/views/pizza/pizza_ingredient_view.dart';

class PizzaOrderScreen extends StatefulWidget {
  const PizzaOrderScreen({Key? key}) : super(key: key);

  @override
  _PizzaOrderScreenState createState() => _PizzaOrderScreenState();
}

class _PizzaOrderScreenState extends State<PizzaOrderScreen> {
  late PizzaOrderBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = PizzaOrderProvider.of(context)!;
    checkItem();
  }

  checkItem(){
    bloc.checkTotalItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Order Pizza',
          style: TextStyle(color: Colors.brown),
        ),
        elevation: 0.0,
        actions: const [IconCartView()],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 60,
            left: 8,
            right: 8,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Expanded(
                    child: PizzaDetailView(),
                    flex: 6,
                  ),
                  Expanded(
                    child: PizzaIngredientView(),
                    flex: 1,
                  ),
                  const SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 44,
              height: 40,
              width: 40,
              left: MediaQuery.of(context).size.width / 2 - 24,
              child: GestureDetector(
                onTap: () {
                  bloc.startAnimationPizzaBox();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.brown,
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                        colors: [Colors.orange.withOpacity(0.6), Colors.orange],
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
              ))
        ],
      ),
    );
  }
}


