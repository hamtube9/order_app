import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_app/bloc/coffee_order_bloc.dart';
import 'package:order_app/bloc/coffee_order_provider.dart';
import 'package:order_app/model/coffee/coffee_model.dart';
import 'package:order_app/model/coffee/slide_action.dart';
import 'package:order_app/utils/hive_services.dart';
import 'package:order_app/views/app_bar_view.dart';
import 'package:order_app/views/coffee/coffee_list_screen.dart';
import 'package:order_app/views/coffee/transform_item_view.dart';

class MainCoffeeScreen extends StatefulWidget {
  const MainCoffeeScreen({Key? key}) : super(key: key);

  @override
  _MainCoffeeScreenState createState() => _MainCoffeeScreenState();
}

class _MainCoffeeScreenState extends State<MainCoffeeScreen> {
  final coffeeList = Coffee.coffeeList;
  late CoffeeOrderBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = CoffeeOrderProvider.of(context)!;
    checkTotalItem();
  }

  checkTotalItem() {
    bloc.checkTotalItem();
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
                      totalItem: value,
                      brightness: Brightness.dark,
                      onTapCart: (){
                        checkTotalItem();
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
            CoffeeTransformItemView(
              displacement: 0,
              coffee: coffeeList[0],
              scale: 0.4,
              endTransitionOpacity: 0.5,
            ),
            CoffeeTransformItemView(
              displacement: height * 0.1,
              coffee: coffeeList[1],
              scale: 1.1,
              endTransitionOpacity: 0.8,
            ),
            CoffeeTransformItemView(
              displacement: height * 0.23,
              coffee: coffeeList[2],
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
                  TextSpan(text: '\nCoffee', style: GoogleFonts.poppins(height: 1.0, fontSize: 60))
                ]),
              ),
            ),
            CoffeeTransformItemView(
              displacement: height * 0.75,
              coffee: coffeeList[3],
              scale: 1.75,
              isOverFlowed: true,
              fixedScale: 1.5,
            ),
          ],
        ),
      );
    });
  }

  _openCoffeeListPage(context, SliderAction action) async {
    await Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: CoffeeOrderProvider(
              child: CoffeeListsCreen(sliderAction: action),
              bloc: CoffeeOrderBloc(localStorage: GetIt.instance.get<LocalStorage>()),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400)));

    checkTotalItem();
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
