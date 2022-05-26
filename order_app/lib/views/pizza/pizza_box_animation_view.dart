import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:order_app/model/pizza/pizza_meta_data.dart';

class PizzaBoxAnimationView extends StatefulWidget {
  final PizzaMetaData? pizzaMetaData;
  final VoidCallback onComplete;

  const PizzaBoxAnimationView({Key? key, this.pizzaMetaData, required this.onComplete}) : super(key: key);

  @override
  _PizzaBoxAnimationViewState createState() => _PizzaBoxAnimationViewState();
}

class _PizzaBoxAnimationViewState extends State<PizzaBoxAnimationView> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> _pizzaScaleAnimation;
  late Animation<double> _pizzaOpacityAnimation;
  late Animation<double> _boxEnterScaleAnimation;
  late Animation<double> _boxExitScaleAnimation;
  late Animation<double> _boxExitCartAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500));
    _pizzaScaleAnimation = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(parent: animationController, curve: const Interval(0.0, 0.2)));
    _pizzaOpacityAnimation = CurvedAnimation(parent: animationController, curve: const Interval(0.2, 0.4));
    _boxEnterScaleAnimation = CurvedAnimation(parent: animationController, curve: const Interval(0.0, 0.2));
    _boxExitScaleAnimation = Tween(begin: 1.0, end: 1.3).animate(CurvedAnimation(parent: animationController, curve: const Interval(0.5, 0.7)));
    _boxExitCartAnimation = CurvedAnimation(parent: animationController, curve: const Interval(0.8, 1.0));

    animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
       widget.onComplete();
      }
    });
    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.pizzaMetaData!.position.dy,
      left: widget.pizzaMetaData!.position.dx,
      width: widget.pizzaMetaData!.size.width,
      height: widget.pizzaMetaData!.size.height,
      child: GestureDetector(
          onTap: () {
            widget.onComplete();
          },
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              final moveToX = _boxExitCartAnimation.value > 0
                  ? widget.pizzaMetaData!.position.dx + widget.pizzaMetaData!.size.width / 2 * _boxExitCartAnimation.value
                  : 0.0;
              final moveToY =  _boxExitCartAnimation.value > 0
              ? -widget.pizzaMetaData!.size.height/1.5 * _boxExitCartAnimation.value : 0.0;
              return Transform.scale(
                scale: 1- _boxExitCartAnimation.value,
                child: Transform(
                  transform: Matrix4.identity()..translate(moveToX,moveToY)
                    ..rotateZ(_boxExitCartAnimation.value)
                    ..scale(_boxExitScaleAnimation.value),
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      _buildBox(),
                      Opacity(
                        opacity: 1 - _pizzaOpacityAnimation.value,
                        child: Transform(
                            transform: Matrix4.identity()
                              ..scale(_pizzaScaleAnimation.value)
                              ..translate(0.0, 20 * (1 - _pizzaOpacityAnimation.value)),
                            alignment: Alignment.center,
                            child: Image.memory(widget.pizzaMetaData!.imagesByte)),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  _buildBox() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxHeight = constraints.maxHeight / 2;
        final boxWidth = constraints.maxWidth / 2;
        const minAngle = -45.0;
        const maxAngle = -125.0;
        final boxClosing = lerpDouble(minAngle, maxAngle, 1 - _pizzaOpacityAnimation.value);
        return Opacity(
          opacity: _boxEnterScaleAnimation.value,
          child: Transform.scale(
            child: Stack(
              children: [
                Center(
                  child: Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.003)
                        ..rotateX(degreesToRads(minAngle)),
                      child: Image.asset(
                        'assets/images/pizza/box_inside.png',
                        height: boxHeight,
                        width: boxWidth,
                      )),
                ),
                Center(
                  child: Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.003)
                        ..rotateX(degreesToRads(boxClosing!)),
                      child: Image.asset(
                        'assets/images/pizza/box_inside.png',
                        height: boxHeight,
                        width: boxWidth,
                      )),
                ),
                if (boxClosing >= -90)
                  Center(
                    child: Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.003)
                          ..rotateX(degreesToRads(boxClosing)),
                        child: Image.asset(
                          'assets/images/pizza/box_front.png',
                          height: boxHeight,
                          width: boxWidth,
                        )),
                  ),
              ],
            ),
            scale: _boxEnterScaleAnimation.value,
          ),
        );
      },
    );
  }

  double degreesToRads(double deg) {
    return (deg * pi) / 180.0;
  }
}
