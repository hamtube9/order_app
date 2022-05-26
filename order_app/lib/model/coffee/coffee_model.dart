class Coffee {
  final String name;
  final String image;
  final double price;

  const Coffee(this.name, this.image, this.price);

  static const coffeeList = [
    Coffee('Vietnamese Style Iced Coffee', 'assets/images/coffee/9.png', 4.2),
    Coffee('Classic Irish Coffee', 'assets/images/coffee/11.png', 4.3),
    Coffee('Americano', 'assets/images/coffee/8.png', 3.3),
    Coffee('Caramel Macchiato', 'assets/images/coffee/1.png', 3.2),
    Coffee('Toffee Nut Iced Latte', 'assets/images/coffee/7.png', 4.0),
    Coffee('Caramelized Pecan Latte', 'assets/images/coffee/4.png', 3.5),
    Coffee('Toffee Nut Latte', 'assets/images/coffee/5.png', 3.9),
    Coffee('Iced Coffe Mocha', 'assets/images/coffee/3.png', 3.2),
    Coffee('Capuchino', 'assets/images/coffee/6.png', 3.1),
    Coffee('Caramel Cold Drink', 'assets/images/coffee/2.png', 3.2),
    Coffee('Black Tea Latte', 'assets/images/coffee/10.png', 4.3),
    Coffee('Toffee Nut Crunch Latte', 'assets/images/coffee/12.png', 3.7),
  ];
}


enum SizeItem{
  s,m,l
}

enum TypeUtility{hot,cold}
