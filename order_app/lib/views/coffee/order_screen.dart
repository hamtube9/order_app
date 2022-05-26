import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:order_app/bloc/coffee_order_bloc.dart';
import 'package:order_app/bloc/coffee_order_provider.dart';
import 'package:order_app/model/coffee/coffee_model.dart';

class CoffeeOrderScreen extends StatefulWidget {
  const CoffeeOrderScreen({Key? key}) : super(key: key);

  @override
  _CoffeeOrderScreenState createState() => _CoffeeOrderScreenState();
}

class _CoffeeOrderScreenState extends State<CoffeeOrderScreen> {
  late PageController _pageController;
  late CoffeeOrderBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: 1);
    bloc = CoffeeOrderProvider.of(context)!;
    bloc.checkTotalItem();
  }

  void _changeCoffeeSize(SizeItem coffeeSize) {
    _pageController.animateToPage(
      coffeeSize.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
    bloc.notifierSize.value = coffeeSize;
    bloc.getSizePricePercent(coffeeSize);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
      body: Column(
        children: [
          SizedBox(
            width: size.width * .65,
            child: Hero(
              tag: bloc.coffee!.name + "title",
              child: Text(
                bloc.coffee!.name,
                style: Theme.of(context).textTheme.headline5,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //------------------------
          // Coffee Image
          //------------------------
          Expanded(
            flex: 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: bloc.coffee!.name,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: Image.asset(bloc.coffee!.image),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Image.asset(bloc.coffee!.image),
                        ),
                        Image.asset(bloc.coffee!.image),
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder<double>(
                    valueListenable: bloc.notifierItemSizePrice,
                    builder: (context, sizeItem, _) {
                      return Align(
                        alignment: const Alignment(-.7, .8),
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 600),
                          tween: Tween(begin: 1.0, end: 0.0),
                          curve: Curves.fastOutSlowIn,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(-(size.width * .5) * value, (size.height * .4) * value),
                              child: child,
                            );
                          },
                          child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 600),
                              tween: Tween(
                                begin: 0.0,
                                end: sizeItem,
                              ),
                              curve: Curves.fastOutSlowIn,
                              builder: (context, value, _) {
                                return Transform.scale(
                                  scale: value,
                                  child: Text(
                                    "${(bloc.coffee!.price * value).toStringAsFixed(1)}\$",
                                    style: Theme.of(context).textTheme.headline2!.copyWith(
                                      color: Colors.white,
                                      shadows: [
                                        const Shadow(
                                          color: Colors.black54,
                                          blurRadius: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      );
                    }),
                Align(
                  alignment: const Alignment(.7, -.7),
                  child: FloatingActionButton(
                    onPressed: () {bloc.addItem();},
                    mini: true,
                    elevation: 10,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.brown[700],
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),
          ),
          //------------------------
          // Coffee Sizes
          //------------------------
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 1.0, end: 0.0),
              curve: Curves.fastOutSlowIn,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, (size.height * .2) * value),
                  child: child,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(SizeItem.values.length, (index) {
                  final coffeeSize = SizeItem.values[index];
                  //----------------------------
                  // Coffee Size Option
                  //----------------------------
                  return ValueListenableBuilder(
                      valueListenable: bloc.notifierSize,
                      builder: (context, size, _) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: _CoffeeSizeOption(isSelected: (coffeeSize == size), coffeeSize: coffeeSize, onTap: () => _changeCoffeeSize(coffeeSize)),
                        );
                      });
                }),
              ),
            ),
          ),
          SizedBox(
            height: 64,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 1.0, end: 0.0),
              curve: Curves.fastOutSlowIn,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, (size.height * .2) * value),
                  child: child,
                );
              },
              child: _CoffeeTemperatures(
                onClickType: (type) {
                  bloc.changeTypeUtility(type);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoffeeTemperatures extends StatelessWidget {
  final Function(TypeUtility) onClickType;

  const _CoffeeTemperatures({
    Key? key,
    required this.onClickType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = CoffeeOrderProvider.of(context)!;
    return ValueListenableBuilder<TypeUtility>(
        valueListenable: bloc.notifierTypeUtil,
        builder: (context, type, _) {
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onClickType(TypeUtility.hot);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: type == TypeUtility.hot
                        ? const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(3, 10))])
                        : null,
                    child: Text(
                      'Hot | Warm',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: type == TypeUtility.hot ? Colors.brown[700] : Colors.grey[400]),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onClickType(TypeUtility.cold);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: type == TypeUtility.cold
                        ? const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(3, 10))])
                        : null,
                    child: Text(
                      'Cold | Ice',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: type == TypeUtility.cold ? Colors.brown[700] : Colors.grey[400]),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class _CoffeeSizeOption extends StatelessWidget {
  const _CoffeeSizeOption({
    Key? key,
    required this.isSelected,
    required this.coffeeSize,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final SizeItem coffeeSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelSize = coffeeSize.toString().split('.')[1][0].toLowerCase();
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isSelected ? [Colors.brown, Colors.orange] : [Colors.grey[300]!, Colors.grey[300]!],
        ).createShader(bounds),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/svg/$labelSize-coffee-cup.svg",
              width: 45.0,
              color: Colors.white,
            ),
            Text(
              labelSize.toUpperCase(),
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.white,
                  ),
            )
          ],
        ),
      ),
    );
  }
}

class IconCartView extends StatefulWidget {
  const IconCartView({Key? key}) : super(key: key);

  @override
  _IconCartViewState createState() => _IconCartViewState();
}

class _IconCartViewState extends State<IconCartView> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  int items = 0;
  late Animation<double> animationScaleIn;
  late Animation<double> animationScaleOut;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    animationScaleIn = CurvedAnimation(parent: controller, curve: const Interval(0.5, 1.0));
    animationScaleOut = CurvedAnimation(parent: controller, curve: const Interval(0.0, 0.5));
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final bloc = CoffeeOrderProvider.of(context);
      bloc!.notifierCartItemAnimation.addListener(() {
        items = bloc.notifierCartItemAnimation.value;
        controller.forward(from: 0.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          double? scale;
          const scaleFactor = 0.5;
          if (animationScaleOut.value < 1.0) {
            scale = 1.0 + scaleFactor * animationScaleOut.value;
          } else if (animationScaleIn.value <= 1.0) {
            scale = (1.0 + scaleFactor) - scaleFactor * animationScaleIn.value;
          }
          return Transform.scale(
            alignment: Alignment.center,
            scale: scale,
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.brown,
                  ),
                  onPressed: () {},
                ),
                if(animationScaleOut.value > 0)
                  Positioned(
                    child: Transform.scale(
                      scale: animationScaleOut.value,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.red,
                        child: Text(
                          items.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                    top: 6,
                    right: 6,
                  )
              ],
            ),
          );
        });
  }
}

