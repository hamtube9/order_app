import 'dart:ui';

import 'package:flutter/material.dart';

import '../../model/coffee/coffee_model.dart';

class CoffeeCarouselView extends StatelessWidget {
  final double percent;
  final List<Coffee> items;
  final int index;

  const CoffeeCarouselView({Key? key, required this.percent, required this.items, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return Stack(
          alignment: Alignment.center,
          children: [
            if (index > 1)
              ItemCarousel(
                coffee: items[index - 2],
                scale: lerpDouble(0.3, 0, percent)!,
                opacity: lerpDouble(0.5, 0, percent)!,
              ),
            if (index > 0)
              ItemCarousel(
                coffee: items[index - 1],
                displacement: lerpDouble((height * 0.1), 0, percent)!,
                scale: lerpDouble(0.6, 0.3, percent)!,
                opacity: lerpDouble(0.8, 0.5, percent)!,
              ),
            ItemCarousel(
              coffee: items[index],
              displacement: lerpDouble(height * 0.25, height * 0.1, percent)!,
              scale: lerpDouble(1.0, 0.6, percent)!,
              opacity: lerpDouble(1.0, 0.8, percent)!,
            ),
            if (index < items.length - 1)
              ItemCarousel(
                coffee: items[index + 1],
                displacement: lerpDouble(height, height * 0.25, percent)!,
                scale: lerpDouble(2.0, 1.0, percent)!,

              )
          ],
        );
      },
    );
  }
}

class ItemCarousel extends StatelessWidget {
  final double displacement;
  final double scale;
  final double opacity;
  final Coffee coffee;

  const ItemCarousel({Key? key,
    this.displacement = 0.0,
    this.scale = 1.0,
    this.opacity = 1.0,
    required this.coffee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, displacement),
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.topCenter,
        child: Opacity(
          opacity: opacity,
          child: ItemImage(coffee: coffee),
        ),
      ),
    );
  }
}


class ItemImage extends StatelessWidget {
  const ItemImage({
    Key? key,
    required this.coffee,
  }) : super(key: key);
  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: AspectRatio(
        aspectRatio: 0.85,
        child: Hero(
          tag: coffee.name,
          child: Image.asset(
            coffee.image,
          ),
        ),
      ),
    );
  }
}