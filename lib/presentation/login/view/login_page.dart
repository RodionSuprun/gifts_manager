import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_manager/data/model/request_error.dart';
import 'package:gifts_manager/extensions/theme_extension.dart';
import 'package:gifts_manager/presentation/home/view/home_page.dart';
import 'package:gifts_manager/presentation/login/bloc/login_bloc.dart';
import 'package:gifts_manager/presentation/login/model/models.dart';
import 'package:gifts_manager/presentation/registration/view/registration_page.dart';
import 'package:gifts_manager/presentation/reset_password/view/reset_password_page.dart';
import 'package:gifts_manager/resources/app_colors.dart';

import '../../../di/service_locator.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<LoginBloc>(),
      child: const Scaffold(
        body: _LoginPageWidget(),
      ),
    );
  }
}

class _LoginPageWidget extends StatefulWidget {
  const _LoginPageWidget({Key? key}) : super(key: key);

  @override
  State<_LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<_LoginPageWidget> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.authenticated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            }
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.requestError != RequestError.noError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Произошла ошибка".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red[900],
                ),
              );
              context.read<LoginBloc>().add(LoginRequestErrorShowed());
            }
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.showAfterPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Проверьте почту, мы отправили вам письмо для сборса пароля",
                  ),
                ),
              );
              context.read<LoginBloc>().add(LoginRequestErrorShowed());
            }
          },
        ),
      ],
      child: Column(
        children: [
          const SizedBox(
            height: 64,
          ),
          Center(
            child: Text(
              "Вход",
              style: context.theme.h2,
            ),
          ),
          const Spacer(flex: 88),
          _EmailTextField(
            emailFocusNode: _emailFocusNode,
            passwordFocusNode: _passwordFocusNode,
          ),
          const SizedBox(
            height: 8,
          ),
          _PasswordTextField(passwordFocusNode: _passwordFocusNode),
          const SizedBox(
            height: 40,
          ),
          const _LoginButton(),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Ещё нет аккаунта?",
                style: context.theme.h4.dynamicColor(
                  context: context,
                  lightThemeColor: AppColors.lightGrey60,
                  darkThemeColor: AppColors.darkWhite60,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const RegistrationPage();
                      },
                    ),
                  );
                },
                child: const Text("Создать"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () async {
              final resetPasswordResult = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ResetPasswordPage();
                  },
                ),
              );
              if (resetPasswordResult == true) {
                context.read<LoginBloc>().add(const LoginAfterResetPassword());
              }
            },
            child: const Text("Не помню пароль"),
          ),
          const Spacer(flex: 284),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: SizedBox(
        width: double.infinity,
        child: BlocSelector<LoginBloc, LoginState, bool>(
          selector: (state) {
            return state.allFieldsValid;
          },
          builder: (context, fieldsValid) {
            return ElevatedButton(
              onPressed: fieldsValid
                  ? () {
                      context
                          .read<LoginBloc>()
                          .add(const LoginLoginButtonClicked());
                    }
                  : null,
              child: const Text(
                "Войти",
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({
    super.key,
    required FocusNode emailFocusNode,
    required FocusNode passwordFocusNode,
  })  : _emailFocusNode = emailFocusNode,
        _passwordFocusNode = passwordFocusNode;

  final FocusNode _emailFocusNode;
  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: BlocSelector<LoginBloc, LoginState, EmailError>(
        selector: (state) {
          return state.emailError;
        },
        builder: (context, emailError) {
          return TextField(
            focusNode: _emailFocusNode,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            onChanged: (text) {
              context.read<LoginBloc>().add(LoginEmailChanged(text));
            },
            onSubmitted: (text) {
              _passwordFocusNode.requestFocus();
            },
            decoration: InputDecoration(
              labelText: "Почта",
              errorText: emailError == EmailError.noError
                  ? null
                  : emailError.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({
    super.key,
    required FocusNode passwordFocusNode,
  }) : _passwordFocusNode = passwordFocusNode;

  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: BlocSelector<LoginBloc, LoginState, PasswordError>(
        selector: (state) {
          return state.passwordError;
        },
        builder: (context, passwordError) {
          return TextField(
            focusNode: _passwordFocusNode,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            autocorrect: false,
            onChanged: (text) {
              context.read<LoginBloc>().add(LoginPasswordChanged(text));
            },
            onSubmitted: (text) {
              context.read<LoginBloc>().add(const LoginLoginButtonClicked());
            },
            decoration: InputDecoration(
              labelText: "Пароль",
              errorText: passwordError == PasswordError.noError
                  ? null
                  : passwordError.toString(),
            ),
          );
        },
      ),
    );
  }
}
