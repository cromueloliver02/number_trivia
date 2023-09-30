import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties;

  const Failure([
    this.properties = const <dynamic>[],
  ]);

  @override
  String toString() => 'Failure(properties: $properties)';

  @override
  List<Object> get props => <Object>[properties];
}
