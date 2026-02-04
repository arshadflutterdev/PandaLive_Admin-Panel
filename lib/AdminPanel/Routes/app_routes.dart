import 'package:get/get.dart';
import 'package:panda_adminpanel/AdminPanel/Authentication/login_screen.dart';

class AppRoutes {
  static const String login = "/LoginScreen";
  static final List<GetPage> routes = [
    GetPage(name: login, page: () => LoginScreen()),
  ];
}
