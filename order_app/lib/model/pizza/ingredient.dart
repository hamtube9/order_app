import 'package:flutter/cupertino.dart';

class Ingredient {
  final String image;
  final String nameItem;
  final String imageUnit;
  final int id;
  final double price;
  final List<Offset> position;

  Ingredient(this.image, this.id, this.price, this.position, this.imageUnit, this.nameItem);

}

final ingredients = [
  Ingredient('assets/images/pizza/chili.png', 1,2.5,
  const [
    Offset(0.3,0.3),
    Offset(0.6,0.4),
    Offset(0.4,0.25),
    Offset(0.5,0.3),
    Offset(0.4,0.65),
  ],'assets/images/pizza/chili_unit.png',
    'chili'
  ),
  Ingredient('assets/images/pizza/garlic.png', 2,3,
      const [
        Offset(0.45,0.35),
        Offset(0.65,0.35),
        Offset(0.3,0.23),
        Offset(0.5,0.2),
        Offset(0.3 ,0.5),
      ],
      'assets/images/pizza/mushroom_unit.png',  'garlic'),
  Ingredient('assets/images/pizza/olive.png', 3,5,
      const [
        Offset(0.55,0.5),
        Offset(0.65,0.6),
        Offset(0.2,0.3),
        Offset(0.4,0.2),
        Offset(0.2,0.6),
      ],
      'assets/images/pizza/olive_unit.png', 'olive'),
  Ingredient('assets/images/pizza/onion.png', 4,1.5,
      const [
        Offset(0.2,0.65),
        Offset(0.65,0.3),
        Offset(0.25,0.25),
        Offset(0.45,0.35),
        Offset(0.4,0.65),
      ],
      'assets/images/pizza/onion.png','onion'),
  Ingredient('assets/images/pizza/pea.png', 5,4,
      const [
        Offset(0.2,0.45),
        Offset(0.65,0.35),
        Offset(0.3,0.3),
        Offset(0.5,0.65),
        Offset(0.3,0.5),
      ],
      'assets/images/pizza/pea_unit.png','pea'),
  Ingredient('assets/images/pizza/pickle.png', 6,3,
      const [
        Offset(0.3,0.65),
        Offset(0.65,0.3),
        Offset(0.35,0.25),
        Offset(0.45,0.35),
        Offset(0.4,0.65),
      ],
      'assets/images/pizza/pickle_unit.png','pickle'),
  Ingredient('assets/images/pizza/potato.png', 7,3,
      const [
        Offset(0.2,0.6),
        Offset(0.6,0.55),
        Offset(0.4,0.25),
        Offset(0.5,0.4),
        Offset(0.4,0.65),
      ],
      'assets/images/pizza/potato_unit.png','potato'),
];
