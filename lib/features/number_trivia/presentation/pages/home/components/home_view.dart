import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import 'package:number_trivia/core/constants/constants.dart';
import 'package:number_trivia/features/number_trivia/presentation/pages/home/components/home_app_bar.dart';
import 'package:number_trivia/features/number_trivia/presentation/pages/home/components/home_bottom_bar.dart';
import 'package:number_trivia/features/number_trivia/presentation/pages/home/components/trivia_display.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const KeyboardDismisser(
      gestures: keyboardDismisserGestures,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: HomeAppBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(child: TriviaDisplay()),
            ),
            HomeBottomBar(),
          ],
        ),
      ),
    );
  }
}
