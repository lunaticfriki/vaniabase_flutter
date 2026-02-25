import 'package:equatable/equatable.dart';
import '../value_objects/auth_value_objects.dart';
import '../value_objects/unique_id.dart';

class User extends Equatable {
  final UniqueId id;
  final EmailAddress emailAddress;
  final String name;
  final String avatar;
  final DateTime createdAt;
  const User._({
    required this.id,
    required this.emailAddress,
    required this.name,
    required this.avatar,
    required this.createdAt,
  });
  static User create({
    required UniqueId id,
    required EmailAddress emailAddress,
    required String name,
    required String avatar,
    required DateTime createdAt,
  }) {
    return User._(
      id: id,
      emailAddress: emailAddress,
      name: name,
      avatar: avatar,
      createdAt: createdAt,
    );
  }

  static User empty() {
    return User._(
      id: UniqueId(),
      emailAddress: EmailAddress('empty@example.com'),
      name: '',
      avatar: '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  @override
  List<Object?> get props => [id, emailAddress, name, avatar, createdAt];
}

class UserObjectMother {
  static User empty() {
    return User.empty();
  }

  static User valid() {
    return User.create(
      id: UniqueId.fromUniqueString('user-123'),
      emailAddress: EmailAddress('user@example.com'),
      name: 'Test User',
      avatar: 'https://example.com/avatar.png',
      createdAt: DateTime(2023, 1, 1),
    );
  }
}
