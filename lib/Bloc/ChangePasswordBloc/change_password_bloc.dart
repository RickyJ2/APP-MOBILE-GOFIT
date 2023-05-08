import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/ChangePasswordBloc/change_password_event.dart';
import 'package:mobile_gofit/Bloc/ChangePasswordBloc/change_password_state.dart';
import 'package:mobile_gofit/Repository/change_password_repository.dart';

import '../../StateBlocTemplate/form_submission_state.dart';
import '../AppBloc/app_bloc.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordRepository changePasswordRepository;
  final AppBloc appBloc;

  ChangePasswordBloc(
      {required this.changePasswordRepository, required this.appBloc})
      : super(ChangePasswordState()) {
    on<ChangePasswordOldPasswordChanged>(
        (event, emit) => _onOldPasswordChanged(event, emit));
    on<ChangePasswordNewPasswordChanged>(
        (event, emit) => _onNewPasswordChanged(event, emit));
    on<ChangePasswordOldPasswordVisibleChanged>(
        (event, emit) => _onOldPasswordVisibleChanged(event, emit));
    on<ChangePasswordNewPasswordVisibleChanged>(
        (event, emit) => _onNewPasswordVisibleChanged(event, emit));
    on<ChangePasswordSubmitted>((event, emit) => _onSubmitted(event, emit));
  }

  void _onOldPasswordChanged(ChangePasswordOldPasswordChanged event,
      Emitter<ChangePasswordState> emit) {
    emit(state.copyWith(
        oldPassword: event.password,
        formSubmissionState: const InitialFormState()));
  }

  void _onNewPasswordChanged(ChangePasswordNewPasswordChanged event,
      Emitter<ChangePasswordState> emit) {
    emit(state.copyWith(
        newPassword: event.password,
        formSubmissionState: const InitialFormState()));
  }

  void _onOldPasswordVisibleChanged(
      ChangePasswordOldPasswordVisibleChanged event,
      Emitter<ChangePasswordState> emit) {
    emit(state.copyWith(
        isOldPasswordVisible: !state.isOldPasswordVisible,
        formSubmissionState: const InitialFormState()));
  }

  void _onNewPasswordVisibleChanged(
      ChangePasswordNewPasswordVisibleChanged event,
      Emitter<ChangePasswordState> emit) {
    emit(state.copyWith(
        isNewPasswordVisible: !state.isNewPasswordVisible,
        formSubmissionState: const InitialFormState()));
  }

  void _onSubmitted(
      ChangePasswordSubmitted event, Emitter<ChangePasswordState> emit) async {
    emit(state.copyWith(formSubmissionState: FormSubmitting()));

    try {
      emit(state.copyWith(oldPasswordError: '', newPasswordError: ''));
      if (appBloc.state.user.role == 1) {
        await changePasswordRepository.changePasswordInstruktur(
            state.oldPassword, state.newPassword);
      } else if (appBloc.state.user.role == 2) {
        await changePasswordRepository.changePasswordMO(
            state.oldPassword, state.newPassword);
      }
      emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
    } on ChangePasswordFormFailure catch (e) {
      emit(state.copyWith(
          oldPasswordError: e.message['old_password'],
          newPasswordError: e.message['new_password']));
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    } on ChangePasswordFailure catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.message)));
    } catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    }
  }
}
