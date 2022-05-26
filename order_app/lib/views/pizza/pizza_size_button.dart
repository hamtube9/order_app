import 'package:flutter/material.dart';

class PizzaSizeButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onClick;
  final bool? isSelected;

  const PizzaSizeButton({Key? key, this.text, this.onClick, this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick!,
      child: Container(
        height: 24,
        width: 24,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: isSelected! ? [const BoxShadow(color: Colors.black26, spreadRadius: 2.0, offset: Offset(0.0, 2.0), blurRadius: 4)] : null),
        child: Center(
            child: Text(
          text!,
          style: TextStyle(color: Colors.brown, fontWeight: isSelected! ? FontWeight.bold : FontWeight.normal),
        )),
      ),
    );
  }
}
