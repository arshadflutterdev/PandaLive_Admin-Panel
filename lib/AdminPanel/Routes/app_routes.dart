import 'package:get/get.dart';
import 'package:panda_adminpanel/AdminPanel/Authentication/login_screen.dart';
import 'package:panda_adminpanel/AdminPanel/Panel_UI/HomeScreen/home_screen.dart';

class AppRoutes {
  static const String login = "/LoginScreen";
  static const String home = "/HomeScreen";
  static final List<GetPage> routes = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: home, page: () => HomeScreen()),
  ];
}
