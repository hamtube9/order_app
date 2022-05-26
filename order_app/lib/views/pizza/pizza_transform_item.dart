import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:order_app/model/pizza/pizza_model.dart';

class PizzaTransformItemView extends StatelessWidget {
  final double displacement;
  final double scale;
  final double? fixedScale;
  final bool isOverFlowed;
  final double endTransitionOpacity;
  final PizzaModel pizza;

  const PizzaTransformItemView(
      {Key? key,
        required this.displacement,
        this.scale = 1.0,
        this.fixedScale,
        this.isOverFlowed = false,
        this.endTransitionOpacity = 1.0,
        required this.pizza})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, displacement),
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.topCenter,
        child: AspectRatio(
          aspectRatio: 0.85,
          child: Hero(
            tag: pizza.name!,
            flightShuttleBuilder: (_, animation, __, ___, ____) {
              return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.scale(
                    scale: isOverFlowed ? lerpDouble(fixedScale, 1.0, animation.value) : 1.0,
                    child: Opacity(
                      opacity: lerpDouble(1.0, endTransitionOpacity, animation.value)!,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(pizza.image!),
              );
            },
            child: Image.asset(pizza.image!),
          ),
        ),
      ),
    );
  }
}