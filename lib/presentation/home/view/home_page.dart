import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_manager/data/http/model/user_dto.dart';
import 'package:gifts_manager/data/repository/token_repository.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';

import '../../../data/repository/user_repository.dart';
import '../../../di/service_locator.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      sl.get<HomeBloc>()
        ..add(const HomePageLoaded()),
      child: const HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLogoutState) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeWithUser) {
                    return Text(state.user.toString());
                  }
                  return const Text("HomePage");
                },
              ),
              const SizedBox(
                height: 42,
              ),
              TextButton(
                onPressed: () async {
                  context.read<HomeBloc>().add(const HomeLogoutPushed());
                },
                child: const Text("Exit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
