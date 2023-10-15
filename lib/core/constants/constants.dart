import 'package:keyboard_dismisser/keyboard_dismisser.dart';

const String cacheNumberTriviaKey = 'cache_number_trivia';

const String serverExceptionMessage = 'Something went wrong with the server';
const String noCacheAvailableMessage = 'No cached trivia available';
const String invalidInputMessage = 'Invalid input';

const List<GestureType> keyboardDismisserGestures = [
  GestureType.onTap,
  GestureType.onPanUpdateDownDirection,
];
