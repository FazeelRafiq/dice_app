import 'package:flutter/material.dart';

class SingleDice extends StatelessWidget {
  const SingleDice({
    super.key,
    required this.currentDiceRoll,
  });

  final int currentDiceRoll;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Image.asset(
        'assets/images/dice-$currentDiceRoll.png',
        width: 150,
      ),
    );
  }
}