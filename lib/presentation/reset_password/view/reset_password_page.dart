import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_manager/extensions/theme_extension.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';

import '../../../data/model/request_error.dart';
import '../bloc/reset_password_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final FocusNode _emailFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _emailFocusNode.addListener(() {
        if (!_emailFocusNode.hasFocus) {
          context
              .read<ResetPasswordBloc>()
              .add(const ResetPasswordEmailFocusLost());
        }
      });
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ResetPasswordBloc, ResetPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordCompletedState) {
                Navigator.of(context).pop(true);
              }
            },
          ),
          BlocListener<ResetPasswordBloc, ResetPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordErrorState) {
                if (state.requestError == RequestError.unknown) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Произошла ошибка".toUpperCase(),
                      ),
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 96),
                    ),
                  );
                }
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Отправить ссылку",
                          style: context.theme.h2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Укажите свою почту, на неё придёт ссылка, чтобы установить новый пароль",
                          style: context.theme.h4,
                        ),
                      ),
                      const SizedBox(height: 26),
                      _EmailTextField(emailFocusNode: _emailFocusNode)
                    ],
                  ),
                ),
                const _ResetPasswordButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  final FocusNode emailFocusNode;

  const _EmailTextField({super.key, required this.emailFocusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
        buildWhen: (_, current) {
          return current is ResetPasswordFieldInfo;
        },
        builder: (context, state) {
          final fieldsInfo = state as ResetPasswordFieldInfo;
          final error = fieldsInfo.emailError;
          return TextField(
            focusNode: emailFocusNode,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            onChanged: (text) {
              context
                  .read<ResetPasswordBloc>()
                  .add(ResetPasswordEmailChanged(email: text));
            },
            onSubmitted: (text) {
              FocusManager.instance.primaryFocus?.unfocus();
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

class _ResetPasswordButton extends StatelessWidget {
  const _ResetPasswordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: BlocSelector<ResetPasswordBloc, ResetPasswordState, bool>(
          selector: (state) {
            return state is ResetPasswordInProgress;
          },
          builder: (context, inProgress) {
            return ElevatedButton(
              onPressed: inProgress
                  ? null
                  : () {
                      context
                          .read<ResetPasswordBloc>()
                          .add(const ResetPasswordAction());
                    },
              child: const Text(
                "Отправить ссылку",
              ),
            );
          },
        ),
      ),
    );
  }
}
