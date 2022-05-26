import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:order_app/bloc/coffee_order_bloc.dart';
import 'package:order_app/bloc/coffee_order_provider.dart';
import 'package:order_app/model/coffee/coffee_model.dart';
import 'package:order_app/model/coffee/slide_action.dart';
import 'package:order_app/utils/hive_services.dart';
import 'package:order_app/views/app_bar_view.dart';
import 'package:order_app/views/coffee/coffee_carousel_view.dart';
import 'package:order_app/views/coffee/order_screen.dart';
import 'package:order_app/views/coffee/title_coffee_view.dart';

class CoffeeListsCreen extends StatefulWidget {
  final SliderAction sliderAction;

  const CoffeeListsCreen({Key? key, required this.sliderAction}) : super(key: key);

  @override
  _CoffeeListsCreenState createState() => _CoffeeListsCreenState();
}

class _CoffeeListsCreenState extends State<CoffeeListsCreen> {
  late PageController _sliderPageController;
  late PageController _titlePageController;
  late int _index;
  late double _percent;
  late CoffeeOrderBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = CoffeeOrderProvider.of(context)!;
    _index = 2;
    _sliderPageController = PageController(initialPage: _index);
    _titlePageController = PageController(initialPage: _index);
    _percent = 0;
    _sliderPageController.addListener(_sliderPageListener);
    Future.delayed(const Duration(milliseconds: 400), () {
      _initAction(widget.sliderAction);
    });
    checkTotalItem();
  }

  checkTotalItem() {
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
    const coffeeList = Coffee.coffeeList;
    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder<int>(
              valueListenable: bloc.notifierCartItemAnimation,
              builder: (context, value, _) {
                return AppBarView(
                  totalItem: value,
                  brightness: Brightness.dark,
                  onTapBack: () => _onBackPress(context),
                  onTapCart: (){
                    checkTotalItem();
                  },
                );
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.17,
            child: PageView.builder(
              itemBuilder: (context, index) {
                return TitleCoffeeView(
                  price: coffeeList[index].price,
                  name: coffeeList[index].name,
                );
              },
              itemCount: coffeeList.length,
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
              CoffeeCarouselView(
                items: coffeeList,
                percent: _percent,
                index: _index,
              ),
              PageView.builder(
                onPageChanged: (value) {
                  _titlePageController.animateToPage(value, duration: const Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _openOderPage(context, coffeeList[index]),
                  );
                },
                controller: _sliderPageController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: coffeeList.length,
              )
            ],
          ))
        ],
      ),
    );
  }

  _openOderPage(BuildContext context, Coffee coffee) async {
    await Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: CoffeeOrderProvider(
            bloc: CoffeeOrderBloc(coffee: coffee, localStorage: GetIt.instance.get<LocalStorage>()),
            child: const CoffeeOrderScreen(),
          ),
        );
      },
    ));
    checkTotalItem();
  }
}
