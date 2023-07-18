import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_manager/presentation/gifts/view/gifts_page.dart';
import 'package:gifts_manager/presentation/home/models/bottom_tab.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';
import 'package:gifts_manager/presentation/new_present/view/create_new_present.dart';
import 'package:gifts_manager/presentation/people/people_page.dart';
import 'package:gifts_manager/presentation/settings/setting_pages.dart';

import '../../../di/service_locator.dart';
import '../../../navigation/route_name.dart';
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

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  BottomTab _currentTab = BottomTab.gifts;

  void _changeTab(final int index) {
    setState(() {
      _currentTab = BottomTab.values[index];
    });
  }

  final _pages = <Widget>[
    const GiftsPage(),
    const PeoplePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLogoutState) {
              Navigator.of(context).pushReplacementNamed(RouteName.login.route);
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTab.index,
          onTap: (position) {
            _changeTab(position);
          },
          items: [
            _createBottomNavigationBarItem(BottomTab.gifts),
            _createBottomNavigationBarItem(BottomTab.people),
            _createBottomNavigationBarItem(BottomTab.settings),
          ],
        ),
        body: IndexedStack(
          index: _currentTab.index,
          children: _pages,
        ),
        // Center(
        //   child: Column(
        //     children: [
        //       BlocBuilder<HomeBloc, HomeState>(
        //         builder: (context, state) {
        //           if (state is HomeWithUserInfo) {
        //             return Text(
        //                 "${state.user.toString()} \n\n ${state.gifts.toString()}");
        //           }
        //           return const Text("HomePage");
        //         },
        //       ),
        //       const SizedBox(
        //         height: 42,
        //       ),
        //       TextButton(
        //         onPressed: () async {
        //           context.read<HomeBloc>().add(const HomeLogoutPushed());
        //         },
        //         child: const Text("Exit"),
        //       ),
        //       const SizedBox(
        //         height: 42,
        //       ),
        //       TextButton(
        //         onPressed: () async {
        //           context.read<HomeBloc>().add(const HomeCreatePresentPushed());
        //         },
        //         child: const Text("Go create"),
        //       ),
        //       const SizedBox(
        //         height: 42,
        //       ),
        //       TextButton(
        //         onPressed: () async {
        //           Navigator.of(context).pushNamed(RouteName.gifts.route);
        //         },
        //         child: const Text("Go gifts"),
        //       ),
        //       TextButton(
        //         onPressed: () async {
        //           Navigator.of(context).push(MaterialPageRoute(
        //             builder: (context) => HomeTrain(),
        //           ));
        //         },
        //         child: const Text("Go HomeTrain"),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  BottomNavigationBarItem _createBottomNavigationBarItem(BottomTab item) {
    return BottomNavigationBarItem(
      icon: Icon(item.icon),
      label: item.title,
    );
  }
}
