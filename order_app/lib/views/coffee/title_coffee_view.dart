import 'package:flutter/material.dart';

class TitleCoffeeView extends StatelessWidget {
  final String name;
  final double price;

  const TitleCoffeeView({Key? key, required this.name, required this.price,  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: Hero(
            tag: name + 'title',
            child: Text(
              name,
              style: Theme.of(context).textTheme.headline5,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Text(
          price.toString() + "\$",
          style: Theme.of(context).textTheme.headline6!.copyWith(
            color: Colors.brown[400],
          ),
        )
      ],
    );
  }
}
