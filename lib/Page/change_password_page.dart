import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_gofit/Bloc/AppBloc/app_bloc.dart';
import 'package:mobile_gofit/Bloc/ChangePasswordBloc/change_password_bloc.dart';
import 'package:mobile_gofit/Bloc/ChangePasswordBloc/change_password_state.dart';
import 'package:mobile_gofit/Repository/change_password_repository.dart';

import '../Bloc/ChangePasswordBloc/change_password_event.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import '../const.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChangePasswordBloc>(
      create: (context) => ChangePasswordBloc(
        changePasswordRepository: ChangePasswordRepository(),
        appBloc: context.read<AppBloc>(),
      ),
      child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listenWhen: (previous, current) =>
            previous.formSubmissionState != current.formSubmissionState,
        listener: (context, state) {
          final formStatus = state.formSubmissionState;
          if (formStatus is SubmissionFailed) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(formStatus.exception.toString()),
                ),
              );
          } else if (formStatus is SubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Password berhasil diubah'),
                ),
              );
            Navigator.of(context).pop();
          }
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              backgroundColor: Colors.transparent,
              foregroundColor: primaryColor,
              elevation: 0,
              title: const Text("Ubah Password"),
              centerTitle: true,
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 20),
                    ChangePasswordForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: const [
          OldPasswordTextFormField(),
          SizedBox(height: 20),
          NewPasswordTextFormField(),
          SizedBox(height: 30),
          SubmitButton(),
        ],
      ),
    );
  }
}

class OldPasswordTextFormField extends StatelessWidget {
  const OldPasswordTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: 'Password Lama',
          suffixIcon: IconButton(
            onPressed: () {
              context
                  .read<ChangePasswordBloc>()
                  .add(ChangePasswordOldPasswordVisibleChanged());
            },
            icon: Icon(
              state.isOldPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color:
                  state.isOldPasswordVisible ? primaryColor : textColorSecond,
            ),
          ),
        ),
        obscureText: !state.isOldPasswordVisible,
        autovalidateMode: AutovalidateMode.always,
        validator: (value) =>
            state.oldPasswordError == '' ? null : state.oldPasswordError,
        onChanged: (value) => context.read<ChangePasswordBloc>().add(
              ChangePasswordOldPasswordChanged(password: value),
            ),
      );
    });
  }
}

class NewPasswordTextFormField extends StatelessWidget {
  const NewPasswordTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.enhanced_encryption),
          labelText: 'Password Baru',
          suffixIcon: IconButton(
            onPressed: () {
              context
                  .read<ChangePasswordBloc>()
                  .add(ChangePasswordNewPasswordVisibleChanged());
            },
            icon: Icon(
              state.isNewPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color:
                  state.isNewPasswordVisible ? primaryColor : textColorSecond,
            ),
          ),
        ),
        obscureText: !state.isNewPasswordVisible,
        autovalidateMode: AutovalidateMode.always,
        validator: (value) =>
            state.newPasswordError == '' ? null : state.newPasswordError,
        onChanged: (value) => context.read<ChangePasswordBloc>().add(
              ChangePasswordNewPasswordChanged(password: value),
            ),
      );
    });
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.read<ChangePasswordBloc>().add(ChangePasswordSubmitted());
          },
          child: Stack(
            children: [
              state.formSubmissionState is FormSubmitting
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  state.formSubmissionState is! FormSubmitting ? 'Simpan' : '',
                  style: TextStyle(
                    fontFamily: 'SchibstedGrotesk',
                    fontSize: 15,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
