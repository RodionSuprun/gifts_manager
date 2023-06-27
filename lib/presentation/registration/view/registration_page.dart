import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gifts_manager/extensions/build_context.dart';
import 'package:gifts_manager/extensions/theme_extension.dart';
import 'package:gifts_manager/presentation/registration/bloc/registration_bloc.dart';
import 'package:gifts_manager/presentation/registration/model/errors.dart';
import 'package:gifts_manager/resources/app_colors.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: const Scaffold(
        body: _RegistrationPageWidget(),
      ),
    );
  }
}

class _RegistrationPageWidget extends StatefulWidget {
  const _RegistrationPageWidget({Key? key}) : super(key: key);

  @override
  State<_RegistrationPageWidget> createState() =>
      _RegistrationPageWidgetState();
}

class _RegistrationPageWidgetState extends State<_RegistrationPageWidget> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _passwordConfirmationFocusNode;
  late final FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordConfirmationFocusNode = FocusNode();
    _nameFocusNode = FocusNode();

    SchedulerBinding.instance
        .addPostFrameCallback((_) => _addFocusLostHandlers());
  }

  void _addFocusLostHandlers() {
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context
            .read<RegistrationBloc>()
            .add(const RegistrationEmailFocusLost());
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context
            .read<RegistrationBloc>()
            .add(const RegistrationPasswordFocusLost());
      }
    });
    _passwordConfirmationFocusNode.addListener(() {
      if (!_passwordConfirmationFocusNode.hasFocus) {
        context
            .read<RegistrationBloc>()
            .add(const RegistrationPasswordConfirmationFocusLost());
      }
    });
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        context.read<RegistrationBloc>().add(const RegistrationNameFocusLost());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Создать аккаунт",
                      style: context.theme.h2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _EmailTextField(
                    emailFocusNode: _emailFocusNode,
                    passwordFocusNode: _passwordFocusNode,
                  ),
                  _PasswordTextField(
                    passwordFocusNode: _passwordFocusNode,
                    passwordConfirmationFocusNode:
                        _passwordConfirmationFocusNode,
                  ),
                  _PasswordConfirmationTextField(
                    passwordConfirmationFocusNode:
                        _passwordConfirmationFocusNode,
                    nameFocusNode: _nameFocusNode,
                  ),
                  _NameTextField(nameFocusNode: _nameFocusNode),
                  const SizedBox(height: 16),
                  const _AvatarWidget(),
                ],
              ),
            ),
            const _RegistrationButton(),
          ],
        ),
      ),
    );
  }
}

class _NameTextField extends StatelessWidget {
  const _NameTextField({
    super.key,
    required FocusNode nameFocusNode,
  }) : _nameFocusNode = nameFocusNode;

  final FocusNode _nameFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) {
          return current is RegistrationFieldsInfo;
        },
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.nameError;
          return TextField(
            focusNode: _nameFocusNode,
            autocorrect: false,
            onChanged: (text) {
              context
                  .read<RegistrationBloc>()
                  .add(RegistrationNameChanged(name: text));
            },
            onSubmitted: (text) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: InputDecoration(
              labelText: "Имя и фамилия",
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _PasswordConfirmationTextField extends StatelessWidget {
  const _PasswordConfirmationTextField({
    super.key,
    required FocusNode passwordConfirmationFocusNode,
    required FocusNode nameFocusNode,
  })  : _passwordConfirmationFocusNode = passwordConfirmationFocusNode,
        _nameFocusNode = nameFocusNode;

  final FocusNode _passwordConfirmationFocusNode;
  final FocusNode _nameFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) {
          return current is RegistrationFieldsInfo;
        },
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.passwordConfirmationError;
          return TextField(
            focusNode: _passwordConfirmationFocusNode,
            autocorrect: false,
            obscureText: true,
            onChanged: (text) {
              context.read<RegistrationBloc>().add(
                  RegistrationPasswordConfirmationChanged(
                      passwordConfirmation: text));
            },
            onSubmitted: (text) {
              _nameFocusNode.requestFocus();
            },
            decoration: InputDecoration(
              labelText: "Пароль второй раз",
              errorText: error?.toString(),
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
    required FocusNode passwordConfirmationFocusNode,
  })  : _passwordFocusNode = passwordFocusNode,
        _passwordConfirmationFocusNode = passwordConfirmationFocusNode;

  final FocusNode _passwordFocusNode;
  final FocusNode _passwordConfirmationFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) {
          return current is RegistrationFieldsInfo;
        },
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.passwordError;
          return TextField(
            focusNode: _passwordFocusNode,
            autocorrect: false,
            obscureText: true,
            onChanged: (text) {
              context
                  .read<RegistrationBloc>()
                  .add(RegistrationPasswordChanged(password: text));
            },
            onSubmitted: (text) {
              _passwordConfirmationFocusNode.requestFocus();
            },
            decoration: InputDecoration(
              labelText: "Пароль",
              errorText: error?.toString(),
            ),
          );
        },
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) {
          return current is RegistrationFieldsInfo;
        },
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.emailError;
          return TextField(
            focusNode: _emailFocusNode,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            onChanged: (text) {
              context
                  .read<RegistrationBloc>()
                  .add(RegistrationEmailChanged(email: text));
            },
            onSubmitted: (text) {
              _passwordFocusNode.requestFocus();
            },
            decoration: InputDecoration(
              labelText: "Почта",
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(left: 8, top: 6, bottom: 6, right: 4),
      decoration: BoxDecoration(
        color: context.dynamicPlainColor(
          lightThemeColor: AppColors.lightLightBlue100,
          darkThemeColor: AppColors.darkWhite20,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          BlocBuilder<RegistrationBloc, RegistrationState>(
            buildWhen: (_, current) {
              return current is RegistrationFieldsInfo;
            },
            builder: (context, state) {
              final fieldsInfo = state as RegistrationFieldsInfo;
              return SvgPicture.network(
                fieldsInfo.avatarLink,
                height: 48,
                width: 48,
              );
            },
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            "Ваш аватар",
            style: context.theme.h3,
          ),
          const SizedBox(
            width: 8,
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              context.read<RegistrationBloc>().add(
                    const RegistrationChangeAvatar(),
                  );
            },
            child: const Text("Изменить"),
          ),
        ],
      ),
    );
  }
}

class _RegistrationButton extends StatelessWidget {
  const _RegistrationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: BlocSelector<RegistrationBloc, RegistrationState, bool>(
          selector: (state) {
            return state is RegistrationInProgress;
          },
          builder: (context, inProgress) {
            return ElevatedButton(
              onPressed: inProgress
                  ? null
                  : () {
                      context
                          .read<RegistrationBloc>()
                          .add(const RegistrationCreateAccount());
                    },
              child: const Text(
                "Создать",
              ),
            );
          },
        ),
      ),
    );
  }
}
