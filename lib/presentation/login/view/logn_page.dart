import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_manager/presentation/home/view/home_page.dart';
import 'package:gifts_manager/presentation/login/bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: _LoginPageWidget(),
      ),
    );
  }
}

class _LoginPageWidget extends StatelessWidget {
  const _LoginPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.authenticated) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            ),
          );
        }
      },
      child: Column(
        children: [
          Spacer(flex: 64),
          Center(
            child: Text(
              "Вход",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
          ),
          Spacer(flex: 88),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 36),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Почта",
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 36),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Пароль",
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print("Нажали на кнопку войти");
                  context.read<LoginBloc>().add(LoginLoginButtonClicked());
                },
                child: Text("Войти"),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Ещё нет аккаунта?"),
              TextButton(
                onPressed: () {},
                child: Text("Создать"),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: Text("Не помню пароль"),
          ),
          Spacer(flex: 284),
        ],
      ),
    );
  }
}
