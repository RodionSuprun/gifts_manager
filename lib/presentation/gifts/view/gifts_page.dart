import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_manager/data/http/model/user_dto.dart';
import 'package:gifts_manager/data/repository/token_repository.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';
import 'package:gifts_manager/presentation/new_present/view/create_new_present.dart';

import '../../../data/repository/user_repository.dart';
import '../../../di/service_locator.dart';
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
              return Text("InitialGiftsLoadingState");
            } else if (state is NoGiftsState) {
              return Text("No gifts");
            } else if (state is InitialLoadingStateError) {
              return Text("InitialLoadingStateError");
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
