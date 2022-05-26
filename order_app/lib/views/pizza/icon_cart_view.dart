import 'package:flutter/material.dart';
import 'package:order_app/bloc/pizza_order_provider.dart';

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
      final bloc = PizzaOrderProvider.of(context);
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
