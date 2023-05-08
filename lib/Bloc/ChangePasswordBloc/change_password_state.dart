import '../../StateBlocTemplate/form_submission_state.dart';

class ChangePasswordState {
  final String oldPassword;
  final String newPassword;
  final String oldPasswordError;
  final String newPasswordError;
  final bool isNewPasswordVisible;
  final bool isOldPasswordVisible;
  final FormSubmissionState formSubmissionState;

  ChangePasswordState({
    this.oldPassword = '',
    this.newPassword = '',
    this.oldPasswordError = '',
    this.newPasswordError = '',
    this.isNewPasswordVisible = false,
    this.isOldPasswordVisible = false,
    this.formSubmissionState = const InitialFormState(),
  });

  ChangePasswordState copyWith({
    String? oldPassword,
    String? newPassword,
    String? oldPasswordError,
    String? newPasswordError,
    bool? isNewPasswordVisible,
    bool? isOldPasswordVisible,
    FormSubmissionState? formSubmissionState,
  }) {
    return ChangePasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      oldPasswordError: oldPasswordError ?? this.oldPasswordError,
      newPasswordError: newPasswordError ?? this.newPasswordError,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isOldPasswordVisible: isOldPasswordVisible ?? this.isOldPasswordVisible,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
