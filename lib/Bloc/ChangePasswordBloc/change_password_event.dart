abstract class ChangePasswordEvent {}

class ChangePasswordOldPasswordChanged extends ChangePasswordEvent {
  final String password;

  ChangePasswordOldPasswordChanged({required this.password});
}

class ChangePasswordNewPasswordChanged extends ChangePasswordEvent {
  final String password;

  ChangePasswordNewPasswordChanged({required this.password});
}

class ChangePasswordOldPasswordVisibleChanged extends ChangePasswordEvent {
  ChangePasswordOldPasswordVisibleChanged();
}

class ChangePasswordNewPasswordVisibleChanged extends ChangePasswordEvent {
  ChangePasswordNewPasswordVisibleChanged();
}

class ChangePasswordSubmitted extends ChangePasswordEvent {}
