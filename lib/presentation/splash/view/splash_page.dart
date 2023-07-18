import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';
import 'package:gifts_manager/presentation/splash/bloc/splash_bloc.dart';

import '../../../di/service_locator.dart';
import '../../../navigation/route_name.dart';
import '../../home/view/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl.get<SplashBloc>();
    _bloc.add(const SplashLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: const _SplashPageWidget(),
    );
  }
}

class _SplashPageWidget extends StatelessWidget {
  const _SplashPageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthorized) {
          Navigator.of(context).pushReplacementNamed(RouteName.home.route);
        } else if (state is SplashUnauthorized) {
          Navigator.of(context).pushReplacementNamed(RouteName.login.route);
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
