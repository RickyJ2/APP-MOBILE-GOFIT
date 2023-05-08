import 'package:equatable/equatable.dart';

class User<E> extends Equatable {
  final E? user;
  final int role;

  const User({this.user, this.role = 3});

  User copyWith({
    E? user,
    int? role,
  }) {
    return User(
      user: user ?? this.user,
      role: role ?? this.role,
    );
  }

  static const empty = User(
    user: null,
    role: 3,
  );

  bool get isEmpty => this == User.empty;
  bool get isNoEmpty => this != User.empty;

  @override
  List<Object?> get props => [user, role];
}
