import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppBar(
      centerTitle: true,
      backgroundColor: theme.primaryColor,
      title: const Text(
        'Number Trivia',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
