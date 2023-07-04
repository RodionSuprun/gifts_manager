import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gifts_manager/data/model/request_error.dart';
import 'package:gifts_manager/extensions/build_context.dart';
import 'package:gifts_manager/extensions/theme_extension.dart';
import 'package:gifts_manager/presentation/registration/bloc/registration_bloc.dart';
import 'package:gifts_manager/resources/app_colors.dart';

import '../../../di/service_locator.dart';
import '../../home/view/home_page.dart';
import '../bloc/create_new_present_bloc.dart';

class CreatePresentPage extends StatelessWidget {
  const CreatePresentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<NewPresentBloc>(),
      child: const Scaffold(
        body: _CreatePresentPageWidget(),
      ),
    );
  }
}

class _CreatePresentPageWidget extends StatefulWidget {
  const _CreatePresentPageWidget({Key? key}) : super(key: key);

  @override
  State<_CreatePresentPageWidget> createState() =>
      _CreatePresentPageWidgetState();
}

class _CreatePresentPageWidgetState extends State<_CreatePresentPageWidget> {
  late final FocusNode _nameFocusNode;
  late final FocusNode _priceFocusNode;
  // late final FocusNode _passwordConfirmationFocusNode;
  // late final FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _priceFocusNode = FocusNode();
    // _passwordConfirmationFocusNode = FocusNode();
    // _nameFocusNode = FocusNode();

    SchedulerBinding.instance
        .addPostFrameCallback((_) => _addFocusLostHandlers());
  }

  void _addFocusLostHandlers() {
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        context
            .read<RegistrationBloc>()
            .add(const RegistrationEmailFocusLost());
      }
    });
    _priceFocusNode.addListener(() {
      if (!_priceFocusNode.hasFocus) {
        context
            .read<RegistrationBloc>()
            .add(const RegistrationPasswordFocusLost());
      }
    });
    // _passwordConfirmationFocusNode.addListener(() {
    //   if (!_passwordConfirmationFocusNode.hasFocus) {
    //     context
    //         .read<RegistrationBloc>()
    //         .add(const RegistrationPasswordConfirmationFocusLost());
    //   }
    // });
    // _nameFocusNode.addListener(() {
    //   if (!_nameFocusNode.hasFocus) {
    //     context.read<RegistrationBloc>().add(const RegistrationNameFocusLost());
    //   }
    // });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _priceFocusNode.dispose();
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
                      "Добавить подарок",
                      style: context.theme.h2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Можно заполнить только название",
                      style: context.theme.h6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _NameTextField(
                    nameFocusNode: _nameFocusNode,
                    priceFocusNode: _priceFocusNode,
                  ),
                  // _PasswordTextField(
                  //   passwordFocusNode: _passwordFocusNode,
                  //   passwordConfirmationFocusNode:
                  //   _passwordConfirmationFocusNode,
                  // ),
                  // _PasswordConfirmationTextField(
                  //   passwordConfirmationFocusNode:
                  //   _passwordConfirmationFocusNode,
                  //   nameFocusNode: _nameFocusNode,
                  // ),
                  // _NameTextField(nameFocusNode: _nameFocusNode),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const _CreateButton(),
          ],
        ),
      ),
    );
  }
}

// class _NameTextField extends StatelessWidget {
//   const _NameTextField({
//     super.key,
//     required FocusNode nameFocusNode,
//   }) : _nameFocusNode = nameFocusNode;
//
//   final FocusNode _nameFocusNode;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: BlocBuilder<RegistrationBloc, RegistrationState>(
//         buildWhen: (_, current) {
//           return current is RegistrationFieldsInfo;
//         },
//         builder: (context, state) {
//           final fieldsInfo = state as RegistrationFieldsInfo;
//           final error = fieldsInfo.nameError;
//           return TextField(
//             focusNode: _nameFocusNode,
//             autocorrect: false,
//             onChanged: (text) {
//               context
//                   .read<RegistrationBloc>()
//                   .add(RegistrationNameChanged(name: text));
//             },
//             onSubmitted: (text) {
//               FocusManager.instance.primaryFocus?.unfocus();
//             },
//             decoration: InputDecoration(
//               labelText: "Имя и фамилия",
//               errorText: error?.toString(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

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

class _NameTextField extends StatelessWidget {
  const _NameTextField({
    super.key,
    required FocusNode nameFocusNode,
    required FocusNode priceFocusNode,
  })  : _nameFocusNode = nameFocusNode,
        _priceFocusNode = priceFocusNode;

  final FocusNode _nameFocusNode;
  final FocusNode _priceFocusNode;

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
            focusNode: _nameFocusNode,
            autocorrect: true,
            keyboardType: TextInputType.text,
            onChanged: (text) {
              context
                  .read<RegistrationBloc>()
                  .add(RegistrationEmailChanged(email: text));
            },
            onSubmitted: (text) {
              _priceFocusNode.requestFocus();
            },
            decoration: InputDecoration(
              labelText: "Название",
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({
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
                "Добавить подарок",
              ),
            );
          },
        ),
      ),
    );
  }
}

