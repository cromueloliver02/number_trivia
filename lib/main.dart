import 'package:flutter/material.dart';

import 'package:number_trivia/injection_container.dart' as di;
import 'package:number_trivia/number_trivia_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  di.inject();

  runApp(const NumberTriviaApp());
}
