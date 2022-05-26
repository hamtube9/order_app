import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:order_app/bloc/pizza_order_bloc.dart';
import 'package:order_app/bloc/pizza_order_provider.dart';
import 'package:order_app/model/coffee/slide_action.dart';
import 'package:order_app/model/pizza/pizza_model.dart';
import 'package:order_app/utils/hive_services.dart';
import 'package:order_app/views/app_bar_view.dart';
import 'package:order_app/views/coffee/title_coffee_view.dart';
import 'package:order_app/views/pizza/pizza_carousel.dart';
import 'package:order_app/views/pizza/pizza_order_screen.dart';

class PizzaListsCreen extends StatefulWidget {
  final SliderAction sliderAction;

  const PizzaListsCreen({Key? key, required this.sliderAction}) : super(key: key);

  @override
  PizzaListsCreenState createState() => PizzaListsCreenState();
}

class PizzaListsCreenState extends State<PizzaListsCreen> {
  late PageController _sliderPageController;
  late PageController _titlePageController;
  late int _index;
  late double _percent;
  late PizzaOrderBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _index = 2;
    _sliderPageController = PageController(initialPage: _index);
    _titlePageController = PageController(initialPage: _index);
    _percent = 0;
    _sliderPageController.addListener(_sliderPageListener);
    Future.delayed(const Duration(milliseconds: 400), () {
      _initAction(widget.sliderAction);
    });
    initTotalItem();
  }

  initTotalItem() {
    bloc = PizzaOrderProvider.of(context)!;
    checkItem();
  }

  checkItem() {
    bloc.checkTotalItem();
  }

  _initAction(SliderAction sliderAction) {
    switch (sliderAction) {
      case SliderAction.next:
        _sliderPageController.nextPage(duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
        break;
      case SliderAction.prev:
        _sliderPageController.previousPage(duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
        break;
      default:
        break;
    }
  }

  void _sliderPageListener() {
    _index = _sliderPageController.page!.floor();
    _percent = (_sliderPageController.page! - _index).abs();
    setState(() {});
  }

  _onBackPress(context) async {
    await _sliderPageController.animateToPage(2, duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _sliderPageController.removeListener(_sliderPageListener);
    _sliderPageController.dispose();
    _titlePageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pizzaList = pizzalAll;
    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder<int>(
              valueListenable: bloc.notifierCartItemAnimation,
              builder: (context, value, _) {
                return AppBarView(
                  brightness: Brightness.dark,
                  totalItem: value,
                  onTapBack: () => _onBackPress(context),
                  onTapCart: (){
                    checkItem();
                  },
                );
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.17,
            child: PageView.builder(
              itemBuilder: (context, index) {
                return TitleCoffeeView(
                  price: pizzaList[index].price!,
                  name: pizzaList[index].name!,
                );
              },
              itemCount: pizzaList.length,
              controller: _titlePageController,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
          Expanded(
              child: Stack(
            children: [
              Positioned.fill(
                  child: Container(
                decoration: const BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.75, 1.0], colors: [Colors.white, Color(0xFFbf7840)])),
              )),
              PizzaCarouselView(
                items: pizzaList,
                percent: _percent,
                index: _index,
              ),
              PageView.builder(
                onPageChanged: (value) {
                  _titlePageController.animateToPage(value, duration: const Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _openOderPage(context, pizzaList[index]),
                  );
                },
                controller: _sliderPageController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: pizzaList.length,
              )
            ],
          ))
        ],
      ),
    );
  }

  _openOderPage(BuildContext context, PizzaModel pizza) async {
    await Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: PizzaOrderProvider(
            child: const PizzaOrderScreen(),
            bloc: PizzaOrderBloc(storage: GetIt.instance.get<LocalStorage>(), pizza: pizza),
          ),
        );
      },
    ));
    checkItem();
  }
}
