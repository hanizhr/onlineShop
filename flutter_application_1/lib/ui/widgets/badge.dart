import 'package:flutter/material.dart';

class IBadge extends StatelessWidget {
  final int value;

  const IBadge({Key? key, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: value > 0,
      child: Container(
        width: 18,
        height: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle),
        child: Text(
          value.toString(),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 12),
        ),
      ),
    );
  }
}
