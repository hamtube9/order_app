import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_app/bloc/pizza_order_bloc.dart';
import 'package:order_app/bloc/pizza_order_provider.dart';
import 'package:order_app/model/coffee/slide_action.dart';
import 'package:order_app/model/pizza/pizza_model.dart';
import 'package:order_app/utils/hive_services.dart';
import 'package:order_app/views/app_bar_view.dart';
import 'package:order_app/views/pizza/pizza_list_screen.dart';
import 'package:order_app/views/pizza/pizza_transform_item.dart';

class MainPizzaScreen extends StatefulWidget {
  const MainPizzaScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPizzaScreenState();
}

class MainPizzaScreenState extends State<MainPizzaScreen> {
  final pizzaList = pizzalAll;
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.brown, Colors.white], begin: Alignment.topCenter, end: Alignment(0, -0.3)))),
          Column(
            children: [
              ValueListenableBuilder<int>(
                  valueListenable: bloc.notifierCartItemAnimation,
                  builder: (context, value, _) {
                    return AppBarView(
                      brightness: Brightness.dark,
                      totalItem: value,
                      onTapCart: (){
                        checkItem();
                      },
                    );
                  }),
              Expanded(child: _layoutBuilder())
            ],
          )
        ],
      ),
    );
  }

  _layoutBuilder() {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;
      return GestureDetector(
        onTap: () => _openCoffeeListPage(context, SliderAction.none),
        onVerticalDragUpdate: (detail) {
          _onVerticalDragUpdate(context, detail);
        },
        child: Stack(
          children: [
            PizzaTransformItemView(
              displacement: 0,
              pizza: pizzaList[0],
              scale: 0.4,
              endTransitionOpacity: 0.5,
            ),
            PizzaTransformItemView(
              displacement: height * 0.1,
              pizza: pizzaList[1],
              scale: 1.1,
              endTransitionOpacity: 0.8,
            ),
            PizzaTransformItemView(
              displacement: height * 0.23,
              pizza: pizzaList[2],
              scale: 1.45,
              isOverFlowed: true,
              fixedScale: 1.2,
            ),
            Align(
              alignment: const Alignment(0, 0.4),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(text: 'Ngaoschos', style: GoogleFonts.lilitaOne(fontSize: 70, color: Colors.white.withOpacity(0.9))),
                  TextSpan(text: '\nPizza', style: GoogleFonts.poppins(height: 1.0, fontSize: 60))
                ]),
              ),
            ),
            PizzaTransformItemView(
              displacement: height * 0.75,
              pizza: pizzaList[3],
              scale: 1.75,
              isOverFlowed: true,
              fixedScale: 1.5,
            ),
          ],
        ),
      );
    });
  }

  _openCoffeeListPage(context, SliderAction action) async  {
   await  Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: PizzaOrderProvider(child: PizzaListsCreen(sliderAction: action), bloc: PizzaOrderBloc(storage: GetIt.instance.get<LocalStorage>())),
          );
        },
        transitionDuration: const Duration(milliseconds: 400)));

   checkItem();
  }

  _onVerticalDragUpdate(BuildContext context, DragUpdateDetails detail) {
    if (detail.primaryDelta! > 2.0) {
      _openCoffeeListPage(context, SliderAction.prev);
    }
    if (detail.primaryDelta! < -2.0) {
      _openCoffeeListPage(context, SliderAction.next);
    }
  }
}
