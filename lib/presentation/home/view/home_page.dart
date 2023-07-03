import 'package:flutter/material.dart';
import 'package:gifts_manager/data/http/model/user_dto.dart';
import 'package:gifts_manager/data/repository/token_repository.dart';
import 'package:gifts_manager/data/storage/shared_preference_data.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';

import '../../../data/repository/user_repository.dart';
import '../../../di/service_locator.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            StreamBuilder<UserDto?>(
              stream: sl.get<UserRepository>().observeItem(),
              builder: (context, snapshot) {
                if (!snapshot.hasData  || snapshot.data == null) {
                  return const Text("HomePage");
                }
                return Text(snapshot.data.toString());
              }
            ),
            const SizedBox(
              height: 42,
            ),
            TextButton(
              onPressed: () async {
                await sl.get<TokenRepository>().setItem(null);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text("Exit"),
            )
          ],
        ),
      ),
    );
  }
}
