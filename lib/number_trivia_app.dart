import 'package:flutter/material.dart';

import 'package:number_trivia/core/theme/app_theme.dart';
import 'package:number_trivia/features/number_trivia/presentation/pages/home/home_page.dart';
import 'package:number_trivia/injection_container.dart' as di;

class NumberTriviaApp extends StatelessWidget {
  const NumberTriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: di.sl.allReady(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          title: 'Number Trivia',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          home: const HomePage(),
        );
      },
    );
  }
}
