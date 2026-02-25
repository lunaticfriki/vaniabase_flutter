import 'package:equatable/equatable.dart';

abstract class ValueObject<T> extends Equatable {
  const ValueObject();
  T get value;
  @override
  List<Object?> get props => [value];
}

class EmailAddress extends ValueObject<String> {
  @override
  final String value;
  const EmailAddress._(this.value);
  factory EmailAddress(String input) {
    if (input.isEmpty || !input.contains('@')) {
      throw ArgumentError('Invalid email address');
    }
    return EmailAddress._(input);
  }
}

class Password extends ValueObject<String> {
  @override
  final String value;
  const Password._(this.value);
  factory Password(String input) {
    if (input.length < 6) {
      throw ArgumentError('Password must be at least 6 characters long');
    }
    return Password._(input);
  }
}
