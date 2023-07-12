import 'package:collection/collection.dart';

enum RouteName {
  home(route: "/home"),
  login(route: "/login"),
  registration(route: "/registration"),
  resetPassword(route: "/resetPassword"),
  gifts(route: "/gifts"),
  splash(route: "/"),
  ;

  static RouteName? find(String? name) =>
      values.firstWhereOrNull((routeName) => routeName.route == name);
  final String route;

  const RouteName({required this.route});
}
