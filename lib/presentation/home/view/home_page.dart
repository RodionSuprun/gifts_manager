import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_manager/presentation/gifts/view/gifts_page.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';
import 'package:gifts_manager/presentation/new_present/view/create_new_present.dart';

import '../../../di/service_locator.dart';
import '../../homeTrain/presentation/home_train.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<HomeBloc>()..add(const HomePageLoaded()),
      child: const HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLogoutState) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            }
          },
        ),
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeCreateNewPresentState) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreatePresentPage()),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeWithUserInfo) {
                    return Text(
                        "${state.user.toString()} \n\n ${state.gifts.toString()}");
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
              ),
              const SizedBox(
                height: 42,
              ),
              TextButton(
                onPressed: () async {
                  context.read<HomeBloc>().add(const HomeCreatePresentPushed());
                },
                child: const Text("Go create"),
              ),
              const SizedBox(
                height: 42,
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GiftsPage(),
                  ));
                },
                child: const Text("Go gifts"),
              ),

              TextButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeTrain(),
                  ));
                },
                child: const Text("Go HomeTrain"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
