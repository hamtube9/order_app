import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:order_app/bloc/pizza_order_provider.dart';
import 'package:order_app/model/pizza/ingredient.dart';
import 'package:order_app/model/pizza/pizza_meta_data.dart';
import 'package:order_app/model/pizza/pizza_size.dart';
import 'package:order_app/views/pizza/pizza_box_animation_view.dart';
import 'package:order_app/views/pizza/pizza_size_button.dart';

class PizzaDetailView extends StatefulWidget {
  const PizzaDetailView({Key? key}) : super(key: key);

  @override
  _PizzaDetailViewState createState() => _PizzaDetailViewState();
}

class _PizzaDetailViewState extends State<PizzaDetailView> with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController animationRotationController;
  PizzaSize size = PizzaSize.m;
  List<Animation> animations = [];
  late BoxConstraints pizzaContrainst;
  final keyPizza = GlobalKey();

  _buildAnimationIngredient() {
    animations.clear();
    animations.add(CurvedAnimation(parent: animationController, curve: const Interval(0.0, 0.8, curve: Curves.decelerate)));
    animations.add(CurvedAnimation(parent: animationController, curve: const Interval(0.2, 0.8, curve: Curves.decelerate)));
    animations.add(CurvedAnimation(parent: animationController, curve: const Interval(0.4, 1.0, curve: Curves.decelerate)));
    animations.add(CurvedAnimation(parent: animationController, curve: const Interval(0.1, 0.7, curve: Curves.decelerate)));
    animations.add(CurvedAnimation(parent: animationController, curve: const Interval(0.3, 1.0, curve: Curves.decelerate)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    animationRotationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final bloc = PizzaOrderProvider.of(context);
      bloc!.animationPizzaBox.addListener(() {
        if(bloc.animationPizzaBox.value){
          _addPizzaToCart();
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
    animationRotationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = PizzaOrderProvider.of(context);
    return Column(
      children: [
        Expanded(
          child: DragTarget<Ingredient>(
            onAccept: (data) {
              bloc!.focusNotifier.value = false;
              bloc.addIngredient(data);
              _buildAnimationIngredient();
              animationController.forward(from: 0.0);
            },
            onWillAccept: (data) {
              bloc!.focusNotifier.value = true;
              return bloc.containsIngredient(data!);
            },
            onLeave: (data) {
              bloc!.focusNotifier.value = false;
            },
            builder: (context, list, rejectedData) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  pizzaContrainst = constraints;
                  return ValueListenableBuilder<PizzaMetaData?>(
                    valueListenable: bloc!.notifierPizzaMetaData,
                    builder: (context, metadata, _) {
                      if (metadata != null) {
                        Future.microtask(() => _startPizzaBoxAnimation(metadata));
                      }
                      return AnimatedOpacity(opacity: metadata != null ? 0.0:1.0, duration: const Duration(milliseconds: 500),
                      child: ValueListenableBuilder<PizzaSizeState>(
                        valueListenable: bloc.notifierPizzaSize,
                        builder: (context, pizza, child) {
                          return RepaintBoundary(
                            key: keyPizza,
                            child: RotationTransition(
                              turns: CurvedAnimation(
                                parent: animationRotationController,
                                curve: Curves.elasticOut,
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: ValueListenableBuilder<bool>(
                                      builder: (context, value, child) {
                                        return AnimatedContainer(
                                          duration: const Duration(milliseconds: 400),
                                          child: Stack(
                                            children:   [
                                              const DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26, offset: Offset(0.0, 4.0), spreadRadius: 4.0)],
                                                  ),
                                                  child: Image(image: AssetImage('assets/images/pizza/dish.png'))),
                                              Padding(
                                                child: Image(image: AssetImage(bloc.pizza!.image!)),
                                                padding: const EdgeInsets.all(10),
                                              ),
                                            ],
                                          ),
                                          height: value ? constraints.maxHeight * pizza.factor : (constraints.maxHeight - 24) * pizza.factor,
                                        );
                                      },
                                      valueListenable: bloc.focusNotifier,
                                    ),
                                  ),
                                  ValueListenableBuilder<Ingredient?>(
                                      valueListenable: bloc.notifierDeleteIngredient,
                                      builder: (context, value, _) {
                                        _animationDeleteIngredient(value);
                                        return AnimatedBuilder(
                                            animation: animationController,
                                            builder: (context, _) {
                                              return animations.isEmpty ? SizedBox.fromSize() : _buildIngredienItem(value);
                                            });
                                      })
                                ],
                              ),
                            ),
                          );
                        },
                      ),);
                    },
                  );
                },
              );
            },
          ),
          flex: 5,
        ),
        ValueListenableBuilder<double>(
            valueListenable: bloc!.price,
            builder: (context, value, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(Tween<Offset>(begin: const Offset(0.0, 0.0), end: Offset(0.0, animation.value))),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  '\$' + value.toString(),
                  key: UniqueKey(),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
                ),
              );
            }),
        const SizedBox(height: 12),
        Expanded(
          child: ValueListenableBuilder<PizzaSizeState>(
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PizzaSizeButton(
                      text: 'S',
                      onClick: () {
                        updateSizePizza(PizzaSize.s);
                      },
                      isSelected: value.size == PizzaSize.s,
                    ),
                    PizzaSizeButton(
                      text: 'M',
                      onClick: () {
                        updateSizePizza(PizzaSize.m);
                      },
                      isSelected: value.size == PizzaSize.m,
                    ),
                    PizzaSizeButton(
                      text: 'L',
                      onClick: () {
                        updateSizePizza(PizzaSize.l);
                      },
                      isSelected: value.size == PizzaSize.l,
                    ),
                  ],
                );
              },
              valueListenable: bloc.notifierPizzaSize),
          flex: 1,
        )
      ],
    );
  }

  Future<void> _animationDeleteIngredient(Ingredient? ingredient) async {
    if (ingredient != null) {
      await animationController.reverse(from: 1.0);
      PizzaOrderProvider.of(context)!.refresh();
    }
  }

  _buildIngredienItem(Ingredient? deleteIngredient) {
    List<Widget> elements = [];

    final listIngredients = List.from(PizzaOrderProvider.of(context)!.ingredients);
    if (deleteIngredient != null) {
      listIngredients.add(deleteIngredient);
    }

    if (animations.isNotEmpty) {
      for (int i = 0; i < listIngredients.length; i++) {
        Ingredient ingre = listIngredients[i];
        final image = Image.asset(
          ingre.imageUnit,
          height: 32,
        );
        for (int j = 0; j < ingre.position.length; j++) {
          final animation = animations[j];
          final position = ingre.position[j];
          final positionX = position.dx;
          final positionY = position.dy;
          double fromX = 0.0;
          double fromY = 0.0;

          if (i == listIngredients.length - 1 && animationController.isAnimating) {
            if (j < 1) {
              fromX = -pizzaContrainst.maxWidth * (1 - animation.value);
            } else if (j < 2) {
              fromX = -pizzaContrainst.maxWidth * (1 - animation.value);
            } else if (j < 4) {
              fromY = -pizzaContrainst.maxHeight * (1 - animation.value);
            } else {
              fromY = -pizzaContrainst.maxHeight * (1 - animation.value);
            }
            elements.add(Transform(
                transform: Matrix4.identity()..translate(fromX + pizzaContrainst.maxWidth * positionY, fromY + pizzaContrainst.maxHeight * positionX),
                child: image));
          } else {
            elements.add(
                Transform(transform: Matrix4.identity()..translate(pizzaContrainst.maxWidth * positionY, pizzaContrainst.maxHeight * positionX), child: image));
          }
        }
      }
    }

    return Stack(
      children: elements,
    );
  }

  void updateSizePizza(PizzaSize size) {
    animationRotationController.forward(from: 0.0);
    PizzaOrderProvider.of(context)!.notifierPizzaSize.value = PizzaSizeState(size);
  }

  void _addPizzaToCart() {
    RenderRepaintBoundary boundary = keyPizza.currentContext?.findRenderObject() as RenderRepaintBoundary;
    PizzaOrderProvider.of(context)?.transformToImage(boundary);
  }

  OverlayEntry? _overlayEntry;

  _startPizzaBoxAnimation(PizzaMetaData metadata) {
    final bloc = PizzaOrderProvider.of(context)!;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) {
          return PizzaBoxAnimationView(
            onComplete: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
              bloc.reset();
            },
            pizzaMetaData: metadata,
          );
        },
      );
      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }
}
