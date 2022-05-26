enum PizzaSize { s, m, l }

class PizzaSizeState {
   PizzaSize size;
  final double factor;

  PizzaSizeState(this.size) : factor = _getFactorSize(size);

  static _getFactorSize(PizzaSize size) {
    switch (size) {
      case PizzaSize.s:
        return 0.75;
      case PizzaSize.m:
        return 0.85;
      case PizzaSize.l:
        return 1.0;
      default:
        return 1.0;
    }
  }
}
