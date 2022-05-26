import 'package:flutter/material.dart';
import 'package:order_app/bloc/pizza_order_provider.dart';
import 'package:order_app/model/pizza/ingredient.dart';

class PizzaIngredientView extends StatelessWidget {
  PizzaIngredientView({Key? key}) : super(key: key);

  final listIngredient = ingredients;

  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);
    return ValueListenableBuilder(
        valueListenable: bloc!.price,
        builder: (context, value, _) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: listIngredient.length,
            itemBuilder: (context, index) {
              final ingredient = listIngredient[index];
              return IngredientItemView(
                onTap: (){
                  bloc.removeIngredient(ingredient);
                },
                ingredient: ingredient,
                exist: !bloc.containsIngredient(ingredient),
              );
            },
          );
        });
  }
}

class IngredientItemView extends StatelessWidget {
  final Ingredient? ingredient;
  final bool? exist;
  final VoidCallback onTap;
  const IngredientItemView({Key? key, this.ingredient, this.exist, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Draggable(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Image(
                image: AssetImage(ingredient!.image),
                fit: BoxFit.contain,
              ),
              height: 48,
              width: 48,
              decoration:  BoxDecoration(
                color: const Color(0xFFF5EED3),
                shape: BoxShape.circle,
                border: Border.all( color: exist! ? Colors.orange : Colors.transparent, width: 2)
              ),
            ),
          ),
          feedback: Container(
            padding: const EdgeInsets.all(8),
            child: Image(
              image: AssetImage(ingredient!.image),
              fit: BoxFit.contain,
            ),
            height: 48,
            width: 48,
          ),
          data: ingredient,
        ),
      ),
    );
  }
}
