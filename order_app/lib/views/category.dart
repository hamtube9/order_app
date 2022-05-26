import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:order_app/bloc/coffee_order_bloc.dart';
import 'package:order_app/bloc/coffee_order_provider.dart';
import 'package:order_app/bloc/pizza_order_bloc.dart';
import 'package:order_app/bloc/pizza_order_provider.dart';
import 'package:order_app/utils/hive_services.dart';
import 'package:order_app/views/coffee/main_coffee_screen.dart';
import 'package:order_app/views/pizza/main_pizza_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 24,),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PizzaOrderProvider(child: const MainPizzaScreen(), bloc: PizzaOrderBloc(storage: GetIt.instance.get<LocalStorage>())),
            )),
            child: Container(
              height: 120,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: const [BoxShadow(blurRadius: 4, offset: Offset(-1, 0), color: Colors.grey)]),
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const Image(
                        image: AssetImage('assets/images/pizza/pizza-2.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    top: -10,
                    left: -40,
                    bottom: -10,
                    width: 140,
                  ),
                  Positioned(
                    child: Stack(
                      children: [
                        Positioned(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Pizza',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Size, toping, ...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          top: 16,
                          right: 16,
                          bottom: 16,
                          left: 0,
                        ),
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  'ADD',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          width: 60,
                          bottom: 0,
                          right: 0,
                        )
                      ],
                    ),
                    top: 0,
                    right: 0,
                    left: 120,
                    bottom: 0,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CoffeeOrderProvider(
                        child: const MainCoffeeScreen(),
                        bloc: CoffeeOrderBloc(localStorage: GetIt.instance.get<LocalStorage>()),
                      )),),
            child: Container(
              height: 120,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: const [BoxShadow(blurRadius: 4, offset: Offset(-1, 0), color: Colors.grey)]),
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const Image(
                        image: AssetImage('assets/images/coffee/2.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    top: 0,
                    left: -40,
                    bottom: -20,
                    width: 140,
                  ),
                  Positioned(
                    child: Stack(
                      children: [
                        Positioned(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Coffee',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Size, toping, ...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          top: 16,
                          right: 16,
                          bottom: 16,
                          left: 0,
                        ),
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  'ADD',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          width: 60,
                          bottom: 0,
                          right: 0,
                        )
                      ],
                    ),
                    top: 0,
                    right: 0,
                    left: 120,
                    bottom: 0,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
