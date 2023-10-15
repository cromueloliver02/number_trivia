import 'package:fpdart/fpdart.dart';

extension EitherExtension<L, R> on Either<L, R> {
  L unwrapLeft() {
    late L value;

    fold(
      (left) => value = left,
      (right) => throw UnimplementedError(),
    );

    return value;
  }

  R unwrapRight() {
    late R value;

    fold(
      (left) => throw UnimplementedError(),
      (right) => value = right,
    );

    return value;
  }
}
