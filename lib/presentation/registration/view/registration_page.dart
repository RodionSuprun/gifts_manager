import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gifts_manager/extensions/build_context.dart';
import 'package:gifts_manager/extensions/theme_extension.dart';
import 'package:gifts_manager/presentation/registration/bloc/registration_bloc.dart';
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
                  _AvatarWidget(),
                ],
              ),
            ),
            _RegistrationButton(),
          ],
        ),
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
            child: Text("Изменить"),
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
