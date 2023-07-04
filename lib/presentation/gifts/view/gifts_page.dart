import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gifts_manager/data/http/model/user_dto.dart';
import 'package:gifts_manager/data/repository/token_repository.dart';
import 'package:gifts_manager/extensions/theme_extension.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';
import 'package:gifts_manager/presentation/new_present/view/create_new_present.dart';

import '../../../data/repository/user_repository.dart';
import '../../../di/service_locator.dart';
import '../../../resources/illustrations.dart';
import '../bloc/gifts_bloc.dart';

class GiftsPage extends StatelessWidget {
  const GiftsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<GiftsBloc>()..add(const GiftsPageLoaded()),
      child: const GiftsPageWidget(),
    );
  }
}

class GiftsPageWidget extends StatelessWidget {
  const GiftsPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocBuilder<GiftsBloc, GiftsState>(
          builder: (context, state) {
            if (state is InitialGiftsLoadingState) {
              return _LoadingWidget();
            } else if (state is NoGiftsState) {
              return _NoGiftsWidget();
            } else if (state is InitialLoadingStateError) {
              return _InitialLoadingErrorWidget();
            } else if (state is LoadedGiftsState) {
              return Text("LoadedGiftsState");
            }
            return const Text("GiftsPage");
          },
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _NoGiftsWidget extends StatelessWidget {
  const _NoGiftsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
          ),
          child: SvgPicture.asset(
            Illustrations.noGifts,
          ),
        ),
        const SizedBox(
          height: 36,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Добавьте свой первый подарок",
            textAlign: TextAlign.center,
            style: context.theme.textTheme.headline2,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _InitialLoadingErrorWidget extends StatelessWidget {
  const _InitialLoadingErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
          ),
          child: SvgPicture.asset(
            Illustrations.noGifts,
          ),
        ),
        const SizedBox(
          height: 36,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Произошла ошибка",
            textAlign: TextAlign.center,
            style: context.theme.textTheme.headline2,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<GiftsBloc>().add(const GiftsLoadingRequest());
          },
          child: Text("Повторить попытку"),
        ),
        const Spacer(),
      ],
    );
  }
}
