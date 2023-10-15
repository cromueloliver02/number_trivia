import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/pages/home/components/message_card.dart';
import 'package:number_trivia/features/number_trivia/presentation/pages/home/components/trivia_card.dart';

class TriviaDisplay extends StatelessWidget {
  const TriviaDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
      builder: (ctx, state) => switch (state) {
        NumberTriviaInitial() => const MessageCard(
            message: 'Start reading trivias!',
          ),
        NumberTriviaInProgress() => const CircularProgressIndicator(),
        NumberTriviaSuccess() => TriviaCard(
            number: state.trivia.number,
            text: state.trivia.text,
          ),
        NumberTriviaFailure() => MessageCard(
            message: state.failure.message,
            icon: const Icon(Icons.error, size: 35),
          ),
      },
    );
  }
}
