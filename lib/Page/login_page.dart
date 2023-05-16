import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_gofit/Bloc/LoginBloc/login_bloc.dart';
import 'package:mobile_gofit/Repository/login_repository.dart';
import 'package:mobile_gofit/StateBlocTemplate/form_submission_state.dart';

import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/AppBloc/app_event.dart';
import '../Bloc/AppBloc/app_state.dart';
import '../Bloc/LoginBloc/login_event.dart';
import '../Bloc/LoginBloc/login_state.dart';
import '../const.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(loginRepository: LoginRepository()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppBloc>(context).add(const AppOpened());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.formSubmissionState != current.formSubmissionState,
          listener: (context, state) {
            if (state.formSubmissionState is SubmissionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Berhasil Login"),
                ),
              );
              BlocProvider.of<AppBloc>(context).add(const AppLogined());
            }
            if (state.formSubmissionState is SubmissionFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text((state.formSubmissionState as SubmissionFailed)
                      .exception
                      .toString()),
                ),
              );
            }
          },
        ),
        BlocListener<AppBloc, AppState>(
          listenWhen: (previous, current) =>
              previous.authenticated != current.authenticated,
          listener: (context, state) {
            if (state.authenticated == true) {
              switch (state.user.role) {
                case 0:
                  {
                    context.push('/home-member');
                    break;
                  }
                case 1:
                  {
                    context.push('/home-instruktur');
                    break;
                  }
                case 2:
                  {
                    context.push('/home-MO');
                    break;
                  }
                case 3:
                  {
                    context.push('/home-guest');
                    break;
                  }
              }
            }
          },
        )
      ],
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'GoFit',
                    style: TextStyle(
                      fontFamily: 'SchibstedGrotesk',
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      fontFamily: 'roboto',
                      color: accentColor,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Log in untuk melanjutkan',
                    style: TextStyle(
                      fontFamily: 'roboto',
                      color: textColorSecond,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: LoginForm(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: const [
          UsernameTextFormField(),
          SizedBox(height: 10),
          PasswordTextFormField(),
          SizedBox(height: 10),
          ButtonLoginForm(),
          SizedBox(height: 10),
          SubtextFormLogin(),
        ],
      ),
    );
  }
}

class ButtonLoginForm extends StatelessWidget {
  const ButtonLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.read<LoginBloc>().add(LoginSubmitted());
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
                  state.formSubmissionState is! FormSubmitting ? 'Login' : '',
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

class PasswordTextFormField extends StatelessWidget {
  const PasswordTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: 'Password',
          suffixIcon: IconButton(
            onPressed: () {
              context.read<LoginBloc>().add(PasswordVisibleChanged());
            },
            icon: Icon(
              state.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: state.isPasswordVisible ? primaryColor : textColorSecond,
            ),
          ),
        ),
        obscureText: !state.isPasswordVisible,
        autovalidateMode: AutovalidateMode.always,
        validator: (value) =>
            state.passwordError == '' ? null : state.passwordError,
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginPasswordChanged(password: value),
            ),
      );
    });
  }
}

class UsernameTextFormField extends StatelessWidget {
  const UsernameTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Username',
        ),
        autovalidateMode: AutovalidateMode.always,
        validator: (value) =>
            state.usernameError == '' ? null : state.usernameError,
        onChanged: (value) => context.read<LoginBloc>().add(
              LoginUsernameChanged(username: value),
            ),
      );
    });
  }
}

class SubtextFormLogin extends StatelessWidget {
  const SubtextFormLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Belum mempunyai akun?',
            style: TextStyle(
              fontFamily: 'Roboto',
              color: textColorSecond,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<AppBloc>().add(const GuestModeRequested());
            },
            child: Text(
              'Login sebagai Tamu',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
